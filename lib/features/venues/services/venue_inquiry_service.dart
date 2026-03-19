import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/venue.dart';

class VenueInquiryService {
  static final VenueInquiryService _instance = VenueInquiryService._internal();
  factory VenueInquiryService() => _instance;
  VenueInquiryService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  /// Submit a venue inquiry
  Future<VenueInquiry> submitInquiry({
    required String venueId,
    required String eventName,
    required DateTime eventDate,
    required String startTime,
    required String endTime,
    required int expectedGuests,
    required String message,
    Map<String, dynamic>? additionalDetails,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final data = {
      'venue_id': venueId,
      'organizer_id': userId,
      'event_name': eventName,
      'event_date': eventDate.toIso8601String(),
      'start_time': startTime,
      'end_time': endTime,
      'expected_guests': expectedGuests,
      'message': message,
      'status': 'pending',
      'additional_details': additionalDetails,
    };

    final response = await _supabase
        .from('venue_inquiries')
        .insert(data)
        .select()
        .single();

    return VenueInquiry.fromSupabase(response);
  }

  /// Get all inquiries for an organizer
  Future<List<VenueInquiry>> getOrganizerInquiries() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final response = await _supabase
        .from('venue_inquiries')
        .select('''
          *,
          venues!inner(name, image_url)
        ''')
        .eq('organizer_id', userId)
        .order('created_at', ascending: false);

    return (response as List).map((item) {
      final venue = item['venues'] as Map<String, dynamic>?;
      return VenueInquiry.fromSupabase({
        ...item,
        'venue_name': venue?['name'],
        'venue_image_url': venue?['image_url'],
      });
    }).toList();
  }

  /// Get a specific inquiry by ID
  Future<VenueInquiry> getInquiryById(String inquiryId) async {
    final response = await _supabase
        .from('venue_inquiries')
        .select('''
          *,
          venues!inner(name, image_url),
          users!inner(full_name, email)
        ''')
        .eq('id', inquiryId)
        .single();

    final venue = response['venues'] as Map<String, dynamic>?;
    final user = response['users'] as Map<String, dynamic>?;

    return VenueInquiry.fromSupabase({
      ...response,
      'venue_name': venue?['name'],
      'venue_image_url': venue?['image_url'],
      'organizer_name': user?['full_name'],
      'organizer_email': user?['email'],
    });
  }

  /// Cancel an inquiry
  Future<void> cancelInquiry(String inquiryId) async {
    await _supabase
        .from('venue_inquiries')
        .update({'status': 'cancelled'})
        .eq('id', inquiryId);
  }

  /// Get venue availability for a specific date/time
  Future<bool> checkVenueAvailability({
    required String venueId,
    required DateTime eventDate,
    required String startTime,
    required String endTime,
  }) async {
    final response = await _supabase
        .from('venue_inquiries')
        .select('id')
        .eq('venue_id', venueId)
        .eq('event_date', eventDate.toIso8601String().split('T')[0])
        .inFilter('status', ['accepted', 'pending']);

    return (response as List).isEmpty;
  }
}
