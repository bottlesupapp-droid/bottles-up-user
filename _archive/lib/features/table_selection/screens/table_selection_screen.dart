import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:bottles_up_user/shared/widgets/widgets.dart';
import 'package:bottles_up_user/features/payment/screens/payment_screen.dart';
import 'package:bottles_up_user/core/models/payment_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TableSelectionScreen extends StatefulWidget {
  final String? clubId;
  final String? date;
  final String? timeSlot;
  final int guestCount;
  final String? clubName;

  const TableSelectionScreen({
    super.key,
    this.clubId,
    this.date,
    this.timeSlot,
    this.guestCount = 4,
    this.clubName,
  });

  @override
  State<TableSelectionScreen> createState() => _TableSelectionScreenState();
}

class _TableSelectionScreenState extends State<TableSelectionScreen> {
  String? _selectedTableId;
  Map<String, dynamic>? _selectedTable;
  List<Map<String, dynamic>> _tables = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTables();
  }

  Future<void> _loadTables() async {
    if (widget.clubId == null) {
      setState(() {
        _error = 'No club specified';
        _isLoading = false;
      });
      return;
    }

    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final supabase = Supabase.instance.client;

      // If date and timeSlot are provided, filter out already-booked tables
      Set<String> bookedTableIds = {};
      if (widget.date != null && widget.timeSlot != null) {
        final bookings = await supabase
            .from('table_bookings')
            .select('table_id')
            .eq('booking_date', widget.date!)
            .eq('start_time', widget.timeSlot!)
            .eq('status', 'confirmed');

        bookedTableIds = (bookings as List)
            .map((b) => b['table_id'].toString())
            .toSet();
      }

      // Load all active tables for this club that fit the guest count
      var query = supabase
          .from('club_tables')
          .select('*')
          .eq('club_id', widget.clubId!)
          .eq('is_active', true)
          .gte('capacity', widget.guestCount)
          .order('is_vip', ascending: false)
          .order('price', ascending: true);

      final response = await query;

      final tables = (response as List)
          .map((t) => Map<String, dynamic>.from(t))
          .map((t) {
            t['is_booked'] = bookedTableIds.contains(t['id'].toString());
            return t;
          })
          .toList();

      setState(() {
        _tables = tables;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load tables. Please try again.';
        _isLoading = false;
      });
    }
  }

  void _onTableTap(Map<String, dynamic> table) {
    if (table['is_booked'] == true) return;
    setState(() {
      if (_selectedTableId == table['id'].toString()) {
        _selectedTableId = null;
        _selectedTable = null;
      } else {
        _selectedTableId = table['id'].toString();
        _selectedTable = table;
      }
    });
  }

  void _proceedToPayment() {
    if (_selectedTable == null) return;

    final tablePrice =
        double.tryParse(_selectedTable!['price']?.toString() ?? '0') ?? 0.0;
    final minimumSpend =
        double.tryParse(_selectedTable!['minimum_spend']?.toString() ?? '0') ??
            0.0;
    final chargeAmount = tablePrice > 0 ? tablePrice : minimumSpend;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          amount: chargeAmount,
          currency: 'USD',
          description:
              'Table Booking - ${_selectedTable!['name'] ?? 'Table'}',
          paymentType: PaymentType.tableBooking,
          metadata: {
            'table_id': _selectedTableId,
            'table_name': _selectedTable!['name'] ?? '',
            'club_id': widget.clubId,
            'date': widget.date,
            'time_slot': widget.timeSlot,
            'guest_count': widget.guestCount.toString(),
            'capacity': _selectedTable!['capacity']?.toString() ?? '',
            'is_vip': _selectedTable!['is_vip']?.toString() ?? 'false',
          },
          clubName: widget.clubName ?? 'Club',
          date: widget.date,
          timeSlot: widget.timeSlot,
          tableName: _selectedTable!['name']?.toString(),
          guestCount: widget.guestCount,
          onPaymentSuccess: () async {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Table ${_selectedTable!['name']} reserved successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
          onPaymentFailed: () async {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Payment failed. Please try again.'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const CustomAppBar(title: 'Select a Table'),
      body: Column(
        children: [
          // Info bar — date/time/guests
          if (widget.date != null || widget.timeSlot != null)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primaryColor.withOpacity(0.15)),
              ),
              child: Row(
                children: [
                  Icon(Iconsax.calendar_1, size: 16, color: primaryColor),
                  const Gap(8),
                  if (widget.date != null)
                    Text(
                      widget.date!,
                      style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600, color: primaryColor),
                    ),
                  if (widget.timeSlot != null) ...[
                    const Gap(12),
                    Icon(Iconsax.clock, size: 16, color: primaryColor),
                    const Gap(4),
                    Text(
                      widget.timeSlot!,
                      style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600, color: primaryColor),
                    ),
                  ],
                  const Spacer(),
                  Icon(Iconsax.people, size: 16, color: primaryColor),
                  const Gap(4),
                  Text(
                    '${widget.guestCount} guests',
                    style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600, color: primaryColor),
                  ),
                ],
              ),
            ),

          // Legend
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                _buildLegendDot(Colors.green, 'Available'),
                const Gap(16),
                _buildLegendDot(Colors.red.shade400, 'Booked'),
                const Gap(16),
                _buildLegendDot(Colors.amber, 'VIP'),
                const Spacer(),
                if (!_isLoading)
                  GestureDetector(
                    onTap: _loadTables,
                    child: Row(
                      children: [
                        Icon(Iconsax.refresh, size: 14,
                            color: theme.colorScheme.onSurface.withOpacity(0.5)),
                        const Gap(4),
                        Text(
                          'Refresh',
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.5)),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Table list
          Expanded(child: _buildBody(theme, primaryColor)),

          // Bottom action bar
          if (_selectedTable != null) _buildBottomBar(theme, primaryColor),
        ],
      ),
    );
  }

  Widget _buildBody(ThemeData theme, Color primaryColor) {
    if (_isLoading) {
      return Center(
        child: LoadingAnimationWidget.inkDrop(color: primaryColor, size: 40),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.warning_2, size: 48,
                color: theme.colorScheme.onSurface.withOpacity(0.4)),
            const Gap(12),
            Text(_error!,
                style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6))),
            const Gap(16),
            ElevatedButton.icon(
              onPressed: _loadTables,
              icon: const Icon(Iconsax.refresh, size: 16),
              label: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (_tables.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.reserve,
                size: 64,
                color: theme.colorScheme.onSurface.withOpacity(0.2)),
            const Gap(16),
            Text(
              'No tables available',
              style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6)),
            ),
            const Gap(8),
            Text(
              widget.date != null
                  ? 'No tables available for ${widget.guestCount} guests\nat this time. Try a different slot.'
                  : 'This venue has no tables configured yet.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.4)),
            ),
          ],
        ),
      );
    }

    // Group into VIP and Regular
    final vipTables = _tables.where((t) => t['is_vip'] == true).toList();
    final regularTables = _tables.where((t) => t['is_vip'] != true).toList();

    return RefreshIndicator(
      onRefresh: _loadTables,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          if (vipTables.isNotEmpty) ...[
            _buildSectionHeader('VIP Tables', Iconsax.crown_1, Colors.amber, theme),
            const Gap(8),
            ...vipTables.map((t) => _buildTableCard(t, theme, primaryColor)),
            const Gap(16),
          ],
          if (regularTables.isNotEmpty) ...[
            _buildSectionHeader('Regular Tables', Iconsax.reserve, primaryColor, theme),
            const Gap(8),
            ...regularTables.map((t) => _buildTableCard(t, theme, primaryColor)),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
      String title, IconData icon, Color color, ThemeData theme) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const Gap(8),
        Text(title,
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _buildTableCard(
      Map<String, dynamic> table, ThemeData theme, Color primaryColor) {
    final tableId = table['id'].toString();
    final isSelected = _selectedTableId == tableId;
    final isBooked = table['is_booked'] == true;
    final isVip = table['is_vip'] == true;

    final price =
        double.tryParse(table['price']?.toString() ?? '0') ?? 0.0;
    final minSpend =
        double.tryParse(table['minimum_spend']?.toString() ?? '0') ?? 0.0;
    final capacity = table['capacity'] as int? ?? 0;
    final name = table['name']?.toString() ?? 'Table';
    final locationDesc = table['location_description']?.toString();

    Color borderColor;
    Color bgColor;
    if (isSelected) {
      borderColor = primaryColor;
      bgColor = primaryColor.withOpacity(0.08);
    } else if (isBooked) {
      borderColor = Colors.red.shade400.withOpacity(0.4);
      bgColor = Colors.red.shade400.withOpacity(0.04);
    } else if (isVip) {
      borderColor = Colors.amber.withOpacity(0.4);
      bgColor = Colors.amber.withOpacity(0.04);
    } else {
      borderColor = theme.colorScheme.outline.withOpacity(0.2);
      bgColor = theme.colorScheme.surface;
    }

    return GestureDetector(
      onTap: isBooked ? null : () => _onTableTap(table),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
        ),
        child: Row(
          children: [
            // Status dot
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isBooked
                    ? Colors.red.shade400
                    : isVip
                        ? Colors.amber
                        : Colors.green,
              ),
            ),
            const Gap(12),

            // Table info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(name,
                          style: theme.textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      if (isVip) ...[
                        const Gap(6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                                color: Colors.amber.withOpacity(0.4)),
                          ),
                          child: const Text('VIP',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber)),
                        ),
                      ],
                      if (isBooked) ...[
                        const Gap(6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text('Booked',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.red.shade400,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ],
                  ),
                  const Gap(4),
                  Row(
                    children: [
                      Icon(Iconsax.people,
                          size: 13,
                          color: theme.colorScheme.onSurface.withOpacity(0.5)),
                      const Gap(4),
                      Text('Up to $capacity guests',
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withOpacity(0.6))),
                      if (locationDesc != null && locationDesc.isNotEmpty) ...[
                        const Gap(10),
                        Icon(Iconsax.location,
                            size: 13,
                            color:
                                theme.colorScheme.onSurface.withOpacity(0.5)),
                        const Gap(4),
                        Flexible(
                          child: Text(locationDesc,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.6))),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Price
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (price > 0)
                  Text('\$${price.toStringAsFixed(0)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isSelected ? primaryColor : null)),
                if (minSpend > 0)
                  Text('min \$${minSpend.toStringAsFixed(0)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                          color:
                              theme.colorScheme.onSurface.withOpacity(0.5))),
              ],
            ),

            // Selection indicator
            const Gap(10),
            if (isSelected)
              Icon(Iconsax.tick_circle, color: primaryColor, size: 22)
            else
              Icon(Iconsax.record_circle,
                  color: theme.colorScheme.onSurface.withOpacity(0.2),
                  size: 22),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(ThemeData theme, Color primaryColor) {
    final price =
        double.tryParse(_selectedTable!['price']?.toString() ?? '0') ?? 0.0;
    final minSpend =
        double.tryParse(_selectedTable!['minimum_spend']?.toString() ?? '0') ??
            0.0;
    final chargeAmount = price > 0 ? price : minSpend;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
            top: BorderSide(
                color: theme.colorScheme.outline.withOpacity(0.15))),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_selectedTable!['name']?.toString() ?? 'Selected Table',
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              Text(
                chargeAmount > 0
                    ? '\$${chargeAmount.toStringAsFixed(2)}'
                    : 'Free entry',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: primaryColor, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: _proceedToPayment,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              elevation: 0,
            ),
            child: const Text('Reserve Table',
                style:
                    TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const Gap(5),
        Text(label,
            style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w400)),
      ],
    );
  }
}
