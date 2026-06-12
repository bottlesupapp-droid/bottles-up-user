#!/bin/bash

echo "🚀 BottlesUp Migration Helper"
echo "=============================="
echo ""
echo "This will apply database migrations in 2 steps:"
echo ""
echo "STEP 1: Base tables (venues, events, user_profiles, venue_ratings)"
echo "STEP 2: All 110 features (67 total tables)"
echo ""
read -p "Ready to start? (y/n): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Cancelled."
    exit 1
fi

echo ""
echo "📋 STEP 1: Copying base migration to clipboard..."
cat supabase/migrations/20260428_safe_incremental.sql | pbcopy
echo "✅ Base migration copied!"
echo ""
echo "Now:"
echo "1. Opening Supabase SQL Editor..."
sleep 2
open "https://supabase.com/dashboard/project/hwmynlghrmtoufyrcihp/sql/new"
echo "2. Paste (Cmd+V) and click Run"
echo "3. Verify you see: user_profiles_exists: 1, venues_exists: 1"
echo ""
read -p "Base migration complete? Press Enter when done..." 

echo ""
echo "📦 STEP 2: Copying full migration to clipboard..."
cat supabase/migrations/20260428_complete_schema_with_base.sql | pbcopy
echo "✅ Full migration copied!"
echo ""
echo "Now:"
echo "1. In the same SQL Editor"
echo "2. Paste (Cmd+V) and click Run"
echo "3. This will create 67 total tables"
echo ""
read -p "Full migration complete? Press Enter when done..." 

echo ""
echo "✅ VERIFICATION"
echo "==============="
echo ""
echo "Run this query to verify:"
echo ""
echo "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';"
echo ""
echo "Expected result: 67"
echo ""
echo "Copy verification query to clipboard?"
read -p "(y/n): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';" | pbcopy
    echo "✅ Verification query copied! Paste and run it."
fi

echo ""
echo "🎉 Migration process complete!"
echo ""
echo "Next steps:"
echo "  1. flutter pub get"
echo "  2. dart run build_runner build --delete-conflicting-outputs"
echo "  3. flutter run"
echo ""

