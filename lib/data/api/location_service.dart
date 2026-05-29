import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  LocationService._();
  static final LocationService instance = LocationService._();

  // Maps device country → MealDB area name
  static const Map<String, String> _countryToArea = {
    'United States': 'American',
    'United Kingdom': 'British',
    'Canada': 'Canadian',
    'China': 'Chinese',
    'Croatia': 'Croatian',
    'Netherlands': 'Dutch',
    'Egypt': 'Egyptian',
    'Philippines': 'Filipino',
    'France': 'French',
    'Greece': 'Greek',
    'India': 'Indian',
    'Ireland': 'Irish',
    'Italy': 'Italian',
    'Jamaica': 'Jamaican',
    'Japan': 'Japanese',
    'Kenya': 'Kenyan',
    'Malaysia': 'Malaysian',
    'Mexico': 'Mexican',
    'Morocco': 'Moroccan',
    'Poland': 'Polish',
    'Portugal': 'Portuguese',
    'Russia': 'Russian',
    'Spain': 'Spanish',
    'Thailand': 'Thai',
    'Tunisia': 'Tunisian',
    'Turkey': 'Turkish',
    'Ukraine': 'Ukrainian',
    'Uruguay': 'Uruguayan',
    'Vietnam': 'Vietnamese',
  };

  /// Returns MealDB area string for device's current country.
  /// Returns null if permission denied or country not in map.
  Future<String?> getAreaForCurrentLocation() async {
    try {
      // Check & request permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      // Check if location service is on
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      // Get coordinates
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        timeLimit: const Duration(seconds: 10),
      );

      // Reverse geocode to country
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isEmpty) return null;

      final country = placemarks.first.country ?? '';
      return _countryToArea[country]; // null if country not supported
    } catch (_) {
      return null; // Fail silently — caller handles null gracefully
    }
  }
}
