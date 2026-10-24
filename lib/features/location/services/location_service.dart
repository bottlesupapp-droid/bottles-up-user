import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LocationPermissionResult {
  granted,
  denied,
  deniedForever,
  serviceDisabled,
  error,
}

final locationServiceProvider = Provider<LocationService>((ref) => LocationService());

class LocationService {
  static const String _manualLocationKey = 'manual_location';
  static const String _locationPermissionGrantedKey = 'location_permission_granted';

  Future<LocationPermissionResult> requestLocationPermission() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return LocationPermissionResult.serviceDisabled;
      }

      // Check current permission status
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return LocationPermissionResult.denied;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return LocationPermissionResult.deniedForever;
      }

      // Save that permission was granted
      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_locationPermissionGrantedKey, true);
      }

      return LocationPermissionResult.granted;
    } catch (e) {
      return LocationPermissionResult.error;
    }
  }

  Future<bool> hasLocationPermission() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return false;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      return permission == LocationPermission.whileInUse || 
             permission == LocationPermission.always;
    } catch (e) {
      return false;
    }
  }

  Future<String> getCurrentLocation() async {
    try {
      // Check for manual location first
      final manualLocation = await getManualLocation();
      if (manualLocation != null) {
        return manualLocation;
      }

      // Get GPS location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        final city = placemark.locality ?? placemark.subAdministrativeArea ?? '';
        final state = placemark.administrativeArea ?? '';
        final country = placemark.country ?? '';
        
        if (city.isNotEmpty && state.isNotEmpty) {
          return '$city, $state, $country';
        } else if (city.isNotEmpty) {
          return '$city, $country';
        } else {
          return country.isNotEmpty ? country : 'Unknown Location';
        }
      }

      return 'Unknown Location';
    } catch (e) {
      // Fallback to manual location or default
      final manualLocation = await getManualLocation();
      return manualLocation ?? 'Nearby';
    }
  }

  Future<void> setManualLocation(String location) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_manualLocationKey, location);
    } catch (e) {
      throw 'Failed to save location';
    }
  }

  Future<String?> getManualLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_manualLocationKey);
    } catch (e) {
      return null;
    }
  }

  Future<void> clearManualLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_manualLocationKey);
    } catch (e) {
      // Ignore error
    }
  }

  Future<bool> shouldShowLocationScreen() async {
    // Check if we have a manual location set
    final manualLocation = await getManualLocation();
    if (manualLocation != null) {
      return false;
    }

    // Check if permission was previously granted
    final prefs = await SharedPreferences.getInstance();
    final permissionGranted = prefs.getBool(_locationPermissionGrantedKey) ?? false;
    if (permissionGranted) {
      return false;
    }

    // Check if we have location permission
    return !(await hasLocationPermission());
  }
} 