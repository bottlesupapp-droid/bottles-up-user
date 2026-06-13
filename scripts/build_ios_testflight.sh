#!/bin/bash

# Build iOS app for TestFlight with environment variables from env.json
# This script ensures all Supabase credentials are included in the build

set -e  # Exit on error

echo "🚀 Building iOS app for TestFlight..."
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

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean
flutter pub get
echo ""

# Build iOS archive with environment variables
echo "📦 Building iOS archive..."
flutter build ipa \
  --dart-define=SUPABASE_URL="$SUPABASE_URL" \
  --dart-define=SUPABASE_ANON_KEY="$SUPABASE_ANON_KEY" \
  --dart-define=STRIPE_PUBLISHABLE_KEY="$STRIPE_KEY" \
  --release

echo ""
echo "✅ Build complete!"
echo ""
echo "📍 Archive location:"
echo "   build/ios/archive/Runner.xcarchive"
echo ""
echo "📤 Next steps:"
echo "   1. Open Xcode"
echo "   2. Go to Window → Organizer"
echo "   3. Select the archive"
echo "   4. Click 'Distribute App'"
echo "   5. Choose 'TestFlight & App Store'"
echo "   6. Follow the upload wizard"
echo ""
