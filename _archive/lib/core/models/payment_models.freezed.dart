// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PaymentIntent _$PaymentIntentFromJson(Map<String, dynamic> json) {
  return _PaymentIntent.fromJson(json);
}

/// @nodoc
mixin _$PaymentIntent {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'client_secret')
  String get clientSecret => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  @JsonKey(name: 'created')
  int get createdTimestamp => throw _privateConstructorUsedError;

  /// Serializes this PaymentIntent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentIntent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentIntentCopyWith<PaymentIntent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentIntentCopyWith<$Res> {
  factory $PaymentIntentCopyWith(
          PaymentIntent value, $Res Function(PaymentIntent) then) =
      _$PaymentIntentCopyWithImpl<$Res, PaymentIntent>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'client_secret') String clientSecret,
      double amount,
      String currency,
      String status,
      String? description,
      Map<String, dynamic>? metadata,
      @JsonKey(name: 'created') int createdTimestamp});
}

/// @nodoc
class _$PaymentIntentCopyWithImpl<$Res, $Val extends PaymentIntent>
    implements $PaymentIntentCopyWith<$Res> {
  _$PaymentIntentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentIntent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientSecret = null,
    Object? amount = null,
    Object? currency = null,
    Object? status = null,
    Object? description = freezed,
    Object? metadata = freezed,
    Object? createdTimestamp = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      clientSecret: null == clientSecret
          ? _value.clientSecret
          : clientSecret // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdTimestamp: null == createdTimestamp
          ? _value.createdTimestamp
          : createdTimestamp // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaymentIntentImplCopyWith<$Res>
    implements $PaymentIntentCopyWith<$Res> {
  factory _$$PaymentIntentImplCopyWith(
          _$PaymentIntentImpl value, $Res Function(_$PaymentIntentImpl) then) =
      __$$PaymentIntentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'client_secret') String clientSecret,
      double amount,
      String currency,
      String status,
      String? description,
      Map<String, dynamic>? metadata,
      @JsonKey(name: 'created') int createdTimestamp});
}

/// @nodoc
class __$$PaymentIntentImplCopyWithImpl<$Res>
    extends _$PaymentIntentCopyWithImpl<$Res, _$PaymentIntentImpl>
    implements _$$PaymentIntentImplCopyWith<$Res> {
  __$$PaymentIntentImplCopyWithImpl(
      _$PaymentIntentImpl _value, $Res Function(_$PaymentIntentImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaymentIntent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientSecret = null,
    Object? amount = null,
    Object? currency = null,
    Object? status = null,
    Object? description = freezed,
    Object? metadata = freezed,
    Object? createdTimestamp = null,
  }) {
    return _then(_$PaymentIntentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      clientSecret: null == clientSecret
          ? _value.clientSecret
          : clientSecret // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdTimestamp: null == createdTimestamp
          ? _value.createdTimestamp
          : createdTimestamp // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentIntentImpl implements _PaymentIntent {
  const _$PaymentIntentImpl(
      {required this.id,
      @JsonKey(name: 'client_secret') required this.clientSecret,
      required this.amount,
      required this.currency,
      required this.status,
      this.description,
      final Map<String, dynamic>? metadata,
      @JsonKey(name: 'created') required this.createdTimestamp})
      : _metadata = metadata;

  factory _$PaymentIntentImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentIntentImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'client_secret')
  final String clientSecret;
  @override
  final double amount;
  @override
  final String currency;
  @override
  final String status;
  @override
  final String? description;
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
  @JsonKey(name: 'created')
  final int createdTimestamp;

  @override
  String toString() {
    return 'PaymentIntent(id: $id, clientSecret: $clientSecret, amount: $amount, currency: $currency, status: $status, description: $description, metadata: $metadata, createdTimestamp: $createdTimestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentIntentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clientSecret, clientSecret) ||
                other.clientSecret == clientSecret) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.createdTimestamp, createdTimestamp) ||
                other.createdTimestamp == createdTimestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      clientSecret,
      amount,
      currency,
      status,
      description,
      const DeepCollectionEquality().hash(_metadata),
      createdTimestamp);

  /// Create a copy of PaymentIntent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentIntentImplCopyWith<_$PaymentIntentImpl> get copyWith =>
      __$$PaymentIntentImplCopyWithImpl<_$PaymentIntentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentIntentImplToJson(
      this,
    );
  }
}

abstract class _PaymentIntent implements PaymentIntent {
  const factory _PaymentIntent(
          {required final String id,
          @JsonKey(name: 'client_secret') required final String clientSecret,
          required final double amount,
          required final String currency,
          required final String status,
          final String? description,
          final Map<String, dynamic>? metadata,
          @JsonKey(name: 'created') required final int createdTimestamp}) =
      _$PaymentIntentImpl;

  factory _PaymentIntent.fromJson(Map<String, dynamic> json) =
      _$PaymentIntentImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'client_secret')
  String get clientSecret;
  @override
  double get amount;
  @override
  String get currency;
  @override
  String get status;
  @override
  String? get description;
  @override
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(name: 'created')
  int get createdTimestamp;

  /// Create a copy of PaymentIntent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentIntentImplCopyWith<_$PaymentIntentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PaymentMethodInfo _$PaymentMethodInfoFromJson(Map<String, dynamic> json) {
  return _PaymentMethodInfo.fromJson(json);
}

/// @nodoc
mixin _$PaymentMethodInfo {
  String get id => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  PaymentMethodCard? get card => throw _privateConstructorUsedError;
  PaymentMethodBillingDetails? get billingDetails =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'created')
  int get createdTimestamp => throw _privateConstructorUsedError;

  /// Serializes this PaymentMethodInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentMethodInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentMethodInfoCopyWith<PaymentMethodInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentMethodInfoCopyWith<$Res> {
  factory $PaymentMethodInfoCopyWith(
          PaymentMethodInfo value, $Res Function(PaymentMethodInfo) then) =
      _$PaymentMethodInfoCopyWithImpl<$Res, PaymentMethodInfo>;
  @useResult
  $Res call(
      {String id,
      String type,
      PaymentMethodCard? card,
      PaymentMethodBillingDetails? billingDetails,
      @JsonKey(name: 'created') int createdTimestamp});

  $PaymentMethodCardCopyWith<$Res>? get card;
  $PaymentMethodBillingDetailsCopyWith<$Res>? get billingDetails;
}

/// @nodoc
class _$PaymentMethodInfoCopyWithImpl<$Res, $Val extends PaymentMethodInfo>
    implements $PaymentMethodInfoCopyWith<$Res> {
  _$PaymentMethodInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentMethodInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? card = freezed,
    Object? billingDetails = freezed,
    Object? createdTimestamp = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      card: freezed == card
          ? _value.card
          : card // ignore: cast_nullable_to_non_nullable
              as PaymentMethodCard?,
      billingDetails: freezed == billingDetails
          ? _value.billingDetails
          : billingDetails // ignore: cast_nullable_to_non_nullable
              as PaymentMethodBillingDetails?,
      createdTimestamp: null == createdTimestamp
          ? _value.createdTimestamp
          : createdTimestamp // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  /// Create a copy of PaymentMethodInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PaymentMethodCardCopyWith<$Res>? get card {
    if (_value.card == null) {
      return null;
    }

    return $PaymentMethodCardCopyWith<$Res>(_value.card!, (value) {
      return _then(_value.copyWith(card: value) as $Val);
    });
  }

  /// Create a copy of PaymentMethodInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PaymentMethodBillingDetailsCopyWith<$Res>? get billingDetails {
    if (_value.billingDetails == null) {
      return null;
    }

    return $PaymentMethodBillingDetailsCopyWith<$Res>(_value.billingDetails!,
        (value) {
      return _then(_value.copyWith(billingDetails: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PaymentMethodInfoImplCopyWith<$Res>
    implements $PaymentMethodInfoCopyWith<$Res> {
  factory _$$PaymentMethodInfoImplCopyWith(_$PaymentMethodInfoImpl value,
          $Res Function(_$PaymentMethodInfoImpl) then) =
      __$$PaymentMethodInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String type,
      PaymentMethodCard? card,
      PaymentMethodBillingDetails? billingDetails,
      @JsonKey(name: 'created') int createdTimestamp});

  @override
  $PaymentMethodCardCopyWith<$Res>? get card;
  @override
  $PaymentMethodBillingDetailsCopyWith<$Res>? get billingDetails;
}

/// @nodoc
class __$$PaymentMethodInfoImplCopyWithImpl<$Res>
    extends _$PaymentMethodInfoCopyWithImpl<$Res, _$PaymentMethodInfoImpl>
    implements _$$PaymentMethodInfoImplCopyWith<$Res> {
  __$$PaymentMethodInfoImplCopyWithImpl(_$PaymentMethodInfoImpl _value,
      $Res Function(_$PaymentMethodInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaymentMethodInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? card = freezed,
    Object? billingDetails = freezed,
    Object? createdTimestamp = null,
  }) {
    return _then(_$PaymentMethodInfoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      card: freezed == card
          ? _value.card
          : card // ignore: cast_nullable_to_non_nullable
              as PaymentMethodCard?,
      billingDetails: freezed == billingDetails
          ? _value.billingDetails
          : billingDetails // ignore: cast_nullable_to_non_nullable
              as PaymentMethodBillingDetails?,
      createdTimestamp: null == createdTimestamp
          ? _value.createdTimestamp
          : createdTimestamp // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentMethodInfoImpl implements _PaymentMethodInfo {
  const _$PaymentMethodInfoImpl(
      {required this.id,
      required this.type,
      this.card,
      this.billingDetails,
      @JsonKey(name: 'created') required this.createdTimestamp});

  factory _$PaymentMethodInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentMethodInfoImplFromJson(json);

  @override
  final String id;
  @override
  final String type;
  @override
  final PaymentMethodCard? card;
  @override
  final PaymentMethodBillingDetails? billingDetails;
  @override
  @JsonKey(name: 'created')
  final int createdTimestamp;

  @override
  String toString() {
    return 'PaymentMethodInfo(id: $id, type: $type, card: $card, billingDetails: $billingDetails, createdTimestamp: $createdTimestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentMethodInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.card, card) || other.card == card) &&
            (identical(other.billingDetails, billingDetails) ||
                other.billingDetails == billingDetails) &&
            (identical(other.createdTimestamp, createdTimestamp) ||
                other.createdTimestamp == createdTimestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, type, card, billingDetails, createdTimestamp);

  /// Create a copy of PaymentMethodInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentMethodInfoImplCopyWith<_$PaymentMethodInfoImpl> get copyWith =>
      __$$PaymentMethodInfoImplCopyWithImpl<_$PaymentMethodInfoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentMethodInfoImplToJson(
      this,
    );
  }
}

abstract class _PaymentMethodInfo implements PaymentMethodInfo {
  const factory _PaymentMethodInfo(
          {required final String id,
          required final String type,
          final PaymentMethodCard? card,
          final PaymentMethodBillingDetails? billingDetails,
          @JsonKey(name: 'created') required final int createdTimestamp}) =
      _$PaymentMethodInfoImpl;

  factory _PaymentMethodInfo.fromJson(Map<String, dynamic> json) =
      _$PaymentMethodInfoImpl.fromJson;

  @override
  String get id;
  @override
  String get type;
  @override
  PaymentMethodCard? get card;
  @override
  PaymentMethodBillingDetails? get billingDetails;
  @override
  @JsonKey(name: 'created')
  int get createdTimestamp;

  /// Create a copy of PaymentMethodInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentMethodInfoImplCopyWith<_$PaymentMethodInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PaymentMethodCard _$PaymentMethodCardFromJson(Map<String, dynamic> json) {
  return _PaymentMethodCard.fromJson(json);
}

/// @nodoc
mixin _$PaymentMethodCard {
  String get brand => throw _privateConstructorUsedError;
  String get country => throw _privateConstructorUsedError;
  @JsonKey(name: 'exp_month')
  int get expMonth => throw _privateConstructorUsedError;
  @JsonKey(name: 'exp_year')
  int get expYear => throw _privateConstructorUsedError;
  String get funding => throw _privateConstructorUsedError;
  @JsonKey(name: 'last4')
  String get last4 => throw _privateConstructorUsedError;

  /// Serializes this PaymentMethodCard to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentMethodCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentMethodCardCopyWith<PaymentMethodCard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentMethodCardCopyWith<$Res> {
  factory $PaymentMethodCardCopyWith(
          PaymentMethodCard value, $Res Function(PaymentMethodCard) then) =
      _$PaymentMethodCardCopyWithImpl<$Res, PaymentMethodCard>;
  @useResult
  $Res call(
      {String brand,
      String country,
      @JsonKey(name: 'exp_month') int expMonth,
      @JsonKey(name: 'exp_year') int expYear,
      String funding,
      @JsonKey(name: 'last4') String last4});
}

/// @nodoc
class _$PaymentMethodCardCopyWithImpl<$Res, $Val extends PaymentMethodCard>
    implements $PaymentMethodCardCopyWith<$Res> {
  _$PaymentMethodCardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentMethodCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? brand = null,
    Object? country = null,
    Object? expMonth = null,
    Object? expYear = null,
    Object? funding = null,
    Object? last4 = null,
  }) {
    return _then(_value.copyWith(
      brand: null == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      expMonth: null == expMonth
          ? _value.expMonth
          : expMonth // ignore: cast_nullable_to_non_nullable
              as int,
      expYear: null == expYear
          ? _value.expYear
          : expYear // ignore: cast_nullable_to_non_nullable
              as int,
      funding: null == funding
          ? _value.funding
          : funding // ignore: cast_nullable_to_non_nullable
              as String,
      last4: null == last4
          ? _value.last4
          : last4 // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaymentMethodCardImplCopyWith<$Res>
    implements $PaymentMethodCardCopyWith<$Res> {
  factory _$$PaymentMethodCardImplCopyWith(_$PaymentMethodCardImpl value,
          $Res Function(_$PaymentMethodCardImpl) then) =
      __$$PaymentMethodCardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String brand,
      String country,
      @JsonKey(name: 'exp_month') int expMonth,
      @JsonKey(name: 'exp_year') int expYear,
      String funding,
      @JsonKey(name: 'last4') String last4});
}

/// @nodoc
class __$$PaymentMethodCardImplCopyWithImpl<$Res>
    extends _$PaymentMethodCardCopyWithImpl<$Res, _$PaymentMethodCardImpl>
    implements _$$PaymentMethodCardImplCopyWith<$Res> {
  __$$PaymentMethodCardImplCopyWithImpl(_$PaymentMethodCardImpl _value,
      $Res Function(_$PaymentMethodCardImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaymentMethodCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? brand = null,
    Object? country = null,
    Object? expMonth = null,
    Object? expYear = null,
    Object? funding = null,
    Object? last4 = null,
  }) {
    return _then(_$PaymentMethodCardImpl(
      brand: null == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      expMonth: null == expMonth
          ? _value.expMonth
          : expMonth // ignore: cast_nullable_to_non_nullable
              as int,
      expYear: null == expYear
          ? _value.expYear
          : expYear // ignore: cast_nullable_to_non_nullable
              as int,
      funding: null == funding
          ? _value.funding
          : funding // ignore: cast_nullable_to_non_nullable
              as String,
      last4: null == last4
          ? _value.last4
          : last4 // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentMethodCardImpl implements _PaymentMethodCard {
  const _$PaymentMethodCardImpl(
      {required this.brand,
      required this.country,
      @JsonKey(name: 'exp_month') required this.expMonth,
      @JsonKey(name: 'exp_year') required this.expYear,
      required this.funding,
      @JsonKey(name: 'last4') required this.last4});

  factory _$PaymentMethodCardImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentMethodCardImplFromJson(json);

  @override
  final String brand;
  @override
  final String country;
  @override
  @JsonKey(name: 'exp_month')
  final int expMonth;
  @override
  @JsonKey(name: 'exp_year')
  final int expYear;
  @override
  final String funding;
  @override
  @JsonKey(name: 'last4')
  final String last4;

  @override
  String toString() {
    return 'PaymentMethodCard(brand: $brand, country: $country, expMonth: $expMonth, expYear: $expYear, funding: $funding, last4: $last4)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentMethodCardImpl &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.expMonth, expMonth) ||
                other.expMonth == expMonth) &&
            (identical(other.expYear, expYear) || other.expYear == expYear) &&
            (identical(other.funding, funding) || other.funding == funding) &&
            (identical(other.last4, last4) || other.last4 == last4));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, brand, country, expMonth, expYear, funding, last4);

  /// Create a copy of PaymentMethodCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentMethodCardImplCopyWith<_$PaymentMethodCardImpl> get copyWith =>
      __$$PaymentMethodCardImplCopyWithImpl<_$PaymentMethodCardImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentMethodCardImplToJson(
      this,
    );
  }
}

abstract class _PaymentMethodCard implements PaymentMethodCard {
  const factory _PaymentMethodCard(
          {required final String brand,
          required final String country,
          @JsonKey(name: 'exp_month') required final int expMonth,
          @JsonKey(name: 'exp_year') required final int expYear,
          required final String funding,
          @JsonKey(name: 'last4') required final String last4}) =
      _$PaymentMethodCardImpl;

  factory _PaymentMethodCard.fromJson(Map<String, dynamic> json) =
      _$PaymentMethodCardImpl.fromJson;

  @override
  String get brand;
  @override
  String get country;
  @override
  @JsonKey(name: 'exp_month')
  int get expMonth;
  @override
  @JsonKey(name: 'exp_year')
  int get expYear;
  @override
  String get funding;
  @override
  @JsonKey(name: 'last4')
  String get last4;

  /// Create a copy of PaymentMethodCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentMethodCardImplCopyWith<_$PaymentMethodCardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PaymentMethodBillingDetails _$PaymentMethodBillingDetailsFromJson(
    Map<String, dynamic> json) {
  return _PaymentMethodBillingDetails.fromJson(json);
}

/// @nodoc
mixin _$PaymentMethodBillingDetails {
  String? get email => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  PaymentMethodAddress? get address => throw _privateConstructorUsedError;

  /// Serializes this PaymentMethodBillingDetails to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentMethodBillingDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentMethodBillingDetailsCopyWith<PaymentMethodBillingDetails>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentMethodBillingDetailsCopyWith<$Res> {
  factory $PaymentMethodBillingDetailsCopyWith(
          PaymentMethodBillingDetails value,
          $Res Function(PaymentMethodBillingDetails) then) =
      _$PaymentMethodBillingDetailsCopyWithImpl<$Res,
          PaymentMethodBillingDetails>;
  @useResult
  $Res call(
      {String? email,
      String? name,
      String? phone,
      PaymentMethodAddress? address});

  $PaymentMethodAddressCopyWith<$Res>? get address;
}

/// @nodoc
class _$PaymentMethodBillingDetailsCopyWithImpl<$Res,
        $Val extends PaymentMethodBillingDetails>
    implements $PaymentMethodBillingDetailsCopyWith<$Res> {
  _$PaymentMethodBillingDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentMethodBillingDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = freezed,
    Object? name = freezed,
    Object? phone = freezed,
    Object? address = freezed,
  }) {
    return _then(_value.copyWith(
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as PaymentMethodAddress?,
    ) as $Val);
  }

  /// Create a copy of PaymentMethodBillingDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PaymentMethodAddressCopyWith<$Res>? get address {
    if (_value.address == null) {
      return null;
    }

    return $PaymentMethodAddressCopyWith<$Res>(_value.address!, (value) {
      return _then(_value.copyWith(address: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PaymentMethodBillingDetailsImplCopyWith<$Res>
    implements $PaymentMethodBillingDetailsCopyWith<$Res> {
  factory _$$PaymentMethodBillingDetailsImplCopyWith(
          _$PaymentMethodBillingDetailsImpl value,
          $Res Function(_$PaymentMethodBillingDetailsImpl) then) =
      __$$PaymentMethodBillingDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? email,
      String? name,
      String? phone,
      PaymentMethodAddress? address});

  @override
  $PaymentMethodAddressCopyWith<$Res>? get address;
}

/// @nodoc
class __$$PaymentMethodBillingDetailsImplCopyWithImpl<$Res>
    extends _$PaymentMethodBillingDetailsCopyWithImpl<$Res,
        _$PaymentMethodBillingDetailsImpl>
    implements _$$PaymentMethodBillingDetailsImplCopyWith<$Res> {
  __$$PaymentMethodBillingDetailsImplCopyWithImpl(
      _$PaymentMethodBillingDetailsImpl _value,
      $Res Function(_$PaymentMethodBillingDetailsImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaymentMethodBillingDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = freezed,
    Object? name = freezed,
    Object? phone = freezed,
    Object? address = freezed,
  }) {
    return _then(_$PaymentMethodBillingDetailsImpl(
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as PaymentMethodAddress?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentMethodBillingDetailsImpl
    implements _PaymentMethodBillingDetails {
  const _$PaymentMethodBillingDetailsImpl(
      {this.email, this.name, this.phone, this.address});

  factory _$PaymentMethodBillingDetailsImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$PaymentMethodBillingDetailsImplFromJson(json);

  @override
  final String? email;
  @override
  final String? name;
  @override
  final String? phone;
  @override
  final PaymentMethodAddress? address;

  @override
  String toString() {
    return 'PaymentMethodBillingDetails(email: $email, name: $name, phone: $phone, address: $address)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentMethodBillingDetailsImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.address, address) || other.address == address));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, email, name, phone, address);

  /// Create a copy of PaymentMethodBillingDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentMethodBillingDetailsImplCopyWith<_$PaymentMethodBillingDetailsImpl>
      get copyWith => __$$PaymentMethodBillingDetailsImplCopyWithImpl<
          _$PaymentMethodBillingDetailsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentMethodBillingDetailsImplToJson(
      this,
    );
  }
}

abstract class _PaymentMethodBillingDetails
    implements PaymentMethodBillingDetails {
  const factory _PaymentMethodBillingDetails(
      {final String? email,
      final String? name,
      final String? phone,
      final PaymentMethodAddress? address}) = _$PaymentMethodBillingDetailsImpl;

  factory _PaymentMethodBillingDetails.fromJson(Map<String, dynamic> json) =
      _$PaymentMethodBillingDetailsImpl.fromJson;

  @override
  String? get email;
  @override
  String? get name;
  @override
  String? get phone;
  @override
  PaymentMethodAddress? get address;

  /// Create a copy of PaymentMethodBillingDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentMethodBillingDetailsImplCopyWith<_$PaymentMethodBillingDetailsImpl>
      get copyWith => throw _privateConstructorUsedError;
}

PaymentMethodAddress _$PaymentMethodAddressFromJson(Map<String, dynamic> json) {
  return _PaymentMethodAddress.fromJson(json);
}

/// @nodoc
mixin _$PaymentMethodAddress {
  String? get city => throw _privateConstructorUsedError;
  String? get country => throw _privateConstructorUsedError;
  String? get line1 => throw _privateConstructorUsedError;
  String? get line2 => throw _privateConstructorUsedError;
  @JsonKey(name: 'postal_code')
  String? get postalCode => throw _privateConstructorUsedError;
  String? get state => throw _privateConstructorUsedError;

  /// Serializes this PaymentMethodAddress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentMethodAddress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentMethodAddressCopyWith<PaymentMethodAddress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentMethodAddressCopyWith<$Res> {
  factory $PaymentMethodAddressCopyWith(PaymentMethodAddress value,
          $Res Function(PaymentMethodAddress) then) =
      _$PaymentMethodAddressCopyWithImpl<$Res, PaymentMethodAddress>;
  @useResult
  $Res call(
      {String? city,
      String? country,
      String? line1,
      String? line2,
      @JsonKey(name: 'postal_code') String? postalCode,
      String? state});
}

/// @nodoc
class _$PaymentMethodAddressCopyWithImpl<$Res,
        $Val extends PaymentMethodAddress>
    implements $PaymentMethodAddressCopyWith<$Res> {
  _$PaymentMethodAddressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentMethodAddress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? city = freezed,
    Object? country = freezed,
    Object? line1 = freezed,
    Object? line2 = freezed,
    Object? postalCode = freezed,
    Object? state = freezed,
  }) {
    return _then(_value.copyWith(
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      line1: freezed == line1
          ? _value.line1
          : line1 // ignore: cast_nullable_to_non_nullable
              as String?,
      line2: freezed == line2
          ? _value.line2
          : line2 // ignore: cast_nullable_to_non_nullable
              as String?,
      postalCode: freezed == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String?,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaymentMethodAddressImplCopyWith<$Res>
    implements $PaymentMethodAddressCopyWith<$Res> {
  factory _$$PaymentMethodAddressImplCopyWith(_$PaymentMethodAddressImpl value,
          $Res Function(_$PaymentMethodAddressImpl) then) =
      __$$PaymentMethodAddressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? city,
      String? country,
      String? line1,
      String? line2,
      @JsonKey(name: 'postal_code') String? postalCode,
      String? state});
}

/// @nodoc
class __$$PaymentMethodAddressImplCopyWithImpl<$Res>
    extends _$PaymentMethodAddressCopyWithImpl<$Res, _$PaymentMethodAddressImpl>
    implements _$$PaymentMethodAddressImplCopyWith<$Res> {
  __$$PaymentMethodAddressImplCopyWithImpl(_$PaymentMethodAddressImpl _value,
      $Res Function(_$PaymentMethodAddressImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaymentMethodAddress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? city = freezed,
    Object? country = freezed,
    Object? line1 = freezed,
    Object? line2 = freezed,
    Object? postalCode = freezed,
    Object? state = freezed,
  }) {
    return _then(_$PaymentMethodAddressImpl(
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      line1: freezed == line1
          ? _value.line1
          : line1 // ignore: cast_nullable_to_non_nullable
              as String?,
      line2: freezed == line2
          ? _value.line2
          : line2 // ignore: cast_nullable_to_non_nullable
              as String?,
      postalCode: freezed == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String?,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentMethodAddressImpl implements _PaymentMethodAddress {
  const _$PaymentMethodAddressImpl(
      {this.city,
      this.country,
      this.line1,
      this.line2,
      @JsonKey(name: 'postal_code') this.postalCode,
      this.state});

  factory _$PaymentMethodAddressImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentMethodAddressImplFromJson(json);

  @override
  final String? city;
  @override
  final String? country;
  @override
  final String? line1;
  @override
  final String? line2;
  @override
  @JsonKey(name: 'postal_code')
  final String? postalCode;
  @override
  final String? state;

  @override
  String toString() {
    return 'PaymentMethodAddress(city: $city, country: $country, line1: $line1, line2: $line2, postalCode: $postalCode, state: $state)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentMethodAddressImpl &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.line1, line1) || other.line1 == line1) &&
            (identical(other.line2, line2) || other.line2 == line2) &&
            (identical(other.postalCode, postalCode) ||
                other.postalCode == postalCode) &&
            (identical(other.state, state) || other.state == state));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, city, country, line1, line2, postalCode, state);

  /// Create a copy of PaymentMethodAddress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentMethodAddressImplCopyWith<_$PaymentMethodAddressImpl>
      get copyWith =>
          __$$PaymentMethodAddressImplCopyWithImpl<_$PaymentMethodAddressImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentMethodAddressImplToJson(
      this,
    );
  }
}

abstract class _PaymentMethodAddress implements PaymentMethodAddress {
  const factory _PaymentMethodAddress(
      {final String? city,
      final String? country,
      final String? line1,
      final String? line2,
      @JsonKey(name: 'postal_code') final String? postalCode,
      final String? state}) = _$PaymentMethodAddressImpl;

  factory _PaymentMethodAddress.fromJson(Map<String, dynamic> json) =
      _$PaymentMethodAddressImpl.fromJson;

  @override
  String? get city;
  @override
  String? get country;
  @override
  String? get line1;
  @override
  String? get line2;
  @override
  @JsonKey(name: 'postal_code')
  String? get postalCode;
  @override
  String? get state;

  /// Create a copy of PaymentMethodAddress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentMethodAddressImplCopyWith<_$PaymentMethodAddressImpl>
      get copyWith => throw _privateConstructorUsedError;
}

StripeCustomer _$StripeCustomerFromJson(Map<String, dynamic> json) {
  return _StripeCustomer.fromJson(json);
}

/// @nodoc
mixin _$StripeCustomer {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  @JsonKey(name: 'created')
  int get createdTimestamp => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this StripeCustomer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StripeCustomer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StripeCustomerCopyWith<StripeCustomer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StripeCustomerCopyWith<$Res> {
  factory $StripeCustomerCopyWith(
          StripeCustomer value, $Res Function(StripeCustomer) then) =
      _$StripeCustomerCopyWithImpl<$Res, StripeCustomer>;
  @useResult
  $Res call(
      {String id,
      String email,
      String? name,
      String? phone,
      @JsonKey(name: 'created') int createdTimestamp,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$StripeCustomerCopyWithImpl<$Res, $Val extends StripeCustomer>
    implements $StripeCustomerCopyWith<$Res> {
  _$StripeCustomerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StripeCustomer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? name = freezed,
    Object? phone = freezed,
    Object? createdTimestamp = null,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      createdTimestamp: null == createdTimestamp
          ? _value.createdTimestamp
          : createdTimestamp // ignore: cast_nullable_to_non_nullable
              as int,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StripeCustomerImplCopyWith<$Res>
    implements $StripeCustomerCopyWith<$Res> {
  factory _$$StripeCustomerImplCopyWith(_$StripeCustomerImpl value,
          $Res Function(_$StripeCustomerImpl) then) =
      __$$StripeCustomerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String email,
      String? name,
      String? phone,
      @JsonKey(name: 'created') int createdTimestamp,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$StripeCustomerImplCopyWithImpl<$Res>
    extends _$StripeCustomerCopyWithImpl<$Res, _$StripeCustomerImpl>
    implements _$$StripeCustomerImplCopyWith<$Res> {
  __$$StripeCustomerImplCopyWithImpl(
      _$StripeCustomerImpl _value, $Res Function(_$StripeCustomerImpl) _then)
      : super(_value, _then);

  /// Create a copy of StripeCustomer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? name = freezed,
    Object? phone = freezed,
    Object? createdTimestamp = null,
    Object? metadata = freezed,
  }) {
    return _then(_$StripeCustomerImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      createdTimestamp: null == createdTimestamp
          ? _value.createdTimestamp
          : createdTimestamp // ignore: cast_nullable_to_non_nullable
              as int,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StripeCustomerImpl implements _StripeCustomer {
  const _$StripeCustomerImpl(
      {required this.id,
      required this.email,
      this.name,
      this.phone,
      @JsonKey(name: 'created') required this.createdTimestamp,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  factory _$StripeCustomerImpl.fromJson(Map<String, dynamic> json) =>
      _$$StripeCustomerImplFromJson(json);

  @override
  final String id;
  @override
  final String email;
  @override
  final String? name;
  @override
  final String? phone;
  @override
  @JsonKey(name: 'created')
  final int createdTimestamp;
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
    return 'StripeCustomer(id: $id, email: $email, name: $name, phone: $phone, createdTimestamp: $createdTimestamp, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StripeCustomerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.createdTimestamp, createdTimestamp) ||
                other.createdTimestamp == createdTimestamp) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, email, name, phone,
      createdTimestamp, const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of StripeCustomer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StripeCustomerImplCopyWith<_$StripeCustomerImpl> get copyWith =>
      __$$StripeCustomerImplCopyWithImpl<_$StripeCustomerImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StripeCustomerImplToJson(
      this,
    );
  }
}

abstract class _StripeCustomer implements StripeCustomer {
  const factory _StripeCustomer(
      {required final String id,
      required final String email,
      final String? name,
      final String? phone,
      @JsonKey(name: 'created') required final int createdTimestamp,
      final Map<String, dynamic>? metadata}) = _$StripeCustomerImpl;

  factory _StripeCustomer.fromJson(Map<String, dynamic> json) =
      _$StripeCustomerImpl.fromJson;

  @override
  String get id;
  @override
  String get email;
  @override
  String? get name;
  @override
  String? get phone;
  @override
  @JsonKey(name: 'created')
  int get createdTimestamp;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of StripeCustomer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StripeCustomerImplCopyWith<_$StripeCustomerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BookingPayment _$BookingPaymentFromJson(Map<String, dynamic> json) {
  return _BookingPayment.fromJson(json);
}

/// @nodoc
mixin _$BookingPayment {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get bookingId => throw _privateConstructorUsedError;
  PaymentType get type => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  PaymentStatus get status => throw _privateConstructorUsedError;
  String? get stripePaymentIntentId => throw _privateConstructorUsedError;
  String? get stripeCustomerId => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this BookingPayment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookingPayment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingPaymentCopyWith<BookingPayment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingPaymentCopyWith<$Res> {
  factory $BookingPaymentCopyWith(
          BookingPayment value, $Res Function(BookingPayment) then) =
      _$BookingPaymentCopyWithImpl<$Res, BookingPayment>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String bookingId,
      PaymentType type,
      double amount,
      String currency,
      PaymentStatus status,
      String? stripePaymentIntentId,
      String? stripeCustomerId,
      Map<String, dynamic>? metadata,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$BookingPaymentCopyWithImpl<$Res, $Val extends BookingPayment>
    implements $BookingPaymentCopyWith<$Res> {
  _$BookingPaymentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingPayment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? bookingId = null,
    Object? type = null,
    Object? amount = null,
    Object? currency = null,
    Object? status = null,
    Object? stripePaymentIntentId = freezed,
    Object? stripeCustomerId = freezed,
    Object? metadata = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
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
      bookingId: null == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PaymentType,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PaymentStatus,
      stripePaymentIntentId: freezed == stripePaymentIntentId
          ? _value.stripePaymentIntentId
          : stripePaymentIntentId // ignore: cast_nullable_to_non_nullable
              as String?,
      stripeCustomerId: freezed == stripeCustomerId
          ? _value.stripeCustomerId
          : stripeCustomerId // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BookingPaymentImplCopyWith<$Res>
    implements $BookingPaymentCopyWith<$Res> {
  factory _$$BookingPaymentImplCopyWith(_$BookingPaymentImpl value,
          $Res Function(_$BookingPaymentImpl) then) =
      __$$BookingPaymentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String bookingId,
      PaymentType type,
      double amount,
      String currency,
      PaymentStatus status,
      String? stripePaymentIntentId,
      String? stripeCustomerId,
      Map<String, dynamic>? metadata,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$BookingPaymentImplCopyWithImpl<$Res>
    extends _$BookingPaymentCopyWithImpl<$Res, _$BookingPaymentImpl>
    implements _$$BookingPaymentImplCopyWith<$Res> {
  __$$BookingPaymentImplCopyWithImpl(
      _$BookingPaymentImpl _value, $Res Function(_$BookingPaymentImpl) _then)
      : super(_value, _then);

  /// Create a copy of BookingPayment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? bookingId = null,
    Object? type = null,
    Object? amount = null,
    Object? currency = null,
    Object? status = null,
    Object? stripePaymentIntentId = freezed,
    Object? stripeCustomerId = freezed,
    Object? metadata = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$BookingPaymentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      bookingId: null == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PaymentType,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PaymentStatus,
      stripePaymentIntentId: freezed == stripePaymentIntentId
          ? _value.stripePaymentIntentId
          : stripePaymentIntentId // ignore: cast_nullable_to_non_nullable
              as String?,
      stripeCustomerId: freezed == stripeCustomerId
          ? _value.stripeCustomerId
          : stripeCustomerId // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingPaymentImpl implements _BookingPayment {
  const _$BookingPaymentImpl(
      {required this.id,
      required this.userId,
      required this.bookingId,
      required this.type,
      required this.amount,
      required this.currency,
      required this.status,
      this.stripePaymentIntentId,
      this.stripeCustomerId,
      final Map<String, dynamic>? metadata,
      required this.createdAt,
      this.updatedAt})
      : _metadata = metadata;

  factory _$BookingPaymentImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingPaymentImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String bookingId;
  @override
  final PaymentType type;
  @override
  final double amount;
  @override
  final String currency;
  @override
  final PaymentStatus status;
  @override
  final String? stripePaymentIntentId;
  @override
  final String? stripeCustomerId;
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
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'BookingPayment(id: $id, userId: $userId, bookingId: $bookingId, type: $type, amount: $amount, currency: $currency, status: $status, stripePaymentIntentId: $stripePaymentIntentId, stripeCustomerId: $stripeCustomerId, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingPaymentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.stripePaymentIntentId, stripePaymentIntentId) ||
                other.stripePaymentIntentId == stripePaymentIntentId) &&
            (identical(other.stripeCustomerId, stripeCustomerId) ||
                other.stripeCustomerId == stripeCustomerId) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      bookingId,
      type,
      amount,
      currency,
      status,
      stripePaymentIntentId,
      stripeCustomerId,
      const DeepCollectionEquality().hash(_metadata),
      createdAt,
      updatedAt);

  /// Create a copy of BookingPayment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingPaymentImplCopyWith<_$BookingPaymentImpl> get copyWith =>
      __$$BookingPaymentImplCopyWithImpl<_$BookingPaymentImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingPaymentImplToJson(
      this,
    );
  }
}

abstract class _BookingPayment implements BookingPayment {
  const factory _BookingPayment(
      {required final String id,
      required final String userId,
      required final String bookingId,
      required final PaymentType type,
      required final double amount,
      required final String currency,
      required final PaymentStatus status,
      final String? stripePaymentIntentId,
      final String? stripeCustomerId,
      final Map<String, dynamic>? metadata,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$BookingPaymentImpl;

  factory _BookingPayment.fromJson(Map<String, dynamic> json) =
      _$BookingPaymentImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get bookingId;
  @override
  PaymentType get type;
  @override
  double get amount;
  @override
  String get currency;
  @override
  PaymentStatus get status;
  @override
  String? get stripePaymentIntentId;
  @override
  String? get stripeCustomerId;
  @override
  Map<String, dynamic>? get metadata;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of BookingPayment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingPaymentImplCopyWith<_$BookingPaymentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
