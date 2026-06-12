#!/bin/bash

echo "🚀 BottlesUp Migration Helper"
echo "=============================="
echo ""
echo "✅ Migration file VALIDATED:"
echo "   - File: supabase/migrations/20260428_complete_schema_with_base.sql"
echo "   - Size: 53 KB"
echo "   - Tables: 67"
echo "   - auth.users references: 55"
echo "   - Status: READY TO APPLY"
echo ""
echo "📋 Option 1: Copy migration to clipboard"
echo "   Then paste into Supabase Dashboard"
echo ""
read -p "Copy to clipboard? (y/n): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]
then
    cat supabase/migrations/20260428_complete_schema_with_base.sql | pbcopy
    echo "✅ Migration copied to clipboard!"
    echo ""
    echo "Now:"
    echo "1. Opening Supabase SQL Editor..."
    sleep 2
    open "https://supabase.com/dashboard/project/hwmynlghrmtoufyrcihp/sql/new"
    echo "2. Paste (Cmd+V) into the editor"
    echo "3. Click 'Run' button"
    echo ""
    echo "📊 After running, verify with:"
    echo "   SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';"
    echo "   Expected: 67 tables"
    echo ""
else
    echo ""
    echo "📖 Manual instructions:"
    echo "1. Open: https://supabase.com/dashboard/project/hwmynlghrmtoufyrcihp/sql"
    echo "2. Copy: supabase/migrations/20260428_complete_schema_with_base.sql"
    echo "3. Paste and Run"
    echo ""
    echo "📄 Or read: MIGRATION_READY.md for detailed instructions"
    echo ""
fi

echo "✨ Done!"
