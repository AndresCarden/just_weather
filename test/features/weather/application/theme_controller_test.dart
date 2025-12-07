import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:just_weather/features/weather/application/theme_controller.dart';

void main() {
  group('ThemeController', () {
    test('estado inicial es ThemeMode.light', () {
      final container = ProviderContainer();
      final themeMode = container.read(themeControllerProvider);

      expect(themeMode, ThemeMode.light);
    });

    test('toggle() cambia correctamente entre light y dark', () {
      final container = ProviderContainer();
      final controller = container.read(themeControllerProvider.notifier);

      expect(container.read(themeControllerProvider), ThemeMode.light);

      controller.toggle();
      expect(container.read(themeControllerProvider), ThemeMode.dark);

      controller.toggle();
      expect(container.read(themeControllerProvider), ThemeMode.light);
    });

    test('setTheme(ThemeMode.dark) cambia el estado a dark', () {
      final container = ProviderContainer();
      final controller = container.read(themeControllerProvider.notifier);

      controller.setTheme(ThemeMode.dark);

      expect(container.read(themeControllerProvider), ThemeMode.dark);
    });

    test('setTheme(ThemeMode.light) cambia el estado a light', () {
      final container = ProviderContainer();
      final controller = container.read(themeControllerProvider.notifier);

      controller.setTheme(ThemeMode.light);

      expect(container.read(themeControllerProvider), ThemeMode.light);
    });
  });
}
