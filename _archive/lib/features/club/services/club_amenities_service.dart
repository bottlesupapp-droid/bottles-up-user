import 'package:supabase_flutter/supabase_flutter.dart';

class ClubAmenitiesService {
  static ClubAmenitiesService? _instance;
  static ClubAmenitiesService get instance => _instance ??= ClubAmenitiesService._();
  
  ClubAmenitiesService._();

  final SupabaseClient _supabase = Supabase.instance.client;

  /// Get amenities for a specific club
  Future<List<ClubAmenity>> getAmenitiesForClub(String clubId) async {
    try {
      final response = await _supabase
          .from('club_amenities')
          .select('*')
          .eq('club_id', clubId)
          .order('name');

      return response
          .map<ClubAmenity>((data) => ClubAmenity.fromSupabase(data))
          .toList();
    } catch (e) {
      return _getFallbackAmenities();
    }
  }

  /// Fallback amenities when database is unavailable
  List<ClubAmenity> _getFallbackAmenities() {
    return [
      const ClubAmenity(
        id: '1',
        clubId: '',
        name: 'VIP seating areas',
        icon: 'vip',
      ),
      const ClubAmenity(
        id: '2',
        clubId: '',
        name: 'Premium sound system',
        icon: 'sound',
      ),
      const ClubAmenity(
        id: '3',
        clubId: '',
        name: 'Full bar service',
        icon: 'bar',
      ),
      const ClubAmenity(
        id: '4',
        clubId: '',
        name: 'Live DJ performances',
        icon: 'music',
      ),
      const ClubAmenity(
        id: '5',
        clubId: '',
        name: 'Private event hosting',
        icon: 'event',
      ),
    ];
  }
}

class ClubAmenity {
  final String id;
  final String clubId;
  final String name;
  final String? icon;

  const ClubAmenity({
    required this.id,
    required this.clubId,
    required this.name,
    this.icon,
  });

  factory ClubAmenity.fromSupabase(Map<String, dynamic> data) {
    return ClubAmenity(
      id: data['id'],
      clubId: data['club_id'],
      name: data['name'],
      icon: data['icon'],
    );
  }
} 