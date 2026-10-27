import 'package:flutter/material.dart';

import 'bookings_tab.dart';

/// Tickets and VIP tables as a page of their own, for the layout where Bookings is not a tab (Profile and Home lead here).
class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key, this.now});

  final DateTime? now;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Tickets and bookings')),
        body: BookingsTab(now: now, showTitle: false),
      );
}
