import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_weather/core/theme/app_theme.dart';
import 'features/weather/presentation/pages/weather_home_page.dart';

void main() {
  runApp(const ProviderScope(child: JustWeatherApp()));
}

class JustWeatherApp extends ConsumerWidget {
  const JustWeatherApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Just Weather',
      themeMode: ThemeMode.system,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: const WeatherHomePage(),
    );
  }
}
