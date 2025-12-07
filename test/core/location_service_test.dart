import 'package:flutter_test/flutter_test.dart';
// ignore: depend_on_referenced_packages
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
// ignore: depend_on_referenced_packages
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'package:just_weather/core/location_service.dart';

/// Fake de GeolocatorPlatform que podemos controlar en cada test
class FakeGeolocatorPlatform extends GeolocatorPlatform
    with MockPlatformInterfaceMixin {
  LocationPermission permission = LocationPermission.always;
  bool serviceEnabled = true;
  Position? position;
  bool throwOnGetPosition = false;

  @override
  Future<LocationPermission> checkPermission() async {
    return permission;
  }

  @override
  Future<LocationPermission> requestPermission() async {
    return permission;
  }

  @override
  Future<bool> isLocationServiceEnabled() async {
    return serviceEnabled;
  }

  @override
  Future<Position> getCurrentPosition({
    LocationSettings? locationSettings,
  }) async {
    if (throwOnGetPosition) {
      throw Exception('boom');
    }

    return position ??
        Position(
          latitude: 10.5,
          longitude: -74.2,
          timestamp: DateTime.now(),
          accuracy: 10.0,
          altitude: 0.0,
          heading: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
          altitudeAccuracy: 0.0,
          headingAccuracy: 0.0,
        );
  }
}

void main() {
  late FakeGeolocatorPlatform fakePlatform;
  late LocationService service;

  setUp(() {
    fakePlatform = FakeGeolocatorPlatform();
    GeolocatorPlatform.instance = fakePlatform;

    service = LocationService();
  });

  test(
    'si tiene permiso y location está habilitado → retorna "lat,long" de la posición',
    () async {
      // Arrange
      fakePlatform.permission = LocationPermission.always;
      fakePlatform.serviceEnabled = true;
      fakePlatform.position = Position(
        latitude: 4.61,
        longitude: -74.08,
        timestamp: DateTime.now(),
        accuracy: 5.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        altitudeAccuracy: 0.0,
        headingAccuracy: 0.0,
      );

      // Act
      final result = await service.getQueryForWeather();

      // Assert
      expect(result, '4.61,-74.08');
    },
  );

  test('si permiso denegado → retorna una capital aleatoria', () async {
    fakePlatform.permission = LocationPermission.denied;

    final result = await service.getQueryForWeather();

    expect(_isCapital(result), true);
  });

  test(
    'si servicio de ubicación está deshabilitado → retorna una capital aleatoria',
    () async {
      fakePlatform.permission = LocationPermission.always;
      fakePlatform.serviceEnabled = false;

      final result = await service.getQueryForWeather();

      expect(_isCapital(result), true);
    },
  );

  test(
    'si getCurrentPosition lanza error → retorna una capital aleatoria',
    () async {
      fakePlatform.permission = LocationPermission.always;
      fakePlatform.serviceEnabled = true;
      fakePlatform.throwOnGetPosition = true;

      final result = await service.getQueryForWeather();

      expect(_isCapital(result), true);
    },
  );
}

bool _isCapital(String value) {
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

  return capitals.contains(value);
}
