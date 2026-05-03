// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_preferences.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserPreferences _$UserPreferencesFromJson(Map<String, dynamic> json) {
  return _UserPreferences.fromJson(json);
}

/// @nodoc
mixin _$UserPreferences {
  String get userId =>
      throw _privateConstructorUsedError; // Notification preferences
  NotificationPreference get notificationPreference =>
      throw _privateConstructorUsedError;
  bool get bookingReminders => throw _privateConstructorUsedError;
  bool get eventAnnouncements => throw _privateConstructorUsedError;
  bool get friendActivity => throw _privateConstructorUsedError;
  bool get promotionalOffers => throw _privateConstructorUsedError;
  bool get loyaltyUpdates => throw _privateConstructorUsedError;
  bool get emailNotifications => throw _privateConstructorUsedError;
  bool get pushNotifications => throw _privateConstructorUsedError;
  bool get smsNotifications =>
      throw _privateConstructorUsedError; // Privacy settings
  bool get profileVisible => throw _privateConstructorUsedError;
  bool get showActivityToFriends => throw _privateConstructorUsedError;
  bool get showActivityPublic => throw _privateConstructorUsedError;
  bool get allowFriendRequests => throw _privateConstructorUsedError;
  bool get shareLocationWithFriends =>
      throw _privateConstructorUsedError; // Display preferences
  ThemeMode get themeMode => throw _privateConstructorUsedError;
  DistanceUnit get distanceUnit => throw _privateConstructorUsedError;
  CurrencyPreference get currency => throw _privateConstructorUsedError;
  String get language => throw _privateConstructorUsedError;
  bool get showTutorials =>
      throw _privateConstructorUsedError; // Search and discovery
  bool get personalizedRecommendations => throw _privateConstructorUsedError;
  bool get saveSearchHistory => throw _privateConstructorUsedError;
  List<String> get favoriteCategories => throw _privateConstructorUsedError;
  Map<String, dynamic> get savedFilters =>
      throw _privateConstructorUsedError; // Booking preferences
  bool get autoConfirmBookings => throw _privateConstructorUsedError;
  bool get sendBookingConfirmation => throw _privateConstructorUsedError;
  int get defaultPartySize => throw _privateConstructorUsedError;
  String? get preferredPaymentMethod =>
      throw _privateConstructorUsedError; // Accessibility
  double get fontSize => throw _privateConstructorUsedError;
  bool get highContrast => throw _privateConstructorUsedError;
  bool get screenReaderOptimized => throw _privateConstructorUsedError; // Other
  Map<String, dynamic>? get customSettings =>
      throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this UserPreferences to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserPreferences
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserPreferencesCopyWith<UserPreferences> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserPreferencesCopyWith<$Res> {
  factory $UserPreferencesCopyWith(
          UserPreferences value, $Res Function(UserPreferences) then) =
      _$UserPreferencesCopyWithImpl<$Res, UserPreferences>;
  @useResult
  $Res call(
      {String userId,
      NotificationPreference notificationPreference,
      bool bookingReminders,
      bool eventAnnouncements,
      bool friendActivity,
      bool promotionalOffers,
      bool loyaltyUpdates,
      bool emailNotifications,
      bool pushNotifications,
      bool smsNotifications,
      bool profileVisible,
      bool showActivityToFriends,
      bool showActivityPublic,
      bool allowFriendRequests,
      bool shareLocationWithFriends,
      ThemeMode themeMode,
      DistanceUnit distanceUnit,
      CurrencyPreference currency,
      String language,
      bool showTutorials,
      bool personalizedRecommendations,
      bool saveSearchHistory,
      List<String> favoriteCategories,
      Map<String, dynamic> savedFilters,
      bool autoConfirmBookings,
      bool sendBookingConfirmation,
      int defaultPartySize,
      String? preferredPaymentMethod,
      double fontSize,
      bool highContrast,
      bool screenReaderOptimized,
      Map<String, dynamic>? customSettings,
      DateTime updatedAt});
}

/// @nodoc
class _$UserPreferencesCopyWithImpl<$Res, $Val extends UserPreferences>
    implements $UserPreferencesCopyWith<$Res> {
  _$UserPreferencesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserPreferences
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? notificationPreference = null,
    Object? bookingReminders = null,
    Object? eventAnnouncements = null,
    Object? friendActivity = null,
    Object? promotionalOffers = null,
    Object? loyaltyUpdates = null,
    Object? emailNotifications = null,
    Object? pushNotifications = null,
    Object? smsNotifications = null,
    Object? profileVisible = null,
    Object? showActivityToFriends = null,
    Object? showActivityPublic = null,
    Object? allowFriendRequests = null,
    Object? shareLocationWithFriends = null,
    Object? themeMode = null,
    Object? distanceUnit = null,
    Object? currency = null,
    Object? language = null,
    Object? showTutorials = null,
    Object? personalizedRecommendations = null,
    Object? saveSearchHistory = null,
    Object? favoriteCategories = null,
    Object? savedFilters = null,
    Object? autoConfirmBookings = null,
    Object? sendBookingConfirmation = null,
    Object? defaultPartySize = null,
    Object? preferredPaymentMethod = freezed,
    Object? fontSize = null,
    Object? highContrast = null,
    Object? screenReaderOptimized = null,
    Object? customSettings = freezed,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      notificationPreference: null == notificationPreference
          ? _value.notificationPreference
          : notificationPreference // ignore: cast_nullable_to_non_nullable
              as NotificationPreference,
      bookingReminders: null == bookingReminders
          ? _value.bookingReminders
          : bookingReminders // ignore: cast_nullable_to_non_nullable
              as bool,
      eventAnnouncements: null == eventAnnouncements
          ? _value.eventAnnouncements
          : eventAnnouncements // ignore: cast_nullable_to_non_nullable
              as bool,
      friendActivity: null == friendActivity
          ? _value.friendActivity
          : friendActivity // ignore: cast_nullable_to_non_nullable
              as bool,
      promotionalOffers: null == promotionalOffers
          ? _value.promotionalOffers
          : promotionalOffers // ignore: cast_nullable_to_non_nullable
              as bool,
      loyaltyUpdates: null == loyaltyUpdates
          ? _value.loyaltyUpdates
          : loyaltyUpdates // ignore: cast_nullable_to_non_nullable
              as bool,
      emailNotifications: null == emailNotifications
          ? _value.emailNotifications
          : emailNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      pushNotifications: null == pushNotifications
          ? _value.pushNotifications
          : pushNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      smsNotifications: null == smsNotifications
          ? _value.smsNotifications
          : smsNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      profileVisible: null == profileVisible
          ? _value.profileVisible
          : profileVisible // ignore: cast_nullable_to_non_nullable
              as bool,
      showActivityToFriends: null == showActivityToFriends
          ? _value.showActivityToFriends
          : showActivityToFriends // ignore: cast_nullable_to_non_nullable
              as bool,
      showActivityPublic: null == showActivityPublic
          ? _value.showActivityPublic
          : showActivityPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      allowFriendRequests: null == allowFriendRequests
          ? _value.allowFriendRequests
          : allowFriendRequests // ignore: cast_nullable_to_non_nullable
              as bool,
      shareLocationWithFriends: null == shareLocationWithFriends
          ? _value.shareLocationWithFriends
          : shareLocationWithFriends // ignore: cast_nullable_to_non_nullable
              as bool,
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      distanceUnit: null == distanceUnit
          ? _value.distanceUnit
          : distanceUnit // ignore: cast_nullable_to_non_nullable
              as DistanceUnit,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as CurrencyPreference,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      showTutorials: null == showTutorials
          ? _value.showTutorials
          : showTutorials // ignore: cast_nullable_to_non_nullable
              as bool,
      personalizedRecommendations: null == personalizedRecommendations
          ? _value.personalizedRecommendations
          : personalizedRecommendations // ignore: cast_nullable_to_non_nullable
              as bool,
      saveSearchHistory: null == saveSearchHistory
          ? _value.saveSearchHistory
          : saveSearchHistory // ignore: cast_nullable_to_non_nullable
              as bool,
      favoriteCategories: null == favoriteCategories
          ? _value.favoriteCategories
          : favoriteCategories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      savedFilters: null == savedFilters
          ? _value.savedFilters
          : savedFilters // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      autoConfirmBookings: null == autoConfirmBookings
          ? _value.autoConfirmBookings
          : autoConfirmBookings // ignore: cast_nullable_to_non_nullable
              as bool,
      sendBookingConfirmation: null == sendBookingConfirmation
          ? _value.sendBookingConfirmation
          : sendBookingConfirmation // ignore: cast_nullable_to_non_nullable
              as bool,
      defaultPartySize: null == defaultPartySize
          ? _value.defaultPartySize
          : defaultPartySize // ignore: cast_nullable_to_non_nullable
              as int,
      preferredPaymentMethod: freezed == preferredPaymentMethod
          ? _value.preferredPaymentMethod
          : preferredPaymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      fontSize: null == fontSize
          ? _value.fontSize
          : fontSize // ignore: cast_nullable_to_non_nullable
              as double,
      highContrast: null == highContrast
          ? _value.highContrast
          : highContrast // ignore: cast_nullable_to_non_nullable
              as bool,
      screenReaderOptimized: null == screenReaderOptimized
          ? _value.screenReaderOptimized
          : screenReaderOptimized // ignore: cast_nullable_to_non_nullable
              as bool,
      customSettings: freezed == customSettings
          ? _value.customSettings
          : customSettings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserPreferencesImplCopyWith<$Res>
    implements $UserPreferencesCopyWith<$Res> {
  factory _$$UserPreferencesImplCopyWith(_$UserPreferencesImpl value,
          $Res Function(_$UserPreferencesImpl) then) =
      __$$UserPreferencesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      NotificationPreference notificationPreference,
      bool bookingReminders,
      bool eventAnnouncements,
      bool friendActivity,
      bool promotionalOffers,
      bool loyaltyUpdates,
      bool emailNotifications,
      bool pushNotifications,
      bool smsNotifications,
      bool profileVisible,
      bool showActivityToFriends,
      bool showActivityPublic,
      bool allowFriendRequests,
      bool shareLocationWithFriends,
      ThemeMode themeMode,
      DistanceUnit distanceUnit,
      CurrencyPreference currency,
      String language,
      bool showTutorials,
      bool personalizedRecommendations,
      bool saveSearchHistory,
      List<String> favoriteCategories,
      Map<String, dynamic> savedFilters,
      bool autoConfirmBookings,
      bool sendBookingConfirmation,
      int defaultPartySize,
      String? preferredPaymentMethod,
      double fontSize,
      bool highContrast,
      bool screenReaderOptimized,
      Map<String, dynamic>? customSettings,
      DateTime updatedAt});
}

/// @nodoc
class __$$UserPreferencesImplCopyWithImpl<$Res>
    extends _$UserPreferencesCopyWithImpl<$Res, _$UserPreferencesImpl>
    implements _$$UserPreferencesImplCopyWith<$Res> {
  __$$UserPreferencesImplCopyWithImpl(
      _$UserPreferencesImpl _value, $Res Function(_$UserPreferencesImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserPreferences
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? notificationPreference = null,
    Object? bookingReminders = null,
    Object? eventAnnouncements = null,
    Object? friendActivity = null,
    Object? promotionalOffers = null,
    Object? loyaltyUpdates = null,
    Object? emailNotifications = null,
    Object? pushNotifications = null,
    Object? smsNotifications = null,
    Object? profileVisible = null,
    Object? showActivityToFriends = null,
    Object? showActivityPublic = null,
    Object? allowFriendRequests = null,
    Object? shareLocationWithFriends = null,
    Object? themeMode = null,
    Object? distanceUnit = null,
    Object? currency = null,
    Object? language = null,
    Object? showTutorials = null,
    Object? personalizedRecommendations = null,
    Object? saveSearchHistory = null,
    Object? favoriteCategories = null,
    Object? savedFilters = null,
    Object? autoConfirmBookings = null,
    Object? sendBookingConfirmation = null,
    Object? defaultPartySize = null,
    Object? preferredPaymentMethod = freezed,
    Object? fontSize = null,
    Object? highContrast = null,
    Object? screenReaderOptimized = null,
    Object? customSettings = freezed,
    Object? updatedAt = null,
  }) {
    return _then(_$UserPreferencesImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      notificationPreference: null == notificationPreference
          ? _value.notificationPreference
          : notificationPreference // ignore: cast_nullable_to_non_nullable
              as NotificationPreference,
      bookingReminders: null == bookingReminders
          ? _value.bookingReminders
          : bookingReminders // ignore: cast_nullable_to_non_nullable
              as bool,
      eventAnnouncements: null == eventAnnouncements
          ? _value.eventAnnouncements
          : eventAnnouncements // ignore: cast_nullable_to_non_nullable
              as bool,
      friendActivity: null == friendActivity
          ? _value.friendActivity
          : friendActivity // ignore: cast_nullable_to_non_nullable
              as bool,
      promotionalOffers: null == promotionalOffers
          ? _value.promotionalOffers
          : promotionalOffers // ignore: cast_nullable_to_non_nullable
              as bool,
      loyaltyUpdates: null == loyaltyUpdates
          ? _value.loyaltyUpdates
          : loyaltyUpdates // ignore: cast_nullable_to_non_nullable
              as bool,
      emailNotifications: null == emailNotifications
          ? _value.emailNotifications
          : emailNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      pushNotifications: null == pushNotifications
          ? _value.pushNotifications
          : pushNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      smsNotifications: null == smsNotifications
          ? _value.smsNotifications
          : smsNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      profileVisible: null == profileVisible
          ? _value.profileVisible
          : profileVisible // ignore: cast_nullable_to_non_nullable
              as bool,
      showActivityToFriends: null == showActivityToFriends
          ? _value.showActivityToFriends
          : showActivityToFriends // ignore: cast_nullable_to_non_nullable
              as bool,
      showActivityPublic: null == showActivityPublic
          ? _value.showActivityPublic
          : showActivityPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      allowFriendRequests: null == allowFriendRequests
          ? _value.allowFriendRequests
          : allowFriendRequests // ignore: cast_nullable_to_non_nullable
              as bool,
      shareLocationWithFriends: null == shareLocationWithFriends
          ? _value.shareLocationWithFriends
          : shareLocationWithFriends // ignore: cast_nullable_to_non_nullable
              as bool,
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      distanceUnit: null == distanceUnit
          ? _value.distanceUnit
          : distanceUnit // ignore: cast_nullable_to_non_nullable
              as DistanceUnit,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as CurrencyPreference,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      showTutorials: null == showTutorials
          ? _value.showTutorials
          : showTutorials // ignore: cast_nullable_to_non_nullable
              as bool,
      personalizedRecommendations: null == personalizedRecommendations
          ? _value.personalizedRecommendations
          : personalizedRecommendations // ignore: cast_nullable_to_non_nullable
              as bool,
      saveSearchHistory: null == saveSearchHistory
          ? _value.saveSearchHistory
          : saveSearchHistory // ignore: cast_nullable_to_non_nullable
              as bool,
      favoriteCategories: null == favoriteCategories
          ? _value._favoriteCategories
          : favoriteCategories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      savedFilters: null == savedFilters
          ? _value._savedFilters
          : savedFilters // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      autoConfirmBookings: null == autoConfirmBookings
          ? _value.autoConfirmBookings
          : autoConfirmBookings // ignore: cast_nullable_to_non_nullable
              as bool,
      sendBookingConfirmation: null == sendBookingConfirmation
          ? _value.sendBookingConfirmation
          : sendBookingConfirmation // ignore: cast_nullable_to_non_nullable
              as bool,
      defaultPartySize: null == defaultPartySize
          ? _value.defaultPartySize
          : defaultPartySize // ignore: cast_nullable_to_non_nullable
              as int,
      preferredPaymentMethod: freezed == preferredPaymentMethod
          ? _value.preferredPaymentMethod
          : preferredPaymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      fontSize: null == fontSize
          ? _value.fontSize
          : fontSize // ignore: cast_nullable_to_non_nullable
              as double,
      highContrast: null == highContrast
          ? _value.highContrast
          : highContrast // ignore: cast_nullable_to_non_nullable
              as bool,
      screenReaderOptimized: null == screenReaderOptimized
          ? _value.screenReaderOptimized
          : screenReaderOptimized // ignore: cast_nullable_to_non_nullable
              as bool,
      customSettings: freezed == customSettings
          ? _value._customSettings
          : customSettings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserPreferencesImpl implements _UserPreferences {
  const _$UserPreferencesImpl(
      {required this.userId,
      this.notificationPreference = NotificationPreference.all,
      this.bookingReminders = true,
      this.eventAnnouncements = true,
      this.friendActivity = true,
      this.promotionalOffers = true,
      this.loyaltyUpdates = true,
      this.emailNotifications = false,
      this.pushNotifications = true,
      this.smsNotifications = false,
      this.profileVisible = true,
      this.showActivityToFriends = true,
      this.showActivityPublic = false,
      this.allowFriendRequests = true,
      this.shareLocationWithFriends = false,
      this.themeMode = ThemeMode.system,
      this.distanceUnit = DistanceUnit.kilometers,
      this.currency = CurrencyPreference.usd,
      this.language = 'en',
      this.showTutorials = true,
      this.personalizedRecommendations = true,
      this.saveSearchHistory = true,
      final List<String> favoriteCategories = const [],
      final Map<String, dynamic> savedFilters = const {},
      this.autoConfirmBookings = false,
      this.sendBookingConfirmation = true,
      this.defaultPartySize = 2,
      this.preferredPaymentMethod,
      this.fontSize = 1.0,
      this.highContrast = false,
      this.screenReaderOptimized = false,
      final Map<String, dynamic>? customSettings,
      required this.updatedAt})
      : _favoriteCategories = favoriteCategories,
        _savedFilters = savedFilters,
        _customSettings = customSettings;

  factory _$UserPreferencesImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserPreferencesImplFromJson(json);

  @override
  final String userId;
// Notification preferences
  @override
  @JsonKey()
  final NotificationPreference notificationPreference;
  @override
  @JsonKey()
  final bool bookingReminders;
  @override
  @JsonKey()
  final bool eventAnnouncements;
  @override
  @JsonKey()
  final bool friendActivity;
  @override
  @JsonKey()
  final bool promotionalOffers;
  @override
  @JsonKey()
  final bool loyaltyUpdates;
  @override
  @JsonKey()
  final bool emailNotifications;
  @override
  @JsonKey()
  final bool pushNotifications;
  @override
  @JsonKey()
  final bool smsNotifications;
// Privacy settings
  @override
  @JsonKey()
  final bool profileVisible;
  @override
  @JsonKey()
  final bool showActivityToFriends;
  @override
  @JsonKey()
  final bool showActivityPublic;
  @override
  @JsonKey()
  final bool allowFriendRequests;
  @override
  @JsonKey()
  final bool shareLocationWithFriends;
// Display preferences
  @override
  @JsonKey()
  final ThemeMode themeMode;
  @override
  @JsonKey()
  final DistanceUnit distanceUnit;
  @override
  @JsonKey()
  final CurrencyPreference currency;
  @override
  @JsonKey()
  final String language;
  @override
  @JsonKey()
  final bool showTutorials;
// Search and discovery
  @override
  @JsonKey()
  final bool personalizedRecommendations;
  @override
  @JsonKey()
  final bool saveSearchHistory;
  final List<String> _favoriteCategories;
  @override
  @JsonKey()
  List<String> get favoriteCategories {
    if (_favoriteCategories is EqualUnmodifiableListView)
      return _favoriteCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_favoriteCategories);
  }

  final Map<String, dynamic> _savedFilters;
  @override
  @JsonKey()
  Map<String, dynamic> get savedFilters {
    if (_savedFilters is EqualUnmodifiableMapView) return _savedFilters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_savedFilters);
  }

// Booking preferences
  @override
  @JsonKey()
  final bool autoConfirmBookings;
  @override
  @JsonKey()
  final bool sendBookingConfirmation;
  @override
  @JsonKey()
  final int defaultPartySize;
  @override
  final String? preferredPaymentMethod;
// Accessibility
  @override
  @JsonKey()
  final double fontSize;
  @override
  @JsonKey()
  final bool highContrast;
  @override
  @JsonKey()
  final bool screenReaderOptimized;
// Other
  final Map<String, dynamic>? _customSettings;
// Other
  @override
  Map<String, dynamic>? get customSettings {
    final value = _customSettings;
    if (value == null) return null;
    if (_customSettings is EqualUnmodifiableMapView) return _customSettings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'UserPreferences(userId: $userId, notificationPreference: $notificationPreference, bookingReminders: $bookingReminders, eventAnnouncements: $eventAnnouncements, friendActivity: $friendActivity, promotionalOffers: $promotionalOffers, loyaltyUpdates: $loyaltyUpdates, emailNotifications: $emailNotifications, pushNotifications: $pushNotifications, smsNotifications: $smsNotifications, profileVisible: $profileVisible, showActivityToFriends: $showActivityToFriends, showActivityPublic: $showActivityPublic, allowFriendRequests: $allowFriendRequests, shareLocationWithFriends: $shareLocationWithFriends, themeMode: $themeMode, distanceUnit: $distanceUnit, currency: $currency, language: $language, showTutorials: $showTutorials, personalizedRecommendations: $personalizedRecommendations, saveSearchHistory: $saveSearchHistory, favoriteCategories: $favoriteCategories, savedFilters: $savedFilters, autoConfirmBookings: $autoConfirmBookings, sendBookingConfirmation: $sendBookingConfirmation, defaultPartySize: $defaultPartySize, preferredPaymentMethod: $preferredPaymentMethod, fontSize: $fontSize, highContrast: $highContrast, screenReaderOptimized: $screenReaderOptimized, customSettings: $customSettings, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserPreferencesImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.notificationPreference, notificationPreference) ||
                other.notificationPreference == notificationPreference) &&
            (identical(other.bookingReminders, bookingReminders) ||
                other.bookingReminders == bookingReminders) &&
            (identical(other.eventAnnouncements, eventAnnouncements) ||
                other.eventAnnouncements == eventAnnouncements) &&
            (identical(other.friendActivity, friendActivity) ||
                other.friendActivity == friendActivity) &&
            (identical(other.promotionalOffers, promotionalOffers) ||
                other.promotionalOffers == promotionalOffers) &&
            (identical(other.loyaltyUpdates, loyaltyUpdates) ||
                other.loyaltyUpdates == loyaltyUpdates) &&
            (identical(other.emailNotifications, emailNotifications) ||
                other.emailNotifications == emailNotifications) &&
            (identical(other.pushNotifications, pushNotifications) ||
                other.pushNotifications == pushNotifications) &&
            (identical(other.smsNotifications, smsNotifications) ||
                other.smsNotifications == smsNotifications) &&
            (identical(other.profileVisible, profileVisible) ||
                other.profileVisible == profileVisible) &&
            (identical(other.showActivityToFriends, showActivityToFriends) ||
                other.showActivityToFriends == showActivityToFriends) &&
            (identical(other.showActivityPublic, showActivityPublic) ||
                other.showActivityPublic == showActivityPublic) &&
            (identical(other.allowFriendRequests, allowFriendRequests) ||
                other.allowFriendRequests == allowFriendRequests) &&
            (identical(other.shareLocationWithFriends, shareLocationWithFriends) ||
                other.shareLocationWithFriends == shareLocationWithFriends) &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.distanceUnit, distanceUnit) ||
                other.distanceUnit == distanceUnit) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.showTutorials, showTutorials) ||
                other.showTutorials == showTutorials) &&
            (identical(other.personalizedRecommendations,
                    personalizedRecommendations) ||
                other.personalizedRecommendations ==
                    personalizedRecommendations) &&
            (identical(other.saveSearchHistory, saveSearchHistory) ||
                other.saveSearchHistory == saveSearchHistory) &&
            const DeepCollectionEquality()
                .equals(other._favoriteCategories, _favoriteCategories) &&
            const DeepCollectionEquality()
                .equals(other._savedFilters, _savedFilters) &&
            (identical(other.autoConfirmBookings, autoConfirmBookings) ||
                other.autoConfirmBookings == autoConfirmBookings) &&
            (identical(other.sendBookingConfirmation, sendBookingConfirmation) ||
                other.sendBookingConfirmation == sendBookingConfirmation) &&
            (identical(other.defaultPartySize, defaultPartySize) ||
                other.defaultPartySize == defaultPartySize) &&
            (identical(other.preferredPaymentMethod, preferredPaymentMethod) ||
                other.preferredPaymentMethod == preferredPaymentMethod) &&
            (identical(other.fontSize, fontSize) ||
                other.fontSize == fontSize) &&
            (identical(other.highContrast, highContrast) ||
                other.highContrast == highContrast) &&
            (identical(other.screenReaderOptimized, screenReaderOptimized) ||
                other.screenReaderOptimized == screenReaderOptimized) &&
            const DeepCollectionEquality()
                .equals(other._customSettings, _customSettings) &&
            (identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        userId,
        notificationPreference,
        bookingReminders,
        eventAnnouncements,
        friendActivity,
        promotionalOffers,
        loyaltyUpdates,
        emailNotifications,
        pushNotifications,
        smsNotifications,
        profileVisible,
        showActivityToFriends,
        showActivityPublic,
        allowFriendRequests,
        shareLocationWithFriends,
        themeMode,
        distanceUnit,
        currency,
        language,
        showTutorials,
        personalizedRecommendations,
        saveSearchHistory,
        const DeepCollectionEquality().hash(_favoriteCategories),
        const DeepCollectionEquality().hash(_savedFilters),
        autoConfirmBookings,
        sendBookingConfirmation,
        defaultPartySize,
        preferredPaymentMethod,
        fontSize,
        highContrast,
        screenReaderOptimized,
        const DeepCollectionEquality().hash(_customSettings),
        updatedAt
      ]);

  /// Create a copy of UserPreferences
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserPreferencesImplCopyWith<_$UserPreferencesImpl> get copyWith =>
      __$$UserPreferencesImplCopyWithImpl<_$UserPreferencesImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserPreferencesImplToJson(
      this,
    );
  }
}

abstract class _UserPreferences implements UserPreferences {
  const factory _UserPreferences(
      {required final String userId,
      final NotificationPreference notificationPreference,
      final bool bookingReminders,
      final bool eventAnnouncements,
      final bool friendActivity,
      final bool promotionalOffers,
      final bool loyaltyUpdates,
      final bool emailNotifications,
      final bool pushNotifications,
      final bool smsNotifications,
      final bool profileVisible,
      final bool showActivityToFriends,
      final bool showActivityPublic,
      final bool allowFriendRequests,
      final bool shareLocationWithFriends,
      final ThemeMode themeMode,
      final DistanceUnit distanceUnit,
      final CurrencyPreference currency,
      final String language,
      final bool showTutorials,
      final bool personalizedRecommendations,
      final bool saveSearchHistory,
      final List<String> favoriteCategories,
      final Map<String, dynamic> savedFilters,
      final bool autoConfirmBookings,
      final bool sendBookingConfirmation,
      final int defaultPartySize,
      final String? preferredPaymentMethod,
      final double fontSize,
      final bool highContrast,
      final bool screenReaderOptimized,
      final Map<String, dynamic>? customSettings,
      required final DateTime updatedAt}) = _$UserPreferencesImpl;

  factory _UserPreferences.fromJson(Map<String, dynamic> json) =
      _$UserPreferencesImpl.fromJson;

  @override
  String get userId; // Notification preferences
  @override
  NotificationPreference get notificationPreference;
  @override
  bool get bookingReminders;
  @override
  bool get eventAnnouncements;
  @override
  bool get friendActivity;
  @override
  bool get promotionalOffers;
  @override
  bool get loyaltyUpdates;
  @override
  bool get emailNotifications;
  @override
  bool get pushNotifications;
  @override
  bool get smsNotifications; // Privacy settings
  @override
  bool get profileVisible;
  @override
  bool get showActivityToFriends;
  @override
  bool get showActivityPublic;
  @override
  bool get allowFriendRequests;
  @override
  bool get shareLocationWithFriends; // Display preferences
  @override
  ThemeMode get themeMode;
  @override
  DistanceUnit get distanceUnit;
  @override
  CurrencyPreference get currency;
  @override
  String get language;
  @override
  bool get showTutorials; // Search and discovery
  @override
  bool get personalizedRecommendations;
  @override
  bool get saveSearchHistory;
  @override
  List<String> get favoriteCategories;
  @override
  Map<String, dynamic> get savedFilters; // Booking preferences
  @override
  bool get autoConfirmBookings;
  @override
  bool get sendBookingConfirmation;
  @override
  int get defaultPartySize;
  @override
  String? get preferredPaymentMethod; // Accessibility
  @override
  double get fontSize;
  @override
  bool get highContrast;
  @override
  bool get screenReaderOptimized; // Other
  @override
  Map<String, dynamic>? get customSettings;
  @override
  DateTime get updatedAt;

  /// Create a copy of UserPreferences
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserPreferencesImplCopyWith<_$UserPreferencesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PrivacySettings _$PrivacySettingsFromJson(Map<String, dynamic> json) {
  return _PrivacySettings.fromJson(json);
}

/// @nodoc
mixin _$PrivacySettings {
  String get userId => throw _privateConstructorUsedError;
  bool get showEmail => throw _privateConstructorUsedError;
  bool get showPhone => throw _privateConstructorUsedError;
  bool get showDateOfBirth => throw _privateConstructorUsedError;
  bool get showGender => throw _privateConstructorUsedError;
  bool get showLocation => throw _privateConstructorUsedError;
  bool get allowTagging => throw _privateConstructorUsedError;
  bool get allowMentions => throw _privateConstructorUsedError;
  bool get allowDataSharing => throw _privateConstructorUsedError;
  bool get allowMarketingEmails => throw _privateConstructorUsedError;
  List<String> get blockedUsers => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this PrivacySettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PrivacySettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrivacySettingsCopyWith<PrivacySettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrivacySettingsCopyWith<$Res> {
  factory $PrivacySettingsCopyWith(
          PrivacySettings value, $Res Function(PrivacySettings) then) =
      _$PrivacySettingsCopyWithImpl<$Res, PrivacySettings>;
  @useResult
  $Res call(
      {String userId,
      bool showEmail,
      bool showPhone,
      bool showDateOfBirth,
      bool showGender,
      bool showLocation,
      bool allowTagging,
      bool allowMentions,
      bool allowDataSharing,
      bool allowMarketingEmails,
      List<String> blockedUsers,
      DateTime updatedAt});
}

/// @nodoc
class _$PrivacySettingsCopyWithImpl<$Res, $Val extends PrivacySettings>
    implements $PrivacySettingsCopyWith<$Res> {
  _$PrivacySettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrivacySettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? showEmail = null,
    Object? showPhone = null,
    Object? showDateOfBirth = null,
    Object? showGender = null,
    Object? showLocation = null,
    Object? allowTagging = null,
    Object? allowMentions = null,
    Object? allowDataSharing = null,
    Object? allowMarketingEmails = null,
    Object? blockedUsers = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      showEmail: null == showEmail
          ? _value.showEmail
          : showEmail // ignore: cast_nullable_to_non_nullable
              as bool,
      showPhone: null == showPhone
          ? _value.showPhone
          : showPhone // ignore: cast_nullable_to_non_nullable
              as bool,
      showDateOfBirth: null == showDateOfBirth
          ? _value.showDateOfBirth
          : showDateOfBirth // ignore: cast_nullable_to_non_nullable
              as bool,
      showGender: null == showGender
          ? _value.showGender
          : showGender // ignore: cast_nullable_to_non_nullable
              as bool,
      showLocation: null == showLocation
          ? _value.showLocation
          : showLocation // ignore: cast_nullable_to_non_nullable
              as bool,
      allowTagging: null == allowTagging
          ? _value.allowTagging
          : allowTagging // ignore: cast_nullable_to_non_nullable
              as bool,
      allowMentions: null == allowMentions
          ? _value.allowMentions
          : allowMentions // ignore: cast_nullable_to_non_nullable
              as bool,
      allowDataSharing: null == allowDataSharing
          ? _value.allowDataSharing
          : allowDataSharing // ignore: cast_nullable_to_non_nullable
              as bool,
      allowMarketingEmails: null == allowMarketingEmails
          ? _value.allowMarketingEmails
          : allowMarketingEmails // ignore: cast_nullable_to_non_nullable
              as bool,
      blockedUsers: null == blockedUsers
          ? _value.blockedUsers
          : blockedUsers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PrivacySettingsImplCopyWith<$Res>
    implements $PrivacySettingsCopyWith<$Res> {
  factory _$$PrivacySettingsImplCopyWith(_$PrivacySettingsImpl value,
          $Res Function(_$PrivacySettingsImpl) then) =
      __$$PrivacySettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      bool showEmail,
      bool showPhone,
      bool showDateOfBirth,
      bool showGender,
      bool showLocation,
      bool allowTagging,
      bool allowMentions,
      bool allowDataSharing,
      bool allowMarketingEmails,
      List<String> blockedUsers,
      DateTime updatedAt});
}

/// @nodoc
class __$$PrivacySettingsImplCopyWithImpl<$Res>
    extends _$PrivacySettingsCopyWithImpl<$Res, _$PrivacySettingsImpl>
    implements _$$PrivacySettingsImplCopyWith<$Res> {
  __$$PrivacySettingsImplCopyWithImpl(
      _$PrivacySettingsImpl _value, $Res Function(_$PrivacySettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of PrivacySettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? showEmail = null,
    Object? showPhone = null,
    Object? showDateOfBirth = null,
    Object? showGender = null,
    Object? showLocation = null,
    Object? allowTagging = null,
    Object? allowMentions = null,
    Object? allowDataSharing = null,
    Object? allowMarketingEmails = null,
    Object? blockedUsers = null,
    Object? updatedAt = null,
  }) {
    return _then(_$PrivacySettingsImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      showEmail: null == showEmail
          ? _value.showEmail
          : showEmail // ignore: cast_nullable_to_non_nullable
              as bool,
      showPhone: null == showPhone
          ? _value.showPhone
          : showPhone // ignore: cast_nullable_to_non_nullable
              as bool,
      showDateOfBirth: null == showDateOfBirth
          ? _value.showDateOfBirth
          : showDateOfBirth // ignore: cast_nullable_to_non_nullable
              as bool,
      showGender: null == showGender
          ? _value.showGender
          : showGender // ignore: cast_nullable_to_non_nullable
              as bool,
      showLocation: null == showLocation
          ? _value.showLocation
          : showLocation // ignore: cast_nullable_to_non_nullable
              as bool,
      allowTagging: null == allowTagging
          ? _value.allowTagging
          : allowTagging // ignore: cast_nullable_to_non_nullable
              as bool,
      allowMentions: null == allowMentions
          ? _value.allowMentions
          : allowMentions // ignore: cast_nullable_to_non_nullable
              as bool,
      allowDataSharing: null == allowDataSharing
          ? _value.allowDataSharing
          : allowDataSharing // ignore: cast_nullable_to_non_nullable
              as bool,
      allowMarketingEmails: null == allowMarketingEmails
          ? _value.allowMarketingEmails
          : allowMarketingEmails // ignore: cast_nullable_to_non_nullable
              as bool,
      blockedUsers: null == blockedUsers
          ? _value._blockedUsers
          : blockedUsers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PrivacySettingsImpl implements _PrivacySettings {
  const _$PrivacySettingsImpl(
      {required this.userId,
      this.showEmail = true,
      this.showPhone = false,
      this.showDateOfBirth = true,
      this.showGender = true,
      this.showLocation = true,
      this.allowTagging = true,
      this.allowMentions = true,
      this.allowDataSharing = false,
      this.allowMarketingEmails = false,
      final List<String> blockedUsers = const [],
      required this.updatedAt})
      : _blockedUsers = blockedUsers;

  factory _$PrivacySettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrivacySettingsImplFromJson(json);

  @override
  final String userId;
  @override
  @JsonKey()
  final bool showEmail;
  @override
  @JsonKey()
  final bool showPhone;
  @override
  @JsonKey()
  final bool showDateOfBirth;
  @override
  @JsonKey()
  final bool showGender;
  @override
  @JsonKey()
  final bool showLocation;
  @override
  @JsonKey()
  final bool allowTagging;
  @override
  @JsonKey()
  final bool allowMentions;
  @override
  @JsonKey()
  final bool allowDataSharing;
  @override
  @JsonKey()
  final bool allowMarketingEmails;
  final List<String> _blockedUsers;
  @override
  @JsonKey()
  List<String> get blockedUsers {
    if (_blockedUsers is EqualUnmodifiableListView) return _blockedUsers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_blockedUsers);
  }

  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'PrivacySettings(userId: $userId, showEmail: $showEmail, showPhone: $showPhone, showDateOfBirth: $showDateOfBirth, showGender: $showGender, showLocation: $showLocation, allowTagging: $allowTagging, allowMentions: $allowMentions, allowDataSharing: $allowDataSharing, allowMarketingEmails: $allowMarketingEmails, blockedUsers: $blockedUsers, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrivacySettingsImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.showEmail, showEmail) ||
                other.showEmail == showEmail) &&
            (identical(other.showPhone, showPhone) ||
                other.showPhone == showPhone) &&
            (identical(other.showDateOfBirth, showDateOfBirth) ||
                other.showDateOfBirth == showDateOfBirth) &&
            (identical(other.showGender, showGender) ||
                other.showGender == showGender) &&
            (identical(other.showLocation, showLocation) ||
                other.showLocation == showLocation) &&
            (identical(other.allowTagging, allowTagging) ||
                other.allowTagging == allowTagging) &&
            (identical(other.allowMentions, allowMentions) ||
                other.allowMentions == allowMentions) &&
            (identical(other.allowDataSharing, allowDataSharing) ||
                other.allowDataSharing == allowDataSharing) &&
            (identical(other.allowMarketingEmails, allowMarketingEmails) ||
                other.allowMarketingEmails == allowMarketingEmails) &&
            const DeepCollectionEquality()
                .equals(other._blockedUsers, _blockedUsers) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      showEmail,
      showPhone,
      showDateOfBirth,
      showGender,
      showLocation,
      allowTagging,
      allowMentions,
      allowDataSharing,
      allowMarketingEmails,
      const DeepCollectionEquality().hash(_blockedUsers),
      updatedAt);

  /// Create a copy of PrivacySettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrivacySettingsImplCopyWith<_$PrivacySettingsImpl> get copyWith =>
      __$$PrivacySettingsImplCopyWithImpl<_$PrivacySettingsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrivacySettingsImplToJson(
      this,
    );
  }
}

abstract class _PrivacySettings implements PrivacySettings {
  const factory _PrivacySettings(
      {required final String userId,
      final bool showEmail,
      final bool showPhone,
      final bool showDateOfBirth,
      final bool showGender,
      final bool showLocation,
      final bool allowTagging,
      final bool allowMentions,
      final bool allowDataSharing,
      final bool allowMarketingEmails,
      final List<String> blockedUsers,
      required final DateTime updatedAt}) = _$PrivacySettingsImpl;

  factory _PrivacySettings.fromJson(Map<String, dynamic> json) =
      _$PrivacySettingsImpl.fromJson;

  @override
  String get userId;
  @override
  bool get showEmail;
  @override
  bool get showPhone;
  @override
  bool get showDateOfBirth;
  @override
  bool get showGender;
  @override
  bool get showLocation;
  @override
  bool get allowTagging;
  @override
  bool get allowMentions;
  @override
  bool get allowDataSharing;
  @override
  bool get allowMarketingEmails;
  @override
  List<String> get blockedUsers;
  @override
  DateTime get updatedAt;

  /// Create a copy of PrivacySettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrivacySettingsImplCopyWith<_$PrivacySettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NotificationSettings _$NotificationSettingsFromJson(Map<String, dynamic> json) {
  return _NotificationSettings.fromJson(json);
}

/// @nodoc
mixin _$NotificationSettings {
  String get userId => throw _privateConstructorUsedError; // Push notifications
  bool get pushEnabled => throw _privateConstructorUsedError;
  bool get pushBookings => throw _privateConstructorUsedError;
  bool get pushEvents => throw _privateConstructorUsedError;
  bool get pushMessages => throw _privateConstructorUsedError;
  bool get pushFriendRequests => throw _privateConstructorUsedError;
  bool get pushPromotions =>
      throw _privateConstructorUsedError; // Email notifications
  bool get emailEnabled => throw _privateConstructorUsedError;
  bool get emailBookings => throw _privateConstructorUsedError;
  bool get emailEvents => throw _privateConstructorUsedError;
  bool get emailMessages => throw _privateConstructorUsedError;
  bool get emailFriendRequests => throw _privateConstructorUsedError;
  bool get emailPromotions => throw _privateConstructorUsedError;
  bool get emailWeeklyDigest =>
      throw _privateConstructorUsedError; // SMS notifications
  bool get smsEnabled => throw _privateConstructorUsedError;
  bool get smsBookingReminders => throw _privateConstructorUsedError;
  bool get smsEventReminders =>
      throw _privateConstructorUsedError; // Quiet hours
  bool get quietHoursEnabled => throw _privateConstructorUsedError;
  String? get quietHoursStart => throw _privateConstructorUsedError;
  String? get quietHoursEnd => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this NotificationSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationSettingsCopyWith<NotificationSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationSettingsCopyWith<$Res> {
  factory $NotificationSettingsCopyWith(NotificationSettings value,
          $Res Function(NotificationSettings) then) =
      _$NotificationSettingsCopyWithImpl<$Res, NotificationSettings>;
  @useResult
  $Res call(
      {String userId,
      bool pushEnabled,
      bool pushBookings,
      bool pushEvents,
      bool pushMessages,
      bool pushFriendRequests,
      bool pushPromotions,
      bool emailEnabled,
      bool emailBookings,
      bool emailEvents,
      bool emailMessages,
      bool emailFriendRequests,
      bool emailPromotions,
      bool emailWeeklyDigest,
      bool smsEnabled,
      bool smsBookingReminders,
      bool smsEventReminders,
      bool quietHoursEnabled,
      String? quietHoursStart,
      String? quietHoursEnd,
      DateTime updatedAt});
}

/// @nodoc
class _$NotificationSettingsCopyWithImpl<$Res,
        $Val extends NotificationSettings>
    implements $NotificationSettingsCopyWith<$Res> {
  _$NotificationSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? pushEnabled = null,
    Object? pushBookings = null,
    Object? pushEvents = null,
    Object? pushMessages = null,
    Object? pushFriendRequests = null,
    Object? pushPromotions = null,
    Object? emailEnabled = null,
    Object? emailBookings = null,
    Object? emailEvents = null,
    Object? emailMessages = null,
    Object? emailFriendRequests = null,
    Object? emailPromotions = null,
    Object? emailWeeklyDigest = null,
    Object? smsEnabled = null,
    Object? smsBookingReminders = null,
    Object? smsEventReminders = null,
    Object? quietHoursEnabled = null,
    Object? quietHoursStart = freezed,
    Object? quietHoursEnd = freezed,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      pushEnabled: null == pushEnabled
          ? _value.pushEnabled
          : pushEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      pushBookings: null == pushBookings
          ? _value.pushBookings
          : pushBookings // ignore: cast_nullable_to_non_nullable
              as bool,
      pushEvents: null == pushEvents
          ? _value.pushEvents
          : pushEvents // ignore: cast_nullable_to_non_nullable
              as bool,
      pushMessages: null == pushMessages
          ? _value.pushMessages
          : pushMessages // ignore: cast_nullable_to_non_nullable
              as bool,
      pushFriendRequests: null == pushFriendRequests
          ? _value.pushFriendRequests
          : pushFriendRequests // ignore: cast_nullable_to_non_nullable
              as bool,
      pushPromotions: null == pushPromotions
          ? _value.pushPromotions
          : pushPromotions // ignore: cast_nullable_to_non_nullable
              as bool,
      emailEnabled: null == emailEnabled
          ? _value.emailEnabled
          : emailEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      emailBookings: null == emailBookings
          ? _value.emailBookings
          : emailBookings // ignore: cast_nullable_to_non_nullable
              as bool,
      emailEvents: null == emailEvents
          ? _value.emailEvents
          : emailEvents // ignore: cast_nullable_to_non_nullable
              as bool,
      emailMessages: null == emailMessages
          ? _value.emailMessages
          : emailMessages // ignore: cast_nullable_to_non_nullable
              as bool,
      emailFriendRequests: null == emailFriendRequests
          ? _value.emailFriendRequests
          : emailFriendRequests // ignore: cast_nullable_to_non_nullable
              as bool,
      emailPromotions: null == emailPromotions
          ? _value.emailPromotions
          : emailPromotions // ignore: cast_nullable_to_non_nullable
              as bool,
      emailWeeklyDigest: null == emailWeeklyDigest
          ? _value.emailWeeklyDigest
          : emailWeeklyDigest // ignore: cast_nullable_to_non_nullable
              as bool,
      smsEnabled: null == smsEnabled
          ? _value.smsEnabled
          : smsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      smsBookingReminders: null == smsBookingReminders
          ? _value.smsBookingReminders
          : smsBookingReminders // ignore: cast_nullable_to_non_nullable
              as bool,
      smsEventReminders: null == smsEventReminders
          ? _value.smsEventReminders
          : smsEventReminders // ignore: cast_nullable_to_non_nullable
              as bool,
      quietHoursEnabled: null == quietHoursEnabled
          ? _value.quietHoursEnabled
          : quietHoursEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      quietHoursStart: freezed == quietHoursStart
          ? _value.quietHoursStart
          : quietHoursStart // ignore: cast_nullable_to_non_nullable
              as String?,
      quietHoursEnd: freezed == quietHoursEnd
          ? _value.quietHoursEnd
          : quietHoursEnd // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationSettingsImplCopyWith<$Res>
    implements $NotificationSettingsCopyWith<$Res> {
  factory _$$NotificationSettingsImplCopyWith(_$NotificationSettingsImpl value,
          $Res Function(_$NotificationSettingsImpl) then) =
      __$$NotificationSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      bool pushEnabled,
      bool pushBookings,
      bool pushEvents,
      bool pushMessages,
      bool pushFriendRequests,
      bool pushPromotions,
      bool emailEnabled,
      bool emailBookings,
      bool emailEvents,
      bool emailMessages,
      bool emailFriendRequests,
      bool emailPromotions,
      bool emailWeeklyDigest,
      bool smsEnabled,
      bool smsBookingReminders,
      bool smsEventReminders,
      bool quietHoursEnabled,
      String? quietHoursStart,
      String? quietHoursEnd,
      DateTime updatedAt});
}

/// @nodoc
class __$$NotificationSettingsImplCopyWithImpl<$Res>
    extends _$NotificationSettingsCopyWithImpl<$Res, _$NotificationSettingsImpl>
    implements _$$NotificationSettingsImplCopyWith<$Res> {
  __$$NotificationSettingsImplCopyWithImpl(_$NotificationSettingsImpl _value,
      $Res Function(_$NotificationSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of NotificationSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? pushEnabled = null,
    Object? pushBookings = null,
    Object? pushEvents = null,
    Object? pushMessages = null,
    Object? pushFriendRequests = null,
    Object? pushPromotions = null,
    Object? emailEnabled = null,
    Object? emailBookings = null,
    Object? emailEvents = null,
    Object? emailMessages = null,
    Object? emailFriendRequests = null,
    Object? emailPromotions = null,
    Object? emailWeeklyDigest = null,
    Object? smsEnabled = null,
    Object? smsBookingReminders = null,
    Object? smsEventReminders = null,
    Object? quietHoursEnabled = null,
    Object? quietHoursStart = freezed,
    Object? quietHoursEnd = freezed,
    Object? updatedAt = null,
  }) {
    return _then(_$NotificationSettingsImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      pushEnabled: null == pushEnabled
          ? _value.pushEnabled
          : pushEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      pushBookings: null == pushBookings
          ? _value.pushBookings
          : pushBookings // ignore: cast_nullable_to_non_nullable
              as bool,
      pushEvents: null == pushEvents
          ? _value.pushEvents
          : pushEvents // ignore: cast_nullable_to_non_nullable
              as bool,
      pushMessages: null == pushMessages
          ? _value.pushMessages
          : pushMessages // ignore: cast_nullable_to_non_nullable
              as bool,
      pushFriendRequests: null == pushFriendRequests
          ? _value.pushFriendRequests
          : pushFriendRequests // ignore: cast_nullable_to_non_nullable
              as bool,
      pushPromotions: null == pushPromotions
          ? _value.pushPromotions
          : pushPromotions // ignore: cast_nullable_to_non_nullable
              as bool,
      emailEnabled: null == emailEnabled
          ? _value.emailEnabled
          : emailEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      emailBookings: null == emailBookings
          ? _value.emailBookings
          : emailBookings // ignore: cast_nullable_to_non_nullable
              as bool,
      emailEvents: null == emailEvents
          ? _value.emailEvents
          : emailEvents // ignore: cast_nullable_to_non_nullable
              as bool,
      emailMessages: null == emailMessages
          ? _value.emailMessages
          : emailMessages // ignore: cast_nullable_to_non_nullable
              as bool,
      emailFriendRequests: null == emailFriendRequests
          ? _value.emailFriendRequests
          : emailFriendRequests // ignore: cast_nullable_to_non_nullable
              as bool,
      emailPromotions: null == emailPromotions
          ? _value.emailPromotions
          : emailPromotions // ignore: cast_nullable_to_non_nullable
              as bool,
      emailWeeklyDigest: null == emailWeeklyDigest
          ? _value.emailWeeklyDigest
          : emailWeeklyDigest // ignore: cast_nullable_to_non_nullable
              as bool,
      smsEnabled: null == smsEnabled
          ? _value.smsEnabled
          : smsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      smsBookingReminders: null == smsBookingReminders
          ? _value.smsBookingReminders
          : smsBookingReminders // ignore: cast_nullable_to_non_nullable
              as bool,
      smsEventReminders: null == smsEventReminders
          ? _value.smsEventReminders
          : smsEventReminders // ignore: cast_nullable_to_non_nullable
              as bool,
      quietHoursEnabled: null == quietHoursEnabled
          ? _value.quietHoursEnabled
          : quietHoursEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      quietHoursStart: freezed == quietHoursStart
          ? _value.quietHoursStart
          : quietHoursStart // ignore: cast_nullable_to_non_nullable
              as String?,
      quietHoursEnd: freezed == quietHoursEnd
          ? _value.quietHoursEnd
          : quietHoursEnd // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationSettingsImpl implements _NotificationSettings {
  const _$NotificationSettingsImpl(
      {required this.userId,
      this.pushEnabled = true,
      this.pushBookings = true,
      this.pushEvents = true,
      this.pushMessages = true,
      this.pushFriendRequests = true,
      this.pushPromotions = true,
      this.emailEnabled = false,
      this.emailBookings = true,
      this.emailEvents = true,
      this.emailMessages = false,
      this.emailFriendRequests = true,
      this.emailPromotions = false,
      this.emailWeeklyDigest = false,
      this.smsEnabled = false,
      this.smsBookingReminders = true,
      this.smsEventReminders = false,
      this.quietHoursEnabled = false,
      this.quietHoursStart,
      this.quietHoursEnd,
      required this.updatedAt});

  factory _$NotificationSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationSettingsImplFromJson(json);

  @override
  final String userId;
// Push notifications
  @override
  @JsonKey()
  final bool pushEnabled;
  @override
  @JsonKey()
  final bool pushBookings;
  @override
  @JsonKey()
  final bool pushEvents;
  @override
  @JsonKey()
  final bool pushMessages;
  @override
  @JsonKey()
  final bool pushFriendRequests;
  @override
  @JsonKey()
  final bool pushPromotions;
// Email notifications
  @override
  @JsonKey()
  final bool emailEnabled;
  @override
  @JsonKey()
  final bool emailBookings;
  @override
  @JsonKey()
  final bool emailEvents;
  @override
  @JsonKey()
  final bool emailMessages;
  @override
  @JsonKey()
  final bool emailFriendRequests;
  @override
  @JsonKey()
  final bool emailPromotions;
  @override
  @JsonKey()
  final bool emailWeeklyDigest;
// SMS notifications
  @override
  @JsonKey()
  final bool smsEnabled;
  @override
  @JsonKey()
  final bool smsBookingReminders;
  @override
  @JsonKey()
  final bool smsEventReminders;
// Quiet hours
  @override
  @JsonKey()
  final bool quietHoursEnabled;
  @override
  final String? quietHoursStart;
  @override
  final String? quietHoursEnd;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'NotificationSettings(userId: $userId, pushEnabled: $pushEnabled, pushBookings: $pushBookings, pushEvents: $pushEvents, pushMessages: $pushMessages, pushFriendRequests: $pushFriendRequests, pushPromotions: $pushPromotions, emailEnabled: $emailEnabled, emailBookings: $emailBookings, emailEvents: $emailEvents, emailMessages: $emailMessages, emailFriendRequests: $emailFriendRequests, emailPromotions: $emailPromotions, emailWeeklyDigest: $emailWeeklyDigest, smsEnabled: $smsEnabled, smsBookingReminders: $smsBookingReminders, smsEventReminders: $smsEventReminders, quietHoursEnabled: $quietHoursEnabled, quietHoursStart: $quietHoursStart, quietHoursEnd: $quietHoursEnd, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationSettingsImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.pushEnabled, pushEnabled) ||
                other.pushEnabled == pushEnabled) &&
            (identical(other.pushBookings, pushBookings) ||
                other.pushBookings == pushBookings) &&
            (identical(other.pushEvents, pushEvents) ||
                other.pushEvents == pushEvents) &&
            (identical(other.pushMessages, pushMessages) ||
                other.pushMessages == pushMessages) &&
            (identical(other.pushFriendRequests, pushFriendRequests) ||
                other.pushFriendRequests == pushFriendRequests) &&
            (identical(other.pushPromotions, pushPromotions) ||
                other.pushPromotions == pushPromotions) &&
            (identical(other.emailEnabled, emailEnabled) ||
                other.emailEnabled == emailEnabled) &&
            (identical(other.emailBookings, emailBookings) ||
                other.emailBookings == emailBookings) &&
            (identical(other.emailEvents, emailEvents) ||
                other.emailEvents == emailEvents) &&
            (identical(other.emailMessages, emailMessages) ||
                other.emailMessages == emailMessages) &&
            (identical(other.emailFriendRequests, emailFriendRequests) ||
                other.emailFriendRequests == emailFriendRequests) &&
            (identical(other.emailPromotions, emailPromotions) ||
                other.emailPromotions == emailPromotions) &&
            (identical(other.emailWeeklyDigest, emailWeeklyDigest) ||
                other.emailWeeklyDigest == emailWeeklyDigest) &&
            (identical(other.smsEnabled, smsEnabled) ||
                other.smsEnabled == smsEnabled) &&
            (identical(other.smsBookingReminders, smsBookingReminders) ||
                other.smsBookingReminders == smsBookingReminders) &&
            (identical(other.smsEventReminders, smsEventReminders) ||
                other.smsEventReminders == smsEventReminders) &&
            (identical(other.quietHoursEnabled, quietHoursEnabled) ||
                other.quietHoursEnabled == quietHoursEnabled) &&
            (identical(other.quietHoursStart, quietHoursStart) ||
                other.quietHoursStart == quietHoursStart) &&
            (identical(other.quietHoursEnd, quietHoursEnd) ||
                other.quietHoursEnd == quietHoursEnd) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        userId,
        pushEnabled,
        pushBookings,
        pushEvents,
        pushMessages,
        pushFriendRequests,
        pushPromotions,
        emailEnabled,
        emailBookings,
        emailEvents,
        emailMessages,
        emailFriendRequests,
        emailPromotions,
        emailWeeklyDigest,
        smsEnabled,
        smsBookingReminders,
        smsEventReminders,
        quietHoursEnabled,
        quietHoursStart,
        quietHoursEnd,
        updatedAt
      ]);

  /// Create a copy of NotificationSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationSettingsImplCopyWith<_$NotificationSettingsImpl>
      get copyWith =>
          __$$NotificationSettingsImplCopyWithImpl<_$NotificationSettingsImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationSettingsImplToJson(
      this,
    );
  }
}

abstract class _NotificationSettings implements NotificationSettings {
  const factory _NotificationSettings(
      {required final String userId,
      final bool pushEnabled,
      final bool pushBookings,
      final bool pushEvents,
      final bool pushMessages,
      final bool pushFriendRequests,
      final bool pushPromotions,
      final bool emailEnabled,
      final bool emailBookings,
      final bool emailEvents,
      final bool emailMessages,
      final bool emailFriendRequests,
      final bool emailPromotions,
      final bool emailWeeklyDigest,
      final bool smsEnabled,
      final bool smsBookingReminders,
      final bool smsEventReminders,
      final bool quietHoursEnabled,
      final String? quietHoursStart,
      final String? quietHoursEnd,
      required final DateTime updatedAt}) = _$NotificationSettingsImpl;

  factory _NotificationSettings.fromJson(Map<String, dynamic> json) =
      _$NotificationSettingsImpl.fromJson;

  @override
  String get userId; // Push notifications
  @override
  bool get pushEnabled;
  @override
  bool get pushBookings;
  @override
  bool get pushEvents;
  @override
  bool get pushMessages;
  @override
  bool get pushFriendRequests;
  @override
  bool get pushPromotions; // Email notifications
  @override
  bool get emailEnabled;
  @override
  bool get emailBookings;
  @override
  bool get emailEvents;
  @override
  bool get emailMessages;
  @override
  bool get emailFriendRequests;
  @override
  bool get emailPromotions;
  @override
  bool get emailWeeklyDigest; // SMS notifications
  @override
  bool get smsEnabled;
  @override
  bool get smsBookingReminders;
  @override
  bool get smsEventReminders; // Quiet hours
  @override
  bool get quietHoursEnabled;
  @override
  String? get quietHoursStart;
  @override
  String? get quietHoursEnd;
  @override
  DateTime get updatedAt;

  /// Create a copy of NotificationSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationSettingsImplCopyWith<_$NotificationSettingsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
