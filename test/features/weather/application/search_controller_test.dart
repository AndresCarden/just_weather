import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
// ignore: depend_on_referenced_packages
import 'package:fake_async/fake_async.dart';
import 'package:just_weather/features/weather/application/search_controller.dart';
import 'package:just_weather/features/weather/data/weather_repository.dart';
import 'package:just_weather/features/weather/models/weather_models.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  late MockWeatherRepository mockRepo;
  late SearchController controller;

  WeatherLocation makeLocation(String name, String country) {
    return WeatherLocation(
      name: name,
      country: country,
      lat: 0.0,
      lon: 0.0,
      timezone: '',
    );
  }

  setUp(() {
    mockRepo = MockWeatherRepository();
    controller = SearchController(mockRepo);
  });

  group('SearchState inicial', () {
    test('tiene valores por defecto correctos', () {
      final state = controller.state;

      expect(state.isLoading, false);
      expect(state.query, '');
      expect(state.results, isEmpty);
      expect(state.recent, isEmpty);
      expect(state.error, isNull);
    });
  });

  group('onQueryChanged', () {
    test(
      'cuando query está vacío limpia resultados y error y detiene loading',
      () {
        controller.state = SearchState(
          isLoading: true,
          query: 'London',
          results: [makeLocation('London', 'UK')],
          error: 'Error previous',
        );

        controller.onQueryChanged('  ');

        final state = controller.state;
        expect(state.query, '  ');
        expect(state.isLoading, false);
        expect(state.results, isEmpty);
        expect(state.error, isNull);
      },
    );

    test(
      'cuando query tiene valor, luego de 400ms hace búsqueda y actualiza resultados',
      () {
        fakeAsync((async) {
          final results = [
            makeLocation('London', 'UK'),
            makeLocation('Londonderry', 'UK'),
          ];

          when(
            () => mockRepo.searchLocations('Lon'),
          ).thenAnswer((_) async => results);

          controller.onQueryChanged('Lon');

          verifyNever(() => mockRepo.searchLocations(any()));

          async.elapse(const Duration(milliseconds: 450));

          verify(() => mockRepo.searchLocations('Lon')).called(1);

          final state = controller.state;
          expect(state.isLoading, false);
          expect(state.results, results);
          expect(state.error, isNull);
        });
      },
    );

    test(
      'si el repo lanza error, guarda mensaje error y limpia resultados tras debounce',
      () {
        fakeAsync((async) {
          when(
            () => mockRepo.searchLocations('Paris'),
          ).thenThrow(Exception('network'));

          controller.onQueryChanged('Paris');

          async.elapse(const Duration(milliseconds: 450));

          verify(() => mockRepo.searchLocations('Paris')).called(1);

          final state = controller.state;
          expect(state.isLoading, false);
          expect(state.results, isEmpty);
          expect(state.error, 'Error searching locations');
        });
      },
    );

    test(
      'al escribir una segunda query antes del debounce, solo busca la última',
      () {
        fakeAsync((async) {
          when(
            () => mockRepo.searchLocations('Lon'),
          ).thenAnswer((_) async => [makeLocation('London', 'UK')]);
          when(
            () => mockRepo.searchLocations('London'),
          ).thenAnswer((_) async => [makeLocation('London', 'UK')]);

          controller.onQueryChanged('Lon');

          async.elapse(const Duration(milliseconds: 200));

          verifyNever(() => mockRepo.searchLocations(any()));

          controller.onQueryChanged('London');

          async.elapse(const Duration(milliseconds: 450));

          verify(() => mockRepo.searchLocations('London')).called(1);
          verifyNever(() => mockRepo.searchLocations('Lon'));
        });
      },
    );
  });

  group('recent search handling', () {
    test('addRecent agrega un elemento nuevo al inicio', () {
      final loc = makeLocation('London', 'UK');
      controller.addRecent(loc);

      final state = controller.state;
      expect(state.recent.length, 1);
      expect(state.recent.first.name, 'London');
    });

    test('addRecent no agrega duplicados', () {
      final loc = makeLocation('London', 'UK');

      controller.addRecent(loc);
      controller.addRecent(loc);

      final state = controller.state;
      expect(state.recent.length, 1);
    });

    test('addRecent mantiene solo los últimos 5', () {
      final locations = [
        makeLocation('City1', 'C1'),
        makeLocation('City2', 'C2'),
        makeLocation('City3', 'C3'),
        makeLocation('City4', 'C4'),
        makeLocation('City5', 'C5'),
        makeLocation('City6', 'C6'),
      ];

      for (final loc in locations) {
        controller.addRecent(loc);
      }

      final state = controller.state;
      expect(state.recent.length, 5);
      expect(state.recent.first.name, 'City6');
      expect(state.recent.any((r) => r.name == 'City1'), false);
    });

    test('clearAllRecent vacía la lista reciente', () {
      controller.addRecent(makeLocation('London', 'UK'));
      controller.addRecent(makeLocation('Paris', 'FR'));

      controller.clearAllRecent();

      final state = controller.state;
      expect(state.recent, isEmpty);
    });

    test('deleteRecent elimina solo el elemento indicado', () {
      final loc1 = makeLocation('London', 'UK');
      final loc2 = makeLocation('Paris', 'FR');

      controller.addRecent(loc1);
      controller.addRecent(loc2);

      controller.deleteRecent(loc1);

      final state = controller.state;

      expect(state.recent.length, 1);
      expect(state.recent.first.name, 'Paris');
    });
  });
}
