import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:just_weather/features/weather/presentation/widgets/weather_details_grid.dart';
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

  CurrentWeather makeCurrent({
    double tempC = 22.5,
    double tempF = 72.5,
    double feelsLikeC = 24.3,
    double feelsLikeF = 75.7,
    int humidity = 60,
    double windKph = 10.4,
    String conditionText = 'Sunny',
    String conditionIcon = '//icon.png',
    double pressureMb = 1013.2,
    double uv = 5.4,
    double visKm = 9.7,
    double chanceOfRain = 42.0,
  }) => CurrentWeather(
    tempC: tempC,
    tempF: tempF,
    feelsLikeC: feelsLikeC,
    feelsLikeF: feelsLikeF,
    humidity: humidity,
    windKph: windKph,
    conditionText: conditionText,
    conditionIcon: conditionIcon,
    pressureMb: pressureMb,
    uv: uv,
    visKm: visKm,
    chanceOfRain: chanceOfRain,
  );

  FullWeather makeWeather({
    required DateTime sunrise,
    required DateTime sunset,
    CurrentWeather? current,
  }) {
    return FullWeather(
      location: makeLocation(),
      current: current ?? makeCurrent(),
      hourly: const [],
      daily: const [],
      sunrise: sunrise,
      sunset: sunset,
    );
  }

  testWidgets('muestra correctamente los valores básicos en °C', (
    tester,
  ) async {
    final sunrise = DateTime(2024, 1, 1, 6, 30);
    final sunset = DateTime(2024, 1, 1, 18, 45);
    final current = makeCurrent(
      feelsLikeC: 24.3,
      feelsLikeF: 75.7,
      pressureMb: 1013.2,
      windKph: 10.4,
      uv: 5.4,
      visKm: 9.7,
      chanceOfRain: 42.0,
    );

    final weather = makeWeather(
      sunrise: sunrise,
      sunset: sunset,
      current: current,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WeatherDetailsGrid(
            weather: weather,
            unit: TemperatureUnit.celsius,
          ),
        ),
      ),
    );

    expect(find.text('06:30'), findsOneWidget);
    expect(find.text('18:45'), findsOneWidget);
    expect(find.text('42%'), findsOneWidget);
    expect(find.text('1013 hPa'), findsOneWidget);
    expect(find.text('10.4 km/h'), findsOneWidget);
    expect(find.text('5.4'), findsOneWidget);
    expect(find.text('24.3°C'), findsOneWidget);
    expect(find.text('9.7 km'), findsOneWidget);
    expect(find.text('Amanecer'), findsOneWidget);
    expect(find.text('Atardecer'), findsOneWidget);
    expect(find.text('Probabilidad de lluvia'), findsOneWidget);
    expect(find.text('Presión'), findsOneWidget);
    expect(find.text('Viento'), findsOneWidget);
    expect(find.text('Índice UV'), findsOneWidget);
    expect(find.text('se siente como'), findsOneWidget);
    expect(find.text('Visibilidad'), findsOneWidget);
  });

  testWidgets('usa °F cuando unit es fahrenheit para "Feels like"', (
    tester,
  ) async {
    final current = makeCurrent(feelsLikeC: 24.3, feelsLikeF: 75.7);

    final weather = makeWeather(
      sunrise: DateTime(2024, 1, 1, 6, 0),
      sunset: DateTime(2024, 1, 1, 18, 0),
      current: current,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WeatherDetailsGrid(
            weather: weather,
            unit: TemperatureUnit.fahrenheit,
          ),
        ),
      ),
    );

    expect(find.text('75.7°F'), findsOneWidget);
    expect(find.text('24.3°C'), findsNothing);
  });

  testWidgets('usa fondo blanco en tema light', (tester) async {
    final weather = makeWeather(
      sunrise: DateTime(2024, 1, 1, 6, 0),
      sunset: DateTime(2024, 1, 1, 18, 0),
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.light(),
        home: Scaffold(
          body: WeatherDetailsGrid(
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

    expect(decoration.color, Colors.white);
  });

  testWidgets('usa fondo gris oscuro en tema dark', (tester) async {
    final weather = makeWeather(
      sunrise: DateTime(2024, 1, 1, 6, 0),
      sunset: DateTime(2024, 1, 1, 18, 0),
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark(),
        home: Scaffold(
          body: WeatherDetailsGrid(
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

  testWidgets('crea exactamente 8 items en la grilla', (tester) async {
    final weather = makeWeather(
      sunrise: DateTime(2024, 1, 1, 6, 0),
      sunset: DateTime(2024, 1, 1, 18, 0),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WeatherDetailsGrid(
            weather: weather,
            unit: TemperatureUnit.celsius,
          ),
        ),
      ),
    );

    final rowFinder = find.byType(Row);
    expect(rowFinder, findsNWidgets(8));
  });
}
