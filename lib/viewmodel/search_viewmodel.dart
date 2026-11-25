import 'package:flutter/foundation.dart';
import '../model/location_model.dart';
import '../service/api_service.dart';
import '../service/storage_service.dart';

class SearchViewModel extends ChangeNotifier {
  final ApiService _apiService;
  final StorageService _storageService;

  SearchViewModel({
    required ApiService apiService,
    required StorageService storageService,
  })  : _apiService = apiService,
        _storageService = storageService;

  // State
  List<LocationModel> _searchResults = [];
  List<String> _searchHistory = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<LocationModel> get searchResults => _searchResults;
  List<String> get searchHistory => _searchHistory;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasResults => _searchResults.isNotEmpty;
  bool get isEmpty => !_isLoading && _searchResults.isEmpty && _errorMessage == null;

  /// Mencari lokasi berdasarkan query.
  Future<void> searchLocation(String query) async {
    if (query.trim().isEmpty) {
      _searchResults = [];
      _errorMessage = null;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _searchResults = await _apiService.searchLocation(query);
      _errorMessage = null;

      // Simpan ke riwayat pencarian
      await _storageService.addSearchQuery(query.trim());
      _searchHistory = _storageService.getSearchHistory();
    } catch (e) {
      _errorMessage = 'Gagal mencari lokasi. Periksa koneksi internet Anda.';
      _searchResults = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Memuat riwayat pencarian dari storage.
  void loadSearchHistory() {
    _searchHistory = _storageService.getSearchHistory();
    notifyListeners();
  }

  /// Menghapus seluruh riwayat pencarian.
  Future<void> clearHistory() async {
    await _storageService.clearSearchHistory();
    _searchHistory = [];
    notifyListeners();
  }

  /// Reset state pencarian.
  void clearSearch() {
    _searchResults = [];
    _errorMessage = null;
    notifyListeners();
  }
}
