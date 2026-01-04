import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  static LocationService? _instance;
  static LocationService get instance => _instance ??= LocationService._();
  LocationService._();

  String? _currentLocation;
  String? get currentLocation => _currentLocation;

  /// Check if location services are enabled and permissions are granted
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  /// Get current position and convert to readable address
  Future<String?> getCurrentLocation() async {
    try {
      // Check permissions first
      final hasPermission = await _handleLocationPermission();
      if (!hasPermission) {
        return null;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      // Convert coordinates to address
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        
        // Format the address
        String location = '';
        
        if (placemark.locality != null && placemark.locality!.isNotEmpty) {
          location = placemark.locality!;
        }
        
        if (placemark.administrativeArea != null && placemark.administrativeArea!.isNotEmpty) {
          if (location.isNotEmpty) {
            location += ', ${placemark.administrativeArea!}';
          } else {
            location = placemark.administrativeArea!;
          }
        }
        
        if (placemark.country != null && placemark.country!.isNotEmpty) {
          if (location.isNotEmpty) {
            location += ', ${placemark.country!}';
          } else {
            location = placemark.country!;
          }
        }

        // Fallback if no location found
        if (location.isEmpty) {
          location = 'Unknown Location';
        }

        _currentLocation = location;
        return location;
      }
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }

    return null;
  }

  /// Get cached location or fetch new one
  Future<String> getLocationWithFallback() async {
    // Return cached location if available
    if (_currentLocation != null) {
      return _currentLocation!;
    }

    // Try to get current location
    final location = await getCurrentLocation();
    if (location != null) {
      return location;
    }

    // Fallback to default location
    return 'New York, USA';
  }

  /// Clear cached location
  void clearLocation() {
    _currentLocation = null;
  }
} 