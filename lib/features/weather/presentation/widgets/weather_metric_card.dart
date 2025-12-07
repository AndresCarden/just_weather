import 'package:flutter/material.dart';
import 'package:just_weather/core/theme/app_text_styles.dart';

class WeatherMetricCard extends StatelessWidget {
  const WeatherMetricCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.unit,
    required this.changePercent,
    required this.description,
  });

  final IconData icon;
  final String title;
  final num value;
  final String unit;
  final double changePercent;
  final String description;

  @override
  Widget build(BuildContext context) {
    final isPositive = changePercent >= 0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.surfaceContainer,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 22),
              const SizedBox(width: 6),
              Text(
                title,
                style: AppTextStyles.s.copyWith(color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${value.toStringAsFixed(1)}$unit',
            style: AppTextStyles.l.copyWith(color: Colors.black),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                color: isPositive ? Colors.green : Colors.red,
                size: 18,
              ),
              Text(
                '${changePercent.abs().toStringAsFixed(1)}%',
                style: AppTextStyles.body2.copyWith(
                  color: isPositive ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: AppTextStyles.body.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
