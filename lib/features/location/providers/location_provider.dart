import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/location_service.dart';
import '../models/location_state.dart';

part 'location_provider.g.dart';

@riverpod
class Location extends _$Location {
  @override
  LocationState build() {
    return const LocationState.initial();
  }

  Future<LocationPermissionResult> requestLocationPermission() async {
    state = const LocationState.loading();
    
    try {
      final locationService = ref.read(locationServiceProvider);
      final result = await locationService.requestLocationPermission();
      
      if (result == LocationPermissionResult.granted) {
        final currentLocation = await locationService.getCurrentLocation();
        state = LocationState.success(currentLocation);
        return result;
      } else {
        state = const LocationState.permissionDenied();
        return result;
      }
    } catch (e) {
      state = LocationState.error(e.toString());
      return LocationPermissionResult.error;
    }
  }

  Future<void> setManualLocation(String location) async {
    state = const LocationState.loading();
    
    try {
      final locationService = ref.read(locationServiceProvider);
      await locationService.setManualLocation(location);
      state = LocationState.success(location);
    } catch (e) {
      state = LocationState.error(e.toString());
    }
  }

  Future<void> getCurrentLocation() async {
    state = const LocationState.loading();
    
    try {
      final locationService = ref.read(locationServiceProvider);
      final location = await locationService.getCurrentLocation();
      state = LocationState.success(location);
    } catch (e) {
      state = LocationState.error(e.toString());
    }
  }

  String? get currentLocation {
    return state.maybeWhen(
      success: (location) => location,
      orElse: () => null,
    );
  }

  bool get hasLocation {
    return state.maybeWhen(
      success: (_) => true,
      orElse: () => false,
    );
  }
} 