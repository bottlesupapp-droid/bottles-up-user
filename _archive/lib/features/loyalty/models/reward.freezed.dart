// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reward.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Reward _$RewardFromJson(Map<String, dynamic> json) {
  return _Reward.fromJson(json);
}

/// @nodoc
mixin _$Reward {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  RewardType get type => throw _privateConstructorUsedError;
  RewardStatus get status => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  double? get discountPercentage => throw _privateConstructorUsedError;
  double? get discountAmount => throw _privateConstructorUsedError;
  int? get pointsCost => throw _privateConstructorUsedError;
  int? get pointsValue => throw _privateConstructorUsedError;
  String? get itemId => throw _privateConstructorUsedError;
  String? get itemName => throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  DateTime? get availableFrom => throw _privateConstructorUsedError;
  String? get termsAndConditions => throw _privateConstructorUsedError;
  bool get isBirthdayReward => throw _privateConstructorUsedError;
  bool get isLimitedTime => throw _privateConstructorUsedError;
  int? get maxRedemptions => throw _privateConstructorUsedError;
  int? get currentRedemptions => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this Reward to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Reward
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RewardCopyWith<Reward> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RewardCopyWith<$Res> {
  factory $RewardCopyWith(Reward value, $Res Function(Reward) then) =
      _$RewardCopyWithImpl<$Res, Reward>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      RewardType type,
      RewardStatus status,
      String? imageUrl,
      double? discountPercentage,
      double? discountAmount,
      int? pointsCost,
      int? pointsValue,
      String? itemId,
      String? itemName,
      DateTime? expiresAt,
      DateTime? availableFrom,
      String? termsAndConditions,
      bool isBirthdayReward,
      bool isLimitedTime,
      int? maxRedemptions,
      int? currentRedemptions,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$RewardCopyWithImpl<$Res, $Val extends Reward>
    implements $RewardCopyWith<$Res> {
  _$RewardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Reward
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? type = null,
    Object? status = null,
    Object? imageUrl = freezed,
    Object? discountPercentage = freezed,
    Object? discountAmount = freezed,
    Object? pointsCost = freezed,
    Object? pointsValue = freezed,
    Object? itemId = freezed,
    Object? itemName = freezed,
    Object? expiresAt = freezed,
    Object? availableFrom = freezed,
    Object? termsAndConditions = freezed,
    Object? isBirthdayReward = null,
    Object? isLimitedTime = null,
    Object? maxRedemptions = freezed,
    Object? currentRedemptions = freezed,
    Object? metadata = freezed,
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as RewardType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as RewardStatus,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      discountPercentage: freezed == discountPercentage
          ? _value.discountPercentage
          : discountPercentage // ignore: cast_nullable_to_non_nullable
              as double?,
      discountAmount: freezed == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      pointsCost: freezed == pointsCost
          ? _value.pointsCost
          : pointsCost // ignore: cast_nullable_to_non_nullable
              as int?,
      pointsValue: freezed == pointsValue
          ? _value.pointsValue
          : pointsValue // ignore: cast_nullable_to_non_nullable
              as int?,
      itemId: freezed == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String?,
      itemName: freezed == itemName
          ? _value.itemName
          : itemName // ignore: cast_nullable_to_non_nullable
              as String?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      availableFrom: freezed == availableFrom
          ? _value.availableFrom
          : availableFrom // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      termsAndConditions: freezed == termsAndConditions
          ? _value.termsAndConditions
          : termsAndConditions // ignore: cast_nullable_to_non_nullable
              as String?,
      isBirthdayReward: null == isBirthdayReward
          ? _value.isBirthdayReward
          : isBirthdayReward // ignore: cast_nullable_to_non_nullable
              as bool,
      isLimitedTime: null == isLimitedTime
          ? _value.isLimitedTime
          : isLimitedTime // ignore: cast_nullable_to_non_nullable
              as bool,
      maxRedemptions: freezed == maxRedemptions
          ? _value.maxRedemptions
          : maxRedemptions // ignore: cast_nullable_to_non_nullable
              as int?,
      currentRedemptions: freezed == currentRedemptions
          ? _value.currentRedemptions
          : currentRedemptions // ignore: cast_nullable_to_non_nullable
              as int?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RewardImplCopyWith<$Res> implements $RewardCopyWith<$Res> {
  factory _$$RewardImplCopyWith(
          _$RewardImpl value, $Res Function(_$RewardImpl) then) =
      __$$RewardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      RewardType type,
      RewardStatus status,
      String? imageUrl,
      double? discountPercentage,
      double? discountAmount,
      int? pointsCost,
      int? pointsValue,
      String? itemId,
      String? itemName,
      DateTime? expiresAt,
      DateTime? availableFrom,
      String? termsAndConditions,
      bool isBirthdayReward,
      bool isLimitedTime,
      int? maxRedemptions,
      int? currentRedemptions,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$RewardImplCopyWithImpl<$Res>
    extends _$RewardCopyWithImpl<$Res, _$RewardImpl>
    implements _$$RewardImplCopyWith<$Res> {
  __$$RewardImplCopyWithImpl(
      _$RewardImpl _value, $Res Function(_$RewardImpl) _then)
      : super(_value, _then);

  /// Create a copy of Reward
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? type = null,
    Object? status = null,
    Object? imageUrl = freezed,
    Object? discountPercentage = freezed,
    Object? discountAmount = freezed,
    Object? pointsCost = freezed,
    Object? pointsValue = freezed,
    Object? itemId = freezed,
    Object? itemName = freezed,
    Object? expiresAt = freezed,
    Object? availableFrom = freezed,
    Object? termsAndConditions = freezed,
    Object? isBirthdayReward = null,
    Object? isLimitedTime = null,
    Object? maxRedemptions = freezed,
    Object? currentRedemptions = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$RewardImpl(
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as RewardType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as RewardStatus,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      discountPercentage: freezed == discountPercentage
          ? _value.discountPercentage
          : discountPercentage // ignore: cast_nullable_to_non_nullable
              as double?,
      discountAmount: freezed == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      pointsCost: freezed == pointsCost
          ? _value.pointsCost
          : pointsCost // ignore: cast_nullable_to_non_nullable
              as int?,
      pointsValue: freezed == pointsValue
          ? _value.pointsValue
          : pointsValue // ignore: cast_nullable_to_non_nullable
              as int?,
      itemId: freezed == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String?,
      itemName: freezed == itemName
          ? _value.itemName
          : itemName // ignore: cast_nullable_to_non_nullable
              as String?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      availableFrom: freezed == availableFrom
          ? _value.availableFrom
          : availableFrom // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      termsAndConditions: freezed == termsAndConditions
          ? _value.termsAndConditions
          : termsAndConditions // ignore: cast_nullable_to_non_nullable
              as String?,
      isBirthdayReward: null == isBirthdayReward
          ? _value.isBirthdayReward
          : isBirthdayReward // ignore: cast_nullable_to_non_nullable
              as bool,
      isLimitedTime: null == isLimitedTime
          ? _value.isLimitedTime
          : isLimitedTime // ignore: cast_nullable_to_non_nullable
              as bool,
      maxRedemptions: freezed == maxRedemptions
          ? _value.maxRedemptions
          : maxRedemptions // ignore: cast_nullable_to_non_nullable
              as int?,
      currentRedemptions: freezed == currentRedemptions
          ? _value.currentRedemptions
          : currentRedemptions // ignore: cast_nullable_to_non_nullable
              as int?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RewardImpl implements _Reward {
  const _$RewardImpl(
      {required this.id,
      required this.name,
      required this.description,
      required this.type,
      required this.status,
      this.imageUrl,
      this.discountPercentage,
      this.discountAmount,
      this.pointsCost,
      this.pointsValue,
      this.itemId,
      this.itemName,
      this.expiresAt,
      this.availableFrom,
      this.termsAndConditions,
      this.isBirthdayReward = false,
      this.isLimitedTime = false,
      this.maxRedemptions,
      this.currentRedemptions,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  factory _$RewardImpl.fromJson(Map<String, dynamic> json) =>
      _$$RewardImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final RewardType type;
  @override
  final RewardStatus status;
  @override
  final String? imageUrl;
  @override
  final double? discountPercentage;
  @override
  final double? discountAmount;
  @override
  final int? pointsCost;
  @override
  final int? pointsValue;
  @override
  final String? itemId;
  @override
  final String? itemName;
  @override
  final DateTime? expiresAt;
  @override
  final DateTime? availableFrom;
  @override
  final String? termsAndConditions;
  @override
  @JsonKey()
  final bool isBirthdayReward;
  @override
  @JsonKey()
  final bool isLimitedTime;
  @override
  final int? maxRedemptions;
  @override
  final int? currentRedemptions;
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
    return 'Reward(id: $id, name: $name, description: $description, type: $type, status: $status, imageUrl: $imageUrl, discountPercentage: $discountPercentage, discountAmount: $discountAmount, pointsCost: $pointsCost, pointsValue: $pointsValue, itemId: $itemId, itemName: $itemName, expiresAt: $expiresAt, availableFrom: $availableFrom, termsAndConditions: $termsAndConditions, isBirthdayReward: $isBirthdayReward, isLimitedTime: $isLimitedTime, maxRedemptions: $maxRedemptions, currentRedemptions: $currentRedemptions, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RewardImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.discountPercentage, discountPercentage) ||
                other.discountPercentage == discountPercentage) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.pointsCost, pointsCost) ||
                other.pointsCost == pointsCost) &&
            (identical(other.pointsValue, pointsValue) ||
                other.pointsValue == pointsValue) &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.itemName, itemName) ||
                other.itemName == itemName) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.availableFrom, availableFrom) ||
                other.availableFrom == availableFrom) &&
            (identical(other.termsAndConditions, termsAndConditions) ||
                other.termsAndConditions == termsAndConditions) &&
            (identical(other.isBirthdayReward, isBirthdayReward) ||
                other.isBirthdayReward == isBirthdayReward) &&
            (identical(other.isLimitedTime, isLimitedTime) ||
                other.isLimitedTime == isLimitedTime) &&
            (identical(other.maxRedemptions, maxRedemptions) ||
                other.maxRedemptions == maxRedemptions) &&
            (identical(other.currentRedemptions, currentRedemptions) ||
                other.currentRedemptions == currentRedemptions) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        description,
        type,
        status,
        imageUrl,
        discountPercentage,
        discountAmount,
        pointsCost,
        pointsValue,
        itemId,
        itemName,
        expiresAt,
        availableFrom,
        termsAndConditions,
        isBirthdayReward,
        isLimitedTime,
        maxRedemptions,
        currentRedemptions,
        const DeepCollectionEquality().hash(_metadata)
      ]);

  /// Create a copy of Reward
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RewardImplCopyWith<_$RewardImpl> get copyWith =>
      __$$RewardImplCopyWithImpl<_$RewardImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RewardImplToJson(
      this,
    );
  }
}

abstract class _Reward implements Reward {
  const factory _Reward(
      {required final String id,
      required final String name,
      required final String description,
      required final RewardType type,
      required final RewardStatus status,
      final String? imageUrl,
      final double? discountPercentage,
      final double? discountAmount,
      final int? pointsCost,
      final int? pointsValue,
      final String? itemId,
      final String? itemName,
      final DateTime? expiresAt,
      final DateTime? availableFrom,
      final String? termsAndConditions,
      final bool isBirthdayReward,
      final bool isLimitedTime,
      final int? maxRedemptions,
      final int? currentRedemptions,
      final Map<String, dynamic>? metadata}) = _$RewardImpl;

  factory _Reward.fromJson(Map<String, dynamic> json) = _$RewardImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  RewardType get type;
  @override
  RewardStatus get status;
  @override
  String? get imageUrl;
  @override
  double? get discountPercentage;
  @override
  double? get discountAmount;
  @override
  int? get pointsCost;
  @override
  int? get pointsValue;
  @override
  String? get itemId;
  @override
  String? get itemName;
  @override
  DateTime? get expiresAt;
  @override
  DateTime? get availableFrom;
  @override
  String? get termsAndConditions;
  @override
  bool get isBirthdayReward;
  @override
  bool get isLimitedTime;
  @override
  int? get maxRedemptions;
  @override
  int? get currentRedemptions;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of Reward
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RewardImplCopyWith<_$RewardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserReward _$UserRewardFromJson(Map<String, dynamic> json) {
  return _UserReward.fromJson(json);
}

/// @nodoc
mixin _$UserReward {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  Reward get reward => throw _privateConstructorUsedError;
  RewardStatus get status => throw _privateConstructorUsedError;
  DateTime get acquiredAt => throw _privateConstructorUsedError;
  DateTime? get redeemedAt => throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  String? get redemptionCode => throw _privateConstructorUsedError;
  String? get usedAtBookingId => throw _privateConstructorUsedError;

  /// Serializes this UserReward to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserReward
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserRewardCopyWith<UserReward> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserRewardCopyWith<$Res> {
  factory $UserRewardCopyWith(
          UserReward value, $Res Function(UserReward) then) =
      _$UserRewardCopyWithImpl<$Res, UserReward>;
  @useResult
  $Res call(
      {String id,
      String userId,
      Reward reward,
      RewardStatus status,
      DateTime acquiredAt,
      DateTime? redeemedAt,
      DateTime? expiresAt,
      String? redemptionCode,
      String? usedAtBookingId});

  $RewardCopyWith<$Res> get reward;
}

/// @nodoc
class _$UserRewardCopyWithImpl<$Res, $Val extends UserReward>
    implements $UserRewardCopyWith<$Res> {
  _$UserRewardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserReward
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? reward = null,
    Object? status = null,
    Object? acquiredAt = null,
    Object? redeemedAt = freezed,
    Object? expiresAt = freezed,
    Object? redemptionCode = freezed,
    Object? usedAtBookingId = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      reward: null == reward
          ? _value.reward
          : reward // ignore: cast_nullable_to_non_nullable
              as Reward,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as RewardStatus,
      acquiredAt: null == acquiredAt
          ? _value.acquiredAt
          : acquiredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      redeemedAt: freezed == redeemedAt
          ? _value.redeemedAt
          : redeemedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      redemptionCode: freezed == redemptionCode
          ? _value.redemptionCode
          : redemptionCode // ignore: cast_nullable_to_non_nullable
              as String?,
      usedAtBookingId: freezed == usedAtBookingId
          ? _value.usedAtBookingId
          : usedAtBookingId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of UserReward
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RewardCopyWith<$Res> get reward {
    return $RewardCopyWith<$Res>(_value.reward, (value) {
      return _then(_value.copyWith(reward: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserRewardImplCopyWith<$Res>
    implements $UserRewardCopyWith<$Res> {
  factory _$$UserRewardImplCopyWith(
          _$UserRewardImpl value, $Res Function(_$UserRewardImpl) then) =
      __$$UserRewardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      Reward reward,
      RewardStatus status,
      DateTime acquiredAt,
      DateTime? redeemedAt,
      DateTime? expiresAt,
      String? redemptionCode,
      String? usedAtBookingId});

  @override
  $RewardCopyWith<$Res> get reward;
}

/// @nodoc
class __$$UserRewardImplCopyWithImpl<$Res>
    extends _$UserRewardCopyWithImpl<$Res, _$UserRewardImpl>
    implements _$$UserRewardImplCopyWith<$Res> {
  __$$UserRewardImplCopyWithImpl(
      _$UserRewardImpl _value, $Res Function(_$UserRewardImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserReward
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? reward = null,
    Object? status = null,
    Object? acquiredAt = null,
    Object? redeemedAt = freezed,
    Object? expiresAt = freezed,
    Object? redemptionCode = freezed,
    Object? usedAtBookingId = freezed,
  }) {
    return _then(_$UserRewardImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      reward: null == reward
          ? _value.reward
          : reward // ignore: cast_nullable_to_non_nullable
              as Reward,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as RewardStatus,
      acquiredAt: null == acquiredAt
          ? _value.acquiredAt
          : acquiredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      redeemedAt: freezed == redeemedAt
          ? _value.redeemedAt
          : redeemedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      redemptionCode: freezed == redemptionCode
          ? _value.redemptionCode
          : redemptionCode // ignore: cast_nullable_to_non_nullable
              as String?,
      usedAtBookingId: freezed == usedAtBookingId
          ? _value.usedAtBookingId
          : usedAtBookingId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserRewardImpl implements _UserReward {
  const _$UserRewardImpl(
      {required this.id,
      required this.userId,
      required this.reward,
      this.status = RewardStatus.available,
      required this.acquiredAt,
      this.redeemedAt,
      this.expiresAt,
      this.redemptionCode,
      this.usedAtBookingId});

  factory _$UserRewardImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserRewardImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final Reward reward;
  @override
  @JsonKey()
  final RewardStatus status;
  @override
  final DateTime acquiredAt;
  @override
  final DateTime? redeemedAt;
  @override
  final DateTime? expiresAt;
  @override
  final String? redemptionCode;
  @override
  final String? usedAtBookingId;

  @override
  String toString() {
    return 'UserReward(id: $id, userId: $userId, reward: $reward, status: $status, acquiredAt: $acquiredAt, redeemedAt: $redeemedAt, expiresAt: $expiresAt, redemptionCode: $redemptionCode, usedAtBookingId: $usedAtBookingId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserRewardImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.reward, reward) || other.reward == reward) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.acquiredAt, acquiredAt) ||
                other.acquiredAt == acquiredAt) &&
            (identical(other.redeemedAt, redeemedAt) ||
                other.redeemedAt == redeemedAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.redemptionCode, redemptionCode) ||
                other.redemptionCode == redemptionCode) &&
            (identical(other.usedAtBookingId, usedAtBookingId) ||
                other.usedAtBookingId == usedAtBookingId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, reward, status,
      acquiredAt, redeemedAt, expiresAt, redemptionCode, usedAtBookingId);

  /// Create a copy of UserReward
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserRewardImplCopyWith<_$UserRewardImpl> get copyWith =>
      __$$UserRewardImplCopyWithImpl<_$UserRewardImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserRewardImplToJson(
      this,
    );
  }
}

abstract class _UserReward implements UserReward {
  const factory _UserReward(
      {required final String id,
      required final String userId,
      required final Reward reward,
      final RewardStatus status,
      required final DateTime acquiredAt,
      final DateTime? redeemedAt,
      final DateTime? expiresAt,
      final String? redemptionCode,
      final String? usedAtBookingId}) = _$UserRewardImpl;

  factory _UserReward.fromJson(Map<String, dynamic> json) =
      _$UserRewardImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  Reward get reward;
  @override
  RewardStatus get status;
  @override
  DateTime get acquiredAt;
  @override
  DateTime? get redeemedAt;
  @override
  DateTime? get expiresAt;
  @override
  String? get redemptionCode;
  @override
  String? get usedAtBookingId;

  /// Create a copy of UserReward
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserRewardImplCopyWith<_$UserRewardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BirthdayReward _$BirthdayRewardFromJson(Map<String, dynamic> json) {
  return _BirthdayReward.fromJson(json);
}

/// @nodoc
mixin _$BirthdayReward {
  String get userId => throw _privateConstructorUsedError;
  int get birthMonth => throw _privateConstructorUsedError;
  int get birthDay => throw _privateConstructorUsedError;
  Reward get reward => throw _privateConstructorUsedError;
  bool get hasClaimedThisYear => throw _privateConstructorUsedError;
  DateTime? get lastClaimedAt => throw _privateConstructorUsedError;
  DateTime? get nextEligibleDate => throw _privateConstructorUsedError;

  /// Serializes this BirthdayReward to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BirthdayReward
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BirthdayRewardCopyWith<BirthdayReward> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BirthdayRewardCopyWith<$Res> {
  factory $BirthdayRewardCopyWith(
          BirthdayReward value, $Res Function(BirthdayReward) then) =
      _$BirthdayRewardCopyWithImpl<$Res, BirthdayReward>;
  @useResult
  $Res call(
      {String userId,
      int birthMonth,
      int birthDay,
      Reward reward,
      bool hasClaimedThisYear,
      DateTime? lastClaimedAt,
      DateTime? nextEligibleDate});

  $RewardCopyWith<$Res> get reward;
}

/// @nodoc
class _$BirthdayRewardCopyWithImpl<$Res, $Val extends BirthdayReward>
    implements $BirthdayRewardCopyWith<$Res> {
  _$BirthdayRewardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BirthdayReward
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? birthMonth = null,
    Object? birthDay = null,
    Object? reward = null,
    Object? hasClaimedThisYear = null,
    Object? lastClaimedAt = freezed,
    Object? nextEligibleDate = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      birthMonth: null == birthMonth
          ? _value.birthMonth
          : birthMonth // ignore: cast_nullable_to_non_nullable
              as int,
      birthDay: null == birthDay
          ? _value.birthDay
          : birthDay // ignore: cast_nullable_to_non_nullable
              as int,
      reward: null == reward
          ? _value.reward
          : reward // ignore: cast_nullable_to_non_nullable
              as Reward,
      hasClaimedThisYear: null == hasClaimedThisYear
          ? _value.hasClaimedThisYear
          : hasClaimedThisYear // ignore: cast_nullable_to_non_nullable
              as bool,
      lastClaimedAt: freezed == lastClaimedAt
          ? _value.lastClaimedAt
          : lastClaimedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      nextEligibleDate: freezed == nextEligibleDate
          ? _value.nextEligibleDate
          : nextEligibleDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  /// Create a copy of BirthdayReward
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RewardCopyWith<$Res> get reward {
    return $RewardCopyWith<$Res>(_value.reward, (value) {
      return _then(_value.copyWith(reward: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BirthdayRewardImplCopyWith<$Res>
    implements $BirthdayRewardCopyWith<$Res> {
  factory _$$BirthdayRewardImplCopyWith(_$BirthdayRewardImpl value,
          $Res Function(_$BirthdayRewardImpl) then) =
      __$$BirthdayRewardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      int birthMonth,
      int birthDay,
      Reward reward,
      bool hasClaimedThisYear,
      DateTime? lastClaimedAt,
      DateTime? nextEligibleDate});

  @override
  $RewardCopyWith<$Res> get reward;
}

/// @nodoc
class __$$BirthdayRewardImplCopyWithImpl<$Res>
    extends _$BirthdayRewardCopyWithImpl<$Res, _$BirthdayRewardImpl>
    implements _$$BirthdayRewardImplCopyWith<$Res> {
  __$$BirthdayRewardImplCopyWithImpl(
      _$BirthdayRewardImpl _value, $Res Function(_$BirthdayRewardImpl) _then)
      : super(_value, _then);

  /// Create a copy of BirthdayReward
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? birthMonth = null,
    Object? birthDay = null,
    Object? reward = null,
    Object? hasClaimedThisYear = null,
    Object? lastClaimedAt = freezed,
    Object? nextEligibleDate = freezed,
  }) {
    return _then(_$BirthdayRewardImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      birthMonth: null == birthMonth
          ? _value.birthMonth
          : birthMonth // ignore: cast_nullable_to_non_nullable
              as int,
      birthDay: null == birthDay
          ? _value.birthDay
          : birthDay // ignore: cast_nullable_to_non_nullable
              as int,
      reward: null == reward
          ? _value.reward
          : reward // ignore: cast_nullable_to_non_nullable
              as Reward,
      hasClaimedThisYear: null == hasClaimedThisYear
          ? _value.hasClaimedThisYear
          : hasClaimedThisYear // ignore: cast_nullable_to_non_nullable
              as bool,
      lastClaimedAt: freezed == lastClaimedAt
          ? _value.lastClaimedAt
          : lastClaimedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      nextEligibleDate: freezed == nextEligibleDate
          ? _value.nextEligibleDate
          : nextEligibleDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BirthdayRewardImpl implements _BirthdayReward {
  const _$BirthdayRewardImpl(
      {required this.userId,
      required this.birthMonth,
      required this.birthDay,
      required this.reward,
      this.hasClaimedThisYear = false,
      this.lastClaimedAt,
      this.nextEligibleDate});

  factory _$BirthdayRewardImpl.fromJson(Map<String, dynamic> json) =>
      _$$BirthdayRewardImplFromJson(json);

  @override
  final String userId;
  @override
  final int birthMonth;
  @override
  final int birthDay;
  @override
  final Reward reward;
  @override
  @JsonKey()
  final bool hasClaimedThisYear;
  @override
  final DateTime? lastClaimedAt;
  @override
  final DateTime? nextEligibleDate;

  @override
  String toString() {
    return 'BirthdayReward(userId: $userId, birthMonth: $birthMonth, birthDay: $birthDay, reward: $reward, hasClaimedThisYear: $hasClaimedThisYear, lastClaimedAt: $lastClaimedAt, nextEligibleDate: $nextEligibleDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BirthdayRewardImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.birthMonth, birthMonth) ||
                other.birthMonth == birthMonth) &&
            (identical(other.birthDay, birthDay) ||
                other.birthDay == birthDay) &&
            (identical(other.reward, reward) || other.reward == reward) &&
            (identical(other.hasClaimedThisYear, hasClaimedThisYear) ||
                other.hasClaimedThisYear == hasClaimedThisYear) &&
            (identical(other.lastClaimedAt, lastClaimedAt) ||
                other.lastClaimedAt == lastClaimedAt) &&
            (identical(other.nextEligibleDate, nextEligibleDate) ||
                other.nextEligibleDate == nextEligibleDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, birthMonth, birthDay,
      reward, hasClaimedThisYear, lastClaimedAt, nextEligibleDate);

  /// Create a copy of BirthdayReward
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BirthdayRewardImplCopyWith<_$BirthdayRewardImpl> get copyWith =>
      __$$BirthdayRewardImplCopyWithImpl<_$BirthdayRewardImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BirthdayRewardImplToJson(
      this,
    );
  }
}

abstract class _BirthdayReward implements BirthdayReward {
  const factory _BirthdayReward(
      {required final String userId,
      required final int birthMonth,
      required final int birthDay,
      required final Reward reward,
      final bool hasClaimedThisYear,
      final DateTime? lastClaimedAt,
      final DateTime? nextEligibleDate}) = _$BirthdayRewardImpl;

  factory _BirthdayReward.fromJson(Map<String, dynamic> json) =
      _$BirthdayRewardImpl.fromJson;

  @override
  String get userId;
  @override
  int get birthMonth;
  @override
  int get birthDay;
  @override
  Reward get reward;
  @override
  bool get hasClaimedThisYear;
  @override
  DateTime? get lastClaimedAt;
  @override
  DateTime? get nextEligibleDate;

  /// Create a copy of BirthdayReward
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BirthdayRewardImplCopyWith<_$BirthdayRewardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PointsTransaction _$PointsTransactionFromJson(Map<String, dynamic> json) {
  return _PointsTransaction.fromJson(json);
}

/// @nodoc
mixin _$PointsTransaction {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  int get points => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;
  String get transactionType => throw _privateConstructorUsedError;
  String? get referenceId => throw _privateConstructorUsedError;
  String? get referenceType => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this PointsTransaction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PointsTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PointsTransactionCopyWith<PointsTransaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PointsTransactionCopyWith<$Res> {
  factory $PointsTransactionCopyWith(
          PointsTransaction value, $Res Function(PointsTransaction) then) =
      _$PointsTransactionCopyWithImpl<$Res, PointsTransaction>;
  @useResult
  $Res call(
      {String id,
      String userId,
      int points,
      String reason,
      String transactionType,
      String? referenceId,
      String? referenceType,
      DateTime createdAt,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$PointsTransactionCopyWithImpl<$Res, $Val extends PointsTransaction>
    implements $PointsTransactionCopyWith<$Res> {
  _$PointsTransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PointsTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? points = null,
    Object? reason = null,
    Object? transactionType = null,
    Object? referenceId = freezed,
    Object? referenceType = freezed,
    Object? createdAt = null,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      points: null == points
          ? _value.points
          : points // ignore: cast_nullable_to_non_nullable
              as int,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      transactionType: null == transactionType
          ? _value.transactionType
          : transactionType // ignore: cast_nullable_to_non_nullable
              as String,
      referenceId: freezed == referenceId
          ? _value.referenceId
          : referenceId // ignore: cast_nullable_to_non_nullable
              as String?,
      referenceType: freezed == referenceType
          ? _value.referenceType
          : referenceType // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PointsTransactionImplCopyWith<$Res>
    implements $PointsTransactionCopyWith<$Res> {
  factory _$$PointsTransactionImplCopyWith(_$PointsTransactionImpl value,
          $Res Function(_$PointsTransactionImpl) then) =
      __$$PointsTransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      int points,
      String reason,
      String transactionType,
      String? referenceId,
      String? referenceType,
      DateTime createdAt,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$PointsTransactionImplCopyWithImpl<$Res>
    extends _$PointsTransactionCopyWithImpl<$Res, _$PointsTransactionImpl>
    implements _$$PointsTransactionImplCopyWith<$Res> {
  __$$PointsTransactionImplCopyWithImpl(_$PointsTransactionImpl _value,
      $Res Function(_$PointsTransactionImpl) _then)
      : super(_value, _then);

  /// Create a copy of PointsTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? points = null,
    Object? reason = null,
    Object? transactionType = null,
    Object? referenceId = freezed,
    Object? referenceType = freezed,
    Object? createdAt = null,
    Object? metadata = freezed,
  }) {
    return _then(_$PointsTransactionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      points: null == points
          ? _value.points
          : points // ignore: cast_nullable_to_non_nullable
              as int,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      transactionType: null == transactionType
          ? _value.transactionType
          : transactionType // ignore: cast_nullable_to_non_nullable
              as String,
      referenceId: freezed == referenceId
          ? _value.referenceId
          : referenceId // ignore: cast_nullable_to_non_nullable
              as String?,
      referenceType: freezed == referenceType
          ? _value.referenceType
          : referenceType // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PointsTransactionImpl implements _PointsTransaction {
  const _$PointsTransactionImpl(
      {required this.id,
      required this.userId,
      required this.points,
      required this.reason,
      required this.transactionType,
      this.referenceId,
      this.referenceType,
      required this.createdAt,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  factory _$PointsTransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PointsTransactionImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final int points;
  @override
  final String reason;
  @override
  final String transactionType;
  @override
  final String? referenceId;
  @override
  final String? referenceType;
  @override
  final DateTime createdAt;
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
    return 'PointsTransaction(id: $id, userId: $userId, points: $points, reason: $reason, transactionType: $transactionType, referenceId: $referenceId, referenceType: $referenceType, createdAt: $createdAt, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PointsTransactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.points, points) || other.points == points) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.transactionType, transactionType) ||
                other.transactionType == transactionType) &&
            (identical(other.referenceId, referenceId) ||
                other.referenceId == referenceId) &&
            (identical(other.referenceType, referenceType) ||
                other.referenceType == referenceType) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      points,
      reason,
      transactionType,
      referenceId,
      referenceType,
      createdAt,
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of PointsTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PointsTransactionImplCopyWith<_$PointsTransactionImpl> get copyWith =>
      __$$PointsTransactionImplCopyWithImpl<_$PointsTransactionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PointsTransactionImplToJson(
      this,
    );
  }
}

abstract class _PointsTransaction implements PointsTransaction {
  const factory _PointsTransaction(
      {required final String id,
      required final String userId,
      required final int points,
      required final String reason,
      required final String transactionType,
      final String? referenceId,
      final String? referenceType,
      required final DateTime createdAt,
      final Map<String, dynamic>? metadata}) = _$PointsTransactionImpl;

  factory _PointsTransaction.fromJson(Map<String, dynamic> json) =
      _$PointsTransactionImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  int get points;
  @override
  String get reason;
  @override
  String get transactionType;
  @override
  String? get referenceId;
  @override
  String? get referenceType;
  @override
  DateTime get createdAt;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of PointsTransaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PointsTransactionImplCopyWith<_$PointsTransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
