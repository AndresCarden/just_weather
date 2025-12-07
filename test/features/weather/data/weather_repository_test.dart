import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:just_weather/features/weather/data/weather_repository.dart';
import 'package:just_weather/features/weather/data/weather_api_service.dart';
import 'package:just_weather/features/weather/models/weather_models.dart';

class MockWeatherApiService extends Mock implements WeatherApiService {}

void main() {
  late MockWeatherApiService mockService;
  late WeatherRepositoryImpl repository;

  setUp(() {
    mockService = MockWeatherApiService();
    repository = WeatherRepositoryImpl(mockService);
  });

  group('WeatherRepositoryImpl.getWeather', () {
    test('si el service lanza excepción, el repo también lanza', () async {
      const query = 'Madrid';

      when(
        () => mockService.getWeatherByQuery(query),
      ).thenThrow(Exception('network error'));

      expect(() => repository.getWeather(query), throwsA(isA<Exception>()));

      verify(() => mockService.getWeatherByQuery(query)).called(1);
    });
  });

  group('WeatherRepositoryImpl.searchLocations', () {
    test(
      'delegates en WeatherApiService.searchLocations y retorna la misma lista',
      () async {
        const query = 'Lon';

        final fakeJsonList = [
          {
            'name': 'London',
            'country': 'United Kingdom',
            'region': 'City of London, Greater London',
            'lat': 51.52,
            'lon': -0.11,
            'url': 'london-city-of-london-greater-london-united-kingdom',
          },
          {
            'name': 'London',
            'country': 'Canada',
            'region': 'Ontario',
            'lat': 42.98,
            'lon': -81.25,
            'url': 'london-ontario-canada',
          },
        ];

        final locations = fakeJsonList
            .map((e) => WeatherLocation.fromJson(e))
            .toList();

        when(
          () => mockService.searchLocations(query),
        ).thenAnswer((_) async => locations);

        final result = await repository.searchLocations(query);

        expect(result, isA<List<WeatherLocation>>());
        expect(result.length, 2);
        expect(result.first.name, 'London');
        expect(result.first.country, 'United Kingdom');

        verify(() => mockService.searchLocations(query)).called(1);
      },
    );
  });
}
