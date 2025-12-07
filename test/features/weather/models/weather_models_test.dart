import 'package:flutter_test/flutter_test.dart';
import 'package:just_weather/features/weather/models/weather_models.dart';

void main() {
  group('WeatherLocation', () {
    test('fromJson parsea correctamente todos los campos', () {
      final json = {
        'name': 'London',
        'country': 'United Kingdom',
        'lat': 51.52,
        'lon': -0.11,
        'tz_id': 'Europe/London',
      };

      final loc = WeatherLocation.fromJson(json);

      expect(loc.name, 'London');
      expect(loc.country, 'United Kingdom');
      expect(loc.lat, 51.52);
      expect(loc.lon, -0.11);
      expect(loc.timezone, 'Europe/London');
    });

    test('fromJson usa "" si tz_id no viene en el json', () {
      final json = {
        'name': 'Bogota',
        'country': 'Colombia',
        'lat': 4.61,
        'lon': -74.08,
      };

      final loc = WeatherLocation.fromJson(json);

      expect(loc.timezone, '');
    });
  });

  group('CurrentWeather', () {
    test('fromJson parsea valores numéricos correctamente', () {
      final currentJson = {
        'temp_c': 20.5,
        'temp_f': 68.9,
        'feelslike_c': 21.0,
        'feelslike_f': 69.0,
        'humidity': 65,
        'wind_kph': 10.5,
        'condition': {
          'text': 'Partly cloudy',
          'icon': '//cdn.weatherapi.com/icons/partly.png',
        },
        'pressure_mb': 1013.0,
        'uv': 5.0,
        'vis_km': 10.0,
      };

      final dayJson = {'daily_chance_of_rain': 80};

      final cw = CurrentWeather.fromJson(currentJson, dayJson);

      expect(cw.tempC, 20.5);
      expect(cw.tempF, 68.9);
      expect(cw.feelsLikeC, 21.0);
      expect(cw.feelsLikeF, 69.0);
      expect(cw.humidity, 65);
      expect(cw.windKph, 10.5);
      expect(cw.conditionText, 'Partly cloudy');
      expect(cw.conditionIcon, '//cdn.weatherapi.com/icons/partly.png');
      expect(cw.pressureMb, 1013.0);
      expect(cw.uv, 5.0);
      expect(cw.visKm, 10.0);
      expect(cw.chanceOfRain, 80.0);
    });

    test('fromJson usa _parseDouble para strings y valores inválidos', () {
      final currentJson = {
        'temp_c': '19.5',
        'temp_f': '67.1',
        'feelslike_c': 'bad',
        'feelslike_f': null,
        'humidity': 50,
        'wind_kph': '12.3',
        'condition': {
          'text': 'Sunny',
          'icon': '//cdn.weatherapi.com/icons/sunny.png',
        },
        'pressure_mb': '1010.5',
        'uv': '3',
        'vis_km': '8.5',
      };

      final cw = CurrentWeather.fromJson(currentJson, null);

      expect(cw.tempC, 19.5);
      expect(cw.tempF, 67.1);
      expect(cw.feelsLikeC, 0.0);
      expect(cw.feelsLikeF, 0.0);
      expect(cw.humidity, 50);
      expect(cw.windKph, 12.3);
      expect(cw.conditionText, 'Sunny');
      expect(cw.conditionIcon, '//cdn.weatherapi.com/icons/sunny.png');
      expect(cw.pressureMb, 1010.5);
      expect(cw.uv, 3.0);
      expect(cw.visKm, 8.5);
      expect(cw.chanceOfRain, 0.0);
    });
  });

  group('HourForecast', () {
    test('fromJson parsea fecha, temperaturas e icono', () {
      final json = {
        'time': '2024-01-10 14:00',
        'temp_c': 22.0,
        'temp_f': 71.6,
        'condition': {'icon': '//cdn.weatherapi.com/icons/cloudy.png'},
      };

      final hf = HourForecast.fromJson(json);

      expect(hf.time, DateTime.parse('2024-01-10 14:00:00'));
      expect(hf.tempC, 22.0);
      expect(hf.tempF, 71.6);
      expect(hf.conditionIcon, '//cdn.weatherapi.com/icons/cloudy.png');
    });

    test('fromJson usa _parseDouble con strings', () {
      final json = {
        'time': '2024-01-10 09:00',
        'temp_c': '18.5',
        'temp_f': '65.3',
        'condition': {'icon': '//cdn.weatherapi.com/icons/rain.png'},
      };

      final hf = HourForecast.fromJson(json);

      expect(hf.tempC, 18.5);
      expect(hf.tempF, 65.3);
    });
  });

  group('DayForecast', () {
    test('fromJson parsea day y date correctamente', () {
      final json = {
        'date': '2024-01-11',
        'day': {
          'maxtemp_c': 25.0,
          'mintemp_c': 15.0,
          'maxtemp_f': 77.0,
          'mintemp_f': 59.0,
          'condition': {
            'icon': '//cdn.weatherapi.com/icons/sun.png',
            'text': 'Sunny',
          },
          'daily_chance_of_rain': '30',
        },
      };

      final df = DayForecast.fromJson(json);

      final dayMap = json['day'] as Map<String, dynamic>;
      final icon = dayMap['condition']['icon'];

      expect(df.date, DateTime.parse('2024-01-11'));
      expect(df.maxTempC, 25.0);
      expect(df.minTempC, 15.0);
      expect(df.maxTempF, 77.0);
      expect(df.minTempF, 59.0);

      expect(
        df.conditionIcon,
        icon,
        reason: 'el ícono debe ser el mismo que viene en el JSON',
      );

      expect(df.conditionText, 'Sunny');
      expect(df.chanceOfRain, 30.0);
    });
  });

  group('FullWeather.fromJson', () {
    test('parsea location, current, hourly, daily, sunrise y sunset', () {
      final json = {
        'location': {
          'name': 'London',
          'country': 'United Kingdom',
          'lat': 51.52,
          'lon': -0.11,
          'tz_id': 'Europe/London',
          'localtime': '2024-01-10 13:45',
        },
        'current': {
          'temp_c': 20.0,
          'temp_f': 68.0,
          'feelslike_c': 21.0,
          'feelslike_f': 69.0,
          'humidity': 60,
          'wind_kph': 12.0,
          'condition': {
            'text': 'Partly cloudy',
            'icon': '//cdn.weatherapi.com/icons/partly.png',
          },
          'pressure_mb': 1012.0,
          'uv': 4.0,
          'vis_km': 10.0,
        },
        'forecast': {
          'forecastday': [
            {
              'date': '2024-01-10',
              'day': {
                'maxtemp_c': 22.0,
                'mintemp_c': 12.0,
                'maxtemp_f': 71.6,
                'mintemp_f': 53.6,
                'condition': {
                  'icon': '//cdn.weatherapi.com/icons/day.png',
                  'text': 'Cloudy',
                },
                'daily_chance_of_rain': 40,
              },
              'astro': {'sunrise': '06:30 AM', 'sunset': '05:45 PM'},
              'hour': [
                {
                  'time': '2024-01-10 09:00',
                  'temp_c': 16.0,
                  'temp_f': 60.8,
                  'condition': {'icon': '//cdn.weatherapi.com/icons/hour1.png'},
                },
                {
                  'time': '2024-01-10 12:00',
                  'temp_c': 19.0,
                  'temp_f': 66.2,
                  'condition': {'icon': '//cdn.weatherapi.com/icons/hour2.png'},
                },
              ],
            },
            {
              'date': '2024-01-11',
              'day': {
                'maxtemp_c': 23.0,
                'mintemp_c': 13.0,
                'maxtemp_f': 73.4,
                'mintemp_f': 55.4,
                'condition': {
                  'icon': '//cdn.weatherapi.com/icons/day2.png',
                  'text': 'Sunny',
                },
                'daily_chance_of_rain': 10,
              },
            },
          ],
        },
      };

      final fw = FullWeather.fromJson(json);

      expect(fw.location.name, 'London');
      expect(fw.location.country, 'United Kingdom');
      expect(fw.location.timezone, 'Europe/London');

      expect(fw.current.tempC, 20.0);
      expect(fw.current.humidity, 60);
      expect(fw.current.conditionText, 'Partly cloudy');

      expect(fw.hourly.length, 2);
      expect(fw.hourly.first.time, DateTime.parse('2024-01-10 09:00:00'));

      expect(fw.daily.length, 2);
      expect(fw.daily.first.date, DateTime.parse('2024-01-10'));

      expect(fw.sunrise.year, 2024);
      expect(fw.sunrise.month, 1);
      expect(fw.sunrise.day, 10);
      expect(fw.sunrise.hour, 6);
      expect(fw.sunrise.minute, 30);

      expect(fw.sunset.year, 2024);
      expect(fw.sunset.month, 1);
      expect(fw.sunset.day, 10);
      expect(fw.sunset.hour, 17);
      expect(fw.sunset.minute, 45);
    });

    test(
      'cuando no hay forecastday, usa fecha y horas por defecto para sunrise/sunset',
      () {
        final json = {
          'location': {
            'name': 'Bogota',
            'country': 'Colombia',
            'lat': 4.61,
            'lon': -74.08,
            'tz_id': 'America/Bogota',
            'localtime': '2024-02-01 08:00',
          },
          'current': {
            'temp_c': 18.0,
            'temp_f': 64.4,
            'feelslike_c': 18.0,
            'feelslike_f': 64.4,
            'humidity': 70,
            'wind_kph': 8.0,
            'condition': {
              'text': 'Cloudy',
              'icon': '//cdn/weatherapi.com/icons/cloudy.png',
            },
            'pressure_mb': 1015.0,
            'uv': 3.0,
            'vis_km': 9.0,
          },
          'forecast': {'forecastday': []},
        };

        final fw = FullWeather.fromJson(json);

        expect(fw.sunrise.year, 2024);
        expect(fw.sunrise.month, 2);
        expect(fw.sunrise.day, 1);
        expect(fw.sunrise.hour, 6);
        expect(fw.sunrise.minute, 0);

        expect(fw.sunset.year, 2024);
        expect(fw.sunset.month, 2);
        expect(fw.sunset.day, 1);
        expect(fw.sunset.hour, 18);
        expect(fw.sunset.minute, 0);
      },
    );
  });
}
