import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/weather_model.dart';
import '../model/location_model.dart';

class ApiService {
  static const String _geocodingBaseUrl =
      'https://geocoding-api.open-meteo.com/v1/search';
  static const String _forecastBaseUrl =
      'https://api.open-meteo.com/v1/forecast';

  /// Mencari lokasi berdasarkan nama kota menggunakan Geocoding API.
  Future<List<LocationModel>> searchLocation(String query) async {
    if (query.trim().isEmpty) return [];

    final uri = Uri.parse(_geocodingBaseUrl).replace(queryParameters: {
      'name': query.trim(),
      'count': '10',
      'language': 'id',
      'format': 'json',
    });

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Gagal mencari lokasi: ${response.statusCode}');
    }

    final data = json.decode(response.body) as Map<String, dynamic>;
    final results = data['results'] as List<dynamic>?;

    if (results == null || results.isEmpty) return [];

    return results
        .map((e) => LocationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Mengambil data cuaca berdasarkan koordinat menggunakan Forecast API.
  Future<WeatherModel> fetchWeather({
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.parse(_forecastBaseUrl).replace(queryParameters: {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'current':
          'temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m',
      'daily':
          'temperature_2m_max,temperature_2m_min,precipitation_probability_max,weather_code',
      'timezone': 'auto',
    });

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil data cuaca: ${response.statusCode}');
    }

    final data = json.decode(response.body) as Map<String, dynamic>;
    return WeatherModel.fromJson(data);
  }
}
