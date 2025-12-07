import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:just_weather/features/weather/presentation/widgets/daily_forecast_strip.dart';
import 'package:just_weather/features/weather/models/weather_models.dart';
import 'package:just_weather/features/weather/application/weather_controller.dart';

void main() {
  DayForecast makeDay({
    required DateTime date,
    required double maxC,
    required double minC,
    required double maxF,
    required double minF,
    String icon = '//cdn.weatherapi.com/icons/day.png',
    String text = 'Sunny',
    double chanceOfRain = 0,
  }) {
    return DayForecast(
      date: date,
      maxTempC: maxC,
      minTempC: minC,
      maxTempF: maxF,
      minTempF: minF,
      conditionIcon: icon,
      conditionText: text,
      chanceOfRain: chanceOfRain,
    );
  }

  testWidgets(
    'cuando days está vacío muestra mensaje "No daily forecast available"',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DailyForecastStrip(days: [], unit: TemperatureUnit.celsius),
          ),
        ),
      );

      expect(find.text('No hay pronóstico diario disponible'), findsOneWidget);
    },
  );

  testWidgets('renderiza items con temperaturas en °C cuando unit es celsius', (
    tester,
  ) async {
    final days = [
      makeDay(
        date: DateTime(2024, 1, 1),
        maxC: 20,
        minC: 10,
        maxF: 68,
        minF: 50,
      ),
      makeDay(
        date: DateTime(2024, 1, 2),
        maxC: 22,
        minC: 12,
        maxF: 71.6,
        minF: 53.6,
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DailyForecastStrip(days: days, unit: TemperatureUnit.celsius),
        ),
      ),
    );

    expect(find.text('20°C'), findsOneWidget);
    expect(find.text('10°C'), findsOneWidget);
    expect(find.text('22°C'), findsOneWidget);
    expect(find.text('12°C'), findsOneWidget);
  });

  testWidgets(
    'renderiza items con temperaturas en °F cuando unit es fahrenheit',
    (tester) async {
      final days = [
        makeDay(
          date: DateTime(2024, 1, 1),
          maxC: 20,
          minC: 10,
          maxF: 68,
          minF: 50,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DailyForecastStrip(
              days: days,
              unit: TemperatureUnit.fahrenheit,
            ),
          ),
        ),
      );

      expect(find.text('68°F'), findsOneWidget);
      expect(find.text('50°F'), findsOneWidget);
    },
  );

  testWidgets('usa fondo oscuro cuando el tema es dark', (tester) async {
    final days = [
      makeDay(
        date: DateTime(2024, 1, 1),
        maxC: 20,
        minC: 10,
        maxF: 68,
        minF: 50,
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark(),
        home: Scaffold(
          body: DailyForecastStrip(days: days, unit: TemperatureUnit.celsius),
        ),
      ),
    );

    // Encontramos el primer Container del item
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
