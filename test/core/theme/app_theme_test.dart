import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_weather/core/theme/app_colors.dart';
import 'package:just_weather/core/theme/app_text_styles.dart';
import 'package:just_weather/core/theme/app_theme.dart';

void main() {
  group('AppTheme', () {
    test('light theme text styles', () {
      final theme = AppTheme.light();

      final display = theme.textTheme.displayLarge!;
      expect(display.fontFamily, AppTextStyles.xl.fontFamily);
      expect(display.fontSize, AppTextStyles.xl.fontSize);
      expect(display.fontWeight, AppTextStyles.xl.fontWeight);
      expect(display.letterSpacing, AppTextStyles.xl.letterSpacing);

      final headline = theme.textTheme.headlineMedium!;
      expect(headline.fontFamily, AppTextStyles.m.fontFamily);
      expect(headline.fontSize, AppTextStyles.m.fontSize);
      expect(headline.fontWeight, AppTextStyles.m.fontWeight);
      expect(headline.letterSpacing, AppTextStyles.m.letterSpacing);

      final body = theme.textTheme.bodyMedium!;
      expect(body.fontFamily, AppTextStyles.body.fontFamily);
      expect(body.fontSize, AppTextStyles.body.fontSize);
      expect(body.fontWeight, AppTextStyles.body.fontWeight);
      expect(body.letterSpacing, AppTextStyles.body.letterSpacing);
    });

    test('dark theme config', () {
      final theme = AppTheme.dark();

      expect(theme.brightness, Brightness.dark);
      expect(theme.useMaterial3, true);
      expect(theme.scaffoldBackgroundColor, Colors.black);

      expect(theme.colorScheme.primary, AppColors.indigo400);
      expect(theme.colorScheme.surface, const Color(0xFF1E1E1E));
      expect(
        theme.colorScheme.surfaceContainerHighest,
        const Color(0xFF2C2C2C),
      );

      final display = theme.textTheme.displayLarge!;
      expect(display.fontFamily, AppTextStyles.xl.fontFamily);
      expect(display.fontSize, AppTextStyles.xl.fontSize);
      expect(display.fontWeight, AppTextStyles.xl.fontWeight);
      expect(display.letterSpacing, AppTextStyles.xl.letterSpacing);

      final headline = theme.textTheme.headlineMedium!;
      expect(headline.fontFamily, AppTextStyles.m.fontFamily);
      expect(headline.fontSize, AppTextStyles.m.fontSize);
      expect(headline.fontWeight, AppTextStyles.m.fontWeight);
      expect(headline.letterSpacing, AppTextStyles.m.letterSpacing);

      final body = theme.textTheme.bodyMedium!;
      expect(body.fontFamily, AppTextStyles.body.fontFamily);
      expect(body.fontSize, AppTextStyles.body.fontSize);
      expect(body.fontWeight, AppTextStyles.body.fontWeight);
      expect(body.letterSpacing, AppTextStyles.body.letterSpacing);
    });
  });
}
