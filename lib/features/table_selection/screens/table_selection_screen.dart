import 'package:flutter/material.dart';
import 'package:bottles_up_user/features/table_selection/models/table.dart';
import 'package:bottles_up_user/shared/widgets/widgets.dart';
import 'package:bottles_up_user/features/payment/screens/payment_screen.dart';
import 'package:bottles_up_user/core/models/payment_models.dart';

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
  int selectedFloor = 1;
  String? selectedTableId;

  final List<RestaurantTable> tables = [
    // First Floor - positioned to match screenshot
    const RestaurantTable(id: 'T-01', name: 'T-01', floor: 1, status: TableStatus.reserved, x: 0.1, y: 0.1),
    const RestaurantTable(id: 'T-02', name: 'T-02', floor: 1, status: TableStatus.available, x: 0.6, y: 0.1),
    const RestaurantTable(id: 'T-03', name: 'T-03', floor: 1, status: TableStatus.reserved, x: 0.1, y: 0.25),
    const RestaurantTable(id: 'T-04', name: 'T-04', floor: 1, status: TableStatus.available, x: 0.6, y: 0.25),
    const RestaurantTable(id: 'T-05', name: 'T-05', floor: 1, status: TableStatus.reserved, x: 0.1, y: 0.4),
    const RestaurantTable(id: 'T-06', name: 'T-06', floor: 1, status: TableStatus.available, x: 0.6, y: 0.4),
    const RestaurantTable(id: 'T-07', name: 'T-07', floor: 1, status: TableStatus.available, x: 0.1, y: 0.55),
    const RestaurantTable(id: 'T-08', name: 'T-08', floor: 1, status: TableStatus.reserved, x: 0.6, y: 0.55),
    const RestaurantTable(id: 'T-09', name: 'T-09', floor: 1, status: TableStatus.available, x: 0.35, y: 0.75),
    
    // Second Floor
    const RestaurantTable(id: 'T-10', name: 'T-10', floor: 2, status: TableStatus.available, x: 0.2, y: 0.2),
    const RestaurantTable(id: 'T-11', name: 'T-11', floor: 2, status: TableStatus.reserved, x: 0.7, y: 0.2),
    const RestaurantTable(id: 'T-12', name: 'T-12', floor: 2, status: TableStatus.available, x: 0.2, y: 0.5),
    const RestaurantTable(id: 'T-13', name: 'T-13', floor: 2, status: TableStatus.available, x: 0.7, y: 0.5),
    const RestaurantTable(id: 'T-14', name: 'T-14', floor: 2, status: TableStatus.reserved, x: 0.45, y: 0.8),
    
    // Third Floor
    const RestaurantTable(id: 'T-15', name: 'T-15', floor: 3, status: TableStatus.available, x: 0.3, y: 0.25),
    const RestaurantTable(id: 'T-16', name: 'T-16', floor: 3, status: TableStatus.available, x: 0.6, y: 0.25),
    const RestaurantTable(id: 'T-17', name: 'T-17', floor: 3, status: TableStatus.reserved, x: 0.3, y: 0.6),
    const RestaurantTable(id: 'T-18', name: 'T-18', floor: 3, status: TableStatus.available, x: 0.6, y: 0.6),
  ];

  List<RestaurantTable> get currentFloorTables => tables.where((table) => table.floor == selectedFloor).toList();

  void _proceedToPayment() {
    final selectedTable = tables.firstWhere((table) => table.id == selectedTableId);
    const tablePrice = 150.0; // Base table price - you can make this dynamic

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          amount: tablePrice,
          currency: 'USD',
          description: 'Table Booking - ${selectedTable.name}',
          paymentType: PaymentType.tableBooking,
          bookingId: 'booking_${DateTime.now().millisecondsSinceEpoch}',
          metadata: {
            'table_id': selectedTable.id,
            'table_name': selectedTable.name,
            'floor': selectedTable.floor.toString(),
            'club_id': widget.clubId,
            'date': widget.date,
            'time_slot': widget.timeSlot,
            'guest_count': widget.guestCount.toString(),
          },
          // Pass booking details
          clubName: widget.clubName ?? 'Club Name',
          date: widget.date,
          timeSlot: widget.timeSlot,
          tableName: selectedTable.name,
          guestCount: widget.guestCount,
          onPaymentSuccess: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Table ${selectedTable.name} reserved successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          },
          onPaymentFailed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Payment failed. Please try again.'),
                backgroundColor: Colors.red,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const CustomAppBar(title: 'Book a Table'),
      body: Column(
        children: [
          // Floor Tabs
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildFloorTab(1, '1st Floor'),
                const SizedBox(width: 16),
                _buildFloorTab(2, '2nd Floor'),
                const SizedBox(width: 16),
                _buildFloorTab(3, '3rd Floor'),
              ],
            ),
          ),
          
          // Legend
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildLegendItem(Colors.red, 'Reserved'),
                const SizedBox(width: 20),
                _buildLegendItem(Colors.green, 'Available'),
                const SizedBox(width: 20),
                _buildLegendItem(Theme.of(context).primaryColor, 'Selected'),
              ],
            ),
          ),
          
          // Table Layout
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 39, 39, 39),
                borderRadius: BorderRadius.circular(12),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: currentFloorTables.map((table) {
                      return Positioned(
                        left: (constraints.maxWidth - 80) * table.x,
                        top: (constraints.maxHeight - 40) * table.y,
                        child: _buildTableWidget(table),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),
          
          // Reserve Button
          Container(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: selectedTableId != null ? () {
                  _proceedToPayment();
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedTableId != null ? Theme.of(context).primaryColor : Colors.grey.shade600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Reserve Table',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloorTab(int floor, String title) {
    final isSelected = selectedFloor == floor;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFloor = floor;
          selectedTableId = null; // Reset selection when changing floors
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade600,
            width: 1,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade400,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildTableWidget(RestaurantTable table) {
    final isSelected = selectedTableId == table.id;
    final isAvailable = table.status == TableStatus.available;
    
    Color backgroundColor;
    Color textColor;
    Color borderColor;
    
    if (isSelected) {
      backgroundColor = Theme.of(context).primaryColor;
      textColor = Colors.white;
      borderColor = Theme.of(context).primaryColor;
    } else if (table.status == TableStatus.reserved) {
      backgroundColor = Colors.white;
      textColor = Colors.red;
      borderColor = Colors.red;
    } else {
      backgroundColor = Colors.white;
      textColor = Colors.green;
      borderColor = Colors.green;
    }
    
    return GestureDetector(
      onTap: isAvailable ? () {
        setState(() {
          selectedTableId = isSelected ? null : table.id;
        });
      } : null,
      child: Container(
        width: 80,
        height: 40,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Center(
          child: Text(
            table.name,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}