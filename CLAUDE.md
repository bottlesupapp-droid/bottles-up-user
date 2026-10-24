# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Current state (24 Oct 2026): read this first

The app is being moved onto the **website's `site_*` data** (source of truth; same Supabase project as the website and the vendor app). Bundle IDs: iOS `com.btlup.pop`, Android `com.bottlesup.user`. Events and tickets are done; VIP tables, after-purchase actions, push and store readiness are not (see `HANDOFF.md` at the monorepo root).

- New code lives in `lib/site/` (no codegen, hand-written Riverpod): `models/` (tolerant parsers that drop bad rows), `rules/` (plain functions), `services/` (talk to the website's tables and functions, throw `SiteException` with a plain sentence), `providers/site_providers.dart`. Screens: `lib/features/discover` (events) and `lib/features/tickets_site` (buy, pay, my tickets, ticket). Tabs: Events | My tickets | Profile. The route table is `appRoutes` in `lib/routing/app_router.dart`.
- Payment is the website's hosted Stripe Checkout, opened in an in-app browser view; the app asks `site-booking-status` how it went. There is no Stripe SDK in the app.
- Tests (`flutter test`): services run the real Supabase client against `test/support/fake_website.dart` (a pretend website); `test/site/site_drift_test.dart` reads the website's SQL and edge functions from `../bottles-up-website-main` so a change there that the app does not follow fails a test. Build the `FakeWebsite` in `setUp`, and in widget tests let function calls finish with `settleCalls` (see `test/support/pump_site.dart`).
- `_archive/` holds everything that was cut (`_archive/README.md`, restore with `_archive/restore.sh`). Do not import from it. Edit CRLF files carefully (several are CRLF; keep their line endings).
- Do not build, run or push to `main`; discuss new features with the user first.

Everything below this line describes the OLD app (Freezed, code generation, the legacy tables) and is kept for reference only.

## Common Commands

### Development
- `flutter run` - Run the app in development mode
- `flutter run --hot-reload` - Run with hot reload enabled
- `flutter build apk` - Build Android APK
- `flutter build ios` - Build iOS app

### Code Generation
- `dart run build_runner build` - Generate code for Freezed models, JSON serialization, and Riverpod providers
- `dart run build_runner build --delete-conflicting-outputs` - Clean build with conflict resolution
- `dart run build_runner watch` - Watch for changes and auto-generate code

### Testing & Quality
- `flutter test` - Run all tests
- `flutter clean` - Clean build artifacts
- `flutter pub get` - Install dependencies

## Architecture Overview

### Feature-Based Architecture
The app uses a feature-first architecture where each feature is self-contained:

```
lib/features/[feature_name]/
├── models/          # Freezed data models with JSON serialization
├── providers/       # Riverpod state management (code-generated)
├── services/        # Data services and API calls
├── screens/         # UI screens for the feature
└── widgets/         # Feature-specific widgets
```

### Key Architectural Patterns
- **State Management**: Riverpod with code generation (`@riverpod` annotations)
- **Data Models**: Freezed classes with JSON serialization
- **Navigation**: GoRouter with nested routes and custom transitions
- **Backend**: Supabase with PostgreSQL database
- **Authentication**: Multi-provider (email/password, Google, Apple)

### Core Dependencies
- **flutter_riverpod**: State management with providers
- **freezed**: Immutable data classes and union types
- **go_router**: Declarative routing
- **supabase_flutter**: Backend-as-a-Service
- **google_sign_in**: OAuth authentication
- **geolocator**: Location services

## State Management Patterns

### Riverpod Providers
The app uses code-generated Riverpod providers with auto-dispose:

```dart
@riverpod
class FeatureName extends _$FeatureName {
  @override
  FutureOr<DataType> build() async {
    // Provider implementation
  }
}
```

### Common Provider Types
- `FutureProvider` - Async data fetching
- `StateProvider` - Simple state management
- `StateNotifierProvider` - Complex state with mutations
- Auto-dispose providers for automatic cleanup

## Data Layer

### Supabase Configuration
- URL: `https://hwmynlghrmtoufyrcihp.supabase.co`
- Anonymous key is configured in main.dart
- Row Level Security (RLS) enabled for data protection

### Service Pattern
Each feature has dedicated service classes following singleton pattern:

```dart
class FeatureService {
  static final FeatureService _instance = FeatureService._internal();
  factory FeatureService() => _instance;
  
  final SupabaseClient _supabase = Supabase.instance.client;
  
  Future<List<Model>> getData() async {
    // Service implementation
  }
}
```

### Model Conventions
All models use Freezed with factory constructors:

```dart
@freezed
class ModelName with _$ModelName {
  const factory ModelName({
    required String id,
    required String name,
  }) = _ModelName;

  factory ModelName.fromJson(Map<String, dynamic> json) => _$ModelNameFromJson(json);
  factory ModelName.fromSupabase(Map<String, dynamic> data) => ModelName(...);
}
```

## UI/UX Patterns

### Theme
- Material 3 dark theme with orange primary color (#FF6B00)
- Inter font family throughout the app
- Consistent spacing and elevation using Material 3 tokens

### Common UI Patterns
- **Shimmer Loading**: Skeleton screens during data fetching
- **Infinite Scroll**: Pagination with smooth loading states
- **Hero Animations**: Smooth transitions between screens
- **Custom App Bars**: Scrolling behavior with dynamic opacity

### Navigation Structure
- Splash screen → Authentication → Location permission → Home
- Bottom navigation with multiple tabs
- Nested routes for profile settings
- Custom slide transitions for profile screens

## Key Features

### Authentication Flow
1. **Multi-provider auth**: Email/password, Google, Apple
2. **User profiles**: Extended user data with age verification
3. **Session management**: Automatic token refresh
4. **Protected routes**: Authentication guards

### Location Services
- **GPS integration**: Real-time location tracking
- **Manual location entry**: Fallback for permission denied
- **Geocoding**: Address to coordinates conversion
- **Persistent storage**: Location caching

### Club Discovery
- **Category filtering**: Dynamic club filtering
- **Search functionality**: Real-time search with debouncing
- **Pagination**: Infinite scroll with state management
- **Rating system**: User reviews and ratings

## Development Notes

### Code Generation Requirements
Always run `dart run build_runner build` after:
- Adding new Freezed models
- Modifying existing models
- Adding new Riverpod providers
- Changing JSON serialization

### Database Schema
The app connects to a comprehensive Supabase database with:
- Users, clubs, events, bookings tables
- Reviews, bottles, tables, menu items
- Triggers for automatic timestamp updates
- RLS policies for data security

### MCP Server Integration
The project includes Supabase MCP server integration configured in `.cursor/mcp.json` for enhanced development experience with database operations.

### File Organization
- Use barrel exports (`widgets.dart`) for clean imports
- Follow feature-first organization strictly
- Keep shared widgets in `lib/shared/widgets/`
- Use `lib/common_widgets/` for reusable components

### Error Handling
- Use `AsyncValue` for comprehensive error states
- Implement fallback UI for network failures
- Provide clear user feedback for errors
- Handle authentication state changes gracefully