import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:just_weather/core/api_client.dart';
import 'package:just_weather/features/weather/data/weather_api_service.dart';
import 'package:just_weather/features/weather/models/weather_models.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockClient;
  late WeatherApiService service;

  setUp(() {
    mockClient = MockApiClient();
    service = WeatherApiService(mockClient);
  });

  group('getWeatherByQuery', () {
    test(
      'llama al endpoint correcto con query params adecuados y retorna el mapa',
      () async {
        const query = 'London';
        final expectedQueryParams = {
          'q': query,
          'days': '7',
          'aqi': 'no',
          'alerts': 'no',
        };

        final fakeResponse = {
          'location': {'name': 'London'},
          'current': {'temp_c': 18.0},
        };

        when(
          () => mockClient.get('/v1/forecast.json', query: expectedQueryParams),
        ).thenAnswer((_) async => fakeResponse);

        final result = await service.getWeatherByQuery(query);

        expect(result, fakeResponse);

        verify(
          () => mockClient.get('/v1/forecast.json', query: expectedQueryParams),
        ).called(1);
      },
    );
  });

  group('searchLocations', () {
    test(
      'si query está vacío o solo espacios, retorna lista vacía y no llama al cliente',
      () async {
        final result1 = await service.searchLocations('');
        final result2 = await service.searchLocations('   ');

        expect(result1, isEmpty);
        expect(result2, isEmpty);

        verifyNever(
          () => mockClient.getList(any(), query: any(named: 'query')),
        );
      },
    );

    test(
      'si query tiene texto, llama al endpoint correcto con params adecuados',
      () async {
        const query = 'London';
        final expectedQueryParams = {'q': query};

        final fakeListJson = [
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

        when(
          () =>
              mockClient.getList('/v1/search.json', query: expectedQueryParams),
        ).thenAnswer((_) async => fakeListJson);

        final result = await service.searchLocations(query);

        expect(result, isA<List<WeatherLocation>>());
        expect(result.length, 2);
        expect(result.first.name, 'London');
        expect(result.first.country, 'United Kingdom');

        verify(
          () =>
              mockClient.getList('/v1/search.json', query: expectedQueryParams),
        ).called(1);
      },
    );

    test('limita la lista a máximo 5 elementos', () async {
      const query = 'a';

      final fakeListJson = List.generate(10, (i) {
        return {
          'name': 'City$i',
          'country': 'Country$i',
          'region': 'Region$i',
          'lat': 0.0 + i,
          'lon': 0.0 - i,
          'url': 'city$i-country$i',
        };
      });

      when(
        () => mockClient.getList('/v1/search.json', query: {'q': query}),
      ).thenAnswer((_) async => fakeListJson);

      final result = await service.searchLocations(query);

      expect(result.length, 5);
      expect(result.first.name, 'City0');
      expect(result.last.name, 'City4');
    });
  });
}
