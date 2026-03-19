import 'package:freezed_annotation/freezed_annotation.dart';

part 'bottle.freezed.dart';
part 'bottle.g.dart';

@freezed
class Bottle with _$Bottle {
  const factory Bottle({
    required String id,
    required String clubId,
    required String name,
    required String category,
    String? subcategory,
    String? brand,
    required double price,
    int? volumeMl,
    double? alcoholContent,
    String? description,
    String? imageUrl,
    @Default(true) bool isAvailable,
    @Default(false) bool isFeatured,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Bottle;

  factory Bottle.fromJson(Map<String, dynamic> json) => _$BottleFromJson(json);

  /// Factory method to create Bottle from Supabase response
  factory Bottle.fromSupabase(Map<String, dynamic> data) {
    return Bottle(
      id: data['id'] as String,
      clubId: data['club_id'] as String,
      name: data['name'] as String,
      category: data['category'] as String,
      subcategory: data['subcategory'] as String?,
      brand: data['brand'] as String?,
      price: _parsePrice(data['price']),
      volumeMl: data['volume_ml'] as int?,
      alcoholContent: _parseDouble(data['alcohol_content']),
      description: data['description'] as String?,
      imageUrl: data['image_url'] as String?,
      isAvailable: data['is_available'] as bool? ?? true,
      isFeatured: data['is_featured'] as bool? ?? false,
      createdAt: data['created_at'] != null 
          ? DateTime.parse(data['created_at'] as String)
          : null,
      updatedAt: data['updated_at'] != null 
          ? DateTime.parse(data['updated_at'] as String)
          : null,
    );
  }

  /// Helper method to parse price from various formats
  static double _parsePrice(dynamic price) {
    if (price == null) return 0.0;
    if (price is num) return price.toDouble();
    if (price is String) {
      final parsed = double.tryParse(price);
      return parsed ?? 0.0;
    }
    return 0.0;
  }

  /// Helper method to parse double from various formats
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }
}

extension BottleX on Bottle {
  /// Format price for display
  String get formattedPrice => '\$${price.toStringAsFixed(0)}';
  
  /// Get category display name
  String get categoryDisplayName {
    switch (category.toLowerCase()) {
      case 'wine':
        return 'Wine';
      case 'beer':
        return 'Beer';
      case 'spirits':
        return 'Spirits';
      case 'champagne':
        return 'Champagne';
      case 'cocktail':
        return 'Cocktail';
      case 'non_alcoholic':
        return 'Non-Alcoholic';
      default:
        return category;
    }
  }
  
  /// Get alcohol content display
  String? get alcoholContentDisplay {
    if (alcoholContent == null) return null;
    return '${alcoholContent!.toStringAsFixed(1)}% ABV';
  }
  
  /// Get volume display
  String? get volumeDisplay {
    if (volumeMl == null) return null;
    if (volumeMl! >= 1000) {
      final liters = volumeMl! / 1000;
      return '${liters.toStringAsFixed(1)}L';
    }
    return '${volumeMl}ml';
  }
} 