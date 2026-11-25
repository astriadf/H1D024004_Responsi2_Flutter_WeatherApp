class CurrentWeather {
  final double temperature;
  final int relativeHumidity;
  final double apparentTemperature;
  final double precipitation;
  final int weatherCode;
  final double windSpeed;

  CurrentWeather({
    required this.temperature,
    required this.relativeHumidity,
    required this.apparentTemperature,
    required this.precipitation,
    required this.weatherCode,
    required this.windSpeed,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temperature: (json['temperature_2m'] as num).toDouble(),
      relativeHumidity: (json['relative_humidity_2m'] as num).toInt(),
      apparentTemperature: (json['apparent_temperature'] as num).toDouble(),
      precipitation: (json['precipitation'] as num).toDouble(),
      weatherCode: (json['weather_code'] as num).toInt(),
      windSpeed: (json['wind_speed_10m'] as num).toDouble(),
    );
  }
}

class DailyWeather {
  final String date;
  final double temperatureMax;
  final double temperatureMin;
  final int precipitationProbabilityMax;
  final int weatherCode;

  DailyWeather({
    required this.date,
    required this.temperatureMax,
    required this.temperatureMin,
    required this.precipitationProbabilityMax,
    required this.weatherCode,
  });
}

class WeatherModel {
  final CurrentWeather current;
  final List<DailyWeather> daily;
  final String timezone;

  WeatherModel({
    required this.current,
    required this.daily,
    required this.timezone,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final currentJson = json['current'] as Map<String, dynamic>;
    final dailyJson = json['daily'] as Map<String, dynamic>;

    final dates = (dailyJson['time'] as List).cast<String>();
    final maxTemps = (dailyJson['temperature_2m_max'] as List);
    final minTemps = (dailyJson['temperature_2m_min'] as List);
    final precipProbs = (dailyJson['precipitation_probability_max'] as List);
    final weatherCodes = (dailyJson['weather_code'] as List);

    final dailyList = <DailyWeather>[];
    for (int i = 0; i < dates.length; i++) {
      dailyList.add(DailyWeather(
        date: dates[i],
        temperatureMax: (maxTemps[i] as num).toDouble(),
        temperatureMin: (minTemps[i] as num).toDouble(),
        precipitationProbabilityMax: (precipProbs[i] as num).toInt(),
        weatherCode: (weatherCodes[i] as num).toInt(),
      ));
    }

    return WeatherModel(
      current: CurrentWeather.fromJson(currentJson),
      daily: dailyList,
      timezone: json['timezone'] as String? ?? 'auto',
    );
  }
}
