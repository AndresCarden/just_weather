import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:just_weather/features/weather/presentation/widgets/hourly_forecast_strip.dart';
import 'package:just_weather/features/weather/application/weather_controller.dart';
import 'package:just_weather/features/weather/models/weather_models.dart';

void main() {
  WeatherLocation makeLocation() => WeatherLocation(
    name: 'Test City',
    country: 'TC',
    lat: 0,
    lon: 0,
    timezone: 'UTC',
  );

  CurrentWeather makeCurrent() => CurrentWeather(
    tempC: 20,
    tempF: 68,
    feelsLikeC: 20,
    feelsLikeF: 68,
    humidity: 50,
    windKph: 5,
    conditionText: 'Sunny',
    conditionIcon: '//icon.png',
    pressureMb: 1013,
    uv: 5,
    visKm: 10,
    chanceOfRain: 0,
  );

  DayForecast makeDayForecast(DateTime date) => DayForecast(
    date: date,
    maxTempC: 25,
    minTempC: 15,
    maxTempF: 77,
    minTempF: 59,
    conditionIcon: '//icon.png',
    conditionText: 'Sunny',
    chanceOfRain: 0,
  );

  HourForecast makeHourForecast({
    required DateTime time,
    required double tempC,
    required double tempF,
    String icon = '//icon.png',
  }) =>
      HourForecast(time: time, tempC: tempC, tempF: tempF, conditionIcon: icon);

  FullWeather makeFullWeatherWithHours(List<HourForecast> hours) {
    final baseDate = DateTime(2024, 1, 1);
    return FullWeather(
      location: makeLocation(),
      current: makeCurrent(),
      hourly: hours,
      daily: [makeDayForecast(baseDate)],
      sunrise: DateTime(2024, 1, 1, 6),
      sunset: DateTime(2024, 1, 1, 18),
    );
  }

  testWidgets('muestra horas y temperaturas en °C cuando unit es celsius', (
    tester,
  ) async {
    final hours = [
      makeHourForecast(time: DateTime(2024, 1, 1, 10, 0), tempC: 20, tempF: 68),
      makeHourForecast(
        time: DateTime(2024, 1, 1, 11, 0),
        tempC: 22,
        tempF: 71.6,
      ),
    ];

    final weather = makeFullWeatherWithHours(hours);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HourlyForecastStrip(
            weather: weather,
            unit: TemperatureUnit.celsius,
          ),
        ),
      ),
    );

    expect(find.text('10:00'), findsOneWidget);
    expect(find.text('11:00'), findsOneWidget);
    expect(find.text('20°'), findsOneWidget);
    expect(find.text('22°'), findsOneWidget);
  });

  testWidgets('muestra temperaturas en °F cuando unit es fahrenheit', (
    tester,
  ) async {
    final hours = [
      makeHourForecast(time: DateTime(2024, 1, 1, 10, 0), tempC: 20, tempF: 68),
    ];

    final weather = makeFullWeatherWithHours(hours);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HourlyForecastStrip(
            weather: weather,
            unit: TemperatureUnit.fahrenheit,
          ),
        ),
      ),
    );

    expect(find.text('68°'), findsOneWidget);
    expect(find.text('20°'), findsNothing);
  });

  testWidgets('limita la tira a máximo 24 horas aunque vengan más', (
    tester,
  ) async {
    final List<HourForecast> hours = List.generate(30, (i) {
      return makeHourForecast(
        time: DateTime(2024, 1, 1, i % 24, 0),
        tempC: i.toDouble(),
        tempF: (i * 2).toDouble(),
      );
    });

    final weather = makeFullWeatherWithHours(hours);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HourlyForecastStrip(
            weather: weather,
            unit: TemperatureUnit.celsius,
          ),
        ),
      ),
    );

    for (var i = 0; i < 24; i++) {
      expect(find.text('${i.toString()}°'), findsWidgets);
    }

    expect(find.text('24°'), findsNothing);
    expect(find.text('25°'), findsNothing);
    expect(find.text('29°'), findsNothing);
  });

  testWidgets('usa fondo oscuro cuando el tema es dark', (tester) async {
    final hours = [
      makeHourForecast(time: DateTime(2024, 1, 1, 10, 0), tempC: 20, tempF: 68),
    ];
    final weather = makeFullWeatherWithHours(hours);

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark(),
        home: Scaffold(
          body: HourlyForecastStrip(
            weather: weather,
            unit: TemperatureUnit.celsius,
          ),
        ),
      ),
    );

    final containerFinder = find.byWidgetPredicate(
      (widget) =>
          widget is Container &&
          widget.decoration is BoxDecoration &&
          (widget.decoration as BoxDecoration).borderRadius ==
              BorderRadius.circular(16),
    );

    expect(containerFinder, findsOneWidget);

    final container = tester.widget<Container>(containerFinder);
    final decoration = container.decoration as BoxDecoration;

    expect(decoration.color, Colors.grey[900]);
  });
}
