import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../model/weather_model.dart';
import 'weather_icon_helper.dart';

class DailyForecastCard extends StatelessWidget {
  final DailyWeather daily;

  const DailyForecastCard({super.key, required this.daily});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final date = DateTime.tryParse(daily.date);
    final dayName =
        date != null ? DateFormat('EEE, d MMM').format(date) : daily.date;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Hari
          SizedBox(
            width: 110,
            child: Text(
              dayName,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
          ),
          // Icon cuaca
          Icon(
            WeatherIconHelper.getIcon(daily.weatherCode),
            color: WeatherIconHelper.getColor(daily.weatherCode, context),
            size: 24,
          ),
          const SizedBox(width: 8),
          // Peluang hujan
          const Icon(Icons.water_drop, size: 14, color: Colors.lightBlue),
          const SizedBox(width: 2),
          Text(
            '${daily.precipitationProbabilityMax}%',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.lightBlue,
              fontSize: 12,
            ),
          ),
          const Spacer(),
          // Suhu min/max
          Text(
            '${daily.temperatureMin.round()}°',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(width: 4),
          Container(
            width: 60,
            height: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.secondary,
                ],
              ),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '${daily.temperatureMax.round()}°',
            style: theme.textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
