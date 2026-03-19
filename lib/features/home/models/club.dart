import 'package:freezed_annotation/freezed_annotation.dart';

part 'club.freezed.dart';
part 'club.g.dart';

@freezed
class Club with _$Club {
  const factory Club({
    required String id,
    required String name,
    required String imageUrl,
    required double rating,
    required String location,
    required String priceRange,
    String? description,
    String? phone,
    String? email,
    String? websiteUrl,
    @Default(0) int reviewCount,
    String? categoryId,
    String? categoryName,
    Map<String, dynamic>? openingHours,
    String? dressCode,
    String? ageRequirement,
    @Default(true) bool isActive,
    int? maxGuestsPerBooking,
    int? advanceBookingHours,
    int? timeSlotDurationMinutes,
    double? latitude,
    double? longitude,
    String? contactNumber,
  }) = _Club;

  factory Club.fromJson(Map<String, dynamic> json) => _$ClubFromJson(json);
  
  // Factory method to create from Supabase data
  factory Club.fromSupabase(Map<String, dynamic> data) {
    try {
      print('Parsing club data: $data');
      
      // Convert price from cents to display format
      final priceMin = data['price_min'] != null ? (double.parse(data['price_min'].toString()) / 100).round() : 30;
      final priceMax = data['price_max'] != null ? (double.parse(data['price_max'].toString()) / 100).round() : 80;
      
      // Handle category data - might be in 'categories' object or directly in data
      String? categoryName;
      if (data['category_name'] != null) {
        categoryName = data['category_name'];
      } else if (data['categories'] != null && data['categories']['name'] != null) {
        categoryName = data['categories']['name'];
      }
      
      final club = Club(
        id: data['id']?.toString() ?? '',
        name: data['name']?.toString() ?? 'Unknown Club',
        imageUrl: data['image_url']?.toString() ?? 'https://images.unsplash.com/photo-1516997121675-4c2d1684aa3e?w=400&h=300&fit=crop',
        rating: double.tryParse(data['avg_rating']?.toString() ?? '0.0') ?? 0.0,
        location: data['location']?.toString() ?? 'Unknown Location',
        priceRange: '\$$priceMin-$priceMax',
        description: data['description']?.toString(),
        phone: data['phone']?.toString(),
        email: data['email']?.toString(),
        websiteUrl: data['website_url']?.toString(),
        reviewCount: int.tryParse(data['review_count']?.toString() ?? '0') ?? 0,
        categoryId: data['category_id']?.toString(),
        categoryName: categoryName,
        openingHours: data['opening_hours'] as Map<String, dynamic>?,
        dressCode: data['dress_code']?.toString(),
        ageRequirement: data['age_requirement']?.toString(),
        isActive: data['is_active'] == true,
        maxGuestsPerBooking: int.tryParse(data['max_guests_per_booking']?.toString() ?? '20'),
        advanceBookingHours: int.tryParse(data['advance_booking_hours']?.toString() ?? '2'),
        timeSlotDurationMinutes: int.tryParse(data['time_slot_duration_minutes']?.toString() ?? '30'),
        latitude: double.tryParse(data['latitude']?.toString() ?? '0.0'),
        longitude: double.tryParse(data['longitude']?.toString() ?? '0.0'),
        contactNumber: data['contact_number']?.toString(),
      );
      
      print('Successfully parsed club: ${club.name}');
      return club;
    } catch (e, stackTrace) {
      print('Error parsing club data: $e');
      print('Data: $data');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }
} 