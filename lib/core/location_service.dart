import 'dart:math';

import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<String> getQueryForWeather() async {
    try {
      final hasPermission = await _handlePermission();

      if (!hasPermission) {
        return _getRandomCapital();
      }

      final isLocationServiceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!isLocationServiceEnabled) {
        return _getRandomCapital();
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.medium),
      );

      return '${position.latitude},${position.longitude}';
    } catch (_) {
      return _getRandomCapital();
    }
  }

  Future<bool> _handlePermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  String _getRandomCapital() {
    const capitals = [
      'Bogota',
      'London',
      'Tokyo',
      'Paris',
      'New York',
      'Madrid',
      'Buenos Aires',
      'Mexico City',
      'Santiago',
      'Berlin',
    ];

    final random = Random();
    return capitals[random.nextInt(capitals.length)];
  }
}
