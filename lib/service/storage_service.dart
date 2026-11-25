import 'dart:convert';
import 'package:hive/hive.dart';
import '../model/favorite_model.dart';

class StorageService {
  static const String _favoritesBoxName = 'favorites';
  static const String _searchHistoryBoxName = 'search_history';
  static const String _settingsBoxName = 'settings';

  late Box<FavoriteModel> _favoritesBox;
  late Box<String> _searchHistoryBox;
  late Box<String> _settingsBox;

  /// Inisialisasi semua Hive box.
  Future<void> init() async {
    _favoritesBox = await Hive.openBox<FavoriteModel>(_favoritesBoxName);
    _searchHistoryBox = await Hive.openBox<String>(_searchHistoryBoxName);
    _settingsBox = await Hive.openBox<String>(_settingsBoxName);
  }

  // ==================== FAVORITES ====================

  List<FavoriteModel> getFavorites() {
    return _favoritesBox.values.toList();
  }

  Future<void> addFavorite(FavoriteModel favorite) async {
    // Hindari duplikat berdasarkan locationId
    final exists = _favoritesBox.values
        .any((f) => f.locationId == favorite.locationId);
    if (!exists) {
      await _favoritesBox.add(favorite);
    }
  }

  Future<void> removeFavorite(int locationId) async {
    final key = _favoritesBox.keys.firstWhere(
      (k) => _favoritesBox.get(k)?.locationId == locationId,
      orElse: () => null,
    );
    if (key != null) {
      await _favoritesBox.delete(key);
    }
  }

  bool isFavorite(int locationId) {
    return _favoritesBox.values.any((f) => f.locationId == locationId);
  }

  // ==================== SEARCH HISTORY ====================

  List<String> getSearchHistory() {
    return _searchHistoryBox.values.toList().reversed.toList();
  }

  Future<void> addSearchQuery(String query) async {
    // Hapus duplikat
    final existingKeys = <dynamic>[];
    for (final key in _searchHistoryBox.keys) {
      if (_searchHistoryBox.get(key) == query) {
        existingKeys.add(key);
      }
    }
    for (final key in existingKeys) {
      await _searchHistoryBox.delete(key);
    }
    await _searchHistoryBox.add(query);

    // Batasi riwayat 20 entri terakhir
    if (_searchHistoryBox.length > 20) {
      final firstKey = _searchHistoryBox.keys.first;
      await _searchHistoryBox.delete(firstKey);
    }
  }

  Future<void> clearSearchHistory() async {
    await _searchHistoryBox.clear();
  }

  // ==================== SETTINGS (Home City) ====================

  Future<void> setHomeCity(Map<String, dynamic> locationJson) async {
    await _settingsBox.put('home_city', json.encode(locationJson));
  }

  Map<String, dynamic>? getHomeCity() {
    final raw = _settingsBox.get('home_city');
    if (raw == null) return null;
    return json.decode(raw) as Map<String, dynamic>;
  }
}
