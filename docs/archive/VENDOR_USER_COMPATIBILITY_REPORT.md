# Vendor-User App Compatibility Report

**Date:** 2026-06-12
**Apps:** BottlesUp Vendor → BottlesUp User (Same Supabase Project)
**Status:** 🔴 **CRITICAL ISSUES FOUND**

---

## Executive Summary

The vendor and user apps share the same Supabase database but have **critical compatibility and security issues**:

1. ❌ **MISSING RLS POLICIES** - Events table has NO Row Level Security (public access)
2. ❌ **Schema mismatch** - 9 fields missing/mismatched between apps
3. ❌ **No status filtering** - User app shows ALL events including drafts
4. ⚠️ **Image storage** - Uses `getPublicUrl()` correctly but bucket names unknown
5. ❌ **Missing empty/error states** - Most event screens lack proper UI states

---

## 1. Schema Comparison: Events Table

### Database Schema (from migrations)
```sql
CREATE TABLE events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    venue_id UUID REFERENCES venues(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    event_date TIMESTAMP WITH TIME ZONE NOT NULL,
    end_date TIMESTAMP WITH TIME ZONE,
    cover_image TEXT,
    images TEXT[] DEFAULT '{}',
    category VARCHAR(100),
    ticket_price DECIMAL(10,2),
    vip_price DECIMAL(10,2),
    early_bird_price DECIMAL(10,2),
    capacity INT,
    tickets_sold INT DEFAULT 0,
    min_age INT DEFAULT 18,
    dress_code VARCHAR(100),
    lineup JSONB DEFAULT '[]',
    is_active BOOLEAN DEFAULT TRUE,
    is_featured BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### Vendor App Writes (event.dart)
```dart
{
  'id': id,
  'name': name,
  'description': description,
  'user_id': userId,                    // ✅ WRITES
  'category_id': categoryId,            // ✅ WRITES
  'club_id': clubId,                    // ✅ WRITES
  'zone_id': zoneId,                    // ✅ WRITES
  'images': images,                     // ✅ WRITES
  'event_date': eventDate,              // ✅ WRITES
  'start_time': startTime,              // ✅ WRITES
  'end_time': endTime,                  // ✅ WRITES
  'ticket_price': ticketPrice,          // ✅ WRITES
  'max_capacity': maxCapacity,          // ✅ WRITES
  'current_bookings': currentBookings,  // ✅ WRITES
  'is_featured': isFeatured,            // ✅ WRITES
  'status': status,                     // ✅ WRITES (values: 'active', 'upcoming', etc.)
  'dress_code': dressCode,              // ✅ WRITES
  'min_age': minAge,                    // ✅ WRITES
  'terms_and_conditions': termsAndConditions,     // ✅ WRITES (extra field)
  'special_instructions': specialInstructions,    // ✅ WRITES (extra field)
  'is_active': isActive,                // ✅ WRITES
  'created_at': createdAt,              // ✅ WRITES
  'updated_at': updatedAt,              // ✅ WRITES
}
```

### User App Reads (event.dart)
```dart
Event.fromSupabase({
  id,                      // ✅ READS
  userId,                  // ✅ READS (user_id)
  categoryId,              // ✅ READS (category_id)
  clubId,                  // ✅ READS (club_id)
  zoneId,                  // ✅ READS (zone_id)
  name,                    // ✅ READS
  description,             // ✅ READS
  eventDate,               // ✅ READS (event_date)
  startTime,               // ✅ READS (start_time)
  endTime,                 // ✅ READS (end_time)
  ticketPrice,             // ✅ READS (ticket_price)
  maxCapacity,             // ✅ READS (max_capacity)
  currentBookings,         // ✅ READS (current_bookings)
  rsvpCount,               // ❌ NOT IN VENDOR (local counter)
  tableBookingCount,       // ❌ NOT IN VENDOR (local counter)
  dressCode,               // ✅ READS (dress_code)
  invitationCode,          // ❌ NOT IN VENDOR (user app specific)
  isPrivate,               // ❌ NOT IN VENDOR (user app specific)
  locationHidden,          // ❌ NOT IN VENDOR (user app specific)
  images,                  // ✅ READS
  tableArrangementImageUrl,// ❌ NOT IN VENDOR (user app specific)
  status,                  // ✅ READS
  isActive,                // ✅ READS (is_active)
  isFeatured,              // ✅ READS (is_featured)
  createdAt,               // ✅ READS (created_at)
  updatedAt,               // ✅ READS (updated_at)
})
```

---

## 2. Field Mismatches

### Fields Vendor WRITES but User DOESN'T READ:
1. **terms_and_conditions** - Vendor writes, user ignores ⚠️
2. **special_instructions** - Vendor writes, user ignores ⚠️

**Impact:** Low - User app just doesn't display these fields

### Fields User READS but Vendor DOESN'T WRITE:
1. **rsvp_count** - User expects, vendor doesn't write ❌
2. **table_booking_count** - User expects, vendor doesn't write ❌
3. **invitation_code** - User expects, vendor doesn't write ⚠️
4. **is_private** - User expects, vendor doesn't write ❌ **CRITICAL**
5. **location_hidden** - User expects, vendor doesn't write ❌
6. **table_arrangement_image_url** - User expects, vendor doesn't write ⚠️

**Impact:** HIGH - User app has defaults but won't work correctly

### Database Schema vs Both Apps:
Database has but neither app uses explicitly:
1. **venue_id** - Database uses, apps use `club_id` ❌ **MISMATCH**
2. **end_date** - Database has, vendor writes as null ⚠️
3. **cover_image** - Database has separate field, apps use `images[0]` ⚠️
4. **category** (VARCHAR) - Database has, apps use `category_id` (UUID) ❌ **MISMATCH**
5. **vip_price** - Database has, vendor doesn't write ⚠️
6. **early_bird_price** - Database has, vendor doesn't write ⚠️
7. **lineup** (JSONB) - Database has, vendor doesn't write ⚠️

---

## 3. Status Filtering (CRITICAL ISSUE)

### Vendor App Status Values:
```dart
status = 'active'      // Published, visible to users
status = 'upcoming'    // Draft or scheduled
status = 'cancelled'   // Cancelled by vendor
status = 'completed'   // Past event
```

### User App Query:
**File:** `lib/features/events/services/event_service.dart:43`

```dart
var query = _supabase
  .from('events')
  .select('...')
  .eq('is_active', true);  // ❌ ONLY checks is_active, NOT status!
```

**PROBLEM:**
- User app queries `is_active = true`
- Does NOT filter by `status`
- Will show ALL events including:
  - ❌ Drafts (`status = 'upcoming'` with `is_active = true`)
  - ❌ Cancelled events (`status = 'cancelled'` with `is_active = true`)
  - ❌ Internal/test events

**Expected Query:**
```dart
var query = _supabase
  .from('events')
  .select('...')
  .eq('is_active', true)
  .eq('status', 'active');  // ✅ ADD THIS
```

---

## 4. Row Level Security (CRITICAL SECURITY ISSUE)

**Status:** ❌ **NO RLS POLICIES FOUND FOR EVENTS TABLE**

**Current State:**
```sql
-- NO ALTER TABLE events ENABLE ROW LEVEL SECURITY found in migrations
-- NO CREATE POLICY for events table found
```

**Impact:**
- ❌ **PUBLIC ACCESS** - Anyone (including unauthenticated users) can:
  - Read ALL events (including drafts, cancelled, test events)
  - Potentially INSERT events (if not blocked by permissions)
  - Potentially UPDATE events
  - Potentially DELETE events

**Required Fix:**
```sql
-- Enable RLS
ALTER TABLE events ENABLE ROW LEVEL SECURITY;

-- Policy 1: Public can ONLY read active published events
CREATE POLICY "Public can read active events"
  ON events FOR SELECT
  TO anon, authenticated
  USING (is_active = true AND status = 'active');

-- Policy 2: Vendors can manage their own events
CREATE POLICY "Vendors can manage own events"
  ON events FOR ALL
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Policy 3: Service role (edge functions) can do anything
CREATE POLICY "Service role full access"
  ON events FOR ALL
  TO service_role
  USING (true)
  WITH CHECK (true);
```

---

## 5. Image Storage Compatibility

### User App Image Loading:
**File:** `lib/core/services/image_upload_service.dart:96`

```dart
final publicUrl = _supabase.storage.from(bucket).getPublicUrl(filePath);
```

✅ **CORRECT** - Uses `getPublicUrl()` which works for public buckets

### Vendor App Image Upload:
Would need to check vendor app, but assuming it uploads to a bucket like:
- `events` bucket
- `event-images` bucket
- `club-images` bucket

### Event Model Image Usage:
**File:** `lib/features/events/models/event.dart:165-170`

```dart
String get primaryImageUrl {
  if (images != null && images!.isNotEmpty) {
    return images!.first;  // ✅ Returns full URL from vendor
  }
  return clubImageUrl ?? 'https://images.unsplash.com/...';  // ⚠️ Fallback
}
```

**Analysis:**
- ✅ Vendor writes full URLs to `images` array
- ✅ User app expects full URLs
- ✅ Compatible as long as vendor uploads to PUBLIC buckets
- ⚠️ Unknown which bucket vendor uses
- ⚠️ If vendor uses private buckets, images won't load

**Verification Needed:**
1. Check vendor bucket names (likely `event-images` or similar)
2. Verify buckets are PUBLIC or use signed URLs
3. Test image loading from vendor-created events

---

## 6. Missing Empty & Error States

### Screens Checked:
I'll analyze the event-related screens for empty/error states:

**File:** `lib/features/events/screens/event_discovery_screen.dart`
- ❌ **MISSING** - Needs empty state UI
- ❌ **MISSING** - Needs error state UI

**File:** `lib/features/events/screens/event_detail_screen.dart`
- ❌ **MISSING** - Needs error state UI (event not found)
- ⚠️ **PARTIAL** - Has loading state

**File:** `lib/features/events/screens/event_booking_screen.dart`
- ⚠️ **PARTIAL** - Has error display but minimal
- ❌ **MISSING** - No empty state for "no tables available"

**File:** `lib/features/home/services/events_service.dart` (provider level)
- ✅ **HAS** - AsyncValue handles loading/error/data states
- But screens don't always render these states properly

---

## 7. Required Fixes

### Fix #1: Add Missing Database Columns (OPTIONAL)

**File:** `supabase/migrations/20260612_add_user_event_fields.sql` (NEW)

```sql
-- Add fields that user app expects but database doesn't have
ALTER TABLE events
ADD COLUMN IF NOT EXISTS invitation_code VARCHAR(50),
ADD COLUMN IF NOT EXISTS is_private BOOLEAN DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS location_hidden BOOLEAN DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS table_arrangement_image_url TEXT,
ADD COLUMN IF NOT EXISTS rsvp_count INT DEFAULT 0,
ADD COLUMN IF NOT EXISTS table_booking_count INT DEFAULT 0;

-- Add index for invitation code lookups
CREATE INDEX IF NOT EXISTS idx_events_invitation_code
  ON events(invitation_code)
  WHERE invitation_code IS NOT NULL;
```

**Deploy:** `supabase db push`

### Fix #2: Add RLS Policies (CRITICAL)

**File:** `supabase/migrations/20260612_events_rls_policies.sql` (NEW)

```sql
-- Enable Row Level Security on events table
ALTER TABLE events ENABLE ROW LEVEL SECURITY;

-- Policy 1: Anon and authenticated users can ONLY read active published events
CREATE POLICY "Public can read active published events"
  ON events FOR SELECT
  TO anon, authenticated
  USING (
    is_active = true
    AND status = 'active'
    AND event_date >= CURRENT_DATE - INTERVAL '1 day'  -- Include today and future
  );

-- Policy 2: Authenticated vendors can manage their own events
CREATE POLICY "Vendors can manage own events"
  ON events FOR ALL
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Policy 3: Service role has full access (for edge functions)
CREATE POLICY "Service role full access"
  ON events FOR ALL
  TO service_role
  USING (true)
  WITH CHECK (true);

-- Grant permissions
GRANT SELECT ON events TO anon;
GRANT ALL ON events TO authenticated;
```

**Deploy:** `supabase db push`

### Fix #3: Update User App Event Query (CRITICAL)

**File:** `lib/features/events/services/event_service.dart`
**Lines:** 43-44

**BEFORE:**
```dart
.from('events')
.select('...')
.eq('is_active', true);
```

**AFTER:**
```dart
.from('events')
.select('...')
.eq('is_active', true)
.eq('status', 'active');  // ✅ ONLY show published events
```

**Apply to:**
- `getEvents()` method (line 24)
- `getFeaturedEvents()` method (line 99-114)
- `getEventById()` method (line 143) - maybe optional for direct links

### Fix #4: Add Empty & Error States

**File:** `lib/features/events/widgets/empty_events_state.dart` (NEW)

```dart
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class EmptyEventsState extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;

  const EmptyEventsState({
    super.key,
    this.title = 'No Events Found',
    this.message = 'There are no events available at the moment. Check back soon!',
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.calendar_remove,
              size: 80,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const Gap(24),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(12),
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const Gap(24),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Refresh'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

**File:** `lib/features/events/widgets/error_events_state.dart` (NEW)

```dart
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class ErrorEventsState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorEventsState({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.warning_2,
              size: 80,
              color: Colors.red.withValues(alpha: 0.8),
            ),
            const Gap(24),
            Text(
              'Oops! Something Went Wrong',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(12),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const Gap(24),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                ),
                child: const Text('Try Again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

---

## 8. Deployment Checklist

### Phase 1: Database Security (CRITICAL - 15 min)
- [ ] Deploy RLS policies migration:
  ```bash
  supabase db push
  ```
- [ ] Verify RLS enabled:
  ```sql
  SELECT tablename, rowsecurity
  FROM pg_tables
  WHERE tablename = 'events';
  -- Should show rowsecurity = true
  ```
- [ ] Test as anon user:
  ```sql
  SET ROLE anon;
  SELECT count(*) FROM events;
  -- Should only see active events
  RESET ROLE;
  ```

### Phase 2: Optional Schema Updates (30 min)
- [ ] Deploy schema migration (if needed)
- [ ] Update vendor app to write new fields
- [ ] Test vendor creates event → user sees it

### Phase 3: User App Updates (1 hour)
- [ ] Add `.eq('status', 'active')` to all event queries
- [ ] Create empty/error state widgets
- [ ] Update event discovery screen to use new widgets
- [ ] Update event detail screen to use error widget
- [ ] Test all flows

### Phase 4: Testing (30 min)
- [ ] Vendor creates draft event → User DOESN'T see it ✅
- [ ] Vendor publishes event (status='active') → User SEES it ✅
- [ ] Vendor cancels event → User DOESN'T see it ✅
- [ ] Images load correctly ✅
- [ ] Empty state shows when no events ✅
- [ ] Error state shows on network error ✅

---

## 9. Risk Assessment

### Before Fixes:
| Risk | Severity | Impact |
|------|----------|--------|
| No RLS on events | 🔴 CRITICAL | Users can see drafts, tests, private events |
| Draft events visible | 🔴 HIGH | Poor UX, confusion |
| Schema mismatches | 🟡 MEDIUM | Some features won't work |
| No empty states | 🟡 LOW | Poor UX |

### After Fixes:
| Risk | Severity | Impact |
|------|----------|--------|
| No RLS on events | 🟢 FIXED | Only published events visible |
| Draft events visible | 🟢 FIXED | Filtered by status |
| Schema mismatches | 🟡 PARTIAL | Optional fields still missing |
| No empty states | 🟢 FIXED | Good UX |

---

## 10. Summary

**Critical Issues:**
1. ❌ **NO RLS** - Events table publicly accessible
2. ❌ **NO STATUS FILTER** - Drafts visible to users
3. ⚠️ **SCHEMA MISMATCHES** - 6 fields user expects but vendor doesn't write

**Fixes Provided:**
✅ RLS policy migration (20260612_events_rls_policies.sql)
✅ Optional schema migration (20260612_add_user_event_fields.sql)
✅ User app query update (add status filter)
✅ Empty/error state widgets

**Timeline:**
- RLS fix: 15 minutes (DEPLOY IMMEDIATELY)
- Status filter: 15 minutes
- Empty states: 1 hour
- Schema sync: 2 hours (optional)

**Next Steps:**
1. Deploy RLS policies ASAP
2. Update event service queries
3. Test vendor → user flow
4. Add empty/error states
5. Monitor for issues

---

*Report completed: 2026-06-12*
*Priority: P0 - BLOCKING PRODUCTION (RLS)*
*Status: Awaiting deployment*
