# Bottles Up - User App

The Bottles Up user-facing mobile application for discovering nightlife events, booking tables, managing bottle service, and connecting with venues.

## Table of Contents

- [Overview](#overview)
- [Quick Start](#quick-start)
- [Architecture](#architecture)
- [Development](#development)
- [Testing](#testing)
- [Deployment](#deployment)
- [Documentation](#documentation)
- [Support](#support)

## Overview

Bottles Up is a comprehensive nightlife platform connecting users with clubs, events, and premium experiences. This repository contains the Flutter-based user mobile application.

### Features

- **Event Discovery** - Browse and search nightlife events
- **Table Booking** - Reserve VIP tables and bottle service
- **Payment Integration** - Secure in-app payments via Stripe
- **Ticketing** - Digital tickets with QR codes and wallet passes
- **Social Features** - Share events, invite friends, group bookings
- **Loyalty Program** - Earn rewards and unlock exclusive perks
- **Real-time Updates** - Live bill tracking, chat, and notifications

### Technology Stack

- **Frontend:** Flutter 3.x
- **State Management:** Riverpod with code generation
- **Backend:** Supabase (PostgreSQL, Auth, Storage, Edge Functions)
- **Payments:** Stripe Payment Sheet (In-App)
- **Authentication:** Email, Google Sign-In, Apple Sign-In
- **Navigation:** GoRouter with custom transitions

## Quick Start

### Prerequisites

- Flutter SDK 3.5.0 or higher
- Dart 3.5.0 or higher
- Xcode 15+ (for iOS development)
- Android Studio / Android SDK 34+ (for Android development)
- Supabase account and project
- Stripe account (test and live keys)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/bottlesupapp-droid/bottles-up-user.git
   cd bottles-up-user
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up environment variables**

   Create `env.json` in the root directory:
   ```json
   {
     "SUPABASE_URL": "https://your-project.supabase.co",
     "SUPABASE_ANON_KEY": "your-anon-key",
     "STRIPE_PUBLISHABLE_KEY": "pk_test_..."
   }
   ```

   See [docs/guides/ENVIRONMENT_SETUP.md](docs/guides/ENVIRONMENT_SETUP.md) for full configuration.

4. **Run code generation**
   ```bash
   dart run build_runner build
   ```

5. **Run the app**
   ```bash
   flutter run \
     --dart-define=SUPABASE_URL=https://your-project.supabase.co \
     --dart-define=SUPABASE_ANON_KEY=your-anon-key \
     --dart-define=STRIPE_PUBLISHABLE_KEY=pk_test_...
   ```

## Architecture

### Project Structure

```
lib/
├── core/              # Core utilities and services
│   ├── error/        # Global error handling
│   ├── services/     # Shared services (payment, image upload)
│   └── config/       # App configuration
├── features/         # Feature modules (feature-first architecture)
│   ├── auth/         # Authentication
│   ├── events/       # Event discovery and booking
│   ├── bookings/     # Booking management
│   ├── profile/      # User profile
│   └── ...
├── routing/          # App navigation (GoRouter)
├── theme/            # Material 3 theme configuration
└── main.dart         # App entry point
```

### Feature Structure

Each feature follows a consistent pattern:

```
features/[feature_name]/
├── models/          # Freezed data models
├── providers/       # Riverpod providers (code-generated)
├── services/        # Data services and business logic
├── screens/         # UI screens
└── widgets/         # Feature-specific widgets
```

### Key Architectural Patterns

- **State Management:** Riverpod with `@riverpod` code generation
- **Data Models:** Freezed classes with JSON serialization
- **Error Handling:** Centralized `ErrorHandler` with typed exceptions
- **Services:** Singleton pattern with Supabase client
- **Navigation:** Declarative routing with GoRouter
- **Crash Reporting:** Global error handler with Sentry/Crashlytics hooks

See [CLAUDE.md](CLAUDE.md) for detailed architecture documentation.

## Development

### Common Commands

```bash
# Run app in debug mode
flutter run

# Run with environment variables
flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...

# Code generation (after model changes)
dart run build_runner build --delete-conflicting-outputs

# Watch mode (auto-regenerate)
dart run build_runner watch

# Run tests
flutter test

# Code analysis
flutter analyze

# Clean build artifacts
flutter clean
```

### Code Generation

The app uses code generation for:
- **Freezed models** - Immutable data classes
- **JSON serialization** - `fromJson` / `toJson`
- **Riverpod providers** - Type-safe state management

Always run `dart run build_runner build` after:
- Adding/modifying Freezed models
- Adding/modifying Riverpod providers
- Changing JSON serialization

### Environment Variables

All sensitive configuration must use environment variables:

| Variable | Description | Required |
|----------|-------------|----------|
| `SUPABASE_URL` | Supabase project URL | Yes |
| `SUPABASE_ANON_KEY` | Supabase anonymous key | Yes |
| `STRIPE_PUBLISHABLE_KEY` | Stripe publishable key | Yes |

Pass via `--dart-define` flags when running/building the app.

See [docs/guides/ENVIRONMENT_SETUP.md](docs/guides/ENVIRONMENT_SETUP.md) for full guide.

### Error Handling

All service calls must be wrapped with error handling:

```dart
import 'package:bottles_up_user/core/error/error_handler.dart';

Future<List<Event>> getEvents() async {
  return await ErrorHandler.handleAsync(
    operation: () async {
      final response = await _supabase.from('events').select();
      return (response as List).map((e) => Event.fromSupabase(e)).toList();
    },
    errorMessage: 'Failed to load events',
  );
}
```

See [docs/guides/ERROR_HANDLING_GUIDE.md](docs/guides/ERROR_HANDLING_GUIDE.md) for comprehensive guide.

## Testing

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/features/events/event_service_test.dart

# Run with coverage
flutter test --coverage
```

### Test Structure

- **Unit Tests:** Service layer and business logic
- **Widget Tests:** UI components
- **Integration Tests:** E2E user flows

See testing guides in [docs/guides/](docs/guides/).

## Deployment

### Android Release Build

1. **Configure signing**
   - Create `android/key.properties` (see `android/key.properties.example`)
   - Update `android/app/build.gradle` with signing config

2. **Build APK**
   ```bash
   flutter build apk --release \
     --dart-define=SUPABASE_URL=$SUPABASE_URL \
     --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY \
     --dart-define=STRIPE_PUBLISHABLE_KEY=$STRIPE_PUBLISHABLE_KEY
   ```

3. **Build App Bundle** (for Google Play)
   ```bash
   flutter build appbundle --release \
     --dart-define=SUPABASE_URL=$SUPABASE_URL \
     --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY \
     --dart-define=STRIPE_PUBLISHABLE_KEY=$STRIPE_PUBLISHABLE_KEY
   ```

### iOS Release Build

1. **Configure signing in Xcode**
   - Open `ios/Runner.xcworkspace`
   - Configure signing and capabilities

2. **Build IPA**
   ```bash
   flutter build ios --release \
     --dart-define=SUPABASE_URL=$SUPABASE_URL \
     --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY \
     --dart-define=STRIPE_PUBLISHABLE_KEY=$STRIPE_PUBLISHABLE_KEY
   ```

See full deployment guide in [docs/guides/](docs/guides/) (coming soon).

## Documentation

### Guides

- [Error Handling Guide](docs/guides/ERROR_HANDLING_GUIDE.md) - Comprehensive error handling implementation
- [Environment Setup](docs/guides/ENVIRONMENT_SETUP.md) - Environment variables and build configuration
- [Booking Flow Map](docs/guides/BOOKING_FLOW_COMPLETE_MAP.md) - End-to-end booking flow documentation
- [Testing Guides](docs/guides/) - QA, E2E, and validation guides

### Archive

Historical reports and status documents are in [docs/archive/](docs/archive/):
- Security audits
- Migration guides
- Implementation summaries
- Status reports

### Scripts

Utility scripts are in [scripts/](scripts/):
- `apply_migrations.sh` - Apply Supabase migrations
- `deploy_edge_functions.sh` - Deploy Supabase edge functions
- `fetch_schema.js` - Fetch database schema

## Project Status

### Production Readiness

✅ **Complete:**
- Global error handling integrated
- Environment variables configured
- Stripe secret keys removed from client
- Event service hardened with error handling
- Repository organized

🟡 **In Progress:**
- Error handling for all services (1/77 complete)
- Android/iOS release build configuration
- Production log cleanup

❌ **TODO:**
- Crash reporting integration (Sentry/Crashlytics)
- RLS policies deployment
- Atomic booking function deployment
- Comprehensive test suite

See [PRODUCTION_HARDENING_STATUS.md](PRODUCTION_HARDENING_STATUS.md) for detailed status.

### Recent Major Updates

- **2026-06-12** - Production hardening: Global error handling, repository organization
- **2026-06-12** - Security audit: Removed hardcoded Stripe secrets, environment variables
- **2026-06-12** - Booking flow audit: Identified critical race conditions and double-booking issues
- **2026-06-12** - Vendor-user compatibility audit: RLS policies, schema sync

## Support

### Issues

For bug reports and feature requests, please create an issue in this repository.

### Development Team

This is a private repository for the Bottles Up development team.

### Related Repositories

- **Vendor App:** [bottles-up-vendor](https://github.com/bottlesupapp-droid/bottles-up-vendor) (private)
- **Backend:** Supabase project (self-hosted)

---

**License:** Proprietary - All Rights Reserved
**Version:** 1.0.0 (Pre-release)
**Last Updated:** 2026-06-12
