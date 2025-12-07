import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:just_weather/features/weather/presentation/widgets/unit_chip.dart';
import 'package:just_weather/core/theme/app_text_styles.dart';

void main() {
  group('UnitChip', () {
    testWidgets('muestra el label correctamente', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UnitChip(label: '°C', isActive: false, onTap: () {}),
          ),
        ),
      );

      expect(find.text('°C'), findsOneWidget);
    });

    testWidgets('cuando isActive = true usa fondo primary y texto blanco', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          ),
          home: Scaffold(
            body: Center(
              child: UnitChip(label: '°C', isActive: true, onTap: () {}),
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

      final context = tester.element(containerFinder);
      final theme = Theme.of(context);

      expect(decoration.color, theme.colorScheme.primary);

      final textFinder = find.text('°C');
      final textWidget = tester.widget<Text>(textFinder);
      final textStyle = textWidget.style!;

      expect(textStyle.color, Colors.white);
      expect(textStyle.fontWeight, FontWeight.w600);
      expect(textStyle.fontFamily, AppTextStyles.body2.fontFamily);
      expect(textStyle.fontSize, AppTextStyles.body2.fontSize);
    });

    testWidgets(
      'cuando isActive = false usa fondo transparente y texto onSurface',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
            ),
            home: Scaffold(
              body: Center(
                child: UnitChip(label: '°F', isActive: false, onTap: () {}),
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

        final context = tester.element(containerFinder);
        final theme = Theme.of(context);

        // Fondo transparente
        expect(decoration.color, Colors.transparent);

        // Texto = onSurface
        final textFinder = find.text('°F');
        final textWidget = tester.widget<Text>(textFinder);
        final textStyle = textWidget.style!;

        expect(textStyle.color, theme.colorScheme.onSurface);
        expect(textStyle.fontWeight, FontWeight.w600);
      },
    );

    testWidgets('llama a onTap cuando se toca el chip', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: UnitChip(
                label: '°C',
                isActive: false,
                onTap: () {
                  tapped = true;
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('°C'));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });
  });
}
