import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The tabs of the main screen, by index.
abstract final class MainTab {
  static const int events = 0;
  static const int tables = 1;
  static const int bookings = 2;
  static const int profile = 3;
}

/// Controls which bottom-nav tab is currently selected.
/// Other screens can write to this provider to switch tabs programmatically (see [MainTab]).
final mainNavIndexProvider = StateProvider<int>((ref) => MainTab.events);

/// What the Bookings tab shows: tickets for events, or VIP table bookings.
enum BookingsSegment { tickets, tables }

final bookingsSegmentProvider = StateProvider<BookingsSegment>((ref) => BookingsSegment.tickets);
