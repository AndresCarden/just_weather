import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:just_weather/core/theme/app_colors.dart';

void main() {
  group('AppColors', () {
    test('gray900 should be correct color value', () {
      expect(AppColors.gray900, const Color(0xFF212121));
    });

    test('gray900_60 should be correct color value', () {
      expect(AppColors.gray900_60, const Color(0x99212121));
    });

    test('gray900_32 should be correct color value', () {
      expect(AppColors.gray900_32, const Color(0x52212121));
    });

    test('gray100 should be correct color value', () {
      expect(AppColors.gray100, const Color(0xFFF5F5F5));
    });

    test('gray100_60 should be correct color value', () {
      expect(AppColors.gray100_60, const Color(0x99F5F5F5));
    });

    test('gray100_32 should be correct color value', () {
      expect(AppColors.gray100_32, const Color(0x52F5F5F5));
    });

    test('white should be correct color value', () {
      expect(AppColors.white, const Color(0xFFFFFFFF));
    });

    test('white_81 should be correct color value', () {
      expect(AppColors.white_81, const Color(0xCFFFFFFF));
    });

    test('white_51 should be correct color value', () {
      expect(AppColors.white_51, const Color(0x82FFFFFF));
    });

    test('blue should be correct color value', () {
      expect(AppColors.blue, const Color(0xFF02326E));
    });

    test('indigo400 should be correct color value', () {
      expect(AppColors.indigo400, const Color(0xFF5C8BC0));
    });

    test('indigo50 should be correct color value', () {
      expect(AppColors.indigo50, const Color(0xFFEBFAF6));
    });
  });
}
