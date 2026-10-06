// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'referral.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReferralProgram _$ReferralProgramFromJson(Map<String, dynamic> json) {
  return _ReferralProgram.fromJson(json);
}

/// @nodoc
mixin _$ReferralProgram {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  ReferralRewardType get rewardType => throw _privateConstructorUsedError;
  int get referrerRewardValue => throw _privateConstructorUsedError;
  int get refereeRewardValue => throw _privateConstructorUsedError;
  String? get referrerRewardDescription => throw _privateConstructorUsedError;
  String? get refereeRewardDescription => throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  int? get maxReferrals => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  Map<String, dynamic>? get terms => throw _privateConstructorUsedError;

  /// Serializes this ReferralProgram to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReferralProgram
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReferralProgramCopyWith<ReferralProgram> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReferralProgramCopyWith<$Res> {
  factory $ReferralProgramCopyWith(
          ReferralProgram value, $Res Function(ReferralProgram) then) =
      _$ReferralProgramCopyWithImpl<$Res, ReferralProgram>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      ReferralRewardType rewardType,
      int referrerRewardValue,
      int refereeRewardValue,
      String? referrerRewardDescription,
      String? refereeRewardDescription,
      DateTime? expiresAt,
      int? maxReferrals,
      bool isActive,
      Map<String, dynamic>? terms});
}

/// @nodoc
class _$ReferralProgramCopyWithImpl<$Res, $Val extends ReferralProgram>
    implements $ReferralProgramCopyWith<$Res> {
  _$ReferralProgramCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReferralProgram
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? rewardType = null,
    Object? referrerRewardValue = null,
    Object? refereeRewardValue = null,
    Object? referrerRewardDescription = freezed,
    Object? refereeRewardDescription = freezed,
    Object? expiresAt = freezed,
    Object? maxReferrals = freezed,
    Object? isActive = null,
    Object? terms = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      rewardType: null == rewardType
          ? _value.rewardType
          : rewardType // ignore: cast_nullable_to_non_nullable
              as ReferralRewardType,
      referrerRewardValue: null == referrerRewardValue
          ? _value.referrerRewardValue
          : referrerRewardValue // ignore: cast_nullable_to_non_nullable
              as int,
      refereeRewardValue: null == refereeRewardValue
          ? _value.refereeRewardValue
          : refereeRewardValue // ignore: cast_nullable_to_non_nullable
              as int,
      referrerRewardDescription: freezed == referrerRewardDescription
          ? _value.referrerRewardDescription
          : referrerRewardDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      refereeRewardDescription: freezed == refereeRewardDescription
          ? _value.refereeRewardDescription
          : refereeRewardDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      maxReferrals: freezed == maxReferrals
          ? _value.maxReferrals
          : maxReferrals // ignore: cast_nullable_to_non_nullable
              as int?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      terms: freezed == terms
          ? _value.terms
          : terms // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReferralProgramImplCopyWith<$Res>
    implements $ReferralProgramCopyWith<$Res> {
  factory _$$ReferralProgramImplCopyWith(_$ReferralProgramImpl value,
          $Res Function(_$ReferralProgramImpl) then) =
      __$$ReferralProgramImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      ReferralRewardType rewardType,
      int referrerRewardValue,
      int refereeRewardValue,
      String? referrerRewardDescription,
      String? refereeRewardDescription,
      DateTime? expiresAt,
      int? maxReferrals,
      bool isActive,
      Map<String, dynamic>? terms});
}

/// @nodoc
class __$$ReferralProgramImplCopyWithImpl<$Res>
    extends _$ReferralProgramCopyWithImpl<$Res, _$ReferralProgramImpl>
    implements _$$ReferralProgramImplCopyWith<$Res> {
  __$$ReferralProgramImplCopyWithImpl(
      _$ReferralProgramImpl _value, $Res Function(_$ReferralProgramImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReferralProgram
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? rewardType = null,
    Object? referrerRewardValue = null,
    Object? refereeRewardValue = null,
    Object? referrerRewardDescription = freezed,
    Object? refereeRewardDescription = freezed,
    Object? expiresAt = freezed,
    Object? maxReferrals = freezed,
    Object? isActive = null,
    Object? terms = freezed,
  }) {
    return _then(_$ReferralProgramImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      rewardType: null == rewardType
          ? _value.rewardType
          : rewardType // ignore: cast_nullable_to_non_nullable
              as ReferralRewardType,
      referrerRewardValue: null == referrerRewardValue
          ? _value.referrerRewardValue
          : referrerRewardValue // ignore: cast_nullable_to_non_nullable
              as int,
      refereeRewardValue: null == refereeRewardValue
          ? _value.refereeRewardValue
          : refereeRewardValue // ignore: cast_nullable_to_non_nullable
              as int,
      referrerRewardDescription: freezed == referrerRewardDescription
          ? _value.referrerRewardDescription
          : referrerRewardDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      refereeRewardDescription: freezed == refereeRewardDescription
          ? _value.refereeRewardDescription
          : refereeRewardDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      maxReferrals: freezed == maxReferrals
          ? _value.maxReferrals
          : maxReferrals // ignore: cast_nullable_to_non_nullable
              as int?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      terms: freezed == terms
          ? _value._terms
          : terms // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReferralProgramImpl implements _ReferralProgram {
  const _$ReferralProgramImpl(
      {required this.id,
      required this.name,
      required this.description,
      required this.rewardType,
      required this.referrerRewardValue,
      required this.refereeRewardValue,
      this.referrerRewardDescription,
      this.refereeRewardDescription,
      this.expiresAt,
      this.maxReferrals,
      this.isActive = true,
      final Map<String, dynamic>? terms})
      : _terms = terms;

  factory _$ReferralProgramImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReferralProgramImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final ReferralRewardType rewardType;
  @override
  final int referrerRewardValue;
  @override
  final int refereeRewardValue;
  @override
  final String? referrerRewardDescription;
  @override
  final String? refereeRewardDescription;
  @override
  final DateTime? expiresAt;
  @override
  final int? maxReferrals;
  @override
  @JsonKey()
  final bool isActive;
  final Map<String, dynamic>? _terms;
  @override
  Map<String, dynamic>? get terms {
    final value = _terms;
    if (value == null) return null;
    if (_terms is EqualUnmodifiableMapView) return _terms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'ReferralProgram(id: $id, name: $name, description: $description, rewardType: $rewardType, referrerRewardValue: $referrerRewardValue, refereeRewardValue: $refereeRewardValue, referrerRewardDescription: $referrerRewardDescription, refereeRewardDescription: $refereeRewardDescription, expiresAt: $expiresAt, maxReferrals: $maxReferrals, isActive: $isActive, terms: $terms)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReferralProgramImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.rewardType, rewardType) ||
                other.rewardType == rewardType) &&
            (identical(other.referrerRewardValue, referrerRewardValue) ||
                other.referrerRewardValue == referrerRewardValue) &&
            (identical(other.refereeRewardValue, refereeRewardValue) ||
                other.refereeRewardValue == refereeRewardValue) &&
            (identical(other.referrerRewardDescription,
                    referrerRewardDescription) ||
                other.referrerRewardDescription == referrerRewardDescription) &&
            (identical(
                    other.refereeRewardDescription, refereeRewardDescription) ||
                other.refereeRewardDescription == refereeRewardDescription) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.maxReferrals, maxReferrals) ||
                other.maxReferrals == maxReferrals) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            const DeepCollectionEquality().equals(other._terms, _terms));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      rewardType,
      referrerRewardValue,
      refereeRewardValue,
      referrerRewardDescription,
      refereeRewardDescription,
      expiresAt,
      maxReferrals,
      isActive,
      const DeepCollectionEquality().hash(_terms));

  /// Create a copy of ReferralProgram
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReferralProgramImplCopyWith<_$ReferralProgramImpl> get copyWith =>
      __$$ReferralProgramImplCopyWithImpl<_$ReferralProgramImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReferralProgramImplToJson(
      this,
    );
  }
}

abstract class _ReferralProgram implements ReferralProgram {
  const factory _ReferralProgram(
      {required final String id,
      required final String name,
      required final String description,
      required final ReferralRewardType rewardType,
      required final int referrerRewardValue,
      required final int refereeRewardValue,
      final String? referrerRewardDescription,
      final String? refereeRewardDescription,
      final DateTime? expiresAt,
      final int? maxReferrals,
      final bool isActive,
      final Map<String, dynamic>? terms}) = _$ReferralProgramImpl;

  factory _ReferralProgram.fromJson(Map<String, dynamic> json) =
      _$ReferralProgramImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  ReferralRewardType get rewardType;
  @override
  int get referrerRewardValue;
  @override
  int get refereeRewardValue;
  @override
  String? get referrerRewardDescription;
  @override
  String? get refereeRewardDescription;
  @override
  DateTime? get expiresAt;
  @override
  int? get maxReferrals;
  @override
  bool get isActive;
  @override
  Map<String, dynamic>? get terms;

  /// Create a copy of ReferralProgram
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReferralProgramImplCopyWith<_$ReferralProgramImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserReferral _$UserReferralFromJson(Map<String, dynamic> json) {
  return _UserReferral.fromJson(json);
}

/// @nodoc
mixin _$UserReferral {
  String get id => throw _privateConstructorUsedError;
  String get referrerId => throw _privateConstructorUsedError;
  String get referrerName => throw _privateConstructorUsedError;
  String? get referrerAvatar => throw _privateConstructorUsedError;
  String? get refereeId => throw _privateConstructorUsedError;
  String? get refereeName => throw _privateConstructorUsedError;
  String? get refereeAvatar => throw _privateConstructorUsedError;
  String? get refereeEmail => throw _privateConstructorUsedError;
  String? get refereePhone => throw _privateConstructorUsedError;
  String get referralCode => throw _privateConstructorUsedError;
  ReferralStatus get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  DateTime? get rewardedAt => throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  bool get referrerRewarded => throw _privateConstructorUsedError;
  bool get refereeRewarded => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this UserReferral to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserReferral
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserReferralCopyWith<UserReferral> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserReferralCopyWith<$Res> {
  factory $UserReferralCopyWith(
          UserReferral value, $Res Function(UserReferral) then) =
      _$UserReferralCopyWithImpl<$Res, UserReferral>;
  @useResult
  $Res call(
      {String id,
      String referrerId,
      String referrerName,
      String? referrerAvatar,
      String? refereeId,
      String? refereeName,
      String? refereeAvatar,
      String? refereeEmail,
      String? refereePhone,
      String referralCode,
      ReferralStatus status,
      DateTime createdAt,
      DateTime? completedAt,
      DateTime? rewardedAt,
      DateTime? expiresAt,
      bool referrerRewarded,
      bool refereeRewarded,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$UserReferralCopyWithImpl<$Res, $Val extends UserReferral>
    implements $UserReferralCopyWith<$Res> {
  _$UserReferralCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserReferral
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? referrerId = null,
    Object? referrerName = null,
    Object? referrerAvatar = freezed,
    Object? refereeId = freezed,
    Object? refereeName = freezed,
    Object? refereeAvatar = freezed,
    Object? refereeEmail = freezed,
    Object? refereePhone = freezed,
    Object? referralCode = null,
    Object? status = null,
    Object? createdAt = null,
    Object? completedAt = freezed,
    Object? rewardedAt = freezed,
    Object? expiresAt = freezed,
    Object? referrerRewarded = null,
    Object? refereeRewarded = null,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      referrerId: null == referrerId
          ? _value.referrerId
          : referrerId // ignore: cast_nullable_to_non_nullable
              as String,
      referrerName: null == referrerName
          ? _value.referrerName
          : referrerName // ignore: cast_nullable_to_non_nullable
              as String,
      referrerAvatar: freezed == referrerAvatar
          ? _value.referrerAvatar
          : referrerAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      refereeId: freezed == refereeId
          ? _value.refereeId
          : refereeId // ignore: cast_nullable_to_non_nullable
              as String?,
      refereeName: freezed == refereeName
          ? _value.refereeName
          : refereeName // ignore: cast_nullable_to_non_nullable
              as String?,
      refereeAvatar: freezed == refereeAvatar
          ? _value.refereeAvatar
          : refereeAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      refereeEmail: freezed == refereeEmail
          ? _value.refereeEmail
          : refereeEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      refereePhone: freezed == refereePhone
          ? _value.refereePhone
          : refereePhone // ignore: cast_nullable_to_non_nullable
              as String?,
      referralCode: null == referralCode
          ? _value.referralCode
          : referralCode // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ReferralStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      rewardedAt: freezed == rewardedAt
          ? _value.rewardedAt
          : rewardedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      referrerRewarded: null == referrerRewarded
          ? _value.referrerRewarded
          : referrerRewarded // ignore: cast_nullable_to_non_nullable
              as bool,
      refereeRewarded: null == refereeRewarded
          ? _value.refereeRewarded
          : refereeRewarded // ignore: cast_nullable_to_non_nullable
              as bool,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserReferralImplCopyWith<$Res>
    implements $UserReferralCopyWith<$Res> {
  factory _$$UserReferralImplCopyWith(
          _$UserReferralImpl value, $Res Function(_$UserReferralImpl) then) =
      __$$UserReferralImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String referrerId,
      String referrerName,
      String? referrerAvatar,
      String? refereeId,
      String? refereeName,
      String? refereeAvatar,
      String? refereeEmail,
      String? refereePhone,
      String referralCode,
      ReferralStatus status,
      DateTime createdAt,
      DateTime? completedAt,
      DateTime? rewardedAt,
      DateTime? expiresAt,
      bool referrerRewarded,
      bool refereeRewarded,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$UserReferralImplCopyWithImpl<$Res>
    extends _$UserReferralCopyWithImpl<$Res, _$UserReferralImpl>
    implements _$$UserReferralImplCopyWith<$Res> {
  __$$UserReferralImplCopyWithImpl(
      _$UserReferralImpl _value, $Res Function(_$UserReferralImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserReferral
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? referrerId = null,
    Object? referrerName = null,
    Object? referrerAvatar = freezed,
    Object? refereeId = freezed,
    Object? refereeName = freezed,
    Object? refereeAvatar = freezed,
    Object? refereeEmail = freezed,
    Object? refereePhone = freezed,
    Object? referralCode = null,
    Object? status = null,
    Object? createdAt = null,
    Object? completedAt = freezed,
    Object? rewardedAt = freezed,
    Object? expiresAt = freezed,
    Object? referrerRewarded = null,
    Object? refereeRewarded = null,
    Object? metadata = freezed,
  }) {
    return _then(_$UserReferralImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      referrerId: null == referrerId
          ? _value.referrerId
          : referrerId // ignore: cast_nullable_to_non_nullable
              as String,
      referrerName: null == referrerName
          ? _value.referrerName
          : referrerName // ignore: cast_nullable_to_non_nullable
              as String,
      referrerAvatar: freezed == referrerAvatar
          ? _value.referrerAvatar
          : referrerAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      refereeId: freezed == refereeId
          ? _value.refereeId
          : refereeId // ignore: cast_nullable_to_non_nullable
              as String?,
      refereeName: freezed == refereeName
          ? _value.refereeName
          : refereeName // ignore: cast_nullable_to_non_nullable
              as String?,
      refereeAvatar: freezed == refereeAvatar
          ? _value.refereeAvatar
          : refereeAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      refereeEmail: freezed == refereeEmail
          ? _value.refereeEmail
          : refereeEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      refereePhone: freezed == refereePhone
          ? _value.refereePhone
          : refereePhone // ignore: cast_nullable_to_non_nullable
              as String?,
      referralCode: null == referralCode
          ? _value.referralCode
          : referralCode // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ReferralStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      rewardedAt: freezed == rewardedAt
          ? _value.rewardedAt
          : rewardedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      referrerRewarded: null == referrerRewarded
          ? _value.referrerRewarded
          : referrerRewarded // ignore: cast_nullable_to_non_nullable
              as bool,
      refereeRewarded: null == refereeRewarded
          ? _value.refereeRewarded
          : refereeRewarded // ignore: cast_nullable_to_non_nullable
              as bool,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserReferralImpl implements _UserReferral {
  const _$UserReferralImpl(
      {required this.id,
      required this.referrerId,
      required this.referrerName,
      this.referrerAvatar,
      this.refereeId,
      this.refereeName,
      this.refereeAvatar,
      this.refereeEmail,
      this.refereePhone,
      required this.referralCode,
      required this.status,
      required this.createdAt,
      this.completedAt,
      this.rewardedAt,
      this.expiresAt,
      this.referrerRewarded = false,
      this.refereeRewarded = false,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  factory _$UserReferralImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserReferralImplFromJson(json);

  @override
  final String id;
  @override
  final String referrerId;
  @override
  final String referrerName;
  @override
  final String? referrerAvatar;
  @override
  final String? refereeId;
  @override
  final String? refereeName;
  @override
  final String? refereeAvatar;
  @override
  final String? refereeEmail;
  @override
  final String? refereePhone;
  @override
  final String referralCode;
  @override
  final ReferralStatus status;
  @override
  final DateTime createdAt;
  @override
  final DateTime? completedAt;
  @override
  final DateTime? rewardedAt;
  @override
  final DateTime? expiresAt;
  @override
  @JsonKey()
  final bool referrerRewarded;
  @override
  @JsonKey()
  final bool refereeRewarded;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'UserReferral(id: $id, referrerId: $referrerId, referrerName: $referrerName, referrerAvatar: $referrerAvatar, refereeId: $refereeId, refereeName: $refereeName, refereeAvatar: $refereeAvatar, refereeEmail: $refereeEmail, refereePhone: $refereePhone, referralCode: $referralCode, status: $status, createdAt: $createdAt, completedAt: $completedAt, rewardedAt: $rewardedAt, expiresAt: $expiresAt, referrerRewarded: $referrerRewarded, refereeRewarded: $refereeRewarded, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserReferralImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.referrerId, referrerId) ||
                other.referrerId == referrerId) &&
            (identical(other.referrerName, referrerName) ||
                other.referrerName == referrerName) &&
            (identical(other.referrerAvatar, referrerAvatar) ||
                other.referrerAvatar == referrerAvatar) &&
            (identical(other.refereeId, refereeId) ||
                other.refereeId == refereeId) &&
            (identical(other.refereeName, refereeName) ||
                other.refereeName == refereeName) &&
            (identical(other.refereeAvatar, refereeAvatar) ||
                other.refereeAvatar == refereeAvatar) &&
            (identical(other.refereeEmail, refereeEmail) ||
                other.refereeEmail == refereeEmail) &&
            (identical(other.refereePhone, refereePhone) ||
                other.refereePhone == refereePhone) &&
            (identical(other.referralCode, referralCode) ||
                other.referralCode == referralCode) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.rewardedAt, rewardedAt) ||
                other.rewardedAt == rewardedAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.referrerRewarded, referrerRewarded) ||
                other.referrerRewarded == referrerRewarded) &&
            (identical(other.refereeRewarded, refereeRewarded) ||
                other.refereeRewarded == refereeRewarded) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      referrerId,
      referrerName,
      referrerAvatar,
      refereeId,
      refereeName,
      refereeAvatar,
      refereeEmail,
      refereePhone,
      referralCode,
      status,
      createdAt,
      completedAt,
      rewardedAt,
      expiresAt,
      referrerRewarded,
      refereeRewarded,
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of UserReferral
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserReferralImplCopyWith<_$UserReferralImpl> get copyWith =>
      __$$UserReferralImplCopyWithImpl<_$UserReferralImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserReferralImplToJson(
      this,
    );
  }
}

abstract class _UserReferral implements UserReferral {
  const factory _UserReferral(
      {required final String id,
      required final String referrerId,
      required final String referrerName,
      final String? referrerAvatar,
      final String? refereeId,
      final String? refereeName,
      final String? refereeAvatar,
      final String? refereeEmail,
      final String? refereePhone,
      required final String referralCode,
      required final ReferralStatus status,
      required final DateTime createdAt,
      final DateTime? completedAt,
      final DateTime? rewardedAt,
      final DateTime? expiresAt,
      final bool referrerRewarded,
      final bool refereeRewarded,
      final Map<String, dynamic>? metadata}) = _$UserReferralImpl;

  factory _UserReferral.fromJson(Map<String, dynamic> json) =
      _$UserReferralImpl.fromJson;

  @override
  String get id;
  @override
  String get referrerId;
  @override
  String get referrerName;
  @override
  String? get referrerAvatar;
  @override
  String? get refereeId;
  @override
  String? get refereeName;
  @override
  String? get refereeAvatar;
  @override
  String? get refereeEmail;
  @override
  String? get refereePhone;
  @override
  String get referralCode;
  @override
  ReferralStatus get status;
  @override
  DateTime get createdAt;
  @override
  DateTime? get completedAt;
  @override
  DateTime? get rewardedAt;
  @override
  DateTime? get expiresAt;
  @override
  bool get referrerRewarded;
  @override
  bool get refereeRewarded;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of UserReferral
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserReferralImplCopyWith<_$UserReferralImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReferralStats _$ReferralStatsFromJson(Map<String, dynamic> json) {
  return _ReferralStats.fromJson(json);
}

/// @nodoc
mixin _$ReferralStats {
  int get totalReferrals => throw _privateConstructorUsedError;
  int get completedReferrals => throw _privateConstructorUsedError;
  int get pendingReferrals => throw _privateConstructorUsedError;
  int get totalRewardsEarned => throw _privateConstructorUsedError;
  int get pointsEarned => throw _privateConstructorUsedError;
  double get cashbackEarned => throw _privateConstructorUsedError;
  List<String>? get topReferredUsers => throw _privateConstructorUsedError;
  DateTime? get lastReferralDate => throw _privateConstructorUsedError;
  Map<String, int>? get referralsByMonth => throw _privateConstructorUsedError;

  /// Serializes this ReferralStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReferralStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReferralStatsCopyWith<ReferralStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReferralStatsCopyWith<$Res> {
  factory $ReferralStatsCopyWith(
          ReferralStats value, $Res Function(ReferralStats) then) =
      _$ReferralStatsCopyWithImpl<$Res, ReferralStats>;
  @useResult
  $Res call(
      {int totalReferrals,
      int completedReferrals,
      int pendingReferrals,
      int totalRewardsEarned,
      int pointsEarned,
      double cashbackEarned,
      List<String>? topReferredUsers,
      DateTime? lastReferralDate,
      Map<String, int>? referralsByMonth});
}

/// @nodoc
class _$ReferralStatsCopyWithImpl<$Res, $Val extends ReferralStats>
    implements $ReferralStatsCopyWith<$Res> {
  _$ReferralStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReferralStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalReferrals = null,
    Object? completedReferrals = null,
    Object? pendingReferrals = null,
    Object? totalRewardsEarned = null,
    Object? pointsEarned = null,
    Object? cashbackEarned = null,
    Object? topReferredUsers = freezed,
    Object? lastReferralDate = freezed,
    Object? referralsByMonth = freezed,
  }) {
    return _then(_value.copyWith(
      totalReferrals: null == totalReferrals
          ? _value.totalReferrals
          : totalReferrals // ignore: cast_nullable_to_non_nullable
              as int,
      completedReferrals: null == completedReferrals
          ? _value.completedReferrals
          : completedReferrals // ignore: cast_nullable_to_non_nullable
              as int,
      pendingReferrals: null == pendingReferrals
          ? _value.pendingReferrals
          : pendingReferrals // ignore: cast_nullable_to_non_nullable
              as int,
      totalRewardsEarned: null == totalRewardsEarned
          ? _value.totalRewardsEarned
          : totalRewardsEarned // ignore: cast_nullable_to_non_nullable
              as int,
      pointsEarned: null == pointsEarned
          ? _value.pointsEarned
          : pointsEarned // ignore: cast_nullable_to_non_nullable
              as int,
      cashbackEarned: null == cashbackEarned
          ? _value.cashbackEarned
          : cashbackEarned // ignore: cast_nullable_to_non_nullable
              as double,
      topReferredUsers: freezed == topReferredUsers
          ? _value.topReferredUsers
          : topReferredUsers // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      lastReferralDate: freezed == lastReferralDate
          ? _value.lastReferralDate
          : lastReferralDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      referralsByMonth: freezed == referralsByMonth
          ? _value.referralsByMonth
          : referralsByMonth // ignore: cast_nullable_to_non_nullable
              as Map<String, int>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReferralStatsImplCopyWith<$Res>
    implements $ReferralStatsCopyWith<$Res> {
  factory _$$ReferralStatsImplCopyWith(
          _$ReferralStatsImpl value, $Res Function(_$ReferralStatsImpl) then) =
      __$$ReferralStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalReferrals,
      int completedReferrals,
      int pendingReferrals,
      int totalRewardsEarned,
      int pointsEarned,
      double cashbackEarned,
      List<String>? topReferredUsers,
      DateTime? lastReferralDate,
      Map<String, int>? referralsByMonth});
}

/// @nodoc
class __$$ReferralStatsImplCopyWithImpl<$Res>
    extends _$ReferralStatsCopyWithImpl<$Res, _$ReferralStatsImpl>
    implements _$$ReferralStatsImplCopyWith<$Res> {
  __$$ReferralStatsImplCopyWithImpl(
      _$ReferralStatsImpl _value, $Res Function(_$ReferralStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReferralStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalReferrals = null,
    Object? completedReferrals = null,
    Object? pendingReferrals = null,
    Object? totalRewardsEarned = null,
    Object? pointsEarned = null,
    Object? cashbackEarned = null,
    Object? topReferredUsers = freezed,
    Object? lastReferralDate = freezed,
    Object? referralsByMonth = freezed,
  }) {
    return _then(_$ReferralStatsImpl(
      totalReferrals: null == totalReferrals
          ? _value.totalReferrals
          : totalReferrals // ignore: cast_nullable_to_non_nullable
              as int,
      completedReferrals: null == completedReferrals
          ? _value.completedReferrals
          : completedReferrals // ignore: cast_nullable_to_non_nullable
              as int,
      pendingReferrals: null == pendingReferrals
          ? _value.pendingReferrals
          : pendingReferrals // ignore: cast_nullable_to_non_nullable
              as int,
      totalRewardsEarned: null == totalRewardsEarned
          ? _value.totalRewardsEarned
          : totalRewardsEarned // ignore: cast_nullable_to_non_nullable
              as int,
      pointsEarned: null == pointsEarned
          ? _value.pointsEarned
          : pointsEarned // ignore: cast_nullable_to_non_nullable
              as int,
      cashbackEarned: null == cashbackEarned
          ? _value.cashbackEarned
          : cashbackEarned // ignore: cast_nullable_to_non_nullable
              as double,
      topReferredUsers: freezed == topReferredUsers
          ? _value._topReferredUsers
          : topReferredUsers // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      lastReferralDate: freezed == lastReferralDate
          ? _value.lastReferralDate
          : lastReferralDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      referralsByMonth: freezed == referralsByMonth
          ? _value._referralsByMonth
          : referralsByMonth // ignore: cast_nullable_to_non_nullable
              as Map<String, int>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReferralStatsImpl implements _ReferralStats {
  const _$ReferralStatsImpl(
      {required this.totalReferrals,
      required this.completedReferrals,
      required this.pendingReferrals,
      required this.totalRewardsEarned,
      this.pointsEarned = 0,
      this.cashbackEarned = 0.0,
      final List<String>? topReferredUsers,
      this.lastReferralDate,
      final Map<String, int>? referralsByMonth})
      : _topReferredUsers = topReferredUsers,
        _referralsByMonth = referralsByMonth;

  factory _$ReferralStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReferralStatsImplFromJson(json);

  @override
  final int totalReferrals;
  @override
  final int completedReferrals;
  @override
  final int pendingReferrals;
  @override
  final int totalRewardsEarned;
  @override
  @JsonKey()
  final int pointsEarned;
  @override
  @JsonKey()
  final double cashbackEarned;
  final List<String>? _topReferredUsers;
  @override
  List<String>? get topReferredUsers {
    final value = _topReferredUsers;
    if (value == null) return null;
    if (_topReferredUsers is EqualUnmodifiableListView)
      return _topReferredUsers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime? lastReferralDate;
  final Map<String, int>? _referralsByMonth;
  @override
  Map<String, int>? get referralsByMonth {
    final value = _referralsByMonth;
    if (value == null) return null;
    if (_referralsByMonth is EqualUnmodifiableMapView) return _referralsByMonth;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'ReferralStats(totalReferrals: $totalReferrals, completedReferrals: $completedReferrals, pendingReferrals: $pendingReferrals, totalRewardsEarned: $totalRewardsEarned, pointsEarned: $pointsEarned, cashbackEarned: $cashbackEarned, topReferredUsers: $topReferredUsers, lastReferralDate: $lastReferralDate, referralsByMonth: $referralsByMonth)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReferralStatsImpl &&
            (identical(other.totalReferrals, totalReferrals) ||
                other.totalReferrals == totalReferrals) &&
            (identical(other.completedReferrals, completedReferrals) ||
                other.completedReferrals == completedReferrals) &&
            (identical(other.pendingReferrals, pendingReferrals) ||
                other.pendingReferrals == pendingReferrals) &&
            (identical(other.totalRewardsEarned, totalRewardsEarned) ||
                other.totalRewardsEarned == totalRewardsEarned) &&
            (identical(other.pointsEarned, pointsEarned) ||
                other.pointsEarned == pointsEarned) &&
            (identical(other.cashbackEarned, cashbackEarned) ||
                other.cashbackEarned == cashbackEarned) &&
            const DeepCollectionEquality()
                .equals(other._topReferredUsers, _topReferredUsers) &&
            (identical(other.lastReferralDate, lastReferralDate) ||
                other.lastReferralDate == lastReferralDate) &&
            const DeepCollectionEquality()
                .equals(other._referralsByMonth, _referralsByMonth));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalReferrals,
      completedReferrals,
      pendingReferrals,
      totalRewardsEarned,
      pointsEarned,
      cashbackEarned,
      const DeepCollectionEquality().hash(_topReferredUsers),
      lastReferralDate,
      const DeepCollectionEquality().hash(_referralsByMonth));

  /// Create a copy of ReferralStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReferralStatsImplCopyWith<_$ReferralStatsImpl> get copyWith =>
      __$$ReferralStatsImplCopyWithImpl<_$ReferralStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReferralStatsImplToJson(
      this,
    );
  }
}

abstract class _ReferralStats implements ReferralStats {
  const factory _ReferralStats(
      {required final int totalReferrals,
      required final int completedReferrals,
      required final int pendingReferrals,
      required final int totalRewardsEarned,
      final int pointsEarned,
      final double cashbackEarned,
      final List<String>? topReferredUsers,
      final DateTime? lastReferralDate,
      final Map<String, int>? referralsByMonth}) = _$ReferralStatsImpl;

  factory _ReferralStats.fromJson(Map<String, dynamic> json) =
      _$ReferralStatsImpl.fromJson;

  @override
  int get totalReferrals;
  @override
  int get completedReferrals;
  @override
  int get pendingReferrals;
  @override
  int get totalRewardsEarned;
  @override
  int get pointsEarned;
  @override
  double get cashbackEarned;
  @override
  List<String>? get topReferredUsers;
  @override
  DateTime? get lastReferralDate;
  @override
  Map<String, int>? get referralsByMonth;

  /// Create a copy of ReferralStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReferralStatsImplCopyWith<_$ReferralStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReferralLeaderboard _$ReferralLeaderboardFromJson(Map<String, dynamic> json) {
  return _ReferralLeaderboard.fromJson(json);
}

/// @nodoc
mixin _$ReferralLeaderboard {
  String get userId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  String? get userAvatar => throw _privateConstructorUsedError;
  int get totalReferrals => throw _privateConstructorUsedError;
  int get rank => throw _privateConstructorUsedError;
  int get pointsEarned => throw _privateConstructorUsedError;

  /// Serializes this ReferralLeaderboard to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReferralLeaderboard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReferralLeaderboardCopyWith<ReferralLeaderboard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReferralLeaderboardCopyWith<$Res> {
  factory $ReferralLeaderboardCopyWith(
          ReferralLeaderboard value, $Res Function(ReferralLeaderboard) then) =
      _$ReferralLeaderboardCopyWithImpl<$Res, ReferralLeaderboard>;
  @useResult
  $Res call(
      {String userId,
      String userName,
      String? userAvatar,
      int totalReferrals,
      int rank,
      int pointsEarned});
}

/// @nodoc
class _$ReferralLeaderboardCopyWithImpl<$Res, $Val extends ReferralLeaderboard>
    implements $ReferralLeaderboardCopyWith<$Res> {
  _$ReferralLeaderboardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReferralLeaderboard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? userName = null,
    Object? userAvatar = freezed,
    Object? totalReferrals = null,
    Object? rank = null,
    Object? pointsEarned = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      userAvatar: freezed == userAvatar
          ? _value.userAvatar
          : userAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      totalReferrals: null == totalReferrals
          ? _value.totalReferrals
          : totalReferrals // ignore: cast_nullable_to_non_nullable
              as int,
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int,
      pointsEarned: null == pointsEarned
          ? _value.pointsEarned
          : pointsEarned // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReferralLeaderboardImplCopyWith<$Res>
    implements $ReferralLeaderboardCopyWith<$Res> {
  factory _$$ReferralLeaderboardImplCopyWith(_$ReferralLeaderboardImpl value,
          $Res Function(_$ReferralLeaderboardImpl) then) =
      __$$ReferralLeaderboardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String userName,
      String? userAvatar,
      int totalReferrals,
      int rank,
      int pointsEarned});
}

/// @nodoc
class __$$ReferralLeaderboardImplCopyWithImpl<$Res>
    extends _$ReferralLeaderboardCopyWithImpl<$Res, _$ReferralLeaderboardImpl>
    implements _$$ReferralLeaderboardImplCopyWith<$Res> {
  __$$ReferralLeaderboardImplCopyWithImpl(_$ReferralLeaderboardImpl _value,
      $Res Function(_$ReferralLeaderboardImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReferralLeaderboard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? userName = null,
    Object? userAvatar = freezed,
    Object? totalReferrals = null,
    Object? rank = null,
    Object? pointsEarned = null,
  }) {
    return _then(_$ReferralLeaderboardImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      userAvatar: freezed == userAvatar
          ? _value.userAvatar
          : userAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      totalReferrals: null == totalReferrals
          ? _value.totalReferrals
          : totalReferrals // ignore: cast_nullable_to_non_nullable
              as int,
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int,
      pointsEarned: null == pointsEarned
          ? _value.pointsEarned
          : pointsEarned // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReferralLeaderboardImpl implements _ReferralLeaderboard {
  const _$ReferralLeaderboardImpl(
      {required this.userId,
      required this.userName,
      this.userAvatar,
      required this.totalReferrals,
      required this.rank,
      this.pointsEarned = 0});

  factory _$ReferralLeaderboardImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReferralLeaderboardImplFromJson(json);

  @override
  final String userId;
  @override
  final String userName;
  @override
  final String? userAvatar;
  @override
  final int totalReferrals;
  @override
  final int rank;
  @override
  @JsonKey()
  final int pointsEarned;

  @override
  String toString() {
    return 'ReferralLeaderboard(userId: $userId, userName: $userName, userAvatar: $userAvatar, totalReferrals: $totalReferrals, rank: $rank, pointsEarned: $pointsEarned)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReferralLeaderboardImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userAvatar, userAvatar) ||
                other.userAvatar == userAvatar) &&
            (identical(other.totalReferrals, totalReferrals) ||
                other.totalReferrals == totalReferrals) &&
            (identical(other.rank, rank) || other.rank == rank) &&
            (identical(other.pointsEarned, pointsEarned) ||
                other.pointsEarned == pointsEarned));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, userName, userAvatar,
      totalReferrals, rank, pointsEarned);

  /// Create a copy of ReferralLeaderboard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReferralLeaderboardImplCopyWith<_$ReferralLeaderboardImpl> get copyWith =>
      __$$ReferralLeaderboardImplCopyWithImpl<_$ReferralLeaderboardImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReferralLeaderboardImplToJson(
      this,
    );
  }
}

abstract class _ReferralLeaderboard implements ReferralLeaderboard {
  const factory _ReferralLeaderboard(
      {required final String userId,
      required final String userName,
      final String? userAvatar,
      required final int totalReferrals,
      required final int rank,
      final int pointsEarned}) = _$ReferralLeaderboardImpl;

  factory _ReferralLeaderboard.fromJson(Map<String, dynamic> json) =
      _$ReferralLeaderboardImpl.fromJson;

  @override
  String get userId;
  @override
  String get userName;
  @override
  String? get userAvatar;
  @override
  int get totalReferrals;
  @override
  int get rank;
  @override
  int get pointsEarned;

  /// Create a copy of ReferralLeaderboard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReferralLeaderboardImplCopyWith<_$ReferralLeaderboardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
