import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'service/api_service.dart';
import 'service/storage_service.dart';
import 'viewmodel/weather_viewmodel.dart';
import 'viewmodel/search_viewmodel.dart';
import 'viewmodel/favorite_viewmodel.dart';
import 'view/home_screen.dart';

class WeatherApp extends StatelessWidget {
  final StorageService storageService;

  const WeatherApp({super.key, required this.storageService});

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => WeatherViewModel(
            apiService: apiService,
            storageService: storageService,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => SearchViewModel(
            apiService: apiService,
            storageService: storageService,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => FavoriteViewModel(
            storageService: storageService,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Clima Weather',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
