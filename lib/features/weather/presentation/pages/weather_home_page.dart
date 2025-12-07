import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_weather/core/app_images.dart';
import 'package:just_weather/core/di/app_providers.dart';
import 'package:just_weather/core/theme/app_text_styles.dart';
import 'package:just_weather/features/weather/presentation/widgets/hourly_forecast_strip.dart';
import 'package:just_weather/features/weather/presentation/widgets/search_dropdown.dart';
import 'package:just_weather/features/weather/presentation/widgets/section_title.dart';
import 'package:just_weather/features/weather/presentation/widgets/unit_chip.dart';
import 'package:just_weather/features/weather/presentation/widgets/weather_details_grid.dart';
import 'package:just_weather/features/weather/presentation/widgets/weather_metrics_row.dart';
import 'package:just_weather/features/weather/presentation/widgets/weather_skeleton.dart';
import '../../application/weather_controller.dart';

class WeatherHomePage extends ConsumerStatefulWidget {
  const WeatherHomePage({super.key});

  @override
  ConsumerState<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends ConsumerState<WeatherHomePage> {
  bool _initialized = false;
  final _searchCtrl = TextEditingController();
  final _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initWeather());
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  Future<void> _initWeather() async {
    if (_initialized) return;
    _initialized = true;

    final locationService = ref.read(locationServiceProvider);
    final query = await locationService.getQueryForWeather();

    await ref.read(weatherControllerProvider.notifier).loadWeather(query);
  }

  @override
  Widget build(BuildContext context) {
    final weatherState = ref.watch(weatherControllerProvider);
    final searchState = ref.watch(searchControllerProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= 600;
        const maxContentWidth = 900.0;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            iconTheme: IconThemeData(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            title: Text(
              'Just Weather',
              style: AppTextStyles.s.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),

            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Image.asset(
                    Theme.of(context).brightness == Brightness.dark
                        ? AppImages.sunCloudDark
                        : AppImages.sunCloudLight,
                    width: 28,
                    height: 28,
                  ),
                ),
              ),
            ],
          ),

          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: maxContentWidth),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, isTablet ? 12 : 8),
                    child: Row(
                      children: [
                        Image.asset(
                          Theme.of(context).brightness == Brightness.dark
                              ? AppImages.sunCloudDark
                              : AppImages.sunCloudLight,
                          width: 32,
                          height: 32,
                        ),

                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _searchCtrl,
                            focusNode: _searchFocus,
                            decoration: InputDecoration(
                              hintText: 'Buscar ciudad',
                              prefixIcon: const Icon(Icons.search),
                              filled: true,
                              fillColor:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.grey[900]
                                  : Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.indigo.shade100,
                                  width: 1,
                                ),
                              ),

                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.indigo.shade400,
                                  width: 1.5,
                                ),
                              ),

                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onChanged: (value) {
                              ref
                                  .read(searchControllerProvider.notifier)
                                  .onQueryChanged(value);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SearchDropdown(
                      focusNode: _searchFocus,
                      searchState: searchState,
                      onSelectLocation: (loc) async {
                        FocusScope.of(context).unfocus();

                        _searchCtrl.clear();

                        ref
                            .read(searchControllerProvider.notifier)
                            .onQueryChanged('');

                        ref
                            .read(searchControllerProvider.notifier)
                            .addRecent(loc);

                        await ref
                            .read(weatherControllerProvider.notifier)
                            .loadWeather('${loc.lat},${loc.lon}');
                      },

                      onClearAll: () {
                        ref
                            .read(searchControllerProvider.notifier)
                            .clearAllRecent();
                      },
                      onDeleteRecent: (loc) {
                        ref
                            .read(searchControllerProvider.notifier)
                            .deleteRecent(loc);
                      },
                    ),
                  ),

                  const SizedBox(height: 8),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Builder(
                        builder: (_) {
                          if (weatherState.isLoading &&
                              weatherState.data == null) {
                            return const WeatherSkeleton();
                          }

                          if (weatherState.isError &&
                              weatherState.data == null) {
                            return Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Error al cargar el clima',
                                    style: AppTextStyles.body3,
                                    key: Key('error_text'),
                                  ),
                                  const SizedBox(height: 8),
                                  ElevatedButton(
                                    key: const Key('retry_button'),
                                    onPressed: () {
                                      ref
                                          .read(
                                            weatherControllerProvider.notifier,
                                          )
                                          .retry();
                                    },
                                    child: const Text('Reintentar'),
                                  ),
                                ],
                              ),
                            );
                          }

                          if (weatherState.data == null) {
                            return const Center(
                              child: Text(
                                'Buscar una ciudad',
                                style: AppTextStyles.body,
                              ),
                            );
                          }
                          final weather = weatherState.data!;
                          final unit = weatherState.unit;
                          return SafeArea(
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 24,
                                  top: 8,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                weather.location.name,
                                                key: const Key('city_name'),
                                                style: AppTextStyles.m.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                weather.location.country,
                                                style: AppTextStyles.body
                                                    .copyWith(
                                                      color: Colors.grey,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surfaceContainerHighest,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              UnitChip(
                                                label: '°C',
                                                isActive:
                                                    unit ==
                                                    TemperatureUnit.celsius,
                                                onTap: () => ref
                                                    .read(
                                                      weatherControllerProvider
                                                          .notifier,
                                                    )
                                                    .toggleUnit(),
                                              ),
                                              UnitChip(
                                                label: '°F',
                                                isActive:
                                                    unit ==
                                                    TemperatureUnit.fahrenheit,
                                                onTap: () => ref
                                                    .read(
                                                      weatherControllerProvider
                                                          .notifier,
                                                    )
                                                    .toggleUnit(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 16),
                                    Text(
                                      unit == TemperatureUnit.celsius
                                          ? '${weather.current.tempC.toStringAsFixed(1)}°C'
                                          : '${weather.current.tempF.toStringAsFixed(1)}°F',
                                      key: const Key('main_temp_text'),
                                      style: AppTextStyles.xl.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 4),
                                    Text(
                                      weather.current.conditionText,
                                      style: AppTextStyles.s,
                                    ),

                                    const SizedBox(height: 24),
                                    const SectionTitle('Resumen de hoy'),
                                    WeatherMetricsRow(
                                      weather: weather,
                                      unit: unit,
                                    ),
                                    const SizedBox(height: 24),
                                    const SectionTitle('Previsión horaria'),
                                    HourlyForecastStrip(
                                      weather: weather,
                                      unit: unit,
                                    ),
                                    const SizedBox(height: 24),
                                    const SectionTitle('Detalles del tiempo'),
                                    WeatherDetailsGrid(
                                      weather: weather,
                                      unit: unit,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
