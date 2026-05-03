# 🔧 Migration Instructions - Step by Step

## Current Situation

You're getting error: **"venue_id" does not exist**

This means the `venues` table doesn't exist yet in your Supabase database.

---

## Solution: 2-Step Migration Process

I've created a **safe, incremental approach** that won't fail:

### Step 1: Create Base Tables First
### Step 2: Apply Full Feature Migration

---

## 📋 STEP 1: Inspect Current Database

First, let's see what you already have:

**Copy this SQL and run in Supabase Dashboard:**

```sql
-- Check existing tables
SELECT tablename
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY tablename;

-- Check if base tables exist
SELECT
    CASE WHEN EXISTS (SELECT 1 FROM pg_tables WHERE tablename = 'venues')
        THEN 'EXISTS' ELSE 'MISSING' END as venues,
    CASE WHEN EXISTS (SELECT 1 FROM pg_tables WHERE tablename = 'events')
        THEN 'EXISTS' ELSE 'MISSING' END as events,
    CASE WHEN EXISTS (SELECT 1 FROM pg_tables WHERE tablename = 'user_profiles')
        THEN 'EXISTS' ELSE 'MISSING' END as user_profiles;
```

**Where to run:**
https://supabase.com/dashboard/project/hwmynlghrmtoufyrcihp/sql

---

## 🚀 STEP 2: Apply Safe Base Migration

This creates ONLY the 4 base tables needed for everything else.

### Option A: Quick Script

```bash
cd /Users/abdulrazak/Downloads/bottles-up-user-main

# Copy base migration to clipboard
cat supabase/migrations/20260428_safe_incremental.sql | pbcopy

# Open Supabase Dashboard
open "https://supabase.com/dashboard/project/hwmynlghrmtoufyrcihp/sql/new"

# Then paste (Cmd+V) and click Run
```

### Option B: Manual

1. Open file: `supabase/migrations/20260428_safe_incremental.sql`
2. Copy all contents
3. Go to: https://supabase.com/dashboard/project/hwmynlghrmtoufyrcihp/sql
4. Click "New query"
5. Paste and click "Run"

### What This Creates:

✅ **4 Base Tables:**
- `user_profiles` - Extended user data (references auth.users)
- `venues` - Clubs, bars, restaurants
- `events` - Concerts, parties, events
- `venue_ratings` - User reviews

**This migration uses `IF NOT EXISTS`** - it won't fail if some tables already exist!

### Verify Success:

After running, you should see output like:
```
user_profiles_exists: 1
venues_exists: 1
events_exists: 1
venue_ratings_exists: 1
```

---

## 📦 STEP 3: Apply Full Feature Migration

Once base tables exist, apply the complete migration:

### File: `supabase/migrations/20260428_complete_schema_with_base.sql`

**This adds all 110 features:**
- Batch 8: Bookings (9 tables)
- Batch 9: Events (5 tables)
- Batch 10: Payments (7 tables)
- Batch 11: Loyalty (8 tables)
- Batch 12: Profile (5 tables)
- Batch 13: Real-time (7 tables)
- Batch 14: Social (14 tables)
- Batch 15: Advanced (8 tables)

**To apply:**

```bash
# Copy to clipboard
cat supabase/migrations/20260428_complete_schema_with_base.sql | pbcopy

# Open dashboard (same window)
# Just paste and run in the SQL editor
```

### Verify Success:

```sql
-- Should return 67
SELECT COUNT(*)
FROM information_schema.tables
WHERE table_schema = 'public';
```

---

## 🔍 Alternative: Share Your Current Schema

If migrations still fail, run the inspection queries and share the results:

**File created:** `inspect_database.sql`

```bash
cat inspect_database.sql | pbcopy
# Then paste and run in Supabase Dashboard
# Share the output with me
```

I can then create a **custom migration** that works with your exact database state.

---

## 📁 Files Created

| File | Purpose | Size |
|------|---------|------|
| `20260428_safe_incremental.sql` | Base tables only (safe) | 4 KB |
| `20260428_complete_schema_with_base.sql` | Full migration (67 tables) | 53 KB |
| `inspect_database.sql` | Database inspection queries | 2 KB |

---

## ⚠️ Troubleshooting

### Error: "relation venues does not exist"
**Solution:** Run STEP 2 first (safe incremental migration)

### Error: "relation auth.users does not exist"
**Solution:** Make sure you're using a Supabase project (not raw PostgreSQL)

### Error: "already exists"
**Solution:** That's OK! The migration uses `IF NOT EXISTS`, it will skip existing tables

### Want to start completely fresh?
```sql
-- ⚠️ WARNING: Deletes ALL data!
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO public;

-- Then run migrations from scratch
```

---

## 🎯 Recommended Approach

**For safest results:**

1. ✅ Run `inspect_database.sql` (see what exists)
2. ✅ Run `20260428_safe_incremental.sql` (create base tables)
3. ✅ Verify base tables created
4. ✅ Run `20260428_complete_schema_with_base.sql` (add all features)
5. ✅ Verify final table count (should be 67)

---

## 📊 Expected Results

After all migrations:

```
Base Tables: 4
  ✅ user_profiles
  ✅ venues
  ✅ events
  ✅ venue_ratings

Feature Tables: 63
  ✅ Bookings: 9 tables
  ✅ Events: 5 tables
  ✅ Payments: 7 tables
  ✅ Loyalty: 8 tables
  ✅ Profile: 5 tables
  ✅ Real-time: 7 tables
  ✅ Social: 14 tables
  ✅ Advanced: 8 tables

Database Objects:
  ✅ 30+ indexes
  ✅ 10+ triggers
  ✅ 5+ functions
  ✅ Complete RLS policies
  ✅ Seed data

Total Tables: 67
```

---

## 🚀 Quick Start Commands

```bash
# 1. Apply safe base migration
cat supabase/migrations/20260428_safe_incremental.sql | pbcopy
open "https://supabase.com/dashboard/project/hwmynlghrmtoufyrcihp/sql/new"
# Paste and run

# 2. After base tables exist, apply full migration
cat supabase/migrations/20260428_complete_schema_with_base.sql | pbcopy
# Paste and run in same dashboard

# 3. Verify
# Run: SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';
# Expected: 67 tables
```

---

*Last updated: 2026-04-28*
*Status: Ready to apply*
