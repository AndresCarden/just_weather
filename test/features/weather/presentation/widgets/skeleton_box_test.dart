import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:just_weather/features/weather/presentation/widgets/skeleton_box.dart';

void main() {
  group('SkeletonBox', () {
    testWidgets('usa las dimensiones y borderRadius proporcionados', (
      tester,
    ) async {
      const width = 120.0;
      const height = 16.0;
      const radius = 12.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SkeletonBox(
              width: width,
              height: height,
              borderRadius: radius,
            ),
          ),
        ),
      );

      final containerFinder = find.byType(Container);
      expect(containerFinder, findsOneWidget);
      final size = tester.getSize(containerFinder);
      expect(size.width, width);
      expect(size.height, height);
      final container = tester.widget<Container>(containerFinder);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(radius));
    });

    testWidgets('usa gris claro en tema light', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: const Scaffold(body: SkeletonBox(width: 100, height: 20)),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;

      expect(decoration.color, Colors.grey.shade300);
    });

    testWidgets('usa gris oscuro en tema dark', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: const Scaffold(body: SkeletonBox(width: 100, height: 20)),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;

      expect(decoration.color, Colors.grey.shade800);
    });

    testWidgets('anima la opacidad entre 0.4 y 0.9', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: SkeletonBox(width: 100, height: 20)),
        ),
      );

      FadeTransition fade = tester.widget<FadeTransition>(
        find.byType(FadeTransition),
      );
      final Animation<double> opacityAnimation = fade.opacity;

      expect(opacityAnimation.value, closeTo(0.4, 0.05));

      await tester.pump(const Duration(milliseconds: 500));

      fade = tester.widget<FadeTransition>(find.byType(FadeTransition));
      final midValue = (fade.opacity).value;

      expect(midValue, inInclusiveRange(0.4, 0.9));

      await tester.pump(const Duration(milliseconds: 500));

      fade = tester.widget<FadeTransition>(find.byType(FadeTransition));
      final endValue = (fade.opacity).value;

      expect(endValue, inInclusiveRange(0.4, 0.9));
    });
  });
}
