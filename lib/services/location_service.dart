import 'package:latlong2/latlong.dart';

import '../core/constants.dart';

class LocationService {
  List<Map<String, String>> getCities() => AppConstants.kazakhstanCities;

  List<Map<String, String>> filterCities(String query) {
    if (query.trim().isEmpty) {
      return getCities();
    }

    final normalized = query.toLowerCase();
    return getCities()
        .where((city) => city['name']!.toLowerCase().contains(normalized))
        .toList();
  }

  List<String> filterDestinations(String query) {
    if (query.trim().isEmpty) {
      return AppConstants.destinationSuggestions;
    }

    final normalized = query.toLowerCase();
    return AppConstants.destinationSuggestions
        .where((item) => item.toLowerCase().contains(normalized))
        .toList();
  }

  LatLng cityCenterFor(String city) {
    switch (city) {
      case 'Harare':
        return const LatLng(-17.8292, 31.0522);
      case 'Bulawayo':
        return const LatLng(-20.1328, 28.6265);
      case 'Mutare':
        return const LatLng(-18.9707, 32.6700);
      case 'Gweru':
        return const LatLng(-19.4550, 29.8180);
      case 'Chinhoyi':
        return const LatLng(-17.3600, 30.2018);
      default:
        return AppConstants.defaultCenter;
    }
  }
}
