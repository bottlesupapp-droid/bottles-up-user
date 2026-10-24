import 'package:freezed_annotation/freezed_annotation.dart';

part 'live_bill.freezed.dart';
part 'live_bill.g.dart';

@freezed
class LiveBill with _$LiveBill {
  const factory LiveBill({
    required String id,
    required String bookingId,
    required String userId,
    required String venueId,
    String? venueName,
    required List<BillItem> items,
    required double subtotal,
    required double tax,
    required double serviceCharge,
    required double tip,
    required double total,
    @Default('open') String status,
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? closedAt,
  }) = _LiveBill;

  factory LiveBill.fromJson(Map<String, dynamic> json) =>
      _$LiveBillFromJson(json);

  factory LiveBill.fromSupabase(Map<String, dynamic> data) {
    final itemsData = data['items'] as List? ?? [];
    final items = itemsData
        .map((item) => BillItem.fromJson(item as Map<String, dynamic>))
        .toList();

    return LiveBill(
      id: data['id'] as String,
      bookingId: data['booking_id'] as String,
      userId: data['user_id'] as String,
      venueId: data['venue_id'] as String,
      venueName: data['venue_name'] as String?,
      items: items,
      subtotal: (data['subtotal'] as num).toDouble(),
      tax: (data['tax'] as num).toDouble(),
      serviceCharge: (data['service_charge'] as num? ?? 0).toDouble(),
      tip: (data['tip'] as num? ?? 0).toDouble(),
      total: (data['total'] as num).toDouble(),
      status: data['status'] as String? ?? 'open',
      createdAt: DateTime.parse(data['created_at'] as String),
      updatedAt: data['updated_at'] != null
          ? DateTime.parse(data['updated_at'] as String)
          : null,
      closedAt: data['closed_at'] != null
          ? DateTime.parse(data['closed_at'] as String)
          : null,
    );
  }
}

@freezed
class BillItem with _$BillItem {
  const factory BillItem({
    required String id,
    required String billId,
    required String itemName,
    required int quantity,
    required double pricePerUnit,
    required double totalPrice,
    String? category,
    String? notes,
    required DateTime addedAt,
    String? addedBy,
  }) = _BillItem;

  factory BillItem.fromJson(Map<String, dynamic> json) =>
      _$BillItemFromJson(json);

  factory BillItem.fromSupabase(Map<String, dynamic> data) {
    return BillItem(
      id: data['id'] as String,
      billId: data['bill_id'] as String,
      itemName: data['item_name'] as String,
      quantity: data['quantity'] as int,
      pricePerUnit: (data['price_per_unit'] as num).toDouble(),
      totalPrice: (data['total_price'] as num).toDouble(),
      category: data['category'] as String?,
      notes: data['notes'] as String?,
      addedAt: DateTime.parse(data['added_at'] as String),
      addedBy: data['added_by'] as String?,
    );
  }
}
