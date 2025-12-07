import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:just_weather/features/weather/presentation/widgets/weather_metric_card.dart';
import 'package:just_weather/core/theme/app_text_styles.dart';

void main() {
  group('WeatherMetricCard', () {
    testWidgets('muestra título, valor formateado y descripción', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherMetricCard(
              icon: Icons.thermostat,
              title: 'Temperature',
              value: 23.456,
              unit: '°C',
              changePercent: 5.2,
              description: 'Above the weekly average',
            ),
          ),
        ),
      );

      expect(find.text('Temperature'), findsOneWidget);
      expect(find.text('23.5°C'), findsOneWidget);
      expect(find.text('Above the weekly average'), findsOneWidget);
    });

    testWidgets(
      'usa flecha hacia arriba y verde cuando changePercent es positivo',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherMetricCard(
                icon: Icons.water_drop,
                title: 'Humidity',
                value: 60,
                unit: '%',
                changePercent: 3.0,
                description: 'Slightly higher than usual',
              ),
            ),
          ),
        );

        final arrowFinder = find.byIcon(Icons.arrow_upward);
        expect(arrowFinder, findsOneWidget);

        final arrowIcon = tester.widget<Icon>(arrowFinder);
        expect(arrowIcon.color, Colors.green);

        final percentTextFinder = find.text('3.0%');
        expect(percentTextFinder, findsOneWidget);

        final percentText = tester.widget<Text>(percentTextFinder);
        expect(percentText.style?.color, Colors.green);
      },
    );

    testWidgets(
      'usa flecha hacia abajo y rojo cuando changePercent es negativo',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeatherMetricCard(
                icon: Icons.water_drop,
                title: 'Humidity',
                value: 55,
                unit: '%',
                changePercent: -2.5,
                description: 'Slightly lower than usual',
              ),
            ),
          ),
        );

        final arrowFinder = find.byIcon(Icons.arrow_downward);
        expect(arrowFinder, findsOneWidget);

        final arrowIcon = tester.widget<Icon>(arrowFinder);
        expect(arrowIcon.color, Colors.red);

        final percentTextFinder = find.text('2.5%');
        expect(percentTextFinder, findsOneWidget);

        final percentText = tester.widget<Text>(percentTextFinder);
        expect(percentText.style?.color, Colors.red);
      },
    );

    testWidgets('aplica los estilos de texto configurados', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherMetricCard(
              icon: Icons.thermostat,
              title: 'Temperature',
              value: 21.0,
              unit: '°C',
              changePercent: 0.0,
              description: 'Stable compared to yesterday',
            ),
          ),
        ),
      );

      final titleText = tester.widget<Text>(find.text('Temperature'));
      expect(titleText.style?.fontSize, AppTextStyles.s.fontSize);
      expect(titleText.style?.fontWeight, AppTextStyles.s.fontWeight);
      expect(titleText.style?.fontFamily, AppTextStyles.s.fontFamily);

      final valueText = tester.widget<Text>(find.text('21.0°C'));
      expect(valueText.style?.fontSize, AppTextStyles.l.fontSize);
      expect(valueText.style?.fontWeight, AppTextStyles.l.fontWeight);
      expect(valueText.style?.fontFamily, AppTextStyles.l.fontFamily);

      final descText = tester.widget<Text>(
        find.text('Stable compared to yesterday'),
      );
      expect(descText.style?.fontSize, AppTextStyles.body.fontSize);
      expect(descText.style?.fontWeight, AppTextStyles.body.fontWeight);
      expect(descText.style?.fontFamily, AppTextStyles.body.fontFamily);
    });
  });
}
