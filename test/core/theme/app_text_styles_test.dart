import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:just_weather/core/theme/app_text_styles.dart';

void main() {
  group('AppTextStyles', () {
    test('xl text style values', () {
      const style = AppTextStyles.xl;

      expect(style.fontFamily, 'Nunito');
      expect(style.fontSize, 63);
      expect(style.fontWeight, FontWeight.bold);
      expect(style.letterSpacing, 0.25);
    });

    test('l text style values', () {
      const style = AppTextStyles.l;

      expect(style.fontFamily, 'Nunito');
      expect(style.fontSize, 35);
      expect(style.fontWeight, FontWeight.w600);
      expect(style.letterSpacing, 0.25);
    });

    test('m text style values', () {
      const style = AppTextStyles.m;

      expect(style.fontFamily, 'Nunito');
      expect(style.fontSize, 26);
      expect(style.fontWeight, FontWeight.w500);
      expect(style.letterSpacing, 0.25);
    });

    test('s text style values', () {
      const style = AppTextStyles.s;

      expect(style.fontFamily, 'Nunito');
      expect(style.fontSize, 21);
      expect(style.fontWeight, FontWeight.w600);
      expect(style.letterSpacing, 0.15);
    });

    test('body text style values', () {
      const style = AppTextStyles.body;

      expect(style.fontFamily, 'Nunito');
      expect(style.fontSize, 16);
      expect(style.fontWeight, FontWeight.normal);
      expect(style.letterSpacing, 0.15);
    });

    test('body2 text style values', () {
      const style = AppTextStyles.body2;

      expect(style.fontFamily, 'Nunito');
      expect(style.fontSize, 16);
      expect(style.fontWeight, FontWeight.w600);
      expect(style.letterSpacing, 0.15);
    });

    test('body3 text style values', () {
      const style = AppTextStyles.body3;

      expect(style.fontFamily, 'Nunito');
      expect(style.fontSize, 16);
      expect(style.fontWeight, FontWeight.bold);
      expect(style.letterSpacing, 0.15);
    });
  });
}
