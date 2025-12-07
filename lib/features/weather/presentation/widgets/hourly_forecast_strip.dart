import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:just_weather/core/theme/app_text_styles.dart';
import 'package:just_weather/features/weather/application/weather_controller.dart';
import 'package:just_weather/features/weather/models/weather_models.dart';

class HourlyForecastStrip extends StatelessWidget {
  const HourlyForecastStrip({
    super.key,
    required this.weather,
    required this.unit,
  });

  final FullWeather weather;
  final TemperatureUnit unit;

  String _formatTime(DateTime dt) {
    return DateFormat('HH:mm').format(dt);
  }

  String _formatTemp(double c, double f) {
    if (unit == TemperatureUnit.celsius) {
      return '${c.toStringAsFixed(0)}°';
    } else {
      return '${f.toStringAsFixed(0)}°';
    }
  }

  @override
  Widget build(BuildContext context) {
    final hours = weather.hourly.length > 24
        ? weather.hourly.take(24).toList()
        : weather.hourly;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.07),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            for (final h in hours) ...[
              _HourItem(
                time: _formatTime(h.time),
                iconUrl: h.conditionIcon,
                temp: _formatTemp(h.tempC, h.tempF),
              ),
              const SizedBox(width: 8),
            ],
          ],
        ),
      ),
    );
  }
}

class _HourItem extends StatelessWidget {
  const _HourItem({
    required this.time,
    required this.iconUrl,
    required this.temp,
  });

  final String time;
  final String iconUrl;
  final String temp;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: 70,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(time, style: AppTextStyles.body2),
          const SizedBox(height: 6),
          Image.network(
            iconUrl.startsWith('http') ? iconUrl : 'https:$iconUrl',
            width: 32,
            height: 32,
            errorBuilder: (_, __, ___) => const Icon(Icons.cloud, size: 32),
          ),
          const SizedBox(height: 6),
          Text(temp, style: AppTextStyles.body3),
        ],
      ),
    );
  }
}
