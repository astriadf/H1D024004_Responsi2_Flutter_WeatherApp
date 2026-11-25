import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/weather_viewmodel.dart';
import 'search_screen.dart';
import 'favorite_screen.dart';
import 'widgets/weather_icon_helper.dart';
import 'widgets/weather_detail_card.dart';
import 'widgets/daily_forecast_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Muat home city saat pertama kali
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherViewModel>().loadHomeCity();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Consumer<WeatherViewModel>(
        builder: (context, vm, _) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.appBarTheme.backgroundColor ?? theme.primaryColor,
                  theme.scaffoldBackgroundColor,
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // App Bar custom
                  _buildAppBar(context, vm),
                  // Body
                  Expanded(child: _buildBody(context, vm)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, WeatherViewModel vm) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(Icons.location_on, color: theme.colorScheme.secondary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              vm.currentLocation?.displayName ?? 'Pilih Kota',
              style: theme.textTheme.titleLarge,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: Icon(Icons.search, color: theme.colorScheme.secondary),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchScreen()),
            ),
          ),
          IconButton(
            icon: Icon(Icons.favorite, color: theme.colorScheme.secondary),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FavoriteScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, WeatherViewModel vm) {
    final theme = Theme.of(context);

    // Loading
    if (vm.isLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: theme.colorScheme.secondary),
            const SizedBox(height: 16),
            Text('Memuat data cuaca...', style: theme.textTheme.bodyMedium),
          ],
        ),
      );
    }

    // Error
    if (vm.hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.cloud_off, size: 64, color: theme.colorScheme.error),
              const SizedBox(height: 16),
              Text(
                vm.errorMessage!,
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => vm.retry(),
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Empty — belum ada kota dipilih
    if (!vm.hasData) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.wb_sunny,
                  size: 80,
                  color: theme.colorScheme.secondary.withAlpha(128)),
              const SizedBox(height: 16),
              Text(
                'Selamat Datang!',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Cari kota untuk melihat cuaca terkini',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchScreen()),
                ),
                icon: const Icon(Icons.search),
                label: const Text('Cari Kota'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Data tersedia
    return _buildWeatherContent(context, vm);
  }

  Widget _buildWeatherContent(BuildContext context, WeatherViewModel vm) {
    final theme = Theme.of(context);
    final weather = vm.weather!;
    final current = weather.current;

    return RefreshIndicator(
      onRefresh: () => vm.retry(),
      color: theme.colorScheme.secondary,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(height: 20),
          // ===== KARTU UTAMA SUHU =====
          Center(
            child: Column(
              children: [
                Icon(
                  WeatherIconHelper.getIcon(current.weatherCode),
                  size: 72,
                  color: WeatherIconHelper.getColor(
                      current.weatherCode, context),
                ),
                const SizedBox(height: 8),
                Text(
                  '${current.temperature.round()}°C',
                  style: theme.textTheme.displayLarge,
                ),
                Text(
                  WeatherIconHelper.getDescription(current.weatherCode),
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Terasa seperti ${current.apparentTemperature.round()}°C',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          // ===== GRID DETAIL =====
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.95,
            children: [
              WeatherDetailCard(
                icon: Icons.water_drop,
                label: 'Kelembapan',
                value: '${current.relativeHumidity}%',
              ),
              WeatherDetailCard(
                icon: Icons.air,
                label: 'Angin',
                value: '${current.windSpeed} km/h',
              ),
              WeatherDetailCard(
                icon: Icons.umbrella,
                label: 'Curah Hujan',
                value: '${current.precipitation} mm',
              ),
            ],
          ),
          const SizedBox(height: 28),
          // ===== PRAKIRAAN HARIAN =====
          Row(
            children: [
              Icon(Icons.calendar_today,
                  size: 20, color: theme.colorScheme.secondary),
              const SizedBox(width: 8),
              Text(
                'Prakiraan ${weather.daily.length} Hari',
                style: theme.textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...weather.daily.map(
            (d) => DailyForecastCard(daily: d),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
