# `_archive/` — code removed from the live app

Nothing here was deleted. The app is being moved onto the **website's backend** (the `site_*` tables, RPCs and edge functions) and trimmed to what v1 needs, so everything else was moved out of `lib/` into this folder, **keeping its original relative path**. Restoring a file is moving it back.

`flutter analyze` ignores this folder (see `analysis_options.yaml`), so it never affects builds or CI.

## What was moved

### Tier 1 — unreachable code (no behaviour change) — 223 files

Files that **nothing imports**, traced from `lib/main.dart` through every `import`, `export` and `part`. They were never part of the running app. Generated `*.g.dart` / `*.freezed.dart` files travel with their parent.

| Original location | Files | Lines |
|---|---:|---:|
| `lib/features/social` | 27 | 18324 |
| `lib/features/events` | 41 | 13446 |
| `lib/features/profile` | 12 | 6882 |
| `lib/features/search` | 16 | 5530 |
| `lib/features/realtime` | 6 | 4077 |
| `lib/features/club` | 10 | 3690 |
| `lib/features/advanced` | 3 | 3077 |
| `lib/features/payments` | 6 | 2983 |
| `lib/features/clubs` | 7 | 2306 |
| `lib/features/bookings` | 5 | 2138 |
| `lib/features/tips` | 5 | 2127 |
| `lib/features/tickets` | 7 | 2016 |
| `lib/features/group_booking` | 4 | 1986 |
| `lib/features/waitlist` | 6 | 1802 |
| `lib/features/billing` | 6 | 1730 |
| `lib/features/addons` | 5 | 1690 |
| `lib/features/payment_history` | 4 | 1678 |
| `lib/features/time_slots` | 5 | 1583 |
| `lib/features/bottle_upgrades` | 5 | 1517 |
| `lib/features/special_requests` | 4 | 1072 |
| `lib/features/refunds` | 5 | 1061 |
| `lib/common_widgets` | 4 | 949 |
| `lib/features/home` | 2 | 763 |
| `lib/features/invites` | 3 | 685 |
| `lib/features/loyalty` | 2 | 642 |
| `lib/features/trending` | 2 | 569 |
| `lib/features/favorites` | 4 | 565 |
| `lib/features/auth` | 6 | 557 |
| `lib/features/qr_scan` | 2 | 407 |
| `lib/features/currency` | 1 | 308 |
| `lib/features/receipts` | 1 | 224 |
| `lib/features/photos` | 1 | 176 |
| `lib` | 1 | 171 |
| `lib/core` | 1 | 165 |
| `lib/features/maps` | 1 | 148 |
| `lib/features/payment` | 1 | 102 |
| `lib/shared` | 1 | 52 |
| `lib/features/table_selection` | 1 | 41 |

### Tier 2 — features cut from the product — 64 files

Features that are reachable today but are not part of v1: **Messaging** (the Messages tab and `/messaging/*`), **Loyalty & Rewards** (`/loyalty*` and the profile tile), **event chat, polls and announcements** (`/events/:id/chat|polls|announcements`), **ticket transfer / resale** (`/ticket-transfers`, which contradicts the website's non-transferable tickets), **venue comparison and venue inquiry**. Bottom nav went from 5 tabs to 4. Files that became unreachable once those routes were removed were moved with them.

| Original location | Files | Lines |
|---|---:|---:|
| `lib/features/loyalty` | 24 | 8973 |
| `lib/features/events` | 25 | 5586 |
| `lib/features/messaging` | 13 | 5097 |
| `lib/features/venues` | 2 | 570 |

### Tier 3 — hazard files — 3 files

Non-Dart files that are risky to leave in the repo:

| File | Why |
|---|---|
| `supabase/functions/run-migration/index.ts` | Edge function that runs SQL with the service-role key through an `exec_sql` RPC. Archiving the folder does **not** undeploy it, see `supabase/staging/README.md`. |
| `CLEANUP_LIVE_CUSTOMERS.sql` | Deletes Stripe customer rows. Destructive if run by mistake. |
| `CREATE_TEST_BOOKING.sql` | Test-data script with a personal email address hard-coded in it. |

## What else changed outside this folder

These are the only code edits (everything else was a pure file move). `restore/tier2_edits.patch` reverses all of them.

- `lib/routing/app_router.dart`: removed 12 imports and 12 routes (messaging, loyalty, event chat/polls/announcements, ticket transfers, venue inquiry/comparison)
- `lib/features/main_navigation/screens/main_navigation_screen.dart`: Messages tab removed; Profile is now tab index 3
- `lib/features/profile/screens/profile_screen.dart`: removed the "Loyalty & Rewards" tile

Also: `analysis_options.yaml` now excludes `_archive/**`.

## How to restore

```bash
cd apps/bottles-up-user

# preview, then restore one feature
_archive/restore.sh lib/features/loyalty --dry-run
_archive/restore.sh lib/features/loyalty

# restore everything that came from lib/
_archive/restore.sh lib

# put back the routes / tabs / tiles that pointed at Tier 2 files
git apply -R _archive/restore/tier2_edits.patch
```

- **Tier 1** files need nothing else: nothing referenced them.
- **Tier 2** files also need their wiring back. The patch is the exact record of what was removed, so you can re-add a single route or tile by hand from it.
- A scratch round trip (restore everything + reverse the patch) reproduces the original pinned commit exactly.

## Verification

`flutter analyze` (no pub) at the commit this was cut from, versus now:

| | Before | After |
|---|---|---|
| Analyzer errors | 105 errors | 1 error |

No new errors or warnings were introduced. **This is static analysis only**: the app was not built or run.

## Not moved on purpose

- Checkout and payment screens, `core/services/payment_service.dart` and the `create-payment-intent` / `create-checkout-session` edge functions: still called by the live booking flow. They get replaced when the app is repointed at the website's checkout.
- `pubspec.yaml` dependencies used only by archived code (charts, calendar, maps, etc.). Harmless, prune later.
- About 100 status/report `.md` files at the repo root. Many say "production ready". Not touched.

## Known issues that were already there

- `test/widget_test.dart` is the untouched Flutter template and references a `MyApp` that does not exist. It was failing before and still is. It is the only analyzer error left.
- The home screen's events "See all" button pushes `/events`, which has never had a route (also true before this change).
- The app is **not** verified to run. Only `flutter analyze` was used. Generated `*.g.dart` / `*.freezed.dart` files are the checked-in ones; `build_runner` was not re-run.
