#!/bin/bash
# Run this on a build BEFORE uploading it to TestFlight. A build made without its Supabase settings opens to a blank white screen; this finds that out in a second.
#
#   ./scripts/check_build_has_settings.sh                      the newest Xcode archive
#   ./scripts/check_build_has_settings.sh path/to/Runner.xcarchive
#   ./scripts/check_build_has_settings.sh path/to/Runner.ipa
#
# It looks inside the compiled app for the Supabase address and key. It prints only whether they are there, never the key itself.
set -u

target="${1:-}"
if [ -z "$target" ]; then
  target="$(ls -dt "$HOME"/Library/Developer/Xcode/Archives/*/*.xcarchive 2>/dev/null | head -1)"
  if [ -z "$target" ]; then echo "No archive found. Give the path to an .xcarchive or an .ipa."; exit 2; fi
  echo "Checking the newest archive: $target"
fi

tmp=""
cleanup() { [ -n "$tmp" ] && rm -rf "$tmp"; }
trap cleanup EXIT

case "$target" in
  *.ipa)
    tmp="$(mktemp -d)"
    unzip -q "$target" "Payload/*.app/Frameworks/App.framework/App" "Payload/*.app/Info.plist" -d "$tmp" || { echo "Could not open the .ipa."; exit 2; }
    app="$(ls -d "$tmp"/Payload/*.app | head -1)"
    ;;
  *.xcarchive)
    app="$(ls -d "$target"/Products/Applications/*.app | head -1)"
    ;;
  *) echo "Give an .xcarchive or an .ipa."; exit 2 ;;
esac

bin="$app/Frameworks/App.framework/App"
[ -f "$bin" ] || { echo "No compiled Flutter app found inside."; exit 2; }

id="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' "$app/Info.plist" 2>/dev/null)"
ver="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$app/Info.plist" 2>/dev/null) ($(/usr/libexec/PlistBuddy -c 'Print :CFBundleVersion' "$app/Info.plist" 2>/dev/null))"
echo "App: $id, version $ver"

url_count="$(strings -a "$bin" | grep -c '\.supabase\.co')"
key_count="$(strings -a "$bin" | grep -c '^eyJ')"
echo "Supabase address compiled in: $([ "$url_count" -gt 0 ] && echo yes || echo NO)"
echo "Supabase key compiled in:     $([ "$key_count" -gt 0 ] && echo yes || echo NO)"

if [ "$url_count" -eq 0 ] || [ "$key_count" -eq 0 ]; then
  echo ""
  echo "STOP: this build has no settings, so it opens to a white screen (or, with the newest code, to a page saying it could not start)."
  echo "Rebuild with:  flutter build ipa --release --dart-define-from-file=env.json"
  exit 1
fi
echo "OK: the settings are in this build."
