# IMMEDIATE FIX for Vendor App White Screen

Your vendor app is still showing white screen because the environment config hasn't been generated. Follow these **exact steps** in order:

---

## STOP - Read This First

If you followed the previous instructions but still have white screen:
- The problem is **DartDefines.xcconfig doesn't exist yet**
- You need to **generate it manually first**

---

## Step 1: Verify Your Setup

Check if these files exist in your vendor app:

```bash
# In your vendor app directory
ls -la env.json
ls -la ios/Scripts/generate_dart_defines.sh
```

If either is missing, follow the setup in FIX_INSTRUCTIONS_FOR_OTHER_APPS.md first.

---

## Step 2: Generate the Config File (CRITICAL)

**Run this command in your vendor app root directory:**

```bash
cd ios && SRCROOT="$(pwd)" bash Scripts/generate_dart_defines.sh && cd ..
```

**Expected output:**
```
Generated DartDefines.xcconfig with environment variables
```

**Verify it was created:**
```bash
cat ios/Flutter/DartDefines.xcconfig
```

You should see something like:
```
// Auto-generated from env.json - DO NOT EDIT MANUALLY
// Generated on ...

DART_DEFINES=U1VQQUJBU0VfVVJMPWh0dHBzOi8v...
```

---

## Step 3: Test from Xcode

```bash
# Open in Xcode
open ios/Runner.xcworkspace

# Clean build
# In Xcode: Product → Clean Build Folder (⌘⇧K)

# Run
# In Xcode: Product → Run (⌘R)
```

**The app should now launch without white screen!**

---

## Step 4: Test TestFlight Build

```bash
./scripts/build_ios_testflight.sh
```

This will:
1. Regenerate DartDefines.xcconfig
2. Build iOS archive
3. Ready for TestFlight upload

---

## If Still White Screen After Step 2

### Debug Check 1: Verify env.json exists

```bash
cat env.json
```

Should show your Supabase credentials. If missing:

```json
{
  "SUPABASE_URL": "https://your-project.supabase.co",
  "SUPABASE_ANON_KEY": "eyJhbGciOi...",
  "STRIPE_PUBLISHABLE_KEY": "pk_live_..."
}
```

### Debug Check 2: Verify xcconfig includes

```bash
cat ios/Flutter/Debug.xcconfig
cat ios/Flutter/Release.xcconfig
```

**Both must have this line at the end:**
```
#include? "DartDefines.xcconfig"
```

If missing, add it manually.

### Debug Check 3: Check main.dart

Your `main.dart` should have:

```dart
const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
  throw StateError(
    'Supabase credentials not configured.\n'
    'Pass --dart-define=SUPABASE_URL=... and --dart-define=SUPABASE_ANON_KEY=...',
  );
}
```

### Debug Check 4: View Xcode logs

When the app crashes, check Xcode console for the exact error:
- If you see "Supabase credentials not configured" → DartDefines.xcconfig not loaded
- If you see "Bad state" → Environment variables are empty

---

## Common Mistakes

### ❌ Mistake 1: Forgot to generate DartDefines.xcconfig

**Fix:**
```bash
cd ios && SRCROOT="$(pwd)" bash Scripts/generate_dart_defines.sh && cd ..
```

### ❌ Mistake 2: Generated but didn't clean build in Xcode

**Fix:** In Xcode: `⌘⇧K` (Clean Build Folder), then `⌘R` (Run)

### ❌ Mistake 3: xcconfig doesn't include DartDefines

**Fix:** Add to both Debug.xcconfig and Release.xcconfig:
```
#include? "DartDefines.xcconfig"
```

### ❌ Mistake 4: Script path is wrong

**Fix:** Make sure you're in the **vendor app root directory** when running:
```bash
pwd  # Should show: /path/to/vendor-app
cd ios && SRCROOT="$(pwd)" bash Scripts/generate_dart_defines.sh && cd ..
```

---

## Complete Workflow (Fresh Start)

If nothing works, start completely fresh:

### 1. Clean Everything

```bash
# In vendor app root
flutter clean
rm -f ios/Flutter/DartDefines.xcconfig
rm -rf ios/Pods
rm -f ios/Podfile.lock
```

### 2. Verify env.json

```bash
cat env.json
# Must show your credentials, not template values
```

### 3. Generate Config

```bash
cd ios && SRCROOT="$(pwd)" bash Scripts/generate_dart_defines.sh && cd ..
```

### 4. Install Dependencies

```bash
flutter pub get
cd ios && pod install && cd ..
```

### 5. Open and Run

```bash
open ios/Runner.xcworkspace
```

In Xcode:
- Clean Build Folder: `⌘⇧K`
- Run: `⌘R`

---

## For TestFlight

After the app works in Xcode:

```bash
./scripts/build_ios_testflight.sh
```

Then:
1. Open Xcode
2. Window → Organizer
3. Select archive
4. Distribute App → TestFlight

---

## Quick Commands Reference

```bash
# Generate environment config (DO THIS FIRST!)
cd ios && SRCROOT="$(pwd)" bash Scripts/generate_dart_defines.sh && cd ..

# Verify it was created
cat ios/Flutter/DartDefines.xcconfig

# Open in Xcode
open ios/Runner.xcworkspace

# Build for TestFlight
./scripts/build_ios_testflight.sh

# Check if env.json exists
cat env.json

# Check if includes are correct
grep "DartDefines.xcconfig" ios/Flutter/*.xcconfig
```

---

## Still Not Working?

Share these outputs:

```bash
# 1. Check env.json exists
ls -la env.json

# 2. Check script exists
ls -la ios/Scripts/generate_dart_defines.sh

# 3. Check xcconfig files
cat ios/Flutter/Debug.xcconfig
cat ios/Flutter/Release.xcconfig

# 4. Try to generate (copy the output)
cd ios && SRCROOT="$(pwd)" bash Scripts/generate_dart_defines.sh && cd ..

# 5. Check if it was created
ls -la ios/Flutter/DartDefines.xcconfig
cat ios/Flutter/DartDefines.xcconfig
```

Send me all these outputs and I'll diagnose the exact issue.

---

## The Root Cause

The white screen happens because:

1. ✅ VS Code works → Uses `toolArgs` in launch.json
2. ✅ `flutter run --dart-define-from-file=env.json` works → Passes env directly
3. ❌ Xcode fails → Needs DartDefines.xcconfig (must be generated manually)
4. ❌ TestFlight fails → Uses Xcode build (same issue)

**The solution:** Generate DartDefines.xcconfig **once** before running from Xcode or building for TestFlight.

---

**Last Updated:** 2026-06-13
**Critical Step:** Always run the generate script before Xcode/TestFlight builds!
