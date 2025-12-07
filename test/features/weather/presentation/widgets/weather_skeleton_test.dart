import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:just_weather/features/weather/presentation/widgets/weather_skeleton.dart';
import 'package:just_weather/features/weather/presentation/widgets/skeleton_box.dart';

void main() {
  testWidgets('WeatherSkeleton se renderiza con estructura básica', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: WeatherSkeleton())),
    );

    expect(find.byType(SafeArea), findsOneWidget);

    expect(find.byType(SingleChildScrollView), findsOneWidget);

    expect(find.byType(Column), findsWidgets);

    expect(find.byType(SkeletonBox), findsWidgets);

    final listViewFinder = find.byType(ListView);
    expect(listViewFinder, findsOneWidget);

    final listView = tester.widget<ListView>(listViewFinder);
    expect(listView.scrollDirection, Axis.horizontal);

    final gridViewFinder = find.byType(GridView);
    expect(gridViewFinder, findsOneWidget);

    final gridView = tester.widget<GridView>(gridViewFinder);
    expect(gridView.shrinkWrap, true);
    expect(gridView.physics, isA<NeverScrollableScrollPhysics>());
  });

  testWidgets(
    'usa color basado en surfaceContainerHighest para las tarjetas skeleton',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherSkeleton())),
      );

      final weatherSkeletonFinder = find.byType(WeatherSkeleton);
      final context = tester.element(weatherSkeletonFinder);

      final theme = Theme.of(context);
      final expectedColor = theme.colorScheme.surfaceContainerHighest
          .withValues(alpha: 0.3);

      final cardContainerFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).color == expectedColor,
      );

      expect(cardContainerFinder, findsWidgets);
    },
  );

  testWidgets('estructura de métricas, horas y detalles existe', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: WeatherSkeleton())),
    );

    final rows = find.byType(Row);
    expect(rows, findsWidgets);

    final sizedBox110Finder = find.byWidgetPredicate(
      (widget) => widget is SizedBox && widget.height == 110,
    );
    expect(sizedBox110Finder, findsOneWidget);

    final gridFinder = find.byType(GridView);
    expect(gridFinder, findsOneWidget);
    final detailSkeletonsFinder = find.descendant(
      of: gridFinder,
      matching: find.byType(SkeletonBox),
    );
    expect(detailSkeletonsFinder, findsNWidgets(12));
  });
}
