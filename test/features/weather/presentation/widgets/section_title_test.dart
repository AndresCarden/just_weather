import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:just_weather/features/weather/presentation/widgets/section_title.dart';
import 'package:just_weather/core/theme/app_text_styles.dart';

void main() {
  testWidgets('muestra el texto pasado como parámetro', (tester) async {
    const text = 'Hourly Forecast';

    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: SectionTitle(text))),
    );

    expect(find.text(text), findsOneWidget);
  });

  testWidgets('usa AppTextStyles.s como estilo de texto', (tester) async {
    const text = 'Daily Forecast';

    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: SectionTitle(text))),
    );

    final textWidget = tester.widget<Text>(find.text(text));

    expect(textWidget.style?.fontSize, AppTextStyles.s.fontSize);
    expect(textWidget.style?.fontWeight, AppTextStyles.s.fontWeight);
    expect(textWidget.style?.fontFamily, AppTextStyles.s.fontFamily);
  });

  testWidgets('aplica padding bottom de 8', (tester) async {
    const text = 'Test';

    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: SectionTitle(text))),
    );

    final paddingFinder = find.byType(Padding);
    expect(paddingFinder, findsOneWidget);

    final paddingWidget = tester.widget<Padding>(paddingFinder);
    expect(paddingWidget.padding, const EdgeInsets.only(bottom: 8));
  });
}
