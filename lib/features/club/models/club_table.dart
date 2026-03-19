import 'package:freezed_annotation/freezed_annotation.dart';

part 'club_table.freezed.dart';
part 'club_table.g.dart';

@freezed
class ClubTable with _$ClubTable {
  const factory ClubTable({
    required String id,
    required String clubId,
    required String name,
    required int capacity,
    required double price,
    @Default(false) bool isVip,
    String? locationDescription,
    double? minimumSpend,
    @Default(true) bool isActive,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ClubTable;

  factory ClubTable.fromJson(Map<String, dynamic> json) => _$ClubTableFromJson(json);

  factory ClubTable.fromSupabase(Map<String, dynamic> data) {
    return ClubTable(
      id: data['id']?.toString() ?? '',
      clubId: data['club_id']?.toString() ?? '',
      name: data['name']?.toString() ?? '',
      capacity: int.tryParse(data['capacity']?.toString() ?? '0') ?? 0,
      price: double.tryParse(data['price']?.toString() ?? '0') ?? 0.0,
      isVip: data['is_vip'] == true,
      locationDescription: data['location_description']?.toString(),
      minimumSpend: data['minimum_spend'] != null
          ? double.tryParse(data['minimum_spend'].toString())
          : null,
      isActive: data['is_active'] ?? true,
      imageUrl: data['image_url']?.toString(),
      createdAt: data['created_at'] != null
          ? DateTime.tryParse(data['created_at'].toString())
          : null,
      updatedAt: data['updated_at'] != null
          ? DateTime.tryParse(data['updated_at'].toString())
          : null,
    );
  }
}