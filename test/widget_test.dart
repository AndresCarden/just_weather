import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_weather/main.dart';

void main() {
  testWidgets('App shows title Just Weather', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: JustWeatherApp()));

    expect(find.text('Just Weather'), findsOneWidget);
  });
}
