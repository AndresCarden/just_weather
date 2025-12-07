import 'package:flutter_test/flutter_test.dart';
import 'package:just_weather/core/env.dart';

void main() {
  group('Env', () {
    test('apiBase y apiKey existen como constantes', () {
      expect(Env.apiBase, isA<String>());
      expect(Env.apiKey, isA<String>());
    });

    test('cuando no se define nada, son empty strings', () {
      expect(Env.apiBase.isEmpty, true);
      expect(Env.apiKey.isEmpty, true);
    });
  });
}
