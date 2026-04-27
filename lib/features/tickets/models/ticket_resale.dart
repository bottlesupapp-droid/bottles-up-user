import 'package:freezed_annotation/freezed_annotation.dart';

part 'ticket_resale.freezed.dart';
part 'ticket_resale.g.dart';

enum ResaleStatus {
  @JsonValue('listed')
  listed,
  @JsonValue('sold')
  sold,
  @JsonValue('cancelled')
  cancelled,
  @JsonValue('expired')
  expired,
}

@freezed
class TicketResale with _$TicketResale {
  const factory TicketResale({
    required String id,
    required String ticketId,
    required String sellerId,
    required String eventId,
    String? eventName,
    DateTime? eventDate,
    required double originalPrice,
    required double listingPrice,
    String? sellerName,
    String? ticketType,
    int? quantity,
    String? description,
    @Default(ResaleStatus.listed) ResaleStatus status,
    required DateTime listedAt,
    DateTime? soldAt,
    String? buyerId,
    String? buyerName,
    DateTime? expiresAt,
  }) = _TicketResale;

  factory TicketResale.fromJson(Map<String, dynamic> json) =>
      _$TicketResaleFromJson(json);

  factory TicketResale.fromSupabase(Map<String, dynamic> data) {
    return TicketResale(
      id: data['id'] as String,
      ticketId: data['ticket_id'] as String,
      sellerId: data['seller_id'] as String,
      eventId: data['event_id'] as String,
      eventName: data['event_name'] as String?,
      eventDate: data['event_date'] != null
          ? DateTime.parse(data['event_date'] as String)
          : null,
      originalPrice: (data['original_price'] as num).toDouble(),
      listingPrice: (data['listing_price'] as num).toDouble(),
      sellerName: data['seller_name'] as String?,
      ticketType: data['ticket_type'] as String?,
      quantity: data['quantity'] as int?,
      description: data['description'] as String?,
      status: ResaleStatus.values.firstWhere(
        (s) => s.name == data['status'],
        orElse: () => ResaleStatus.listed,
      ),
      listedAt: DateTime.parse(data['listed_at'] as String),
      soldAt: data['sold_at'] != null
          ? DateTime.parse(data['sold_at'] as String)
          : null,
      buyerId: data['buyer_id'] as String?,
      buyerName: data['buyer_name'] as String?,
      expiresAt: data['expires_at'] != null
          ? DateTime.parse(data['expires_at'] as String)
          : null,
    );
  }
}

@freezed
class ResaleOffer with _$ResaleOffer {
  const factory ResaleOffer({
    required String id,
    required String resaleId,
    required String buyerId,
    String? buyerName,
    required double offeredPrice,
    String? message,
    @Default('pending') String status,
    required DateTime createdAt,
    DateTime? respondedAt,
  }) = _ResaleOffer;

  factory ResaleOffer.fromJson(Map<String, dynamic> json) =>
      _$ResaleOfferFromJson(json);

  factory ResaleOffer.fromSupabase(Map<String, dynamic> data) {
    return ResaleOffer(
      id: data['id'] as String,
      resaleId: data['resale_id'] as String,
      buyerId: data['buyer_id'] as String,
      buyerName: data['buyer_name'] as String?,
      offeredPrice: (data['offered_price'] as num).toDouble(),
      message: data['message'] as String?,
      status: data['status'] as String? ?? 'pending',
      createdAt: DateTime.parse(data['created_at'] as String),
      respondedAt: data['responded_at'] != null
          ? DateTime.parse(data['responded_at'] as String)
          : null,
    );
  }
}
