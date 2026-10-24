import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';
part 'category.g.dart';

@freezed
class Category with _$Category {
  const factory Category({
    required String id,
    required String name,
    required String icon,
    String? description,
    String? color,
    @Default(true) bool isActive,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
  
  // Factory method to create from Supabase data
  factory Category.fromSupabase(Map<String, dynamic> data) {
    return Category(
      id: data['id'],
      name: data['name'],
      icon: data['icon'] ?? 'category',
      description: data['description'],
      color: data['color'],
      isActive: data['is_active'] ?? true,
    );
  }
} 