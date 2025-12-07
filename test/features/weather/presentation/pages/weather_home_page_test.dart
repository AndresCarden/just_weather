import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_weather/core/di/app_providers.dart';
import 'package:mocktail/mocktail.dart';

import 'package:just_weather/core/location_service.dart';
import 'package:just_weather/features/weather/data/weather_repository.dart';
import 'package:just_weather/features/weather/models/weather_models.dart';
import 'package:just_weather/features/weather/presentation/pages/weather_home_page.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

class MockLocationService extends Mock implements LocationService {}

void main() {
  late MockWeatherRepository mockRepo;
  late MockLocationService mockLocationService;

  setUp(() {
    mockRepo = MockWeatherRepository();
    mockLocationService = MockLocationService();
  });

  FullWeather fakeFullWeather() {
    final location = WeatherLocation(
      name: 'Bogota',
      country: 'Colombia',
      lat: 4.711,
      lon: -74.072,
      timezone: 'America/Bogota',
    );

    final current = CurrentWeather(
      tempC: 20,
      tempF: 68,
      feelsLikeC: 19,
      feelsLikeF: 66.2,
      humidity: 70,
      windKph: 10,
      conditionText: 'Partly cloudy',
      conditionIcon: 'https://picsum.photos/40',
      pressureMb: 1010,
      uv: 5,
      visKm: 10,
      chanceOfRain: 30,
    );

    final day = DayForecast(
      date: DateTime(2025, 12, 5),
      maxTempC: 22,
      minTempC: 15,
      maxTempF: 71.6,
      minTempF: 59,
      conditionIcon: 'https://picsum.photos/40',
      conditionText: 'Partly cloudy',
      chanceOfRain: 40,
    );

    final hourly = <HourForecast>[
      HourForecast(
        time: DateTime(2025, 12, 5, 0),
        tempC: 18,
        tempF: 64.4,
        conditionIcon: 'https://picsum.photos/40',
      ),
    ];

    return FullWeather(
      location: location,
      current: current,
      hourly: hourly,
      daily: [day],
      sunrise: DateTime(2025, 12, 5, 6, 0),
      sunset: DateTime(2025, 12, 5, 18, 0),
    );
  }

  Widget buildTestApp() {
    return ProviderScope(
      overrides: [
        locationServiceProvider.overrideWithValue(mockLocationService),
        weatherRepositoryProvider.overrideWithValue(mockRepo),
      ],
      child: const MaterialApp(home: WeatherHomePage()),
    );
  }

  testWidgets('WeatherHomePage muestra datos de ciudad cuando carga OK', (
    tester,
  ) async {
    // arrange
    when(
      () => mockLocationService.getQueryForWeather(),
    ).thenAnswer((_) async => 'Bogota');

    when(
      () => mockRepo.getWeather('Bogota'),
    ).thenAnswer((_) async => fakeFullWeather());

    // act
    await tester.pumpWidget(buildTestApp());
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle(const Duration(milliseconds: 200));
    final exception = tester.takeException();
    if (exception != null && exception is! NetworkImageLoadException) {
      fail('Excepción inesperada: $exception');
    }

    expect(find.text('Bogota'), findsOneWidget);
    expect(find.byKey(const Key('city_name')), findsOneWidget);

    final tempFinder = find.byKey(const Key('main_temp_text'));
    expect(tempFinder, findsOneWidget);

    final tempText = tester.widget<Text>(tempFinder);
    expect(tempText.data, '20.0°C');
  });

  testWidgets('WeatherHomePage muestra mensaje de error cuando falla', (
    tester,
  ) async {
    when(
      () => mockLocationService.getQueryForWeather(),
    ).thenAnswer((_) async => 'Bogota');

    when(
      () => mockRepo.getWeather('Bogota'),
    ).thenThrow(Exception('network error'));

    await tester.pumpWidget(buildTestApp());
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle(const Duration(milliseconds: 200));

    final exception = tester.takeException();
    if (exception != null && exception is! NetworkImageLoadException) {
      fail('Excepción inesperada: $exception');
    }

    expect(find.byKey(const Key('error_text')), findsOneWidget);
    expect(find.byKey(const Key('retry_button')), findsOneWidget);
  });
}
