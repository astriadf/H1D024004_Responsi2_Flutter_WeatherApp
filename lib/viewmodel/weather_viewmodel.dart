import 'package:flutter/foundation.dart';
import '../model/weather_model.dart';
import '../model/location_model.dart';
import '../service/api_service.dart';
import '../service/storage_service.dart';

class WeatherViewModel extends ChangeNotifier {
  final ApiService _apiService;
  final StorageService _storageService;

  WeatherViewModel({
    required ApiService apiService,
    required StorageService storageService,
  })  : _apiService = apiService,
        _storageService = storageService;

  // State
  WeatherModel? _weather;
  LocationModel? _currentLocation;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  WeatherModel? get weather => _weather;
  LocationModel? get currentLocation => _currentLocation;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasData => _weather != null;
  bool get hasError => _errorMessage != null;

  /// Mengambil data cuaca untuk lokasi tertentu.
  Future<void> fetchWeather(LocationModel location) async {
    _isLoading = true;
    _errorMessage = null;
    _currentLocation = location;
    notifyListeners();

    try {
      _weather = await _apiService.fetchWeather(
        latitude: location.latitude,
        longitude: location.longitude,
      );
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Gagal memuat data cuaca. Periksa koneksi internet Anda.';
      _weather = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Memuat home city dari storage dan fetch cuacanya.
  Future<void> loadHomeCity() async {
    final homeCityJson = _storageService.getHomeCity();
    if (homeCityJson != null) {
      final location = LocationModel.fromJson(homeCityJson);
      await fetchWeather(location);
    }
  }

  /// Mengatur lokasi sebagai home city.
  Future<void> setHomeCity(LocationModel location) async {
    await _storageService.setHomeCity(location.toJson());
    await fetchWeather(location);
  }

  /// Retry fetch ulang cuaca.
  Future<void> retry() async {
    if (_currentLocation != null) {
      await fetchWeather(_currentLocation!);
    }
  }
}
