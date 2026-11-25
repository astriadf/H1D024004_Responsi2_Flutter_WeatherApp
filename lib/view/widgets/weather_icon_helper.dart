import 'package:flutter/material.dart';

/// Helper untuk menampilkan icon dan deskripsi cuaca berdasarkan WMO weather code.
class WeatherIconHelper {
  static IconData getIcon(int weatherCode) {
    switch (weatherCode) {
      case 0:
        return Icons.wb_sunny;
      case 1:
      case 2:
        return Icons.wb_cloudy;
      case 3:
        return Icons.cloud;
      case 45:
      case 48:
        return Icons.foggy;
      case 51:
      case 53:
      case 55:
        return Icons.grain;
      case 56:
      case 57:
        return Icons.ac_unit;
      case 61:
      case 63:
      case 65:
        return Icons.water_drop;
      case 66:
      case 67:
        return Icons.severe_cold;
      case 71:
      case 73:
      case 75:
      case 77:
        return Icons.ac_unit;
      case 80:
      case 81:
      case 82:
        return Icons.thunderstorm;
      case 85:
      case 86:
        return Icons.snowing;
      case 95:
      case 96:
      case 99:
        return Icons.flash_on;
      default:
        return Icons.wb_cloudy;
    }
  }

  static String getDescription(int weatherCode) {
    switch (weatherCode) {
      case 0:
        return 'Cerah';
      case 1:
        return 'Sebagian Cerah';
      case 2:
        return 'Berawan Sebagian';
      case 3:
        return 'Berawan';
      case 45:
        return 'Berkabut';
      case 48:
        return 'Kabut Tebal';
      case 51:
        return 'Gerimis Ringan';
      case 53:
        return 'Gerimis';
      case 55:
        return 'Gerimis Lebat';
      case 56:
        return 'Gerimis Beku Ringan';
      case 57:
        return 'Gerimis Beku Lebat';
      case 61:
        return 'Hujan Ringan';
      case 63:
        return 'Hujan Sedang';
      case 65:
        return 'Hujan Lebat';
      case 66:
        return 'Hujan Beku Ringan';
      case 67:
        return 'Hujan Beku Lebat';
      case 71:
        return 'Salju Ringan';
      case 73:
        return 'Salju Sedang';
      case 75:
        return 'Salju Lebat';
      case 77:
        return 'Butiran Salju';
      case 80:
        return 'Hujan Shower Ringan';
      case 81:
        return 'Hujan Shower Sedang';
      case 82:
        return 'Hujan Shower Lebat';
      case 85:
        return 'Salju Shower Ringan';
      case 86:
        return 'Salju Shower Lebat';
      case 95:
        return 'Badai Petir';
      case 96:
        return 'Badai Petir + Hujan Es Ringan';
      case 99:
        return 'Badai Petir + Hujan Es Lebat';
      default:
        return 'Tidak Diketahui';
    }
  }

  static Color getColor(int weatherCode, BuildContext context) {
    final theme = Theme.of(context);
    switch (weatherCode) {
      case 0:
      case 1:
        return theme.colorScheme.secondary; // amber
      case 2:
      case 3:
        return theme.textTheme.bodyMedium?.color ?? Colors.grey;
      case 45:
      case 48:
        return Colors.blueGrey;
      case 51:
      case 53:
      case 55:
      case 61:
      case 63:
      case 65:
      case 80:
      case 81:
      case 82:
        return Colors.lightBlue;
      case 71:
      case 73:
      case 75:
      case 77:
      case 85:
      case 86:
      case 56:
      case 57:
      case 66:
      case 67:
        return Colors.white70;
      case 95:
      case 96:
      case 99:
        return Colors.orangeAccent;
      default:
        return theme.iconTheme.color ?? Colors.white;
    }
  }
}
