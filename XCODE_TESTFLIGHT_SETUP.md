# Xcode & TestFlight Environment Setup

Complete guide for running the app from Xcode and deploying to TestFlight with environment variables.

## Problem Solved

The app requires environment variables (`SUPABASE_URL`, `SUPABASE_ANON_KEY`, `STRIPE_PUBLISHABLE_KEY`) to function. Without these, the app crashes with a white screen.

This guide ensures the variables are included in:
- ✅ Xcode runs (local device testing)
- ✅ TestFlight builds
- ✅ App Store releases

---

## Quick Setup

### 1. Generate Environment Config

Run this once, and whenever env.json changes:

```bash
cd ios && SRCROOT="$(pwd)" bash Scripts/generate_dart_defines.sh && cd ..
```

This creates `ios/Flutter/DartDefines.xcconfig` with your environment variables.

### 2. Open in Xcode

```bash
open ios/Runner.xcworkspace
```

### 3. Run on Device

Press `⌘R` in Xcode - the app will now include all environment variables!

---

## How It Works

### Architecture

```
env.json  (your credentials)
    ↓
Scripts/generate_dart_defines.sh  (reads and base64-encodes)
    ↓
Flutter/DartDefines.xcconfig  (Xcode config file)
    ↓
Flutter/Debug.xcconfig & Release.xcconfig  (includes DartDefines.xcconfig)
    ↓
Xcode Build  (environment variables injected into app)
```

### Files Explained

1. **`env.json`** - Your actual credentials (git-ignored)
   ```json
   {
     "SUPABASE_URL": "https://...",
     "SUPABASE_ANON_KEY": "eyJ...",
     "STRIPE_PUBLISHABLE_KEY": "pk_live_..."
   }
   ```

2. **`ios/Scripts/generate_dart_defines.sh`** - Reads env.json and generates xcconfig
   - Extracts values using grep/sed
   - Base64-encodes for Flutter's DART_DEFINES format
   - Writes to `DartDefines.xcconfig`

3. **`ios/Flutter/DartDefines.xcconfig`** - Generated Xcode config (git-ignored)
   ```
   DART_DEFINES=base64encoded,base64encoded,base64encoded
   ```

4. **`ios/Flutter/Debug.xcconfig` & `Release.xcconfig`** - Includes DartDefines
   ```
   #include "Generated.xcconfig"
   #include? "DartDefines.xcconfig"
   ```

---

## Usage Scenarios

### Local Development in Xcode

```bash
# Generate environment config
cd ios && SRCROOT="$(pwd)" bash Scripts/generate_dart_defines.sh && cd ..

# Open Xcode
open ios/Runner.xcworkspace

# Press ⌘R to run
```

The app runs with all environment variables loaded!

### TestFlight Build

#### Option 1: Automated Script (Recommended)

```bash
./scripts/build_ios_testflight.sh
```

This script:
1. Generates `DartDefines.xcconfig` from `env.json`
2. Cleans and builds iOS archive
3. Creates `.ipa` ready for upload

#### Option 2: Manual Xcode

```bash
# 1. Generate environment config
cd ios && SRCROOT="$(pwd)" bash Scripts/generate_dart_defines.sh && cd ..

# 2. Open Xcode
open ios/Runner.xcworkspace

# 3. Select "Any iOS Device" as target
# 4. Product → Archive
# 5. Window → Organizer → Distribute App → TestFlight
```

### App Store Release

Same as TestFlight - the environment variables are automatically included!

---

## Troubleshooting

### Problem: White Screen in Xcode

**Cause:** `DartDefines.xcconfig` not generated.

**Solution:**
```bash
cd ios && SRCROOT="$(pwd)" bash Scripts/generate_dart_defines.sh && cd ..
```

Then clean and rebuild in Xcode (`⌘⇧K` then `⌘B`).

### Problem: White Screen on TestFlight

**Cause:** Archive was built without environment variables.

**Solution:**
```bash
# Regenerate and rebuild
cd ios && SRCROOT="$(pwd)" bash Scripts/generate_dart_defines.sh && cd ..
./scripts/build_ios_testflight.sh
```

### Problem: "DartDefines.xcconfig not found"

**Cause:** File hasn't been generated yet.

**Solution:**
```bash
cd ios && SRCROOT="$(pwd)" bash Scripts/generate_dart_defines.sh && cd ..
```

### Problem: Changes to env.json Not Reflected

**Cause:** `DartDefines.xcconfig` is cached.

**Solution:** Regenerate after any env.json changes:
```bash
cd ios && SRCROOT="$(pwd)" bash Scripts/generate_dart_defines.sh && cd ..
```

---

## Automated Workflow

### Pre-Build Script (Optional)

You can add the generator script as an Xcode build phase:

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select Runner project → Runner target
3. Build Phases → + → New Run Script Phase
4. Add before "Compile Sources":
   ```bash
   cd "$SRCROOT" && bash Scripts/generate_dart_defines.sh
   ```

This auto-generates `DartDefines.xcconfig` on every Xcode build!

### Git Hooks (Optional)

Auto-regenerate when env.json changes:

```bash
cat > .git/hooks/post-checkout << 'EOF'
#!/bin/bash
if [ -f env.json ]; then
  cd ios && SRCROOT="$(pwd)" bash Scripts/generate_dart_defines.sh && cd ..
fi
EOF
chmod +x .git/hooks/post-checkout
```

---

## Security

### ✅ Safe for Commit
- `env.example.json` (template)
- `Scripts/generate_dart_defines.sh` (generator script)
- `Debug.xcconfig` & `Release.xcconfig` (config includes)

### ❌ NEVER Commit (Git-Ignored)
- `env.json` (your actual credentials)
- `DartDefines.xcconfig` (generated with secrets)

### Verification

```bash
# Check gitignore
grep -E "env.json|DartDefines.xcconfig" .gitignore

# Should show:
# env.json
# ios/Flutter/DartDefines.xcconfig
```

---

## CI/CD Integration

### GitHub Actions

```yaml
- name: Generate iOS environment config
  run: |
    cat > env.json << EOF
    {
      "SUPABASE_URL": "${{ secrets.SUPABASE_URL }}",
      "SUPABASE_ANON_KEY": "${{ secrets.SUPABASE_ANON_KEY }}",
      "STRIPE_PUBLISHABLE_KEY": "${{ secrets.STRIPE_PUBLISHABLE_KEY }}"
    }
    EOF
    cd ios && SRCROOT="$(pwd)" bash Scripts/generate_dart_defines.sh && cd ..

- name: Build iOS
  run: flutter build ipa --release
```

### Codemagic

```yaml
scripts:
  - name: Generate environment config
    script: |
      cat > env.json << EOF
      {
        "SUPABASE_URL": "$SUPABASE_URL",
        "SUPABASE_ANON_KEY": "$SUPABASE_ANON_KEY",
        "STRIPE_PUBLISHABLE_KEY": "$STRIPE_PUBLISHABLE_KEY"
      }
      EOF
      cd ios && SRCROOT="$(pwd)" bash Scripts/generate_dart_defines.sh && cd ..

  - name: Build iOS
    script: flutter build ipa --release
```

---

## Quick Reference

| Task | Command |
|------|---------|
| Generate environment config | `cd ios && SRCROOT="$(pwd)" bash Scripts/generate_dart_defines.sh && cd ..` |
| Open in Xcode | `open ios/Runner.xcworkspace` |
| Build for TestFlight | `./scripts/build_ios_testflight.sh` |
| Verify generated config | `cat ios/Flutter/DartDefines.xcconfig` |
| Check if gitignored | `git status ios/Flutter/DartDefines.xcconfig` |

---

## Comparison with Other Approaches

| Approach | Xcode Support | TestFlight | Pros | Cons |
|----------|---------------|------------|------|------|
| `--dart-define-from-file` | ❌ No | ❌ No | Simple | Only works with `flutter run` |
| `.xcconfig` hardcoded | ✅ Yes | ✅ Yes | Works everywhere | **INSECURE** (secrets in git) |
| **Generated `.xcconfig`** | ✅ Yes | ✅ Yes | Secure + Works everywhere | Requires generation step |

Our approach (generated `.xcconfig`) is the **only secure way** to support both Xcode and TestFlight.

---

**Last Updated:** 2026-06-13
**Tested With:** Xcode 15.4, Flutter 3.24.0
