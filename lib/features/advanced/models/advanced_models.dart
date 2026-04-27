import 'package:freezed_annotation/freezed_annotation.dart';

part 'advanced_models.freezed.dart';
part 'advanced_models.g.dart';

// Analytics Models
@freezed
class AnalyticsEvent with _$AnalyticsEvent {
  const factory AnalyticsEvent({
    required String eventName,
    required DateTime timestamp,
    Map<String, dynamic>? parameters,
    String? userId,
    String? sessionId,
  }) = _AnalyticsEvent;

  factory AnalyticsEvent.fromJson(Map<String, dynamic> json) => _$AnalyticsEventFromJson(json);
}

// Feedback Models
enum FeedbackType {
  bug,
  feature,
  improvement,
  complaint,
  praise,
  other,
}

enum FeedbackStatus {
  submitted,
  reviewing,
  inProgress,
  resolved,
  closed,
}

@freezed
class Feedback with _$Feedback {
  const factory Feedback({
    required String id,
    required String userId,
    required FeedbackType type,
    required String title,
    required String description,
    @Default(FeedbackStatus.submitted) FeedbackStatus status,
    @Default([]) List<String> attachments,
    String? contactEmail,
    Map<String, dynamic>? deviceInfo,
    required DateTime createdAt,
    DateTime? resolvedAt,
    String? adminResponse,
  }) = _Feedback;

  factory Feedback.fromJson(Map<String, dynamic> json) => _$FeedbackFromJson(json);

  factory Feedback.fromSupabase(Map<String, dynamic> data) => Feedback(
        id: data['id'] as String,
        userId: data['user_id'] as String,
        type: FeedbackType.values.firstWhere(
          (e) => e.name == data['type'],
          orElse: () => FeedbackType.other,
        ),
        title: data['title'] as String,
        description: data['description'] as String,
        status: FeedbackStatus.values.firstWhere(
          (e) => e.name == data['status'],
          orElse: () => FeedbackStatus.submitted,
        ),
        attachments: List<String>.from(data['attachments'] as List? ?? []),
        contactEmail: data['contact_email'] as String?,
        deviceInfo: data['device_info'] as Map<String, dynamic>?,
        createdAt: DateTime.parse(data['created_at'] as String),
        resolvedAt: data['resolved_at'] != null ? DateTime.parse(data['resolved_at'] as String) : null,
        adminResponse: data['admin_response'] as String?,
      );
}

// Referral Models
@freezed
class Referral with _$Referral {
  const factory Referral({
    required String id,
    required String referrerId,
    required String referralCode,
    String? referredUserId,
    required DateTime createdAt,
    DateTime? completedAt,
    @Default(false) bool isCompleted,
    @Default(0) int pointsEarned,
    String? campaignId,
  }) = _Referral;

  factory Referral.fromJson(Map<String, dynamic> json) => _$ReferralFromJson(json);

  factory Referral.fromSupabase(Map<String, dynamic> data) => Referral(
        id: data['id'] as String,
        referrerId: data['referrer_id'] as String,
        referralCode: data['referral_code'] as String,
        referredUserId: data['referred_user_id'] as String?,
        createdAt: DateTime.parse(data['created_at'] as String),
        completedAt: data['completed_at'] != null ? DateTime.parse(data['completed_at'] as String) : null,
        isCompleted: data['is_completed'] as bool? ?? false,
        pointsEarned: data['points_earned'] as int? ?? 0,
        campaignId: data['campaign_id'] as String?,
      );
}

// Onboarding Models
enum OnboardingStep {
  welcome,
  permissions,
  profile,
  preferences,
  tutorial,
  complete,
}

@freezed
class OnboardingProgress with _$OnboardingProgress {
  const factory OnboardingProgress({
    required String userId,
    @Default(OnboardingStep.welcome) OnboardingStep currentStep,
    @Default({}) Map<String, bool> completedSteps,
    @Default(false) bool isComplete,
    DateTime? completedAt,
  }) = _OnboardingProgress;

  factory OnboardingProgress.fromJson(Map<String, dynamic> json) => _$OnboardingProgressFromJson(json);

  factory OnboardingProgress.fromSupabase(Map<String, dynamic> data) => OnboardingProgress(
        userId: data['user_id'] as String,
        currentStep: OnboardingStep.values.firstWhere(
          (e) => e.name == data['current_step'],
          orElse: () => OnboardingStep.welcome,
        ),
        completedSteps: Map<String, bool>.from(data['completed_steps'] as Map? ?? {}),
        isComplete: data['is_complete'] as bool? ?? false,
        completedAt: data['completed_at'] != null ? DateTime.parse(data['completed_at'] as String) : null,
      );
}

// Offline Sync Models
enum SyncStatus {
  pending,
  syncing,
  synced,
  failed,
}

@freezed
class SyncOperation with _$SyncOperation {
  const factory SyncOperation({
    required String id,
    required String operationType,
    required String tableName,
    required Map<String, dynamic> data,
    @Default(SyncStatus.pending) SyncStatus status,
    required DateTime createdAt,
    DateTime? syncedAt,
    int? retryCount,
    String? errorMessage,
  }) = _SyncOperation;

  factory SyncOperation.fromJson(Map<String, dynamic> json) => _$SyncOperationFromJson(json);
}

// Deep Link Models
enum DeepLinkType {
  venue,
  event,
  post,
  user,
  booking,
  promotion,
}

@freezed
class DeepLink with _$DeepLink {
  const factory DeepLink({
    required DeepLinkType type,
    required String id,
    Map<String, String>? parameters,
    String? path,
  }) = _DeepLink;

  factory DeepLink.fromJson(Map<String, dynamic> json) => _$DeepLinkFromJson(json);
}

// Support Ticket Models
enum TicketPriority {
  low,
  medium,
  high,
  urgent,
}

enum TicketCategory {
  account,
  booking,
  payment,
  technical,
  venue,
  event,
  other,
}

@freezed
class SupportTicket with _$SupportTicket {
  const factory SupportTicket({
    required String id,
    required String userId,
    required TicketCategory category,
    required String subject,
    required String description,
    @Default(TicketPriority.medium) TicketPriority priority,
    @Default(FeedbackStatus.submitted) FeedbackStatus status,
    @Default([]) List<String> attachments,
    String? assignedTo,
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? resolvedAt,
  }) = _SupportTicket;

  factory SupportTicket.fromJson(Map<String, dynamic> json) => _$SupportTicketFromJson(json);

  factory SupportTicket.fromSupabase(Map<String, dynamic> data) => SupportTicket(
        id: data['id'] as String,
        userId: data['user_id'] as String,
        category: TicketCategory.values.firstWhere(
          (e) => e.name == data['category'],
          orElse: () => TicketCategory.other,
        ),
        subject: data['subject'] as String,
        description: data['description'] as String,
        priority: TicketPriority.values.firstWhere(
          (e) => e.name == data['priority'],
          orElse: () => TicketPriority.medium,
        ),
        status: FeedbackStatus.values.firstWhere(
          (e) => e.name == data['status'],
          orElse: () => FeedbackStatus.submitted,
        ),
        attachments: List<String>.from(data['attachments'] as List? ?? []),
        assignedTo: data['assigned_to'] as String?,
        createdAt: DateTime.parse(data['created_at'] as String),
        updatedAt: data['updated_at'] != null ? DateTime.parse(data['updated_at'] as String) : null,
        resolvedAt: data['resolved_at'] != null ? DateTime.parse(data['resolved_at'] as String) : null,
      );
}

@freezed
class TicketMessage with _$TicketMessage {
  const factory TicketMessage({
    required String id,
    required String ticketId,
    required String senderId,
    required String message,
    @Default([]) List<String> attachments,
    @Default(false) bool isStaff,
    required DateTime createdAt,
  }) = _TicketMessage;

  factory TicketMessage.fromJson(Map<String, dynamic> json) => _$TicketMessageFromJson(json);

  factory TicketMessage.fromSupabase(Map<String, dynamic> data) => TicketMessage(
        id: data['id'] as String,
        ticketId: data['ticket_id'] as String,
        senderId: data['sender_id'] as String,
        message: data['message'] as String,
        attachments: List<String>.from(data['attachments'] as List? ?? []),
        isStaff: data['is_staff'] as bool? ?? false,
        createdAt: DateTime.parse(data['created_at'] as String),
      );
}
