import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:just_weather/features/weather/presentation/widgets/weather_metrics_row.dart';
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
    double tempC = 20.0,
    double tempF = 68.0,
    double feelsLikeC = 22.0,
    double feelsLikeF = 71.6,
    int humidity = 50,
    double windKph = 10.0,
  }) => CurrentWeather(
    tempC: tempC,
    tempF: tempF,
    feelsLikeC: feelsLikeC,
    feelsLikeF: feelsLikeF,
    humidity: humidity,
    windKph: windKph,
    conditionText: 'Sunny',
    conditionIcon: '//icon.png',
    pressureMb: 1013.0,
    uv: 5.0,
    visKm: 10.0,
    chanceOfRain: 0,
  );

  DayForecast makeDay({
    required DateTime date,
    required double maxC,
    required double minC,
    required double maxF,
    required double minF,
  }) => DayForecast(
    date: date,
    maxTempC: maxC,
    minTempC: minC,
    maxTempF: maxF,
    minTempF: minF,
    conditionIcon: '//icon.png',
    conditionText: 'Sunny',
    chanceOfRain: 0,
  );

  FullWeather makeWeather({
    required CurrentWeather current,
    List<DayForecast> daily = const [],
  }) {
    return FullWeather(
      location: makeLocation(),
      current: current,
      hourly: const [],
      daily: daily,
      sunrise: DateTime(2024, 1, 1, 6, 0),
      sunset: DateTime(2024, 1, 1, 18, 0),
    );
  }

  testWidgets('muestra textos básicos y usa °C y km/h cuando unit es celsius', (
    tester,
  ) async {
    final current = makeCurrent(
      tempC: 21.3,
      tempF: 70.3,
      feelsLikeC: 23.7,
      feelsLikeF: 74.7,
      humidity: 55,
      windKph: 12.3,
    );

    final weather = makeWeather(current: current, daily: []);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 320,
            child: WeatherMetricsRow(
              weather: weather,
              unit: TemperatureUnit.celsius,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Temperatura'), findsOneWidget);
    expect(find.text('se siente como'), findsOneWidget);
    expect(find.text('Humedad'), findsOneWidget);
    expect(find.text('Viento'), findsOneWidget);

    expect(find.text('21.3°C'), findsOneWidget);
    expect(find.text('23.7°C'), findsOneWidget);
    expect(find.text('55%'), findsOneWidget);
    expect(find.text('12.3 km/h'), findsOneWidget);

    expect(find.text('—'), findsOneWidget);
  });

  testWidgets('usa °F y mph cuando unit es fahrenheit', (tester) async {
    final current = makeCurrent(
      tempC: 21.3,
      tempF: 70.3,
      feelsLikeC: 23.7,
      feelsLikeF: 74.7,
      humidity: 55,
      windKph: 10.0,
    );

    final weather = makeWeather(current: current, daily: []);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 320,
            child: WeatherMetricsRow(
              weather: weather,
              unit: TemperatureUnit.fahrenheit,
            ),
          ),
        ),
      ),
    );

    expect(find.text('70.3°F'), findsOneWidget);
    expect(find.text('74.7°F'), findsOneWidget);
    expect(find.text('6.2 mph'), findsOneWidget);
  });

  testWidgets(
    'tempChange es "—" cuando no hay daily y se muestra icono neutro gris',
    (tester) async {
      final current = makeCurrent(
        tempC: 20.0,
        tempF: 68.0,
        feelsLikeC: 20.0,
        feelsLikeF: 68.0,
        humidity: 50,
        windKph: 10.0,
      );
      final weather = makeWeather(current: current, daily: []);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 320,
              child: WeatherMetricsRow(
                weather: weather,
                unit: TemperatureUnit.celsius,
              ),
            ),
          ),
        ),
      );

      final tempTitleFinder = find.text('Temperatura');
      expect(tempTitleFinder, findsOneWidget);
      expect(find.text('—'), findsWidgets);
      final removeIconFinder = find.byIcon(Icons.remove);
      expect(removeIconFinder, findsWidgets);
    },
  );

  testWidgets(
    'cuando temp actual es mayor al promedio diario, tempChange es positivo (icono verde arrow_upward)',
    (tester) async {
      final current = makeCurrent(tempC: 20.0, tempF: 68.0);
      final today = makeDay(
        date: DateTime(2024, 1, 1),
        maxC: 18.0,
        minC: 14.0,
        maxF: 64.4,
        minF: 57.2,
      );

      final weather = makeWeather(current: current, daily: [today]);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 320,
              child: WeatherMetricsRow(
                weather: weather,
                unit: TemperatureUnit.celsius,
              ),
            ),
          ),
        ),
      );

      expect(find.text('+25.0%'), findsOneWidget);
      final arrowFinder = find.byIcon(Icons.arrow_upward);
      expect(arrowFinder, findsWidgets);

      final arrowIcon = tester.widget<Icon>(arrowFinder.first);
      expect(arrowIcon.color, Colors.green);
    },
  );

  testWidgets(
    'cuando temp actual es menor al promedio diario, tempChange es negativo (icono rojo arrow_downward)',
    (tester) async {
      final current = makeCurrent(tempC: 20.0, tempF: 68.0);
      final today = makeDay(
        date: DateTime(2024, 1, 1),
        maxC: 26.0,
        minC: 24.0,
        maxF: 78.8,
        minF: 75.2,
      );

      final weather = makeWeather(current: current, daily: [today]);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 320,
              child: WeatherMetricsRow(
                weather: weather,
                unit: TemperatureUnit.celsius,
              ),
            ),
          ),
        ),
      );

      expect(find.text('-20.0%'), findsOneWidget);

      final arrowFinder = find.byIcon(Icons.arrow_downward);
      expect(arrowFinder, findsWidgets);

      final arrowIcon = tester.widget<Icon>(arrowFinder.first);
      expect(arrowIcon.color, Colors.red);
    },
  );

  testWidgets(
    'usa Wrap en pantallas pequeñas y Row en pantallas anchas (layout responsive)',
    (tester) async {
      final current = makeCurrent();
      final weather = makeWeather(current: current, daily: []);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 320,
              child: WeatherMetricsRow(
                weather: weather,
                unit: TemperatureUnit.celsius,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Wrap), findsOneWidget);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 800,
              child: WeatherMetricsRow(
                weather: weather,
                unit: TemperatureUnit.celsius,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Row), findsWidgets);
      expect(find.byType(Wrap), findsNothing);
    },
  );
}
