# Fix Instructions: Environment Variables for Xcode & TestFlight

**Problem:** App crashes with white screen on Xcode runs and TestFlight builds due to missing environment variables (SUPABASE_URL, SUPABASE_ANON_KEY, etc.).

**Solution:** Auto-generate Xcode configuration from `env.json` so environment variables are included in all builds.

---

## Step-by-Step Instructions

### Step 1: Create Environment Files

#### 1.1 Create `env.json` (Git-Ignored)

In your project root, create `env.json` with your actual credentials:

```json
{
  "SUPABASE_URL": "https://your-project.supabase.co",
  "SUPABASE_ANON_KEY": "eyJhbGciOi...",
  "STRIPE_PUBLISHABLE_KEY": "pk_live_..."
}
```

#### 1.2 Create `env.example.json` (Template)

In your project root, create `env.example.json` as a template:

```json
{
  "SUPABASE_URL": "https://your-project.supabase.co",
  "SUPABASE_ANON_KEY": "your-anon-key-here",
  "STRIPE_PUBLISHABLE_KEY": "pk_test_your-key-here"
}
```

#### 1.3 Update `.gitignore`

Add to `.gitignore`:

```
# Environment variables (NEVER commit secrets!)
env.json
.env
.env.local
*.env

# Generated Xcode config (contains secrets)
ios/Flutter/DartDefines.xcconfig
```

---

### Step 2: Create Generator Script

Create `ios/Scripts/generate_dart_defines.sh`:

```bash
#!/bin/bash

# Generate DART_DEFINES for Xcode builds from env.json
# This script creates a temporary xcconfig file with environment variables

set -e

# Path to env.json (relative to ios folder)
ENV_FILE="${SRCROOT}/../env.json"
OUTPUT_FILE="${SRCROOT}/Flutter/DartDefines.xcconfig"

# Check if env.json exists
if [ ! -f "$ENV_FILE" ]; then
    echo "Warning: env.json not found at $ENV_FILE"
    echo "App may crash due to missing environment variables"
    echo "Creating empty DartDefines.xcconfig"
    echo "// No environment variables loaded" > "$OUTPUT_FILE"
    exit 0
fi

# Extract values from env.json
SUPABASE_URL=$(grep -o '"SUPABASE_URL"[[:space:]]*:[[:space:]]*"[^"]*"' "$ENV_FILE" | sed 's/.*"\([^"]*\)".*/\1/')
SUPABASE_ANON_KEY=$(grep -o '"SUPABASE_ANON_KEY"[[:space:]]*:[[:space:]]*"[^"]*"' "$ENV_FILE" | sed 's/.*"\([^"]*\)".*/\1/')
STRIPE_KEY=$(grep -o '"STRIPE_PUBLISHABLE_KEY"[[:space:]]*:[[:space:]]*"[^"]*"' "$ENV_FILE" | sed 's/.*"\([^"]*\)".*/\1/')

# Base64 encode (Flutter's expected format for DART_DEFINES)
SUPABASE_URL_B64=$(echo -n "SUPABASE_URL=$SUPABASE_URL" | base64)
SUPABASE_ANON_KEY_B64=$(echo -n "SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY" | base64)
STRIPE_KEY_B64=$(echo -n "STRIPE_PUBLISHABLE_KEY=$STRIPE_KEY" | base64)

# Write to xcconfig file
cat > "$OUTPUT_FILE" << EOF
// Auto-generated from env.json - DO NOT EDIT MANUALLY
// Generated on $(date)

DART_DEFINES=$SUPABASE_URL_B64,$SUPABASE_ANON_KEY_B64,$STRIPE_KEY_B64
EOF

echo "Generated DartDefines.xcconfig with environment variables"
```

Make it executable:

```bash
chmod +x ios/Scripts/generate_dart_defines.sh
```

**Note:** Customize the script if you have different environment variable names!

---

### Step 3: Update Xcode Configuration Files

#### 3.1 Update `ios/Flutter/Debug.xcconfig`

Add this line at the end:

```
#include? "DartDefines.xcconfig"
```

Full file should look like:

```
#include? "Pods/Target Support Files/Pods-Runner/Pods-Runner.debug.xcconfig"
#include "Generated.xcconfig"
#include? "DartDefines.xcconfig"
```

#### 3.2 Update `ios/Flutter/Release.xcconfig`

Add the same line:

```
#include? "DartDefines.xcconfig"
```

Full file should look like:

```
#include? "Pods/Target Support Files/Pods-Runner/Pods-Runner.release.xcconfig"
#include "Generated.xcconfig"
#include? "DartDefines.xcconfig"
```

---

### Step 4: Create VS Code Configuration

Create `.vscode/launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Development",
      "request": "launch",
      "type": "dart",
      "toolArgs": [
        "--dart-define-from-file=env.json"
      ]
    },
    {
      "name": "Profile",
      "request": "launch",
      "type": "dart",
      "flutterMode": "profile",
      "toolArgs": [
        "--dart-define-from-file=env.json"
      ]
    },
    {
      "name": "Release",
      "request": "launch",
      "type": "dart",
      "flutterMode": "release",
      "toolArgs": [
        "--dart-define-from-file=env.json"
      ]
    }
  ]
}
```

This makes VS Code automatically load environment variables when you press F5.

---

### Step 5: Update main.dart

Ensure `main.dart` loads environment variables properly:

```dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // SECURITY: Load credentials from environment variables
  const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
    throw StateError(
      'Supabase credentials not configured.\n'
      'Pass --dart-define=SUPABASE_URL=... and --dart-define=SUPABASE_ANON_KEY=...',
    );
  }

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  runApp(const MyApp());
}
```

---

### Step 6: Create Build Scripts (Optional but Recommended)

#### 6.1 iOS TestFlight Build Script

Create `scripts/build_ios_testflight.sh`:

```bash
#!/bin/bash

set -e

echo "🚀 Building iOS app for TestFlight..."
echo ""

# Check if env.json exists
if [ ! -f "env.json" ]; then
    echo "❌ Error: env.json not found!"
    echo "Please create env.json with your credentials."
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

# Build iOS archive
echo "📦 Building iOS archive..."
flutter build ipa --release

echo ""
echo "✅ Build complete!"
echo "📍 Archive location: build/ios/archive/Runner.xcarchive"
echo ""
echo "📤 Next steps:"
echo "   1. Open Xcode"
echo "   2. Window → Organizer"
echo "   3. Select the archive"
echo "   4. Click 'Distribute App'"
echo "   5. Choose 'TestFlight & App Store'"
```

Make it executable:

```bash
chmod +x scripts/build_ios_testflight.sh
```

#### 6.2 Android Release Build Script

Create `scripts/build_android_release.sh`:

```bash
#!/bin/bash

set -e

echo "🚀 Building Android app for release..."
echo ""

# Check if env.json exists
if [ ! -f "env.json" ]; then
    echo "❌ Error: env.json not found!"
    exit 1
fi

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean
flutter pub get
echo ""

# Build Android App Bundle
echo "📦 Building Android App Bundle (.aab)..."
flutter build appbundle --dart-define-from-file=env.json --release

echo ""
echo "✅ Build complete!"
echo "📍 App Bundle: build/app/outputs/bundle/release/app-release.aab"
```

Make it executable:

```bash
chmod +x scripts/build_android_release.sh
```

---

## Usage Instructions

### For Local Development

#### Option 1: VS Code (Easiest)

1. Press `F5`
2. Select "Development" configuration
3. App runs with environment variables automatically loaded

#### Option 2: Command Line

```bash
flutter run --dart-define-from-file=env.json
```

#### Option 3: Xcode

```bash
# 1. Generate environment config
cd ios && SRCROOT="$(pwd)" bash Scripts/generate_dart_defines.sh && cd ..

# 2. Open Xcode
open ios/Runner.xcworkspace

# 3. Press ⌘R to run
```

---

### For TestFlight Builds

#### Automated (Recommended)

```bash
./scripts/build_ios_testflight.sh
```

Then upload via Xcode Organizer.

#### Manual

```bash
# 1. Generate environment config
cd ios && SRCROOT="$(pwd)" bash Scripts/generate_dart_defines.sh && cd ..

# 2. Build
flutter build ipa --release

# 3. Upload via Xcode Organizer
open ios/Runner.xcworkspace
# Product → Archive → Window → Organizer → Distribute
```

---

### For Play Store Builds

```bash
./scripts/build_android_release.sh
```

Then upload the `.aab` file to Play Console.

---

## Troubleshooting

### Problem: White screen in Xcode

**Solution:**

```bash
cd ios && SRCROOT="$(pwd)" bash Scripts/generate_dart_defines.sh && cd ..
```

Then clean build in Xcode (`⌘⇧K`).

### Problem: White screen on TestFlight

**Solution:** Rebuild using the script:

```bash
./scripts/build_ios_testflight.sh
```

### Problem: Changes to env.json not reflected

**Solution:** Regenerate the config:

```bash
cd ios && SRCROOT="$(pwd)" bash Scripts/generate_dart_defines.sh && cd ..
```

### Problem: Script permission denied

**Solution:**

```bash
chmod +x ios/Scripts/generate_dart_defines.sh
chmod +x scripts/build_ios_testflight.sh
chmod +x scripts/build_android_release.sh
```

---

## What This Fixes

✅ **Before:**
- ❌ Xcode run → White screen crash
- ❌ TestFlight build → White screen crash
- ✅ `flutter run --dart-define-from-file=env.json` → Works

✅ **After:**
- ✅ Xcode run → Works (with generated config)
- ✅ TestFlight build → Works (with generated config)
- ✅ `flutter run` from VS Code → Works (toolArgs in launch.json)
- ✅ Command line → Works (--dart-define-from-file)

---

## Security Notes

### ✅ Safe to Commit
- `env.example.json` (template)
- `ios/Scripts/generate_dart_defines.sh` (generator)
- `.vscode/launch.json` (references env.json, not secrets)
- `ios/Flutter/Debug.xcconfig` & `Release.xcconfig` (includes, not secrets)
- Build scripts

### ❌ NEVER Commit
- `env.json` (your actual credentials)
- `ios/Flutter/DartDefines.xcconfig` (generated with secrets)

### Verification

```bash
# Should be in .gitignore:
grep -E "env.json|DartDefines.xcconfig" .gitignore
```

---

## File Structure Summary

```
your-app/
├── env.json                         # ← Your credentials (git-ignored)
├── env.example.json                 # ← Template
├── .gitignore                       # ← Excludes env.json, DartDefines.xcconfig
├── .vscode/
│   └── launch.json                  # ← VS Code auto-loads env.json
├── ios/
│   ├── Scripts/
│   │   └── generate_dart_defines.sh # ← Generator script
│   └── Flutter/
│       ├── Debug.xcconfig           # ← Includes DartDefines.xcconfig
│       ├── Release.xcconfig         # ← Includes DartDefines.xcconfig
│       └── DartDefines.xcconfig     # ← Generated (git-ignored)
└── scripts/
    ├── build_ios_testflight.sh      # ← iOS builder
    └── build_android_release.sh     # ← Android builder
```

---

## Customization for Your App

If your app uses different environment variable names, update:

1. **`env.json`** - Add your variable names
2. **`ios/Scripts/generate_dart_defines.sh`** - Update extraction and encoding:
   ```bash
   YOUR_VAR=$(grep -o '"YOUR_VAR"[[:space:]]*:[[:space:]]*"[^"]*"' "$ENV_FILE" | sed 's/.*"\([^"]*\)".*/\1/')
   YOUR_VAR_B64=$(echo -n "YOUR_VAR=$YOUR_VAR" | base64)
   # Add to DART_DEFINES: ...,${YOUR_VAR_B64}
   ```
3. **`main.dart`** - Load your variables:
   ```dart
   const yourVar = String.fromEnvironment('YOUR_VAR');
   ```

---

## Quick Checklist

- [ ] Created `env.json` with credentials
- [ ] Created `env.example.json` template
- [ ] Updated `.gitignore`
- [ ] Created `ios/Scripts/generate_dart_defines.sh`
- [ ] Made script executable (`chmod +x`)
- [ ] Updated `ios/Flutter/Debug.xcconfig`
- [ ] Updated `ios/Flutter/Release.xcconfig`
- [ ] Created `.vscode/launch.json`
- [ ] Updated `main.dart` to use `String.fromEnvironment()`
- [ ] Created build scripts (optional)
- [ ] Generated config: `cd ios && SRCROOT="$(pwd)" bash Scripts/generate_dart_defines.sh && cd ..`
- [ ] Tested Xcode run
- [ ] Tested TestFlight build

---

**That's it!** Your app will now work in Xcode, TestFlight, and command line. 🎉

**Last Updated:** 2026-06-13
**Tested On:** Bottles Up User App (Flutter 3.24.0, Xcode 15.4)
