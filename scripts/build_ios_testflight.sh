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

# Generate DartDefines.xcconfig for Xcode
echo "📝 Generating environment config for Xcode..."
cd ios && SRCROOT="$(pwd)" bash Scripts/generate_dart_defines.sh && cd ..
echo ""

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean
flutter pub get
echo ""

# Build iOS archive (environment variables loaded from DartDefines.xcconfig)
echo "📦 Building iOS archive..."
flutter build ipa --release

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
