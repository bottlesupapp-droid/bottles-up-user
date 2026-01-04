import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import '../providers/location_provider.dart';
import '../services/location_service.dart';

class LocationPermissionScreen extends ConsumerStatefulWidget {
  const LocationPermissionScreen({super.key});

  @override
  ConsumerState<LocationPermissionScreen> createState() => _LocationPermissionScreenState();
}

class _LocationPermissionScreenState extends ConsumerState<LocationPermissionScreen> {
  bool _isRequestingPermission = false;

  Future<void> _requestLocationPermission() async {
    setState(() {
      _isRequestingPermission = true;
    });

    try {
      final result = await ref.read(locationProvider.notifier).requestLocationPermission();
      
      if (result == LocationPermissionResult.granted && mounted) {
        // Navigate to home screen after successful permission
        context.go('/home');
      } else if (mounted) {
        // Show specific error message based on result
        String message;
        switch (result) {
          case LocationPermissionResult.serviceDisabled:
            message = 'Please enable location services in your device settings';
            break;
          case LocationPermissionResult.denied:
            message = 'Location permission is required to show nearby restaurants';
            break;
          case LocationPermissionResult.deniedForever:
            message = 'Location permission permanently denied. Please enable it in app settings';
            break;
          case LocationPermissionResult.error:
            message = 'An error occurred while requesting location permission';
            break;
          default:
            message = 'Location permission is required to show nearby restaurants';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.orange,
            action: result == LocationPermissionResult.serviceDisabled 
                ? SnackBarAction(
                    label: 'Settings',
                    textColor: Colors.white,
                    onPressed: () => Geolocator.openLocationSettings(),
                  )
                : result == LocationPermissionResult.deniedForever
                    ? SnackBarAction(
                        label: 'Settings', 
                        textColor: Colors.white,
                        onPressed: () => Geolocator.openAppSettings(),
                      )
                    : null,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRequestingPermission = false;
        });
      }
    }
  }

  void _enterLocationManually() {
    context.go('/location/manual-entry');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const Spacer(flex: 2),
              
              // Location Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.primary.withValues(alpha: 0.1),
                ),
                child: Icon(
                  Iconsax.location,
                  size: 60,
                  color: colorScheme.primary,
                ),
              ),
              
              const Gap(40),
              
              // Title
              Text(
                'What is Your Location?',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              
              const Gap(16),
              
              // Description
              Text(
                'We need your location to show available nearby restaurant.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
              
              const Spacer(flex: 3),
              
              // Allow Location Button
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isRequestingPermission ? null : _requestLocationPermission,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isRequestingPermission
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Allow Location Access',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              
              const Gap(16),
              
              // Manual Entry Button
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: _isRequestingPermission ? null : _enterLocationManually,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Enter Location Manually',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ),
              
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
} 