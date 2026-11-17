#!/bin/bash
set -e

ENV_FILE="${SRCROOT}/../env.json"
OUTPUT_FILE="${SRCROOT}/Flutter/DartDefines.xcconfig"

if [ ! -f "$ENV_FILE" ]; then
    # A build made without its settings opens to a white screen, so this stops the build instead of carrying on.
    echo "error: env.json not found next to pubspec.yaml. Copy env.example.json to env.json and fill in SUPABASE_URL and SUPABASE_ANON_KEY."
    rm -f "$OUTPUT_FILE"
    exit 1
fi

SUPABASE_URL=$(grep -o '"SUPABASE_URL"[[:space:]]*:[[:space:]]*"[^"]*"' "$ENV_FILE" | sed 's/.*"\([^"]*\)".*/\1/')
SUPABASE_ANON_KEY=$(grep -o '"SUPABASE_ANON_KEY"[[:space:]]*:[[:space:]]*"[^"]*"' "$ENV_FILE" | sed 's/.*"\([^"]*\)".*/\1/')
STRIPE_KEY=$(grep -o '"STRIPE_PUBLISHABLE_KEY"[[:space:]]*:[[:space:]]*"[^"]*"' "$ENV_FILE" | sed 's/.*"\([^"]*\)".*/\1/')

if [ -z "$SUPABASE_URL" ] || [ -z "$SUPABASE_ANON_KEY" ]; then
    echo "error: env.json must have SUPABASE_URL and SUPABASE_ANON_KEY."
    rm -f "$OUTPUT_FILE"
    exit 1
fi

SUPABASE_URL_B64=$(echo -n "SUPABASE_URL=$SUPABASE_URL" | base64)
SUPABASE_ANON_KEY_B64=$(echo -n "SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY" | base64)
STRIPE_KEY_B64=$(echo -n "STRIPE_PUBLISHABLE_KEY=$STRIPE_KEY" | base64)

cat > "$OUTPUT_FILE" << EOF
// Auto-generated from env.json
// Generated on $(date)
DART_DEFINES=$SUPABASE_URL_B64,$SUPABASE_ANON_KEY_B64,$STRIPE_KEY_B64
EOF

echo "Generated DartDefines.xcconfig"
