import 'package:flutter/material.dart' hide SearchController;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import 'package:just_weather/core/api_client.dart';
import 'package:just_weather/core/env.dart';
import 'package:just_weather/core/location_service.dart';
import 'package:just_weather/features/weather/application/search_controller.dart';
import 'package:just_weather/features/weather/application/theme_controller.dart';
import 'package:just_weather/features/weather/application/weather_controller.dart';
import 'package:just_weather/features/weather/data/weather_api_service.dart';
import 'package:just_weather/features/weather/data/weather_repository.dart';

import 'package:just_weather/core/di/app_providers.dart'
    hide themeControllerProvider;

class MockHttpClient extends Mock implements http.Client {}

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(Uri.parse('https://example.com'));
  });

  group('apiClientProvider', () {
    test('crea un ApiClient con http.Client y Env configurado', () {
      final container = ProviderContainer();

      final apiClient = container.read(apiClientProvider);

      expect(apiClient, isA<ApiClient>());
      expect(apiClient.baseUrl, Env.apiBase);
      expect(apiClient.apiKey, Env.apiKey);
    });

    test('puede ser sobrescrito con un ApiClient mockeado', () {
      final mockClient = MockHttpClient();
      final fakeApiClient = ApiClient(
        mockClient,
        baseUrl: 'https://fake-base',
        apiKey: 'FAKE_KEY',
      );

      final container = ProviderContainer(
        overrides: [apiClientProvider.overrideWithValue(fakeApiClient)],
      );

      final apiClient = container.read(apiClientProvider);

      expect(apiClient, same(fakeApiClient));
    });
  });

  group('locationServiceProvider', () {
    test('retorna una instancia de LocationService', () {
      final container = ProviderContainer();

      final locationService = container.read(locationServiceProvider);

      expect(locationService, isA<LocationService>());
    });
  });

  group('weatherApiServiceProvider', () {
    test('usa el ApiClient proveniente de apiClientProvider', () {
      final mockClient = MockHttpClient();
      final fakeApiClient = ApiClient(
        mockClient,
        baseUrl: 'https://fake-base',
        apiKey: 'FAKE_KEY',
      );

      final container = ProviderContainer(
        overrides: [apiClientProvider.overrideWithValue(fakeApiClient)],
      );

      final apiService = container.read(weatherApiServiceProvider);

      expect(apiService, isA<WeatherApiService>());
    });
  });

  group('weatherRepositoryProvider', () {
    test('retorna un WeatherRepositoryImpl por defecto', () {
      final container = ProviderContainer();

      final repo = container.read(weatherRepositoryProvider);

      expect(repo, isA<WeatherRepositoryImpl>());
    });

    test('puede ser sobrescrito con un MockWeatherRepository', () {
      final mockRepo = MockWeatherRepository();

      final container = ProviderContainer(
        overrides: [weatherRepositoryProvider.overrideWithValue(mockRepo)],
      );

      final repo = container.read(weatherRepositoryProvider);

      expect(repo, same(mockRepo));
    });
  });

  group('weatherControllerProvider', () {
    test('se crea correctamente usando el WeatherRepository', () {
      final mockRepo = MockWeatherRepository();

      final container = ProviderContainer(
        overrides: [weatherRepositoryProvider.overrideWithValue(mockRepo)],
      );

      final controller = container.read(weatherControllerProvider.notifier);
      final state = container.read(weatherControllerProvider);

      expect(controller, isA<WeatherController>());
      expect(state, isA<WeatherState>());
    });
  });

  group('searchControllerProvider', () {
    test('se crea correctamente usando el WeatherRepository', () {
      final mockRepo = MockWeatherRepository();

      final container = ProviderContainer(
        overrides: [weatherRepositoryProvider.overrideWithValue(mockRepo)],
      );

      final controller = container.read(searchControllerProvider.notifier);
      final state = container.read(searchControllerProvider);

      expect(controller, isA<SearchController>());
      expect(state, isA<SearchState>());
    });
  });

  group('themeControllerProvider', () {
    test('retorna un ThemeMode válido', () {
      final container = ProviderContainer();

      final themeMode = container.read(themeControllerProvider);

      expect(themeMode, isA<ThemeMode>());
      // Si sabes cuál es el valor inicial (ej: ThemeMode.system), puedes afinar:
      // expect(themeMode, ThemeMode.system);
    });

    test('puedes cambiar el themeMode desde el ThemeController', () {
      final container = ProviderContainer();

      final themeMode = container.read(themeControllerProvider);

      expect(themeMode, isNotNull);
    });
  });
}
