import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:just_weather/features/weather/application/weather_controller.dart';
import 'package:just_weather/features/weather/data/weather_repository.dart';
import 'package:just_weather/features/weather/models/weather_models.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

class FakeFullWeather extends Fake implements FullWeather {}

void main() {
  late MockWeatherRepository mockRepo;
  late WeatherController controller;
  late FullWeather fakeWeather;

  setUpAll(() {
    registerFallbackValue(FakeFullWeather());
  });

  setUp(() {
    mockRepo = MockWeatherRepository();
    controller = WeatherController(mockRepo);
    fakeWeather = FakeFullWeather();
  });

  group('Estado inicial', () {
    test('WeatherState inicial tiene valores por defecto correctos', () {
      final state = controller.state;

      expect(state.isLoading, false);
      expect(state.isError, false);
      expect(state.errorMessage, isNull);
      expect(state.data, isNull);
      expect(state.unit, TemperatureUnit.celsius);
      expect(controller.lastQuery, isNull);
    });
  });

  group('loadWeather', () {
    test(
      'cuando getWeather tiene éxito, actualiza data y desactiva loading',
      () async {
        when(
          () => mockRepo.getWeather('London'),
        ).thenAnswer((_) async => fakeWeather);

        await controller.loadWeather('London');

        final state = controller.state;
        expect(controller.lastQuery, 'London');
        expect(state.isLoading, false);
        expect(state.isError, false);
        expect(state.errorMessage, isNull);
        expect(state.data, fakeWeather);

        verify(() => mockRepo.getWeather('London')).called(1);
      },
    );

    test(
      'cuando getWeather lanza error, setea isError y errorMessage',
      () async {
        when(
          () => mockRepo.getWeather('Madrid'),
        ).thenThrow(Exception('network'));

        await controller.loadWeather('Madrid');

        final state = controller.state;
        expect(controller.lastQuery, 'Madrid');
        expect(state.isLoading, false);
        expect(state.isError, true);
        expect(state.data, isNull);
        expect(state.errorMessage, 'Error loading weather. Please try again.');

        verify(() => mockRepo.getWeather('Madrid')).called(1);
      },
    );
  });

  group('loadWeatherByCoords', () {
    test('construye el query "lat,lon" y llama a loadWeather', () async {
      when(
        () => mockRepo.getWeather('4.5,-74.1'),
      ).thenAnswer((_) async => fakeWeather);

      await controller.loadWeatherByCoords(4.5, -74.1);

      final state = controller.state;
      expect(controller.lastQuery, '4.5,-74.1');
      expect(state.data, fakeWeather);

      verify(() => mockRepo.getWeather('4.5,-74.1')).called(1);
    });
  });

  group('loadRandomCapital', () {
    test(
      'elige una capital de la lista y llama a loadWeather con ella',
      () async {
        when(
          () => mockRepo.getWeather(any()),
        ).thenAnswer((_) async => fakeWeather);

        await controller.loadRandomCapital();

        final lastQuery = controller.lastQuery;
        expect(lastQuery, isNotNull);

        const fallbackCapitals = [
          'Bogota',
          'Madrid',
          'London',
          'Tokyo',
          'New York',
          'Paris',
        ];

        expect(fallbackCapitals.contains(lastQuery), true);

        verify(() => mockRepo.getWeather(lastQuery!)).called(1);
      },
    );
  });

  group('toggleUnit', () {
    test('al inicio está en celsius y alterna a fahrenheit y viceversa', () {
      expect(controller.state.unit, TemperatureUnit.celsius);

      controller.toggleUnit();
      expect(controller.state.unit, TemperatureUnit.fahrenheit);

      controller.toggleUnit();
      expect(controller.state.unit, TemperatureUnit.celsius);
    });
  });

  group('retry', () {
    test(
      'si existe lastQuery, retry vuelve a llamar loadWeather con ese query',
      () async {
        when(
          () => mockRepo.getWeather('London'),
        ).thenAnswer((_) async => fakeWeather);

        await controller.loadWeather('London');

        verify(() => mockRepo.getWeather('London')).called(1);

        clearInteractions(mockRepo);

        await controller.retry();

        verify(() => mockRepo.getWeather('London')).called(1);
        expect(controller.lastQuery, 'London');
      },
    );

    test(
      'si no hay lastQuery, retry llama a loadRandomCapital (usa una ciudad fallback)',
      () async {
        when(
          () => mockRepo.getWeather(any()),
        ).thenAnswer((_) async => fakeWeather);

        expect(controller.lastQuery, isNull);

        await controller.retry();

        final lastQuery = controller.lastQuery;
        expect(lastQuery, isNotNull);

        const fallbackCapitals = [
          'Bogota',
          'Madrid',
          'London',
          'Tokyo',
          'New York',
          'Paris',
        ];

        expect(fallbackCapitals.contains(lastQuery), true);

        verify(() => mockRepo.getWeather(lastQuery!)).called(1);
      },
    );
  });
}
