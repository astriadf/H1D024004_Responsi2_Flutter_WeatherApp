import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/search_viewmodel.dart';
import '../viewmodel/weather_viewmodel.dart';
import '../viewmodel/favorite_viewmodel.dart';
import '../model/location_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchViewModel>().loadSearchHistory();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearch() {
    final query = _controller.text.trim();
    if (query.isNotEmpty) {
      context.read<SearchViewModel>().searchLocation(query);
    }
  }

  void _onSelectLocation(LocationModel location) {
    final weatherVm = context.read<WeatherViewModel>();
    weatherVm.setHomeCity(location);
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  void _onToggleFavorite(LocationModel location) {
    context.read<FavoriteViewModel>().toggleFavorite(location);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cari Kota'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    autofocus: true,
                    style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                    decoration: InputDecoration(
                      hintText: 'Masukkan nama kota...',
                      prefixIcon: Icon(Icons.search,
                          color: theme.textTheme.bodyMedium?.color),
                    ),
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => _onSearch(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send, color: theme.colorScheme.secondary),
                  onPressed: _onSearch,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Consumer<SearchViewModel>(
        builder: (context, vm, _) {
          // Loading
          if (vm.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.secondary,
              ),
            );
          }

          // Error
          if (vm.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline,
                        size: 48, color: theme.colorScheme.error),
                    const SizedBox(height: 12),
                    Text(
                      vm.errorMessage!,
                      style: theme.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          // Hasil pencarian
          if (vm.hasResults) {
            return _buildSearchResults(context, vm);
          }

          // Empty — tampilkan riwayat
          return _buildSearchHistory(context, vm);
        },
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context, SearchViewModel vm) {
    final theme = Theme.of(context);

    return Consumer<FavoriteViewModel>(
      builder: (context, favVm, _) {
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: vm.searchResults.length,
          separatorBuilder: (_, __) =>
              Divider(color: theme.dividerColor, height: 1),
          itemBuilder: (context, index) {
            final location = vm.searchResults[index];
            final isFav = favVm.isFavorite(location.id);
            return ListTile(
              leading: Icon(Icons.location_on,
                  color: theme.colorScheme.secondary),
              title: Text(location.name,
                  style: theme.textTheme.titleMedium),
              subtitle: Text(
                [location.admin1, location.country]
                    .where((s) => s != null && s.isNotEmpty)
                    .join(', '),
                style: theme.textTheme.bodyMedium,
              ),
              trailing: IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav
                      ? theme.colorScheme.error
                      : theme.textTheme.bodyMedium?.color,
                ),
                onPressed: () => _onToggleFavorite(location),
              ),
              onTap: () => _onSelectLocation(location),
            );
          },
        );
      },
    );
  }

  Widget _buildSearchHistory(BuildContext context, SearchViewModel vm) {
    final theme = Theme.of(context);

    if (vm.searchHistory.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search,
                size: 64,
                color: theme.textTheme.bodyMedium?.color?.withAlpha(77)),
            const SizedBox(height: 12),
            Text(
              'Ketik nama kota untuk memulai pencarian',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Riwayat Pencarian', style: theme.textTheme.titleMedium),
              TextButton(
                onPressed: () => vm.clearHistory(),
                child: Text('Hapus',
                    style: TextStyle(color: theme.colorScheme.error)),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: vm.searchHistory.length,
            itemBuilder: (context, index) {
              final query = vm.searchHistory[index];
              return ListTile(
                leading: Icon(Icons.history,
                    color: theme.textTheme.bodyMedium?.color),
                title: Text(query, style: theme.textTheme.bodyLarge),
                onTap: () {
                  _controller.text = query;
                  context.read<SearchViewModel>().searchLocation(query);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
