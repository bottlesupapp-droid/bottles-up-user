# TestFlight Deployment Guide

Complete guide for deploying Bottles Up User app to TestFlight with environment variables.

## ⚠️ Critical: Environment Variables Required

The app requires these environment variables to run:
- `SUPABASE_URL` - Your Supabase project URL
- `SUPABASE_ANON_KEY` - Your Supabase anonymous key
- `STRIPE_PUBLISHABLE_KEY` - Your Stripe publishable key

**These MUST be included in the build** or the app will crash with a white screen.

---

## Quick Start

### 1. Verify env.json Exists

```bash
cat env.json
```

Should show:
```json
{
  "SUPABASE_URL": "https://hwmynlghrmtoufyrcihp.supabase.co",
  "SUPABASE_ANON_KEY": "eyJ...",
  "STRIPE_PUBLISHABLE_KEY": "pk_live_..."
}
```

### 2. Build for TestFlight

```bash
./scripts/build_ios_testflight.sh
```

This script:
- ✅ Loads credentials from `env.json`
- ✅ Builds iOS archive with all environment variables
- ✅ Creates `.ipa` file ready for upload

### 3. Upload to TestFlight

1. Open Xcode
2. Go to **Window → Organizer**
3. Select the newly created archive
4. Click **Distribute App**
5. Choose **TestFlight & App Store**
6. Follow the wizard to upload

---

## Manual Build (Alternative)

If you prefer manual control:

```bash
flutter build ipa \
  --dart-define=SUPABASE_URL=https://hwmynlghrmtoufyrcihp.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key-here \
  --dart-define=STRIPE_PUBLISHABLE_KEY=pk_live_your-key-here \
  --release
```

Or use the shorthand:

```bash
flutter build ipa --dart-define-from-file=env.json --release
```

---

## Local Device Testing

### Option 1: VS Code (Easiest)

1. Open the project in VS Code
2. Press `F5` or click Run
3. Select "bottles_up_user (Development)"
4. The app runs with env.json automatically loaded

### Option 2: Command Line

```bash
flutter run --dart-define-from-file=env.json
```

### Option 3: Xcode

When running from Xcode, add custom arguments:

1. Open `ios/Runner.xcworkspace` in Xcode
2. Go to **Product → Scheme → Edit Scheme**
3. Select **Run** → **Arguments**
4. Add to "Arguments Passed On Launch":
   ```
   --dart-define-from-file=env.json
   ```

---

## Troubleshooting

### Problem: White Screen on TestFlight

**Cause:** Environment variables not included in the build.

**Solution:** Always use the build script or `--dart-define-from-file=env.json` flag.

**Verify the build:**
```bash
# Check if build was created with env vars
unzip -p build/ios/ipa/*.ipa "Payload/Runner.app/Info.plist" | grep -A 2 "DartDefines"
```

### Problem: App Works Locally But Not on TestFlight

**Cause:** Local runs use VS Code `launch.json`, but TestFlight uses the built archive.

**Solution:** Always build TestFlight releases with the script:
```bash
./scripts/build_ios_testflight.sh
```

### Problem: "Supabase credentials not configured" Error

**Cause:** The build didn't include environment variables.

**Fix:** Rebuild using the script or manual command with `--dart-define-from-file=env.json`.

---

## Build Scripts

### iOS TestFlight

```bash
./scripts/build_ios_testflight.sh
```

Automatically:
- Reads `env.json`
- Cleans previous builds
- Builds iOS archive with all credentials
- Shows upload instructions

### Android Release

```bash
./scripts/build_android_release.sh
```

Automatically:
- Reads `env.json`
- Cleans previous builds
- Builds App Bundle (.aab) with all credentials
- Ready for Play Store upload

---

## CI/CD Integration

### GitHub Actions Example

```yaml
name: Deploy to TestFlight

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'

      - name: Create env.json
        run: |
          cat > env.json << EOF
          {
            "SUPABASE_URL": "${{ secrets.SUPABASE_URL }}",
            "SUPABASE_ANON_KEY": "${{ secrets.SUPABASE_ANON_KEY }}",
            "STRIPE_PUBLISHABLE_KEY": "${{ secrets.STRIPE_PUBLISHABLE_KEY }}"
          }
          EOF

      - name: Build iOS
        run: |
          flutter build ipa --dart-define-from-file=env.json --release

      - name: Upload to TestFlight
        uses: apple-actions/upload-testflight-build@v1
        with:
          app-path: build/ios/ipa/*.ipa
          issuer-id: ${{ secrets.APPSTORE_ISSUER_ID }}
          api-key-id: ${{ secrets.APPSTORE_API_KEY_ID }}
          api-private-key: ${{ secrets.APPSTORE_API_PRIVATE_KEY }}
```

### Codemagic Example

In `codemagic.yaml`:

```yaml
workflows:
  ios-testflight:
    name: iOS TestFlight
    environment:
      vars:
        SUPABASE_URL: $SUPABASE_URL
        SUPABASE_ANON_KEY: $SUPABASE_ANON_KEY
        STRIPE_PUBLISHABLE_KEY: $STRIPE_PUBLISHABLE_KEY

    scripts:
      - name: Build iOS
        script: |
          cat > env.json << EOF
          {
            "SUPABASE_URL": "$SUPABASE_URL",
            "SUPABASE_ANON_KEY": "$SUPABASE_ANON_KEY",
            "STRIPE_PUBLISHABLE_KEY": "$STRIPE_PUBLISHABLE_KEY"
          }
          EOF
          flutter build ipa --dart-define-from-file=env.json --release

    publishing:
      app_store_connect:
        api_key: $APP_STORE_CONNECT_KEY
        submit_to_testflight: true
```

---

## Security Notes

### ✅ Safe (Public)
- Supabase URL
- Supabase anon key (has RLS protection)
- Stripe publishable key (public by design)

### ❌ Never Include
- Stripe secret key (server-side only)
- Supabase service role key (server-side only)
- Database passwords
- API secret keys

### Best Practices
1. ✅ Use `env.json` locally (git-ignored)
2. ✅ Use CI/CD secrets for production
3. ✅ Never commit `env.json` to git
4. ✅ Always verify environment variables in build logs
5. ✅ Test TestFlight builds before public release

---

## File Structure

```
bottles-up-user/
├── env.json                      # ← Your credentials (git-ignored)
├── env.example.json              # ← Template for others
├── .vscode/
│   └── launch.json              # ← VS Code auto-loads env.json
├── scripts/
│   ├── build_ios_testflight.sh  # ← iOS TestFlight builder
│   └── build_android_release.sh # ← Android release builder
└── TESTFLIGHT_DEPLOYMENT.md     # ← This guide
```

---

## Quick Reference

| Command | Purpose |
|---------|---------|
| `./scripts/build_ios_testflight.sh` | Build for TestFlight |
| `./scripts/build_android_release.sh` | Build for Play Store |
| `flutter run --dart-define-from-file=env.json` | Run on device |
| `flutter build ipa --dart-define-from-file=env.json` | Manual iOS build |
| `flutter build appbundle --dart-define-from-file=env.json` | Manual Android build |

---

**Last Updated:** 2026-06-13
**Tested With:** Flutter 3.24.0, Xcode 15.4
