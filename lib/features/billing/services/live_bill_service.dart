import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/live_bill.dart';

class LiveBillService {
  static final LiveBillService _instance = LiveBillService._internal();
  factory LiveBillService() => _instance;
  LiveBillService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Get live bill for booking
  Future<LiveBill?> getLiveBill(String bookingId) async {
    try {
      final response = await _supabase
          .from('live_bills')
          .select('''
            *,
            bill_items(*)
          ''')
          .eq('booking_id', bookingId)
          .eq('status', 'open')
          .maybeSingle();

      if (response == null) return null;

      // Transform items
      response['items'] = response['bill_items'] ?? [];
      return LiveBill.fromSupabase(response);
    } catch (e) {
      return null;
    }
  }

  // Add item to bill
  Future<BillItem> addItemToBill({
    required String billId,
    required String itemName,
    required int quantity,
    required double pricePerUnit,
    String? category,
    String? notes,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      final totalPrice = quantity * pricePerUnit;

      final itemData = {
        'bill_id': billId,
        'item_name': itemName,
        'quantity': quantity,
        'price_per_unit': pricePerUnit,
        'total_price': totalPrice,
        'category': category,
        'notes': notes,
        'added_by': currentUser?.id,
      };

      final response = await _supabase
          .from('bill_items')
          .insert(itemData)
          .select()
          .single();

      // Update bill totals
      await _updateBillTotals(billId);

      return BillItem.fromSupabase(response);
    } catch (e) {
      throw Exception('Failed to add item: $e');
    }
  }

  // Remove item from bill
  Future<void> removeItemFromBill(String itemId, String billId) async {
    try {
      await _supabase.from('bill_items').delete().eq('id', itemId);

      // Update bill totals
      await _updateBillTotals(billId);
    } catch (e) {
      throw Exception('Failed to remove item: $e');
    }
  }

  // Update item quantity
  Future<void> updateItemQuantity({
    required String itemId,
    required String billId,
    required int newQuantity,
    required double pricePerUnit,
  }) async {
    try {
      final newTotal = newQuantity * pricePerUnit;

      await _supabase
          .from('bill_items')
          .update({
            'quantity': newQuantity,
            'total_price': newTotal,
          })
          .eq('id', itemId);

      // Update bill totals
      await _updateBillTotals(billId);
    } catch (e) {
      throw Exception('Failed to update quantity: $e');
    }
  }

  // Update tip amount
  Future<void> updateTip(String billId, double tipAmount) async {
    try {
      await _supabase
          .from('live_bills')
          .update({'tip': tipAmount})
          .eq('id', billId);

      // Recalculate total
      await _updateBillTotals(billId);
    } catch (e) {
      throw Exception('Failed to update tip: $e');
    }
  }

  // Close bill
  Future<void> closeBill(String billId) async {
    try {
      await _supabase
          .from('live_bills')
          .update({
            'status': 'closed',
            'closed_at': DateTime.now().toIso8601String(),
          })
          .eq('id', billId);
    } catch (e) {
      throw Exception('Failed to close bill: $e');
    }
  }

  // Split bill
  Future<Map<String, double>> calculateBillSplit({
    required LiveBill bill,
    required int numberOfPeople,
  }) async {
    final perPerson = bill.total / numberOfPeople;
    final splits = <String, double>{};

    for (int i = 1; i <= numberOfPeople; i++) {
      splits['Person $i'] = perPerson;
    }

    return splits;
  }

  // Split by items
  Future<Map<String, double>> splitBillByItems({
    required LiveBill bill,
    required Map<String, List<String>> personItems,
  }) async {
    final splits = <String, double>{};

    // Calculate shared costs per person
    final sharedCosts = (bill.tax + bill.serviceCharge) / personItems.length;

    for (final entry in personItems.entries) {
      final person = entry.key;
      final itemIds = entry.value;

      // Sum items for this person
      double itemsTotal = 0;
      for (final itemId in itemIds) {
        final item = bill.items.firstWhere((i) => i.id == itemId);
        itemsTotal += item.totalPrice;
      }

      // Add shared costs
      splits[person] = itemsTotal + sharedCosts;
    }

    return splits;
  }

  // Helper: Update bill totals
  Future<void> _updateBillTotals(String billId) async {
    try {
      // Get all items
      final items = await _supabase
          .from('bill_items')
          .select()
          .eq('bill_id', billId);

      double subtotal = 0;
      for (final item in (items as List)) {
        subtotal += (item['total_price'] as num).toDouble();
      }

      // Calculate tax and service charge (10% tax, 15% service)
      final tax = subtotal * 0.10;
      final serviceCharge = subtotal * 0.15;

      // Get current tip
      final bill = await _supabase
          .from('live_bills')
          .select('tip')
          .eq('id', billId)
          .single();

      final tip = (bill['tip'] as num?)?.toDouble() ?? 0;

      final total = subtotal + tax + serviceCharge + tip;

      // Update bill
      await _supabase
          .from('live_bills')
          .update({
            'subtotal': subtotal,
            'tax': tax,
            'service_charge': serviceCharge,
            'total': total,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', billId);
    } catch (e) {
      // Silently fail
    }
  }

  // Subscribe to bill updates
  RealtimeChannel subscribeToBill(
    String billId,
    void Function(LiveBill) onUpdate,
  ) {
    return _supabase
        .channel('live_bill_$billId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'live_bills',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id',
            value: billId,
          ),
          callback: (payload) async {
            if (payload.newRecord != null) {
              final bill = await getLiveBill(payload.newRecord['booking_id']);
              if (bill != null) {
                onUpdate(bill);
              }
            }
          },
        )
        .subscribe();
  }

  // Subscribe to bill items
  RealtimeChannel subscribeToBillItems(
    String billId,
    void Function() onItemsChanged,
  ) {
    return _supabase
        .channel('bill_items_$billId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'bill_items',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'bill_id',
            value: billId,
          ),
          callback: (payload) {
            onItemsChanged();
          },
        )
        .subscribe();
  }
}
