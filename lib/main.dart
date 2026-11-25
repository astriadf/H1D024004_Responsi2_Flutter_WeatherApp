import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'model/favorite_model.dart';
import 'service/storage_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Hive
  await Hive.initFlutter();
  Hive.registerAdapter(FavoriteModelAdapter());

  // Inisialisasi StorageService
  final storageService = StorageService();
  await storageService.init();

  runApp(WeatherApp(storageService: storageService));
}
