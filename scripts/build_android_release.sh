#!/bin/bash

# Build Android app for release with environment variables from env.json
# This script ensures all Supabase credentials are included in the build

set -e  # Exit on error

echo "🚀 Building Android app for release..."
echo ""

# Check if env.json exists
if [ ! -f "env.json" ]; then
    echo "❌ Error: env.json not found!"
    echo "Please create env.json with your Supabase credentials."
    echo "See env.example.json for template."
    exit 1
fi

# Extract values from env.json
SUPABASE_URL=$(grep -o '"SUPABASE_URL"[[:space:]]*:[[:space:]]*"[^"]*"' env.json | sed 's/.*"\([^"]*\)".*/\1/')
SUPABASE_ANON_KEY=$(grep -o '"SUPABASE_ANON_KEY"[[:space:]]*:[[:space:]]*"[^"]*"' env.json | sed 's/.*"\([^"]*\)".*/\1/')
STRIPE_KEY=$(grep -o '"STRIPE_PUBLISHABLE_KEY"[[:space:]]*:[[:space:]]*"[^"]*"' env.json | sed 's/.*"\([^"]*\)".*/\1/')

echo "✅ Loaded environment variables from env.json"
echo "   SUPABASE_URL: ${SUPABASE_URL:0:30}..."
echo "   SUPABASE_ANON_KEY: ${SUPABASE_ANON_KEY:0:30}..."
echo "   STRIPE_PUBLISHABLE_KEY: ${STRIPE_KEY:0:30}..."
echo ""

# Check for Android signing
if [ ! -f "android/key.properties" ]; then
    echo "⚠️  Warning: android/key.properties not found"
    echo "   Release will be signed with debug keys"
    echo "   See android/key.properties.example for production setup"
    echo ""
fi

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean
flutter pub get
echo ""

# Build Android App Bundle (for Play Store)
echo "📦 Building Android App Bundle (.aab)..."
flutter build appbundle \
  --dart-define=SUPABASE_URL="$SUPABASE_URL" \
  --dart-define=SUPABASE_ANON_KEY="$SUPABASE_ANON_KEY" \
  --dart-define=STRIPE_PUBLISHABLE_KEY="$STRIPE_KEY" \
  --release

echo ""
echo "✅ Build complete!"
echo ""
echo "📍 App Bundle location:"
echo "   build/app/outputs/bundle/release/app-release.aab"
echo ""
echo "📤 Upload to Play Store:"
echo "   https://play.google.com/console"
echo ""
echo "💡 To build APK instead, run:"
echo "   flutter build apk --dart-define-from-file=env.json --release"
echo ""
