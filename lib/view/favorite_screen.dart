import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/favorite_viewmodel.dart';
import '../viewmodel/weather_viewmodel.dart';
import '../model/location_model.dart';
import '../model/favorite_model.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoriteViewModel>().loadFavorites();
    });
  }

  void _onSelectFavorite(FavoriteModel fav) {
    final location = LocationModel(
      id: fav.locationId,
      name: fav.name,
      latitude: fav.latitude,
      longitude: fav.longitude,
      country: fav.country,
      admin1: fav.admin1,
    );
    context.read<WeatherViewModel>().setHomeCity(location);
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  void _onRemoveFavorite(int locationId) {
    context.read<FavoriteViewModel>().removeFavorite(locationId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kota Favorit'),
      ),
      body: Consumer<FavoriteViewModel>(
        builder: (context, vm, _) {
          // Loading
          if (vm.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.secondary,
              ),
            );
          }

          // Empty
          if (vm.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.favorite_border,
                        size: 64,
                        color:
                            theme.textTheme.bodyMedium?.color?.withAlpha(77)),
                    const SizedBox(height: 12),
                    Text(
                      'Belum ada kota favorit',
                      style: theme.textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tambahkan kota favorit dari halaman pencarian',
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          // Data
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: vm.favorites.length,
            separatorBuilder: (_, __) =>
                Divider(color: theme.dividerColor, height: 1),
            itemBuilder: (context, index) {
              final fav = vm.favorites[index];
              return ListTile(
                leading: Icon(Icons.location_city,
                    color: theme.colorScheme.secondary),
                title: Text(fav.name, style: theme.textTheme.titleMedium),
                subtitle: Text(
                  [fav.admin1, fav.country]
                      .where((s) => s != null && s.isNotEmpty)
                      .join(', '),
                  style: theme.textTheme.bodyMedium,
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete_outline,
                      color: theme.colorScheme.error),
                  onPressed: () => _showRemoveDialog(fav),
                ),
                onTap: () => _onSelectFavorite(fav),
                onLongPress: () => _showRemoveDialog(fav),
              );
            },
          );
        },
      ),
    );
  }

  void _showRemoveDialog(FavoriteModel fav) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Text('Hapus Favorit', style: theme.textTheme.titleLarge),
        content: Text(
          'Hapus ${fav.displayName} dari daftar favorit?',
          style: theme.textTheme.bodyLarge,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Batal',
                style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _onRemoveFavorite(fav.locationId);
            },
            child:
                Text('Hapus', style: TextStyle(color: theme.colorScheme.error)),
          ),
        ],
      ),
    );
  }
}
