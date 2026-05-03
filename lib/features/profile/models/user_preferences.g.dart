// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserPreferencesImpl _$$UserPreferencesImplFromJson(
        Map<String, dynamic> json) =>
    _$UserPreferencesImpl(
      userId: json['userId'] as String,
      notificationPreference: $enumDecodeNullable(
              _$NotificationPreferenceEnumMap,
              json['notificationPreference']) ??
          NotificationPreference.all,
      bookingReminders: json['bookingReminders'] as bool? ?? true,
      eventAnnouncements: json['eventAnnouncements'] as bool? ?? true,
      friendActivity: json['friendActivity'] as bool? ?? true,
      promotionalOffers: json['promotionalOffers'] as bool? ?? true,
      loyaltyUpdates: json['loyaltyUpdates'] as bool? ?? true,
      emailNotifications: json['emailNotifications'] as bool? ?? false,
      pushNotifications: json['pushNotifications'] as bool? ?? true,
      smsNotifications: json['smsNotifications'] as bool? ?? false,
      profileVisible: json['profileVisible'] as bool? ?? true,
      showActivityToFriends: json['showActivityToFriends'] as bool? ?? true,
      showActivityPublic: json['showActivityPublic'] as bool? ?? false,
      allowFriendRequests: json['allowFriendRequests'] as bool? ?? true,
      shareLocationWithFriends:
          json['shareLocationWithFriends'] as bool? ?? false,
      themeMode: $enumDecodeNullable(_$ThemeModeEnumMap, json['themeMode']) ??
          ThemeMode.system,
      distanceUnit:
          $enumDecodeNullable(_$DistanceUnitEnumMap, json['distanceUnit']) ??
              DistanceUnit.kilometers,
      currency:
          $enumDecodeNullable(_$CurrencyPreferenceEnumMap, json['currency']) ??
              CurrencyPreference.usd,
      language: json['language'] as String? ?? 'en',
      showTutorials: json['showTutorials'] as bool? ?? true,
      personalizedRecommendations:
          json['personalizedRecommendations'] as bool? ?? true,
      saveSearchHistory: json['saveSearchHistory'] as bool? ?? true,
      favoriteCategories: (json['favoriteCategories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      savedFilters: json['savedFilters'] as Map<String, dynamic>? ?? const {},
      autoConfirmBookings: json['autoConfirmBookings'] as bool? ?? false,
      sendBookingConfirmation: json['sendBookingConfirmation'] as bool? ?? true,
      defaultPartySize: (json['defaultPartySize'] as num?)?.toInt() ?? 2,
      preferredPaymentMethod: json['preferredPaymentMethod'] as String?,
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 1.0,
      highContrast: json['highContrast'] as bool? ?? false,
      screenReaderOptimized: json['screenReaderOptimized'] as bool? ?? false,
      customSettings: json['customSettings'] as Map<String, dynamic>?,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$UserPreferencesImplToJson(
        _$UserPreferencesImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'notificationPreference':
          _$NotificationPreferenceEnumMap[instance.notificationPreference]!,
      'bookingReminders': instance.bookingReminders,
      'eventAnnouncements': instance.eventAnnouncements,
      'friendActivity': instance.friendActivity,
      'promotionalOffers': instance.promotionalOffers,
      'loyaltyUpdates': instance.loyaltyUpdates,
      'emailNotifications': instance.emailNotifications,
      'pushNotifications': instance.pushNotifications,
      'smsNotifications': instance.smsNotifications,
      'profileVisible': instance.profileVisible,
      'showActivityToFriends': instance.showActivityToFriends,
      'showActivityPublic': instance.showActivityPublic,
      'allowFriendRequests': instance.allowFriendRequests,
      'shareLocationWithFriends': instance.shareLocationWithFriends,
      'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
      'distanceUnit': _$DistanceUnitEnumMap[instance.distanceUnit]!,
      'currency': _$CurrencyPreferenceEnumMap[instance.currency]!,
      'language': instance.language,
      'showTutorials': instance.showTutorials,
      'personalizedRecommendations': instance.personalizedRecommendations,
      'saveSearchHistory': instance.saveSearchHistory,
      'favoriteCategories': instance.favoriteCategories,
      'savedFilters': instance.savedFilters,
      'autoConfirmBookings': instance.autoConfirmBookings,
      'sendBookingConfirmation': instance.sendBookingConfirmation,
      'defaultPartySize': instance.defaultPartySize,
      'preferredPaymentMethod': instance.preferredPaymentMethod,
      'fontSize': instance.fontSize,
      'highContrast': instance.highContrast,
      'screenReaderOptimized': instance.screenReaderOptimized,
      'customSettings': instance.customSettings,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$NotificationPreferenceEnumMap = {
  NotificationPreference.all: 'all',
  NotificationPreference.important: 'important',
  NotificationPreference.none: 'none',
};

const _$ThemeModeEnumMap = {
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
  ThemeMode.system: 'system',
};

const _$DistanceUnitEnumMap = {
  DistanceUnit.kilometers: 'kilometers',
  DistanceUnit.miles: 'miles',
};

const _$CurrencyPreferenceEnumMap = {
  CurrencyPreference.usd: 'usd',
  CurrencyPreference.eur: 'eur',
  CurrencyPreference.gbp: 'gbp',
  CurrencyPreference.cad: 'cad',
  CurrencyPreference.aud: 'aud',
};

_$PrivacySettingsImpl _$$PrivacySettingsImplFromJson(
        Map<String, dynamic> json) =>
    _$PrivacySettingsImpl(
      userId: json['userId'] as String,
      showEmail: json['showEmail'] as bool? ?? true,
      showPhone: json['showPhone'] as bool? ?? false,
      showDateOfBirth: json['showDateOfBirth'] as bool? ?? true,
      showGender: json['showGender'] as bool? ?? true,
      showLocation: json['showLocation'] as bool? ?? true,
      allowTagging: json['allowTagging'] as bool? ?? true,
      allowMentions: json['allowMentions'] as bool? ?? true,
      allowDataSharing: json['allowDataSharing'] as bool? ?? false,
      allowMarketingEmails: json['allowMarketingEmails'] as bool? ?? false,
      blockedUsers: (json['blockedUsers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$PrivacySettingsImplToJson(
        _$PrivacySettingsImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'showEmail': instance.showEmail,
      'showPhone': instance.showPhone,
      'showDateOfBirth': instance.showDateOfBirth,
      'showGender': instance.showGender,
      'showLocation': instance.showLocation,
      'allowTagging': instance.allowTagging,
      'allowMentions': instance.allowMentions,
      'allowDataSharing': instance.allowDataSharing,
      'allowMarketingEmails': instance.allowMarketingEmails,
      'blockedUsers': instance.blockedUsers,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$NotificationSettingsImpl _$$NotificationSettingsImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationSettingsImpl(
      userId: json['userId'] as String,
      pushEnabled: json['pushEnabled'] as bool? ?? true,
      pushBookings: json['pushBookings'] as bool? ?? true,
      pushEvents: json['pushEvents'] as bool? ?? true,
      pushMessages: json['pushMessages'] as bool? ?? true,
      pushFriendRequests: json['pushFriendRequests'] as bool? ?? true,
      pushPromotions: json['pushPromotions'] as bool? ?? true,
      emailEnabled: json['emailEnabled'] as bool? ?? false,
      emailBookings: json['emailBookings'] as bool? ?? true,
      emailEvents: json['emailEvents'] as bool? ?? true,
      emailMessages: json['emailMessages'] as bool? ?? false,
      emailFriendRequests: json['emailFriendRequests'] as bool? ?? true,
      emailPromotions: json['emailPromotions'] as bool? ?? false,
      emailWeeklyDigest: json['emailWeeklyDigest'] as bool? ?? false,
      smsEnabled: json['smsEnabled'] as bool? ?? false,
      smsBookingReminders: json['smsBookingReminders'] as bool? ?? true,
      smsEventReminders: json['smsEventReminders'] as bool? ?? false,
      quietHoursEnabled: json['quietHoursEnabled'] as bool? ?? false,
      quietHoursStart: json['quietHoursStart'] as String?,
      quietHoursEnd: json['quietHoursEnd'] as String?,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$NotificationSettingsImplToJson(
        _$NotificationSettingsImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'pushEnabled': instance.pushEnabled,
      'pushBookings': instance.pushBookings,
      'pushEvents': instance.pushEvents,
      'pushMessages': instance.pushMessages,
      'pushFriendRequests': instance.pushFriendRequests,
      'pushPromotions': instance.pushPromotions,
      'emailEnabled': instance.emailEnabled,
      'emailBookings': instance.emailBookings,
      'emailEvents': instance.emailEvents,
      'emailMessages': instance.emailMessages,
      'emailFriendRequests': instance.emailFriendRequests,
      'emailPromotions': instance.emailPromotions,
      'emailWeeklyDigest': instance.emailWeeklyDigest,
      'smsEnabled': instance.smsEnabled,
      'smsBookingReminders': instance.smsBookingReminders,
      'smsEventReminders': instance.smsEventReminders,
      'quietHoursEnabled': instance.quietHoursEnabled,
      'quietHoursStart': instance.quietHoursStart,
      'quietHoursEnd': instance.quietHoursEnd,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
