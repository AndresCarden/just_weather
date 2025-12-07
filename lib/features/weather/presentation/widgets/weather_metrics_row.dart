import 'package:flutter/material.dart';
import 'package:just_weather/core/theme/app_text_styles.dart';
import 'package:just_weather/features/weather/application/weather_controller.dart';
import 'package:just_weather/features/weather/models/weather_models.dart';

class WeatherMetricsRow extends StatelessWidget {
  const WeatherMetricsRow({
    super.key,
    required this.weather,
    required this.unit,
  });

  final FullWeather weather;
  final TemperatureUnit unit;

  String _formatTemp(double c, double f) {
    if (unit == TemperatureUnit.celsius) {
      return '${c.toStringAsFixed(1)}°C';
    } else {
      return '${f.toStringAsFixed(1)}°F';
    }
  }

  String _formatWind(double kph) {
    if (unit == TemperatureUnit.celsius) {
      return '${kph.toStringAsFixed(1)} km/h';
    } else {
      final mph = kph * 0.621371;
      return '${mph.toStringAsFixed(1)} mph';
    }
  }

  String _formatChangePercent(num current, num reference) {
    if (reference == 0) return '—';
    final diff = ((current - reference) / reference) * 100;
    final sign = diff >= 0 ? '+' : '';
    return '$sign${diff.toStringAsFixed(1)}%';
  }

  @override
  Widget build(BuildContext context) {
    final current = weather.current;
    String tempChange = '—';
    if (weather.daily.isNotEmpty) {
      final today = weather.daily.first;
      final avgC = (today.maxTempC + today.minTempC) / 2;
      tempChange = _formatChangePercent(current.tempC, avgC);
    }

    final feelsChange = _formatChangePercent(current.feelsLikeC, current.tempC);

    final humidityChange = _formatChangePercent(
      current.humidity.toDouble(),
      50,
    );

    final windChange = _formatChangePercent(current.windKph, 10);

    final cards = [
      _MetricCard(
        title: 'Temperatura',
        value: _formatTemp(current.tempC, current.tempF),
        change: tempChange,
        description: 'Comparado con el promedio actual.',
        icon: Icons.thermostat,
      ),
      _MetricCard(
        title: 'se siente como',
        value: _formatTemp(current.feelsLikeC, current.feelsLikeF),
        change: feelsChange,
        description: 'Diferencia vs temperatura real.',
        icon: Icons.device_thermostat,
      ),
      _MetricCard(
        title: 'Humedad',
        value: '${current.humidity}%',
        change: humidityChange,
        description: 'Relativa al 50% de comodidad.',
        icon: Icons.water_drop,
      ),
      _MetricCard(
        title: 'Viento',
        value: _formatWind(current.windKph),
        change: windChange,
        description: 'En comparación con el viento moderado.',
        icon: Icons.air,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= 600;
        if (isTablet) {
          return Row(
            children: [
              for (final card in cards) ...[
                Expanded(child: card),
                if (card != cards.last) const SizedBox(width: 12),
              ],
            ],
          );
        } else {
          final double itemWidth = (constraints.maxWidth - 12) / 2;
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: cards
                .map((card) => SizedBox(width: itemWidth, child: card))
                .toList(),
          );
        }
      },
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.change,
    required this.description,
    required this.icon,
  });

  final String title;
  final String value;
  final String change;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final hasChange = change != '—';
    final isNegative = hasChange && change.startsWith('-');

    final Color changeColor;
    if (!hasChange) {
      changeColor = Colors.grey;
    } else {
      changeColor = isNegative ? Colors.red : Colors.green;
    }

    final IconData changeIcon;
    if (!hasChange) {
      changeIcon = Icons.remove;
    } else {
      changeIcon = isNegative ? Icons.arrow_downward : Icons.arrow_upward;
    }

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(height: 8),
          Text(
            title,
            style: AppTextStyles.body.copyWith(
              color: isDark ? Colors.grey[300] : Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.m.copyWith(
              color: isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(changeIcon, size: 14, color: changeColor),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  change,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body2.copyWith(color: changeColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            description,

            style: AppTextStyles.body.copyWith(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
