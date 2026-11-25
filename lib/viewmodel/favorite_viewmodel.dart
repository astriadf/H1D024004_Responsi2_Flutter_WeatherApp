import 'package:flutter/foundation.dart';
import '../model/favorite_model.dart';
import '../model/location_model.dart';
import '../service/storage_service.dart';

class FavoriteViewModel extends ChangeNotifier {
  final StorageService _storageService;

  FavoriteViewModel({required StorageService storageService})
      : _storageService = storageService;

  // State
  List<FavoriteModel> _favorites = [];
  bool _isLoading = false;

  // Getters
  List<FavoriteModel> get favorites => _favorites;
  bool get isLoading => _isLoading;
  bool get isEmpty => !_isLoading && _favorites.isEmpty;

  /// Memuat daftar favorit dari storage.
  void loadFavorites() {
    _isLoading = true;
    notifyListeners();

    _favorites = _storageService.getFavorites();

    _isLoading = false;
    notifyListeners();
  }

  /// Menambah lokasi ke favorit.
  Future<void> addFavorite(LocationModel location) async {
    final favorite = FavoriteModel(
      locationId: location.id,
      name: location.name,
      latitude: location.latitude,
      longitude: location.longitude,
      country: location.country,
      admin1: location.admin1,
    );
    await _storageService.addFavorite(favorite);
    loadFavorites();
  }

  /// Menghapus lokasi dari favorit.
  Future<void> removeFavorite(int locationId) async {
    await _storageService.removeFavorite(locationId);
    loadFavorites();
  }

  /// Cek apakah lokasi merupakan favorit.
  bool isFavorite(int locationId) {
    return _storageService.isFavorite(locationId);
  }

  /// Toggle status favorit.
  Future<void> toggleFavorite(LocationModel location) async {
    if (isFavorite(location.id)) {
      await removeFavorite(location.id);
    } else {
      await addFavorite(location);
    }
  }
}
