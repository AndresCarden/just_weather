import 'dart:math';
import 'package:flutter_riverpod/legacy.dart';
import 'package:just_weather/features/weather/models/weather_models.dart';
import '../data/weather_repository.dart';

enum TemperatureUnit { celsius, fahrenheit }

class WeatherState {
  final bool isLoading;
  final bool isError;
  final String? errorMessage;
  final FullWeather? data;
  final TemperatureUnit unit;

  WeatherState({
    this.isLoading = false,
    this.isError = false,
    this.errorMessage,
    this.data,
    this.unit = TemperatureUnit.celsius,
  });

  WeatherState copyWith({
    bool? isLoading,
    bool? isError,
    String? errorMessage,
    FullWeather? data,
    TemperatureUnit? unit,
  }) {
    return WeatherState(
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      errorMessage: errorMessage,
      data: data ?? this.data,
      unit: unit ?? this.unit,
    );
  }
}

class WeatherController extends StateNotifier<WeatherState> {
  WeatherController(this._repository) : super(WeatherState());

  final WeatherRepository _repository;
  String? _lastQuery;
  String? get lastQuery => _lastQuery;

  Future<void> loadWeather(String query) async {
    _lastQuery = query;
    state = state.copyWith(isLoading: true, isError: false, errorMessage: null);
    try {
      final result = await _repository.getWeather(query);
      state = state.copyWith(isLoading: false, data: result);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isError: true,
        errorMessage: 'Error loading weather. Please try again.',
      );
    }
  }

  Future<void> loadWeatherByCoords(double lat, double lon) async {
    final query = '$lat,$lon';
    await loadWeather(query);
  }

  static const _fallbackCapitals = [
    'Bogota',
    'Madrid',
    'London',
    'Tokyo',
    'New York',
    'Paris',
  ];

  Future<void> loadRandomCapital() async {
    final rand = Random();
    final city = _fallbackCapitals[rand.nextInt(_fallbackCapitals.length)];
    await loadWeather(city);
  }

  void toggleUnit() {
    state = state.copyWith(
      unit: state.unit == TemperatureUnit.celsius
          ? TemperatureUnit.fahrenheit
          : TemperatureUnit.celsius,
    );
  }

  Future<void> retry() async {
    if (_lastQuery != null) {
      await loadWeather(_lastQuery!);
    } else {
      await loadRandomCapital();
    }
  }
}
