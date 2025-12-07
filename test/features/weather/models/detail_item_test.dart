import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:just_weather/features/weather/models/detail_item.dart';

void main() {
  group('DetailItem', () {
    test('constructor asigna correctamente los valores', () {
      const icon = Icons.wb_sunny;
      const label = 'Sunrise';
      const value = '06:45';

      final item = DetailItem(icon: icon, label: label, value: value);

      expect(item.icon, icon);
      expect(item.label, label);
      expect(item.value, value);
    });

    test('acepta diferentes valores', () {
      const icon = Icons.water_drop_outlined;
      const label = 'Humidity';
      const value = '70%';

      final item = DetailItem(icon: icon, label: label, value: value);

      expect(item.icon, icon);
      expect(item.label, label);
      expect(item.value, value);
    });
  });
}
