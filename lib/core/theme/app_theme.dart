import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.blue,
      scaffoldBackgroundColor: AppColors.gray100,
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.xl,
        headlineMedium: AppTextStyles.m,
        bodyMedium: AppTextStyles.body,
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: AppColors.blue,
        secondary: AppColors.indigo400,
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.black,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.indigo400,
        surface: Color(0xFF1E1E1E),
        surfaceContainerHighest: Color(0xFF2C2C2C),
      ),
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.xl,
        headlineMedium: AppTextStyles.m,
        bodyMedium: AppTextStyles.body,
      ),
    );
  }
}
