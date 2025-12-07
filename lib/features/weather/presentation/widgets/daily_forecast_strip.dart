import 'package:flutter/material.dart';
import 'package:just_weather/core/theme/app_text_styles.dart';
import 'package:just_weather/features/weather/models/weather_models.dart';
import 'package:just_weather/features/weather/application/weather_controller.dart';

class DailyForecastStrip extends StatelessWidget {
  const DailyForecastStrip({super.key, required this.days, required this.unit});

  final List<DayForecast> days;
  final TemperatureUnit unit;

  String _weekdayShort(DateTime date) {
    const names = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    return names[date.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    if (days.isEmpty) {
      return const Text('No hay pronóstico diario disponible');
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final day = days[index];

          final max = unit == TemperatureUnit.celsius
              ? day.maxTempC
              : day.maxTempF;

          final min = unit == TemperatureUnit.celsius
              ? day.minTempC
              : day.minTempF;

          final unitLabel = unit == TemperatureUnit.celsius ? '°C' : '°F';

          return Container(
            width: 90,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[900] : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
              border: Border.all(
                color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _weekdayShort(day.date),
                  style: AppTextStyles.s.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Image.network(
                  'https:${day.conditionIcon}',
                  width: 40,
                  height: 40,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.cloud, size: 32),
                ),
                const SizedBox(height: 4),
                Text(
                  '${max.toStringAsFixed(0)}$unitLabel',
                  style: AppTextStyles.body2,
                ),
                Text(
                  '${min.toStringAsFixed(0)}$unitLabel',
                  style: AppTextStyles.body.copyWith(color: theme.hintColor),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
