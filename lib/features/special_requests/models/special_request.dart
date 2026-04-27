import 'package:freezed_annotation/freezed_annotation.dart';

part 'special_request.freezed.dart';
part 'special_request.g.dart';

enum RequestType {
  dietary,
  accessibility,
  music,
  seating,
  celebration,
  other,
}

enum RequestStatus {
  pending,
  acknowledged,
  approved,
  declined,
  completed,
}

@freezed
class SpecialRequest with _$SpecialRequest {
  const factory SpecialRequest({
    required String id,
    required String bookingId,
    required String userId,
    required RequestType type,
    required String title,
    required String description,
    @Default(RequestStatus.pending) RequestStatus status,
    String? responseMessage,
    DateTime? responseTime,
    @Default(false) bool isPriority,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _SpecialRequest;

  factory SpecialRequest.fromJson(Map<String, dynamic> json) =>
      _$SpecialRequestFromJson(json);

  factory SpecialRequest.fromSupabase(Map<String, dynamic> data) {
    return SpecialRequest(
      id: data['id'] as String,
      bookingId: data['booking_id'] as String,
      userId: data['user_id'] as String,
      type: RequestType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => RequestType.other,
      ),
      title: data['title'] as String,
      description: data['description'] as String,
      status: RequestStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => RequestStatus.pending,
      ),
      responseMessage: data['response_message'] as String?,
      responseTime: data['response_time'] != null
          ? DateTime.parse(data['response_time'] as String)
          : null,
      isPriority: data['is_priority'] as bool? ?? false,
      createdAt: DateTime.parse(data['created_at'] as String),
      updatedAt: data['updated_at'] != null
          ? DateTime.parse(data['updated_at'] as String)
          : null,
    );
  }
}

@freezed
class RequestTemplate with _$RequestTemplate {
  const factory RequestTemplate({
    required String id,
    required RequestType type,
    required String title,
    required String description,
    String? exampleText,
    @Default(false) bool isPopular,
  }) = _RequestTemplate;

  factory RequestTemplate.fromJson(Map<String, dynamic> json) =>
      _$RequestTemplateFromJson(json);
}
