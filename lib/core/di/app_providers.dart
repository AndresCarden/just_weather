import 'package:flutter/material.dart' hide SearchController;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;
import 'package:just_weather/core/api_client.dart';
import 'package:just_weather/core/env.dart';
import 'package:just_weather/core/location_service.dart';
import 'package:just_weather/features/weather/application/search_controller.dart';
import 'package:just_weather/features/weather/application/theme_controller.dart';
import 'package:just_weather/features/weather/application/weather_controller.dart';
import 'package:just_weather/features/weather/data/weather_api_service.dart';
import 'package:just_weather/features/weather/data/weather_repository.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(http.Client(), baseUrl: Env.apiBase, apiKey: Env.apiKey);
});

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

final weatherApiServiceProvider = Provider<WeatherApiService>((ref) {
  final client = ref.watch(apiClientProvider);
  return WeatherApiService(client);
});

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  final service = ref.watch(weatherApiServiceProvider);
  return WeatherRepositoryImpl(service);
});

final weatherControllerProvider =
    StateNotifierProvider<WeatherController, WeatherState>((ref) {
      final repo = ref.watch(weatherRepositoryProvider);
      return WeatherController(repo);
    });

final searchControllerProvider =
    StateNotifierProvider<SearchController, SearchState>((ref) {
      final repo = ref.watch(weatherRepositoryProvider);
      return SearchController(repo);
    });

final themeControllerProvider =
    StateNotifierProvider<ThemeController, ThemeMode>((ref) {
      return ThemeController();
    });
