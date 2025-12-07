class WeatherLocation {
  final String name;
  final String country;
  final double lat;
  final double lon;
  final String timezone;

  WeatherLocation({
    required this.name,
    required this.country,
    required this.lat,
    required this.lon,
    required this.timezone,
  });

  factory WeatherLocation.fromJson(Map<String, dynamic> json) {
    return WeatherLocation(
      name: json['name'] as String,
      country: json['country'] as String,
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      timezone: json['tz_id']?.toString() ?? '',
    );
  }
}

double _parseDouble(dynamic value, {double fallback = 0}) {
  if (value == null) return fallback;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? fallback;
  return fallback;
}

class CurrentWeather {
  final double tempC;
  final double tempF;
  final double feelsLikeC;
  final double feelsLikeF;
  final int humidity;
  final double windKph;
  final String conditionText;
  final String conditionIcon;
  final double pressureMb;
  final double uv;
  final double visKm;
  final double chanceOfRain;

  CurrentWeather({
    required this.tempC,
    required this.tempF,
    required this.feelsLikeC,
    required this.feelsLikeF,
    required this.humidity,
    required this.windKph,
    required this.conditionText,
    required this.conditionIcon,
    required this.pressureMb,
    required this.uv,
    required this.visKm,
    required this.chanceOfRain,
  });

  factory CurrentWeather.fromJson(
    Map<String, dynamic> current,
    Map<String, dynamic>? day,
  ) {
    return CurrentWeather(
      tempC: _parseDouble(current['temp_c']),
      tempF: _parseDouble(current['temp_f']),
      feelsLikeC: _parseDouble(current['feelslike_c']),
      feelsLikeF: _parseDouble(current['feelslike_f']),
      humidity: (current['humidity'] as num).toInt(),
      windKph: _parseDouble(current['wind_kph']),
      conditionText: current['condition']['text'] as String,
      conditionIcon: current['condition']['icon'] as String,
      pressureMb: _parseDouble(current['pressure_mb']),
      uv: _parseDouble(current['uv']),
      visKm: _parseDouble(current['vis_km']),
      chanceOfRain: day != null ? _parseDouble(day['daily_chance_of_rain']) : 0,
    );
  }
}

class HourForecast {
  final DateTime time;
  final double tempC;
  final double tempF;
  final String conditionIcon;

  HourForecast({
    required this.time,
    required this.tempC,
    required this.tempF,
    required this.conditionIcon,
  });

  factory HourForecast.fromJson(Map<String, dynamic> json) {
    return HourForecast(
      time: DateTime.parse(json['time'] as String),
      tempC: _parseDouble(json['temp_c']),
      tempF: _parseDouble(json['temp_f']),
      conditionIcon: json['condition']['icon'] as String,
    );
  }
}

class DayForecast {
  final DateTime date;
  final double maxTempC;
  final double minTempC;
  final double maxTempF;
  final double minTempF;
  final String conditionIcon;
  final String conditionText;
  final double chanceOfRain;

  DayForecast({
    required this.date,
    required this.maxTempC,
    required this.minTempC,
    required this.maxTempF,
    required this.minTempF,
    required this.conditionIcon,
    required this.conditionText,
    required this.chanceOfRain,
  });

  factory DayForecast.fromJson(Map<String, dynamic> json) {
    final day = json['day'] as Map<String, dynamic>;
    return DayForecast(
      date: DateTime.parse(json['date'] as String),
      maxTempC: _parseDouble(day['maxtemp_c']),
      minTempC: _parseDouble(day['mintemp_c']),
      maxTempF: _parseDouble(day['maxtemp_f']),
      minTempF: _parseDouble(day['mintemp_f']),
      conditionIcon: day['condition']['icon'] as String,
      conditionText: day['condition']['text'] as String,
      chanceOfRain: _parseDouble(day['daily_chance_of_rain']),
    );
  }
}

class FullWeather {
  final WeatherLocation location;
  final CurrentWeather current;
  final List<HourForecast> hourly;
  final List<DayForecast> daily;
  final DateTime sunrise;
  final DateTime sunset;

  FullWeather({
    required this.location,
    required this.current,
    required this.hourly,
    required this.daily,
    required this.sunrise,
    required this.sunset,
  });

  factory FullWeather.fromJson(Map<String, dynamic> json) {
    final locationJson = json['location'] as Map<String, dynamic>;
    final currentJson = json['current'] as Map<String, dynamic>;

    final forecast = json['forecast'] as Map<String, dynamic>?;
    final forecastDaysJson = (forecast?['forecastday'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();

    Map<String, dynamic>? todayJson;
    Map<String, dynamic>? todayDayJson;
    Map<String, dynamic>? todayAstroJson;

    if (forecastDaysJson.isNotEmpty) {
      todayJson = forecastDaysJson.first;
      todayDayJson = todayJson['day'] as Map<String, dynamic>?;
      todayAstroJson = todayJson['astro'] as Map<String, dynamic>?;
    }

    final List<HourForecast> hourly = [];
    if (todayJson != null && todayJson['hour'] != null) {
      final hourList = todayJson['hour'] as List<dynamic>;
      hourly.addAll(
        hourList
            .map((e) => HourForecast.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    }

    final List<DayForecast> daily = forecastDaysJson
        .map(DayForecast.fromJson)
        .toList();

    final dateString =
        todayJson?['date'] as String? ??
        (locationJson['localtime']?.toString().split(' ').first ?? '');

    final sunriseStr = todayAstroJson?['sunrise'] as String? ?? '06:00 AM';
    final sunsetStr = todayAstroJson?['sunset'] as String? ?? '06:00 PM';

    DateTime parseSunTime(String date, String time) {
      try {
        final baseDate = DateTime.parse(date);
        final parts = time.split(' ');
        final hm = parts[0].split(':');
        int hour = int.parse(hm[0]);
        final minute = int.parse(hm[1]);
        final isPm = parts.length > 1 && parts[1].toUpperCase() == 'PM';

        if (isPm && hour != 12) hour += 12;
        if (!isPm && hour == 12) hour = 0;

        return DateTime(
          baseDate.year,
          baseDate.month,
          baseDate.day,
          hour,
          minute,
        );
      } catch (_) {
        return DateTime.now();
      }
    }

    final sunrise = parseSunTime(dateString, sunriseStr);
    final sunset = parseSunTime(dateString, sunsetStr);

    return FullWeather(
      location: WeatherLocation.fromJson(locationJson),
      current: CurrentWeather.fromJson(currentJson, todayDayJson),
      hourly: hourly,
      daily: daily,
      sunrise: sunrise,
      sunset: sunset,
    );
  }
}
