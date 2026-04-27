import 'package:freezed_annotation/freezed_annotation.dart';

part 'favorite.freezed.dart';
part 'favorite.g.dart';

enum FavoriteType {
  event,
  venue,
  promoter,
}

@freezed
class Favorite with _$Favorite {
  const factory Favorite({
    required String id,
    required String userId,
    required FavoriteType type,
    required String itemId,
    String? itemName,
    String? itemImage,
    Map<String, dynamic>? metadata,
    required DateTime createdAt,
  }) = _Favorite;

  factory Favorite.fromJson(Map<String, dynamic> json) =>
      _$FavoriteFromJson(json);

  factory Favorite.fromSupabase(Map<String, dynamic> data) {
    return Favorite(
      id: data['id'] as String,
      userId: data['user_id'] as String,
      type: FavoriteType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => FavoriteType.event,
      ),
      itemId: data['item_id'] as String,
      itemName: data['item_name'] as String?,
      itemImage: data['item_image'] as String?,
      metadata: data['metadata'] != null
          ? Map<String, dynamic>.from(data['metadata'] as Map)
          : null,
      createdAt: DateTime.parse(data['created_at'] as String),
    );
  }
}
