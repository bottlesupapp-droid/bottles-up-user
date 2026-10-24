import 'package:freezed_annotation/freezed_annotation.dart';

part 'club_amenity.freezed.dart';
part 'club_amenity.g.dart';

@freezed
class ClubAmenity with _$ClubAmenity {
  const factory ClubAmenity({
    required String id,
    required String clubId,
    required String name,
    String? icon,
    DateTime? createdAt,
  }) = _ClubAmenity;

  factory ClubAmenity.fromJson(Map<String, dynamic> json) => _$ClubAmenityFromJson(json);

  factory ClubAmenity.fromSupabase(Map<String, dynamic> data) {
    return ClubAmenity(
      id: data['id']?.toString() ?? '',
      clubId: data['club_id']?.toString() ?? '',
      name: data['name']?.toString() ?? '',
      icon: data['icon']?.toString(),
      createdAt: data['created_at'] != null
          ? DateTime.tryParse(data['created_at'].toString())
          : null,
    );
  }
}