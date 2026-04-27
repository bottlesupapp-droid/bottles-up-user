import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/special_request.dart';

class SpecialRequestService {
  static final SpecialRequestService _instance = SpecialRequestService._internal();
  factory SpecialRequestService() => _instance;
  SpecialRequestService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Submit special request
  Future<SpecialRequest> submitRequest({
    required String bookingId,
    required RequestType type,
    required String title,
    required String description,
    bool isPriority = false,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase.from('special_requests').insert({
        'booking_id': bookingId,
        'user_id': currentUser.id,
        'type': type.name,
        'title': title,
        'description': description,
        'is_priority': isPriority,
        'status': 'pending',
      }).select().single();

      return SpecialRequest.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to submit special request: $e');
    }
  }

  // Get booking requests
  Future<List<SpecialRequest>> getBookingRequests(String bookingId) async {
    try {
      final response = await _supabase
          .from('special_requests')
          .select()
          .eq('booking_id', bookingId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((item) => SpecialRequest.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get user requests
  Future<List<SpecialRequest>> getUserRequests() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return [];

      final response = await _supabase
          .from('special_requests')
          .select()
          .eq('user_id', currentUser.id)
          .order('created_at', ascending: false);

      return (response as List)
          .map((item) => SpecialRequest.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Update request status
  Future<void> updateRequestStatus({
    required String requestId,
    required RequestStatus status,
    String? responseMessage,
  }) async {
    try {
      final updates = <String, dynamic>{
        'status': status.name,
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (responseMessage != null) {
        updates['response_message'] = responseMessage;
        updates['response_time'] = DateTime.now().toIso8601String();
      }

      await _supabase
          .from('special_requests')
          .update(updates)
          .eq('id', requestId);
    } catch (e) {
      throw Exception('Failed to update request status: $e');
    }
  }

  // Delete request
  Future<void> deleteRequest(String requestId) async {
    try {
      await _supabase
          .from('special_requests')
          .delete()
          .eq('id', requestId);
    } catch (e) {
      throw Exception('Failed to delete request: $e');
    }
  }

  // Get request templates
  Future<List<RequestTemplate>> getRequestTemplates({RequestType? type}) async {
    try {
      var query = _supabase.from('request_templates').select();

      if (type != null) {
        query = query.eq('type', type.name);
      }

      final response = await query.order('is_popular', ascending: false);

      return (response as List)
          .map((item) => RequestTemplate(
                id: item['id'] as String,
                type: RequestType.values.firstWhere(
                  (e) => e.name == item['type'],
                  orElse: () => RequestType.other,
                ),
                title: item['title'] as String,
                description: item['description'] as String,
                exampleText: item['example_text'] as String?,
                isPopular: item['is_popular'] as bool? ?? false,
              ))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get popular request templates
  Future<List<RequestTemplate>> getPopularTemplates() async {
    try {
      final response = await _supabase
          .from('request_templates')
          .select()
          .eq('is_popular', true)
          .limit(5);

      return (response as List)
          .map((item) => RequestTemplate(
                id: item['id'] as String,
                type: RequestType.values.firstWhere(
                  (e) => e.name == item['type'],
                  orElse: () => RequestType.other,
                ),
                title: item['title'] as String,
                description: item['description'] as String,
                exampleText: item['example_text'] as String?,
                isPopular: item['is_popular'] as bool? ?? false,
              ))
          .toList();
    } catch (e) {
      return _getDefaultTemplates();
    }
  }

  // Default templates fallback
  List<RequestTemplate> _getDefaultTemplates() {
    return [
      const RequestTemplate(
        id: '1',
        type: RequestType.celebration,
        title: 'Birthday Celebration',
        description: 'Special arrangements for birthday',
        exampleText: 'Please help arrange a birthday surprise with cake and sparklers',
        isPopular: true,
      ),
      const RequestTemplate(
        id: '2',
        type: RequestType.dietary,
        title: 'Dietary Restrictions',
        description: 'Food allergies or dietary needs',
        exampleText: 'I have a gluten allergy and need gluten-free options',
        isPopular: true,
      ),
      const RequestTemplate(
        id: '3',
        type: RequestType.music,
        title: 'Music Request',
        description: 'Specific music preferences',
        exampleText: 'Please play more hip-hop music during our time',
        isPopular: true,
      ),
      const RequestTemplate(
        id: '4',
        type: RequestType.seating,
        title: 'Seating Preference',
        description: 'Preferred table location',
        exampleText: 'We prefer a table near the dance floor',
        isPopular: true,
      ),
      const RequestTemplate(
        id: '5',
        type: RequestType.accessibility,
        title: 'Accessibility Needs',
        description: 'Wheelchair access or other needs',
        exampleText: 'Wheelchair accessible table needed',
        isPopular: true,
      ),
    ];
  }

  // Track request metrics
  Future<Map<String, int>> getRequestMetrics(String bookingId) async {
    try {
      final requests = await getBookingRequests(bookingId);

      return {
        'total': requests.length,
        'pending': requests.where((r) => r.status == RequestStatus.pending).length,
        'approved': requests.where((r) => r.status == RequestStatus.approved).length,
        'declined': requests.where((r) => r.status == RequestStatus.declined).length,
        'completed': requests.where((r) => r.status == RequestStatus.completed).length,
      };
    } catch (e) {
      return {};
    }
  }
}
