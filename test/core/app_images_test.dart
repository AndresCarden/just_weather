import 'package:flutter_test/flutter_test.dart';
import 'package:just_weather/core/app_images.dart';

void main() {
  group('AppImages', () {
    test('sunCloudLight path es correcto', () {
      expect(AppImages.sunCloudLight, 'assets/icons/sun_cloud_light.png');
      expect(AppImages.sunCloudLight, isA<String>());
    });

    test('sunCloudDark path es correcto', () {
      expect(AppImages.sunCloudDark, 'assets/icons/sun_cloud_dark.png');
      expect(AppImages.sunCloudDark, isA<String>());
    });
  });
}
