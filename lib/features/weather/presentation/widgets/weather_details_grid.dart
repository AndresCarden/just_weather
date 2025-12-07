import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:just_weather/core/theme/app_text_styles.dart';
import 'package:just_weather/features/weather/application/weather_controller.dart';
import 'package:just_weather/features/weather/models/detail_item.dart';
import 'package:just_weather/features/weather/models/weather_models.dart';

class WeatherDetailsGrid extends StatelessWidget {
  const WeatherDetailsGrid({
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
      return '${c.toStringAsFixed(1)}°C';
    } else {
      return '${f.toStringAsFixed(1)}°F';
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = weather.current;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final items = [
      DetailItem(
        icon: Icons.wb_sunny_outlined,
        label: 'Amanecer',
        value: _formatTime(weather.sunrise),
      ),
      DetailItem(
        icon: Icons.nightlight_round,
        label: 'Atardecer',
        value: _formatTime(weather.sunset),
      ),
      DetailItem(
        icon: Icons.umbrella,
        label: 'Probabilidad de lluvia',
        value: '${current.chanceOfRain.toStringAsFixed(0)}%',
      ),
      DetailItem(
        icon: Icons.speed,
        label: 'Presión',
        value: '${current.pressureMb.toStringAsFixed(0)} hPa',
      ),
      DetailItem(
        icon: Icons.air,
        label: 'Viento',
        value: '${current.windKph.toStringAsFixed(1)} km/h',
      ),
      DetailItem(
        icon: Icons.wb_iridescent,
        label: 'Índice UV',
        value: current.uv.toStringAsFixed(1),
      ),
      DetailItem(
        icon: Icons.device_thermostat,
        label: 'se siente como',
        value: _formatTemp(current.feelsLikeC, current.feelsLikeF),
      ),
      DetailItem(
        icon: Icons.visibility,
        label: 'Visibilidad',
        value: '${current.visKm.toStringAsFixed(1)} km',
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(12),
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
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          mainAxisExtent: 49,
        ),
        itemBuilder: (_, index) {
          final item = items[index];
          return Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  item.icon,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.label,
                      style: AppTextStyles.body.copyWith(
                        color: isDark ? Colors.grey[300] : Colors.grey[700],
                      ),
                    ),

                    const SizedBox(height: 2),
                    Expanded(
                      child: Text(
                        item.value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body2.copyWith(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
