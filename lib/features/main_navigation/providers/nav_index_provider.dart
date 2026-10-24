import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Controls which bottom-nav tab is currently selected.
/// Other screens can write to this provider to switch tabs programmatically.
/// Index: 0=Feed, 1=Discover, 2=Book(Bookings), 3=Messages, 4=Profile
final mainNavIndexProvider = StateProvider<int>((ref) => 0);
