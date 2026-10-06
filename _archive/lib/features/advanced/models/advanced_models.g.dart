// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'advanced_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnalyticsEventImpl _$$AnalyticsEventImplFromJson(Map<String, dynamic> json) =>
    _$AnalyticsEventImpl(
      eventName: json['eventName'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      parameters: json['parameters'] as Map<String, dynamic>?,
      userId: json['userId'] as String?,
      sessionId: json['sessionId'] as String?,
    );

Map<String, dynamic> _$$AnalyticsEventImplToJson(
        _$AnalyticsEventImpl instance) =>
    <String, dynamic>{
      'eventName': instance.eventName,
      'timestamp': instance.timestamp.toIso8601String(),
      'parameters': instance.parameters,
      'userId': instance.userId,
      'sessionId': instance.sessionId,
    };

_$FeedbackImpl _$$FeedbackImplFromJson(Map<String, dynamic> json) =>
    _$FeedbackImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: $enumDecode(_$FeedbackTypeEnumMap, json['type']),
      title: json['title'] as String,
      description: json['description'] as String,
      status: $enumDecodeNullable(_$FeedbackStatusEnumMap, json['status']) ??
          FeedbackStatus.submitted,
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      contactEmail: json['contactEmail'] as String?,
      deviceInfo: json['deviceInfo'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      resolvedAt: json['resolvedAt'] == null
          ? null
          : DateTime.parse(json['resolvedAt'] as String),
      adminResponse: json['adminResponse'] as String?,
    );

Map<String, dynamic> _$$FeedbackImplToJson(_$FeedbackImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'type': _$FeedbackTypeEnumMap[instance.type]!,
      'title': instance.title,
      'description': instance.description,
      'status': _$FeedbackStatusEnumMap[instance.status]!,
      'attachments': instance.attachments,
      'contactEmail': instance.contactEmail,
      'deviceInfo': instance.deviceInfo,
      'createdAt': instance.createdAt.toIso8601String(),
      'resolvedAt': instance.resolvedAt?.toIso8601String(),
      'adminResponse': instance.adminResponse,
    };

const _$FeedbackTypeEnumMap = {
  FeedbackType.bug: 'bug',
  FeedbackType.feature: 'feature',
  FeedbackType.improvement: 'improvement',
  FeedbackType.complaint: 'complaint',
  FeedbackType.praise: 'praise',
  FeedbackType.other: 'other',
};

const _$FeedbackStatusEnumMap = {
  FeedbackStatus.submitted: 'submitted',
  FeedbackStatus.reviewing: 'reviewing',
  FeedbackStatus.inProgress: 'inProgress',
  FeedbackStatus.resolved: 'resolved',
  FeedbackStatus.closed: 'closed',
};

_$ReferralImpl _$$ReferralImplFromJson(Map<String, dynamic> json) =>
    _$ReferralImpl(
      id: json['id'] as String,
      referrerId: json['referrerId'] as String,
      referralCode: json['referralCode'] as String,
      referredUserId: json['referredUserId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      isCompleted: json['isCompleted'] as bool? ?? false,
      pointsEarned: (json['pointsEarned'] as num?)?.toInt() ?? 0,
      campaignId: json['campaignId'] as String?,
    );

Map<String, dynamic> _$$ReferralImplToJson(_$ReferralImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'referrerId': instance.referrerId,
      'referralCode': instance.referralCode,
      'referredUserId': instance.referredUserId,
      'createdAt': instance.createdAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'isCompleted': instance.isCompleted,
      'pointsEarned': instance.pointsEarned,
      'campaignId': instance.campaignId,
    };

_$OnboardingProgressImpl _$$OnboardingProgressImplFromJson(
        Map<String, dynamic> json) =>
    _$OnboardingProgressImpl(
      userId: json['userId'] as String,
      currentStep:
          $enumDecodeNullable(_$OnboardingStepEnumMap, json['currentStep']) ??
              OnboardingStep.welcome,
      completedSteps: (json['completedSteps'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as bool),
          ) ??
          const {},
      isComplete: json['isComplete'] as bool? ?? false,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$$OnboardingProgressImplToJson(
        _$OnboardingProgressImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'currentStep': _$OnboardingStepEnumMap[instance.currentStep]!,
      'completedSteps': instance.completedSteps,
      'isComplete': instance.isComplete,
      'completedAt': instance.completedAt?.toIso8601String(),
    };

const _$OnboardingStepEnumMap = {
  OnboardingStep.welcome: 'welcome',
  OnboardingStep.permissions: 'permissions',
  OnboardingStep.profile: 'profile',
  OnboardingStep.preferences: 'preferences',
  OnboardingStep.tutorial: 'tutorial',
  OnboardingStep.complete: 'complete',
};

_$SyncOperationImpl _$$SyncOperationImplFromJson(Map<String, dynamic> json) =>
    _$SyncOperationImpl(
      id: json['id'] as String,
      operationType: json['operationType'] as String,
      tableName: json['tableName'] as String,
      data: json['data'] as Map<String, dynamic>,
      status: $enumDecodeNullable(_$SyncStatusEnumMap, json['status']) ??
          SyncStatus.pending,
      createdAt: DateTime.parse(json['createdAt'] as String),
      syncedAt: json['syncedAt'] == null
          ? null
          : DateTime.parse(json['syncedAt'] as String),
      retryCount: (json['retryCount'] as num?)?.toInt(),
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$$SyncOperationImplToJson(_$SyncOperationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'operationType': instance.operationType,
      'tableName': instance.tableName,
      'data': instance.data,
      'status': _$SyncStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'syncedAt': instance.syncedAt?.toIso8601String(),
      'retryCount': instance.retryCount,
      'errorMessage': instance.errorMessage,
    };

const _$SyncStatusEnumMap = {
  SyncStatus.pending: 'pending',
  SyncStatus.syncing: 'syncing',
  SyncStatus.synced: 'synced',
  SyncStatus.failed: 'failed',
};

_$DeepLinkImpl _$$DeepLinkImplFromJson(Map<String, dynamic> json) =>
    _$DeepLinkImpl(
      type: $enumDecode(_$DeepLinkTypeEnumMap, json['type']),
      id: json['id'] as String,
      parameters: (json['parameters'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      path: json['path'] as String?,
    );

Map<String, dynamic> _$$DeepLinkImplToJson(_$DeepLinkImpl instance) =>
    <String, dynamic>{
      'type': _$DeepLinkTypeEnumMap[instance.type]!,
      'id': instance.id,
      'parameters': instance.parameters,
      'path': instance.path,
    };

const _$DeepLinkTypeEnumMap = {
  DeepLinkType.venue: 'venue',
  DeepLinkType.event: 'event',
  DeepLinkType.post: 'post',
  DeepLinkType.user: 'user',
  DeepLinkType.booking: 'booking',
  DeepLinkType.promotion: 'promotion',
};

_$SupportTicketImpl _$$SupportTicketImplFromJson(Map<String, dynamic> json) =>
    _$SupportTicketImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      category: $enumDecode(_$TicketCategoryEnumMap, json['category']),
      subject: json['subject'] as String,
      description: json['description'] as String,
      priority:
          $enumDecodeNullable(_$TicketPriorityEnumMap, json['priority']) ??
              TicketPriority.medium,
      status: $enumDecodeNullable(_$FeedbackStatusEnumMap, json['status']) ??
          FeedbackStatus.submitted,
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      assignedTo: json['assignedTo'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      resolvedAt: json['resolvedAt'] == null
          ? null
          : DateTime.parse(json['resolvedAt'] as String),
    );

Map<String, dynamic> _$$SupportTicketImplToJson(_$SupportTicketImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'category': _$TicketCategoryEnumMap[instance.category]!,
      'subject': instance.subject,
      'description': instance.description,
      'priority': _$TicketPriorityEnumMap[instance.priority]!,
      'status': _$FeedbackStatusEnumMap[instance.status]!,
      'attachments': instance.attachments,
      'assignedTo': instance.assignedTo,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'resolvedAt': instance.resolvedAt?.toIso8601String(),
    };

const _$TicketCategoryEnumMap = {
  TicketCategory.account: 'account',
  TicketCategory.booking: 'booking',
  TicketCategory.payment: 'payment',
  TicketCategory.technical: 'technical',
  TicketCategory.venue: 'venue',
  TicketCategory.event: 'event',
  TicketCategory.other: 'other',
};

const _$TicketPriorityEnumMap = {
  TicketPriority.low: 'low',
  TicketPriority.medium: 'medium',
  TicketPriority.high: 'high',
  TicketPriority.urgent: 'urgent',
};

_$TicketMessageImpl _$$TicketMessageImplFromJson(Map<String, dynamic> json) =>
    _$TicketMessageImpl(
      id: json['id'] as String,
      ticketId: json['ticketId'] as String,
      senderId: json['senderId'] as String,
      message: json['message'] as String,
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isStaff: json['isStaff'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$TicketMessageImplToJson(_$TicketMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ticketId': instance.ticketId,
      'senderId': instance.senderId,
      'message': instance.message,
      'attachments': instance.attachments,
      'isStaff': instance.isStaff,
      'createdAt': instance.createdAt.toIso8601String(),
    };
