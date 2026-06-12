# 🚀 Apply Migration to Supabase - Step by Step

## Your Supabase Project
- **Project Ref:** `hwmynlghrmtoufyrcihp`
- **Migration File:** `supabase/migrations/20260428_complete_schema_with_base.sql`
- **File Size:** 51 KB (220 SQL statements)

---

## ✅ Method 1: Supabase Dashboard (RECOMMENDED - Easiest!)

This is the **fastest and most reliable** method for large migrations.

### Steps:

1. **Open SQL Editor**
   - Go to: https://supabase.com/dashboard/project/hwmynlghrmtoufyrcihp/sql
   - Or navigate: Dashboard → SQL Editor

2. **Create New Query**
   - Click "+ New query" button

3. **Copy Migration File**
   ```bash
   cat supabase/migrations/20260428_complete_schema_with_base.sql
   ```
   - Or open the file in your code editor
   - Select all (Cmd+A) and copy (Cmd+C)

4. **Paste and Run**
   - Paste the SQL into the editor
   - Click **"Run"** button (or Cmd+Enter)

5. **Wait for Completion**
   - Should take 5-10 seconds
   - You'll see success messages for each statement

6. **Verify Success**
   - Run this query to check table count:
   ```sql
   SELECT COUNT(*) as total_tables
   FROM information_schema.tables
   WHERE table_schema = 'public';
   ```
   - **Expected result:** 65+ tables

---

## Method 2: Using psql Command Line

If you prefer command line, use psql directly.

### Prerequisites:
- PostgreSQL client installed ✅ (detected at `/opt/homebrew/opt/postgresql@15/bin/psql`)
- Your Supabase database password

### Steps:

1. **Get Database Password**
   - Go to: https://supabase.com/dashboard/project/hwmynlghrmtoufyrcihp/settings/database
   - Copy your database password
   - Or reset it if you don't remember

2. **Run Migration**
   ```bash
   cd /Users/abdulrazak/Downloads/bottles-up-user-main

   /opt/homebrew/opt/postgresql@15/bin/psql \
     "postgresql://postgres.hwmynlghrmtoufyrcihp:[YOUR-PASSWORD]@aws-0-ap-southeast-1.pooler.supabase.com:6543/postgres" \
     -f supabase/migrations/20260428_complete_schema_with_base.sql
   ```

   Replace `[YOUR-PASSWORD]` with your actual database password.

3. **Verify Success**
   ```bash
   /opt/homebrew/opt/postgresql@15/bin/psql \
     "postgresql://postgres.hwmynlghrmtoufyrcihp:[YOUR-PASSWORD]@aws-0-ap-southeast-1.pooler.supabase.com:6543/postgres" \
     -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';"
   ```

---

## Method 3: Supabase CLI

If you have the database password, you can use Supabase CLI.

### Steps:

1. **Get Database Password**
   - From: https://supabase.com/dashboard/project/hwmynlghrmtoufyrcihp/settings/database

2. **Link Project**
   ```bash
   cd /Users/abdulrazak/Downloads/bottles-up-user-main
   supabase link --project-ref hwmynlghrmtoufyrcihp
   ```
   - Enter your database password when prompted

3. **Apply Migration**
   ```bash
   supabase db push
   ```

   Or execute directly:
   ```bash
   supabase db execute -f supabase/migrations/20260428_complete_schema_with_base.sql
   ```

---

## Method 4: Quick Copy-Paste Script

For the fastest execution, I've prepared the migration content for you.

### Option A: Open in Browser
Click this link and it will open the SQL editor with your project:
```
https://supabase.com/dashboard/project/hwmynlghrmtoufyrcihp/sql/new
```

### Option B: Use this command to copy to clipboard:
```bash
cat /Users/abdulrazak/Downloads/bottles-up-user-main/supabase/migrations/20260428_complete_schema_with_base.sql | pbcopy
```

Then:
1. Open: https://supabase.com/dashboard/project/hwmynlghrmtoufyrcihp/sql
2. Click "New query"
3. Paste (Cmd+V)
4. Click "Run"

---

## What Gets Created

When you run the migration, you'll get:

### Base Tables (4)
- ✅ `user_profiles` - Extended user profile data
- ✅ `venues` - Clubs, bars, restaurants
- ✅ `events` - Concerts, parties, events
- ✅ `venue_ratings` - User reviews and ratings

### Feature Tables (60+)

**Batch 8: Bookings** (9 tables)
- tables, table_bookings, group_bookings, booking_participants
- bottle_services, booking_bottles, menu_items, booking_preorders
- waitlist_entries

**Batch 9: Events** (5 tables)
- event_categories, event_tickets, event_registrations
- event_check_ins, event_recommendations

**Batch 10: Payments** (7 tables)
- payment_methods, transactions, split_bills
- split_bill_shares, tips, refunds, receipts

**Batch 11: Loyalty** (8 tables)
- loyalty_tiers, user_loyalty, points_transactions
- rewards, reward_redemptions, promotions
- user_promotions, achievements, user_achievements

**Batch 12: Profile** (5 tables)
- user_preferences, user_activities, saved_items
- blocked_users, account_deletion_requests

**Batch 13: Real-time** (7 tables)
- venue_availability, booking_status_updates, queue_entries
- event_updates, user_presence, user_devices

**Batch 14: Social** (14 tables)
- friendships, conversations, messages, posts
- post_likes, comments, comment_likes, post_shares
- parties, party_invitations, photo_albums, photos
- photo_likes, shares

**Batch 15: Advanced** (8 tables)
- feedback, referrals, onboarding_progress, sync_queue
- support_tickets, ticket_messages, app_ratings
- analytics_events

### Additional Features
- ✅ **30+ Indexes** for performance
- ✅ **10+ Triggers** for data consistency
- ✅ **5+ Functions** for complex queries
- ✅ **Complete RLS policies** for security
- ✅ **Seed data** (loyalty tiers, achievements, event categories)

---

## After Migration

### Verify Everything Worked

Run these queries in SQL Editor:

```sql
-- 1. Check total tables (should be 65+)
SELECT COUNT(*) as total_tables
FROM information_schema.tables
WHERE table_schema = 'public';

-- 2. List all tables
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

-- 3. Check RLS is enabled
SELECT
    tablename,
    rowsecurity as rls_enabled
FROM pg_tables
WHERE schemaname = 'public'
AND rowsecurity = true;

-- 4. Check seed data
SELECT * FROM loyalty_tiers;
SELECT * FROM achievements;
SELECT * FROM event_categories;
```

### Expected Results:
- ✅ **65 tables** created
- ✅ **30+ tables** with RLS enabled
- ✅ **4 loyalty tiers** (Bronze, Silver, Gold, Platinum)
- ✅ **5 achievements** seeded
- ✅ **5 event categories** seeded

---

## Troubleshooting

### Error: "relation auth.users does not exist"
**Solution:** Make sure you're running this on a Supabase project (not raw PostgreSQL). Supabase provides `auth.users` automatically.

### Error: "permission denied"
**Solution:** Make sure you're using the service role key or postgres user credentials.

### Error: "syntax error at or near..."
**Solution:** Make sure you copied the ENTIRE file. The migration is 51KB and 220 statements.

### Error: "already exists"
**Solution:** Some tables might already exist. You can either:
1. Drop existing tables first (⚠️ WARNING: This deletes data!)
2. Or modify migration to use `CREATE TABLE IF NOT EXISTS` (already done!)

### Want to Start Fresh?
```sql
-- ⚠️ WARNING: This deletes ALL tables and data!
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO public;

-- Then run the migration again
```

---

## My Recommendation

**Use Method 1 (Supabase Dashboard)** - It's:
- ✅ Fastest (no password needed)
- ✅ Most reliable (built-in editor)
- ✅ Visual feedback (see results immediately)
- ✅ Error handling (clear error messages)

Just:
1. Open: https://supabase.com/dashboard/project/hwmynlghrmtoufyrcihp/sql
2. Copy the file contents
3. Paste and run
4. Done! ✅

---

## Next Steps After Migration

1. ✅ **Verify migration** (run verification queries above)
2. ✅ **Install Flutter dependencies:** `flutter pub get`
3. ✅ **Generate code:** `dart run build_runner build --delete-conflicting-outputs`
4. ✅ **Run the app:** `flutter run`

---

**Migration file ready at:**
```
/Users/abdulrazak/Downloads/bottles-up-user-main/supabase/migrations/20260428_complete_schema_with_base.sql
```

**Dashboard link:**
```
https://supabase.com/dashboard/project/hwmynlghrmtoufyrcihp/sql
```

**Let me know once you've applied the migration and I can help with the next steps!** 🚀
