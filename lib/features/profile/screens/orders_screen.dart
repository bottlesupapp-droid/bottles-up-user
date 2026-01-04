import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../shared/widgets/loading_indicator.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> _clubBookings = [];
  List<Map<String, dynamic>> _tableBookings = [];
  List<Map<String, dynamic>> _eventBookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadBookings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadBookings() async {
    final authState = ref.read(authStateProvider);
    await authState.maybeMap(
      authenticated: (state) async {
        try {
          setState(() {
            _isLoading = true;
          });

          final userId = state.user.id;

          // Load club bookings
          final clubBookingsData = await Supabase.instance.client
              .from('clubs_bookings')
              .select('''
                *,
                clubs!inner(name, location, image_url),
                zones(name, zone_type)
              ''')
              .eq('user_id', userId)
              .order('created_at', ascending: false);

          // Load table bookings
          final tableBookingsData = await Supabase.instance.client
              .from('table_bookings')
              .select('''
                *,
                club_tables!inner(
                  name,
                  capacity,
                  is_vip,
                  clubs!inner(name, location, image_url)
                )
              ''')
              .eq('user_id', userId)
              .order('created_at', ascending: false);

          // Load event bookings
          final eventBookingsData = await Supabase.instance.client
              .from('events_bookings')
              .select('''
                *,
                events!inner(
                  name,
                  description,
                  event_date,
                  start_time,
                  end_time,
                  clubs(name, location, image_url)
                )
              ''')
              .eq('user_id', userId)
              .order('created_at', ascending: false);

          if (mounted) {
            setState(() {
              _clubBookings = List<Map<String, dynamic>>.from(clubBookingsData);
              _tableBookings = List<Map<String, dynamic>>.from(tableBookingsData);
              _eventBookings = List<Map<String, dynamic>>.from(eventBookingsData);
              _isLoading = false;
            });
          }
        } catch (e) {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error loading bookings: $e')),
            );
          }
        }
      },
      orElse: () {
        setState(() {
          _isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Iconsax.building),
              text: 'Club Entry',
            ),
            Tab(
              icon: Icon(Iconsax.tag_2),
              text: 'Table Booking',
            ),
            Tab(
              icon: Icon(Iconsax.ticket),
              text: 'Events',
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: LoadingIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildClubBookingsList(),
                _buildTableBookingsList(),
                _buildEventBookingsList(),
              ],
            ),
    );
  }

  Widget _buildClubBookingsList() {
    if (_clubBookings.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.building, size: 64, color: Colors.grey),
            Gap(16),
            Text(
              'No club bookings yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Gap(8),
            Text(
              'Your club entry bookings will appear here',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _clubBookings.length,
      itemBuilder: (context, index) {
        final booking = _clubBookings[index];
        final club = booking['clubs'];
        final zone = booking['zones'];
        
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        club['image_url'] ?? '',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[300],
                          child: const Icon(Icons.business),
                        ),
                      ),
                    ),
                    const Gap(12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            club['name'] ?? 'Unknown Club',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            club['location'] ?? '',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                          const Gap(4),
                          _buildStatusChip(booking['status']),
                        ],
                      ),
                    ),
                  ],
                ),
                const Gap(12),
                const Divider(),
                const Gap(8),
                _buildBookingDetails([
                  {'label': 'Booking Type', 'value': booking['booking_type']?.toString().replaceAll('_', ' ').toUpperCase() ?? 'N/A'},
                  {'label': 'Date', 'value': booking['booking_date']?.toString() ?? 'N/A'},
                  {'label': 'Time', 'value': booking['visit_time']?.toString() ?? 'N/A'},
                  {'label': 'Guests', 'value': booking['guest_count']?.toString() ?? 'N/A'},
                  if (zone != null) {'label': 'Zone', 'value': '${zone['name']} (${zone['zone_type']})'},
                  {'label': 'Total Amount', 'value': '\$${booking['total_amount']?.toString() ?? '0'}'},
                  if (booking['confirmation_code'] != null) {'label': 'Confirmation Code', 'value': booking['confirmation_code']},
                ]),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTableBookingsList() {
    if (_tableBookings.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.tag_2, size: 64, color: Colors.grey),
            Gap(16),
            Text(
              'No table bookings yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Gap(8),
            Text(
              'Your table reservations will appear here',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _tableBookings.length,
      itemBuilder: (context, index) {
        final booking = _tableBookings[index];
        final table = booking['club_tables'];
        final club = table['clubs'];
        
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        club['image_url'] ?? '',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[300],
                          child: const Icon(Icons.business),
                        ),
                      ),
                    ),
                    const Gap(12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            club['name'] ?? 'Unknown Club',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            club['location'] ?? '',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                          const Gap(4),
                          _buildStatusChip(booking['status']),
                        ],
                      ),
                    ),
                  ],
                ),
                const Gap(12),
                const Divider(),
                const Gap(8),
                _buildBookingDetails([
                  {'label': 'Table', 'value': '${table['name']} ${table['is_vip'] == true ? '(VIP)' : ''}'},
                  {'label': 'Capacity', 'value': table['capacity']?.toString() ?? 'N/A'},
                  {'label': 'Date', 'value': booking['booking_date']?.toString() ?? 'N/A'},
                  {'label': 'Time Slot', 'value': booking['time_slot']?.toString() ?? 'N/A'},
                  {'label': 'Guests', 'value': booking['guest_count']?.toString() ?? 'N/A'},
                  {'label': 'Total Price', 'value': '\$${booking['total_price']?.toString() ?? '0'}'},
                  if (booking['confirmation_code'] != null) {'label': 'Confirmation Code', 'value': booking['confirmation_code']},
                ]),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEventBookingsList() {
    if (_eventBookings.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.ticket, size: 64, color: Colors.grey),
            Gap(16),
            Text(
              'No event bookings yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Gap(8),
            Text(
              'Your event tickets will appear here',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _eventBookings.length,
      itemBuilder: (context, index) {
        final booking = _eventBookings[index];
        final event = booking['events'];
        final club = event['clubs'];
        
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: club != null && club['image_url'] != null
                          ? Image.network(
                              club['image_url'],
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey[300],
                                child: const Icon(Icons.event),
                              ),
                            )
                          : Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey[300],
                              child: const Icon(Icons.event),
                            ),
                    ),
                    const Gap(12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event['name'] ?? 'Unknown Event',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          if (club != null)
                            Text(
                              club['name'] ?? '',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                            ),
                          const Gap(4),
                          _buildStatusChip(booking['status']),
                        ],
                      ),
                    ),
                  ],
                ),
                const Gap(12),
                const Divider(),
                const Gap(8),
                _buildBookingDetails([
                  {'label': 'Event Date', 'value': event['event_date']?.toString() ?? 'N/A'},
                  {'label': 'Time', 'value': '${event['start_time']} - ${event['end_time']}'},
                  {'label': 'Tickets', 'value': booking['ticket_quantity']?.toString() ?? 'N/A'},
                  {'label': 'Ticket Price', 'value': '\$${booking['ticket_price']?.toString() ?? '0'}'},
                  {'label': 'Total Amount', 'value': '\$${booking['total_amount']?.toString() ?? '0'}'},
                  if (booking['confirmation_code'] != null) {'label': 'Confirmation Code', 'value': booking['confirmation_code']},
                ]),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(String? status) {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (status?.toLowerCase()) {
      case 'confirmed':
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        icon = Iconsax.tick_circle;
        break;
      case 'pending':
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        icon = Iconsax.clock;
        break;
      case 'cancelled':
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        icon = Iconsax.close_circle;
        break;
      case 'completed':
        backgroundColor = Colors.blue.shade100;
        textColor = Colors.blue.shade800;
        icon = Iconsax.verify;
        break;
      default:
        backgroundColor = Colors.grey.shade100;
        textColor = Colors.grey.shade800;
        icon = Iconsax.info_circle;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const Gap(4),
          Text(
            status?.toUpperCase() ?? 'UNKNOWN',
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingDetails(List<Map<String, String>> details) {
    return Column(
      children: details.map((detail) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 120,
                child: Text(
                  detail['label']!,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  detail['value']!,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
} 