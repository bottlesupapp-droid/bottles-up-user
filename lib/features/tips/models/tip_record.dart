import 'package:freezed_annotation/freezed_annotation.dart';

part 'tip_record.freezed.dart';
part 'tip_record.g.dart';

enum TipType {
  percentage,
  fixed,
  custom,
}

@freezed
class TipRecord with _$TipRecord {
  const factory TipRecord({
    required String id,
    required String userId,
    required String bookingId,
    String? venueId,
    String? venueName,
    String? staffId,
    String? staffName,
    required double tipAmount,
    required double billAmount,
    required TipType tipType,
    double? tipPercentage,
    String? paymentMethod,
    String? currency,
    Map<String, dynamic>? metadata,
    required DateTime createdAt,
  }) = _TipRecord;

  factory TipRecord.fromJson(Map<String, dynamic> json) =>
      _$TipRecordFromJson(json);

  factory TipRecord.fromSupabase(Map<String, dynamic> data) {
    return TipRecord(
      id: data['id'] as String,
      userId: data['user_id'] as String,
      bookingId: data['booking_id'] as String,
      venueId: data['venue_id'] as String?,
      venueName: data['venue_name'] as String?,
      staffId: data['staff_id'] as String?,
      staffName: data['staff_name'] as String?,
      tipAmount: (data['tip_amount'] as num).toDouble(),
      billAmount: (data['bill_amount'] as num).toDouble(),
      tipType: TipType.values.firstWhere(
        (e) => e.name == data['tip_type'],
        orElse: () => TipType.percentage,
      ),
      tipPercentage: (data['tip_percentage'] as num?)?.toDouble(),
      paymentMethod: data['payment_method'] as String?,
      currency: data['currency'] as String?,
      metadata: data['metadata'] != null
          ? Map<String, dynamic>.from(data['metadata'] as Map)
          : null,
      createdAt: DateTime.parse(data['created_at'] as String),
    );
  }
}

@freezed
class TipStatistics with _$TipStatistics {
  const factory TipStatistics({
    required double totalTipped,
    required double averageTipAmount,
    required double averageTipPercentage,
    required int totalTips,
    required Map<String, double> tipsByVenue,
    required Map<String, int> tipsByMonth,
    double? highestTip,
    double? lowestTip,
    String? mostTippedVenue,
  }) = _TipStatistics;

  factory TipStatistics.fromJson(Map<String, dynamic> json) =>
      _$TipStatisticsFromJson(json);

  factory TipStatistics.fromSupabase(Map<String, dynamic> data) {
    return TipStatistics(
      totalTipped: (data['total_tipped'] as num).toDouble(),
      averageTipAmount: (data['average_tip_amount'] as num).toDouble(),
      averageTipPercentage: (data['average_tip_percentage'] as num).toDouble(),
      totalTips: data['total_tips'] as int,
      tipsByVenue: data['tips_by_venue'] != null
          ? Map<String, double>.from(data['tips_by_venue'] as Map)
          : {},
      tipsByMonth: data['tips_by_month'] != null
          ? Map<String, int>.from(data['tips_by_month'] as Map)
          : {},
      highestTip: (data['highest_tip'] as num?)?.toDouble(),
      lowestTip: (data['lowest_tip'] as num?)?.toDouble(),
      mostTippedVenue: data['most_tipped_venue'] as String?,
    );
  }
}

@freezed
class TipPreset with _$TipPreset {
  const factory TipPreset({
    required String label,
    required double percentage,
    bool? isDefault,
  }) = _TipPreset;

  factory TipPreset.fromJson(Map<String, dynamic> json) =>
      _$TipPresetFromJson(json);
}
