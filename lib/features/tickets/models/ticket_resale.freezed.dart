// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ticket_resale.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TicketResale _$TicketResaleFromJson(Map<String, dynamic> json) {
  return _TicketResale.fromJson(json);
}

/// @nodoc
mixin _$TicketResale {
  String get id => throw _privateConstructorUsedError;
  String get ticketId => throw _privateConstructorUsedError;
  String get sellerId => throw _privateConstructorUsedError;
  String get eventId => throw _privateConstructorUsedError;
  String? get eventName => throw _privateConstructorUsedError;
  DateTime? get eventDate => throw _privateConstructorUsedError;
  double get originalPrice => throw _privateConstructorUsedError;
  double get listingPrice => throw _privateConstructorUsedError;
  String? get sellerName => throw _privateConstructorUsedError;
  String? get ticketType => throw _privateConstructorUsedError;
  int? get quantity => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  ResaleStatus get status => throw _privateConstructorUsedError;
  DateTime get listedAt => throw _privateConstructorUsedError;
  DateTime? get soldAt => throw _privateConstructorUsedError;
  String? get buyerId => throw _privateConstructorUsedError;
  String? get buyerName => throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;

  /// Serializes this TicketResale to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TicketResale
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TicketResaleCopyWith<TicketResale> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TicketResaleCopyWith<$Res> {
  factory $TicketResaleCopyWith(
          TicketResale value, $Res Function(TicketResale) then) =
      _$TicketResaleCopyWithImpl<$Res, TicketResale>;
  @useResult
  $Res call(
      {String id,
      String ticketId,
      String sellerId,
      String eventId,
      String? eventName,
      DateTime? eventDate,
      double originalPrice,
      double listingPrice,
      String? sellerName,
      String? ticketType,
      int? quantity,
      String? description,
      ResaleStatus status,
      DateTime listedAt,
      DateTime? soldAt,
      String? buyerId,
      String? buyerName,
      DateTime? expiresAt});
}

/// @nodoc
class _$TicketResaleCopyWithImpl<$Res, $Val extends TicketResale>
    implements $TicketResaleCopyWith<$Res> {
  _$TicketResaleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TicketResale
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ticketId = null,
    Object? sellerId = null,
    Object? eventId = null,
    Object? eventName = freezed,
    Object? eventDate = freezed,
    Object? originalPrice = null,
    Object? listingPrice = null,
    Object? sellerName = freezed,
    Object? ticketType = freezed,
    Object? quantity = freezed,
    Object? description = freezed,
    Object? status = null,
    Object? listedAt = null,
    Object? soldAt = freezed,
    Object? buyerId = freezed,
    Object? buyerName = freezed,
    Object? expiresAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ticketId: null == ticketId
          ? _value.ticketId
          : ticketId // ignore: cast_nullable_to_non_nullable
              as String,
      sellerId: null == sellerId
          ? _value.sellerId
          : sellerId // ignore: cast_nullable_to_non_nullable
              as String,
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      eventName: freezed == eventName
          ? _value.eventName
          : eventName // ignore: cast_nullable_to_non_nullable
              as String?,
      eventDate: freezed == eventDate
          ? _value.eventDate
          : eventDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      originalPrice: null == originalPrice
          ? _value.originalPrice
          : originalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      listingPrice: null == listingPrice
          ? _value.listingPrice
          : listingPrice // ignore: cast_nullable_to_non_nullable
              as double,
      sellerName: freezed == sellerName
          ? _value.sellerName
          : sellerName // ignore: cast_nullable_to_non_nullable
              as String?,
      ticketType: freezed == ticketType
          ? _value.ticketType
          : ticketType // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: freezed == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ResaleStatus,
      listedAt: null == listedAt
          ? _value.listedAt
          : listedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      soldAt: freezed == soldAt
          ? _value.soldAt
          : soldAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      buyerId: freezed == buyerId
          ? _value.buyerId
          : buyerId // ignore: cast_nullable_to_non_nullable
              as String?,
      buyerName: freezed == buyerName
          ? _value.buyerName
          : buyerName // ignore: cast_nullable_to_non_nullable
              as String?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TicketResaleImplCopyWith<$Res>
    implements $TicketResaleCopyWith<$Res> {
  factory _$$TicketResaleImplCopyWith(
          _$TicketResaleImpl value, $Res Function(_$TicketResaleImpl) then) =
      __$$TicketResaleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String ticketId,
      String sellerId,
      String eventId,
      String? eventName,
      DateTime? eventDate,
      double originalPrice,
      double listingPrice,
      String? sellerName,
      String? ticketType,
      int? quantity,
      String? description,
      ResaleStatus status,
      DateTime listedAt,
      DateTime? soldAt,
      String? buyerId,
      String? buyerName,
      DateTime? expiresAt});
}

/// @nodoc
class __$$TicketResaleImplCopyWithImpl<$Res>
    extends _$TicketResaleCopyWithImpl<$Res, _$TicketResaleImpl>
    implements _$$TicketResaleImplCopyWith<$Res> {
  __$$TicketResaleImplCopyWithImpl(
      _$TicketResaleImpl _value, $Res Function(_$TicketResaleImpl) _then)
      : super(_value, _then);

  /// Create a copy of TicketResale
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ticketId = null,
    Object? sellerId = null,
    Object? eventId = null,
    Object? eventName = freezed,
    Object? eventDate = freezed,
    Object? originalPrice = null,
    Object? listingPrice = null,
    Object? sellerName = freezed,
    Object? ticketType = freezed,
    Object? quantity = freezed,
    Object? description = freezed,
    Object? status = null,
    Object? listedAt = null,
    Object? soldAt = freezed,
    Object? buyerId = freezed,
    Object? buyerName = freezed,
    Object? expiresAt = freezed,
  }) {
    return _then(_$TicketResaleImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ticketId: null == ticketId
          ? _value.ticketId
          : ticketId // ignore: cast_nullable_to_non_nullable
              as String,
      sellerId: null == sellerId
          ? _value.sellerId
          : sellerId // ignore: cast_nullable_to_non_nullable
              as String,
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      eventName: freezed == eventName
          ? _value.eventName
          : eventName // ignore: cast_nullable_to_non_nullable
              as String?,
      eventDate: freezed == eventDate
          ? _value.eventDate
          : eventDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      originalPrice: null == originalPrice
          ? _value.originalPrice
          : originalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      listingPrice: null == listingPrice
          ? _value.listingPrice
          : listingPrice // ignore: cast_nullable_to_non_nullable
              as double,
      sellerName: freezed == sellerName
          ? _value.sellerName
          : sellerName // ignore: cast_nullable_to_non_nullable
              as String?,
      ticketType: freezed == ticketType
          ? _value.ticketType
          : ticketType // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: freezed == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ResaleStatus,
      listedAt: null == listedAt
          ? _value.listedAt
          : listedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      soldAt: freezed == soldAt
          ? _value.soldAt
          : soldAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      buyerId: freezed == buyerId
          ? _value.buyerId
          : buyerId // ignore: cast_nullable_to_non_nullable
              as String?,
      buyerName: freezed == buyerName
          ? _value.buyerName
          : buyerName // ignore: cast_nullable_to_non_nullable
              as String?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TicketResaleImpl implements _TicketResale {
  const _$TicketResaleImpl(
      {required this.id,
      required this.ticketId,
      required this.sellerId,
      required this.eventId,
      this.eventName,
      this.eventDate,
      required this.originalPrice,
      required this.listingPrice,
      this.sellerName,
      this.ticketType,
      this.quantity,
      this.description,
      this.status = ResaleStatus.listed,
      required this.listedAt,
      this.soldAt,
      this.buyerId,
      this.buyerName,
      this.expiresAt});

  factory _$TicketResaleImpl.fromJson(Map<String, dynamic> json) =>
      _$$TicketResaleImplFromJson(json);

  @override
  final String id;
  @override
  final String ticketId;
  @override
  final String sellerId;
  @override
  final String eventId;
  @override
  final String? eventName;
  @override
  final DateTime? eventDate;
  @override
  final double originalPrice;
  @override
  final double listingPrice;
  @override
  final String? sellerName;
  @override
  final String? ticketType;
  @override
  final int? quantity;
  @override
  final String? description;
  @override
  @JsonKey()
  final ResaleStatus status;
  @override
  final DateTime listedAt;
  @override
  final DateTime? soldAt;
  @override
  final String? buyerId;
  @override
  final String? buyerName;
  @override
  final DateTime? expiresAt;

  @override
  String toString() {
    return 'TicketResale(id: $id, ticketId: $ticketId, sellerId: $sellerId, eventId: $eventId, eventName: $eventName, eventDate: $eventDate, originalPrice: $originalPrice, listingPrice: $listingPrice, sellerName: $sellerName, ticketType: $ticketType, quantity: $quantity, description: $description, status: $status, listedAt: $listedAt, soldAt: $soldAt, buyerId: $buyerId, buyerName: $buyerName, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TicketResaleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ticketId, ticketId) ||
                other.ticketId == ticketId) &&
            (identical(other.sellerId, sellerId) ||
                other.sellerId == sellerId) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.eventName, eventName) ||
                other.eventName == eventName) &&
            (identical(other.eventDate, eventDate) ||
                other.eventDate == eventDate) &&
            (identical(other.originalPrice, originalPrice) ||
                other.originalPrice == originalPrice) &&
            (identical(other.listingPrice, listingPrice) ||
                other.listingPrice == listingPrice) &&
            (identical(other.sellerName, sellerName) ||
                other.sellerName == sellerName) &&
            (identical(other.ticketType, ticketType) ||
                other.ticketType == ticketType) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.listedAt, listedAt) ||
                other.listedAt == listedAt) &&
            (identical(other.soldAt, soldAt) || other.soldAt == soldAt) &&
            (identical(other.buyerId, buyerId) || other.buyerId == buyerId) &&
            (identical(other.buyerName, buyerName) ||
                other.buyerName == buyerName) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      ticketId,
      sellerId,
      eventId,
      eventName,
      eventDate,
      originalPrice,
      listingPrice,
      sellerName,
      ticketType,
      quantity,
      description,
      status,
      listedAt,
      soldAt,
      buyerId,
      buyerName,
      expiresAt);

  /// Create a copy of TicketResale
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TicketResaleImplCopyWith<_$TicketResaleImpl> get copyWith =>
      __$$TicketResaleImplCopyWithImpl<_$TicketResaleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TicketResaleImplToJson(
      this,
    );
  }
}

abstract class _TicketResale implements TicketResale {
  const factory _TicketResale(
      {required final String id,
      required final String ticketId,
      required final String sellerId,
      required final String eventId,
      final String? eventName,
      final DateTime? eventDate,
      required final double originalPrice,
      required final double listingPrice,
      final String? sellerName,
      final String? ticketType,
      final int? quantity,
      final String? description,
      final ResaleStatus status,
      required final DateTime listedAt,
      final DateTime? soldAt,
      final String? buyerId,
      final String? buyerName,
      final DateTime? expiresAt}) = _$TicketResaleImpl;

  factory _TicketResale.fromJson(Map<String, dynamic> json) =
      _$TicketResaleImpl.fromJson;

  @override
  String get id;
  @override
  String get ticketId;
  @override
  String get sellerId;
  @override
  String get eventId;
  @override
  String? get eventName;
  @override
  DateTime? get eventDate;
  @override
  double get originalPrice;
  @override
  double get listingPrice;
  @override
  String? get sellerName;
  @override
  String? get ticketType;
  @override
  int? get quantity;
  @override
  String? get description;
  @override
  ResaleStatus get status;
  @override
  DateTime get listedAt;
  @override
  DateTime? get soldAt;
  @override
  String? get buyerId;
  @override
  String? get buyerName;
  @override
  DateTime? get expiresAt;

  /// Create a copy of TicketResale
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TicketResaleImplCopyWith<_$TicketResaleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ResaleOffer _$ResaleOfferFromJson(Map<String, dynamic> json) {
  return _ResaleOffer.fromJson(json);
}

/// @nodoc
mixin _$ResaleOffer {
  String get id => throw _privateConstructorUsedError;
  String get resaleId => throw _privateConstructorUsedError;
  String get buyerId => throw _privateConstructorUsedError;
  String? get buyerName => throw _privateConstructorUsedError;
  double get offeredPrice => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get respondedAt => throw _privateConstructorUsedError;

  /// Serializes this ResaleOffer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ResaleOffer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ResaleOfferCopyWith<ResaleOffer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResaleOfferCopyWith<$Res> {
  factory $ResaleOfferCopyWith(
          ResaleOffer value, $Res Function(ResaleOffer) then) =
      _$ResaleOfferCopyWithImpl<$Res, ResaleOffer>;
  @useResult
  $Res call(
      {String id,
      String resaleId,
      String buyerId,
      String? buyerName,
      double offeredPrice,
      String? message,
      String status,
      DateTime createdAt,
      DateTime? respondedAt});
}

/// @nodoc
class _$ResaleOfferCopyWithImpl<$Res, $Val extends ResaleOffer>
    implements $ResaleOfferCopyWith<$Res> {
  _$ResaleOfferCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ResaleOffer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? resaleId = null,
    Object? buyerId = null,
    Object? buyerName = freezed,
    Object? offeredPrice = null,
    Object? message = freezed,
    Object? status = null,
    Object? createdAt = null,
    Object? respondedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      resaleId: null == resaleId
          ? _value.resaleId
          : resaleId // ignore: cast_nullable_to_non_nullable
              as String,
      buyerId: null == buyerId
          ? _value.buyerId
          : buyerId // ignore: cast_nullable_to_non_nullable
              as String,
      buyerName: freezed == buyerName
          ? _value.buyerName
          : buyerName // ignore: cast_nullable_to_non_nullable
              as String?,
      offeredPrice: null == offeredPrice
          ? _value.offeredPrice
          : offeredPrice // ignore: cast_nullable_to_non_nullable
              as double,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      respondedAt: freezed == respondedAt
          ? _value.respondedAt
          : respondedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ResaleOfferImplCopyWith<$Res>
    implements $ResaleOfferCopyWith<$Res> {
  factory _$$ResaleOfferImplCopyWith(
          _$ResaleOfferImpl value, $Res Function(_$ResaleOfferImpl) then) =
      __$$ResaleOfferImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String resaleId,
      String buyerId,
      String? buyerName,
      double offeredPrice,
      String? message,
      String status,
      DateTime createdAt,
      DateTime? respondedAt});
}

/// @nodoc
class __$$ResaleOfferImplCopyWithImpl<$Res>
    extends _$ResaleOfferCopyWithImpl<$Res, _$ResaleOfferImpl>
    implements _$$ResaleOfferImplCopyWith<$Res> {
  __$$ResaleOfferImplCopyWithImpl(
      _$ResaleOfferImpl _value, $Res Function(_$ResaleOfferImpl) _then)
      : super(_value, _then);

  /// Create a copy of ResaleOffer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? resaleId = null,
    Object? buyerId = null,
    Object? buyerName = freezed,
    Object? offeredPrice = null,
    Object? message = freezed,
    Object? status = null,
    Object? createdAt = null,
    Object? respondedAt = freezed,
  }) {
    return _then(_$ResaleOfferImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      resaleId: null == resaleId
          ? _value.resaleId
          : resaleId // ignore: cast_nullable_to_non_nullable
              as String,
      buyerId: null == buyerId
          ? _value.buyerId
          : buyerId // ignore: cast_nullable_to_non_nullable
              as String,
      buyerName: freezed == buyerName
          ? _value.buyerName
          : buyerName // ignore: cast_nullable_to_non_nullable
              as String?,
      offeredPrice: null == offeredPrice
          ? _value.offeredPrice
          : offeredPrice // ignore: cast_nullable_to_non_nullable
              as double,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      respondedAt: freezed == respondedAt
          ? _value.respondedAt
          : respondedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ResaleOfferImpl implements _ResaleOffer {
  const _$ResaleOfferImpl(
      {required this.id,
      required this.resaleId,
      required this.buyerId,
      this.buyerName,
      required this.offeredPrice,
      this.message,
      this.status = 'pending',
      required this.createdAt,
      this.respondedAt});

  factory _$ResaleOfferImpl.fromJson(Map<String, dynamic> json) =>
      _$$ResaleOfferImplFromJson(json);

  @override
  final String id;
  @override
  final String resaleId;
  @override
  final String buyerId;
  @override
  final String? buyerName;
  @override
  final double offeredPrice;
  @override
  final String? message;
  @override
  @JsonKey()
  final String status;
  @override
  final DateTime createdAt;
  @override
  final DateTime? respondedAt;

  @override
  String toString() {
    return 'ResaleOffer(id: $id, resaleId: $resaleId, buyerId: $buyerId, buyerName: $buyerName, offeredPrice: $offeredPrice, message: $message, status: $status, createdAt: $createdAt, respondedAt: $respondedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResaleOfferImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.resaleId, resaleId) ||
                other.resaleId == resaleId) &&
            (identical(other.buyerId, buyerId) || other.buyerId == buyerId) &&
            (identical(other.buyerName, buyerName) ||
                other.buyerName == buyerName) &&
            (identical(other.offeredPrice, offeredPrice) ||
                other.offeredPrice == offeredPrice) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.respondedAt, respondedAt) ||
                other.respondedAt == respondedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, resaleId, buyerId, buyerName,
      offeredPrice, message, status, createdAt, respondedAt);

  /// Create a copy of ResaleOffer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResaleOfferImplCopyWith<_$ResaleOfferImpl> get copyWith =>
      __$$ResaleOfferImplCopyWithImpl<_$ResaleOfferImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ResaleOfferImplToJson(
      this,
    );
  }
}

abstract class _ResaleOffer implements ResaleOffer {
  const factory _ResaleOffer(
      {required final String id,
      required final String resaleId,
      required final String buyerId,
      final String? buyerName,
      required final double offeredPrice,
      final String? message,
      final String status,
      required final DateTime createdAt,
      final DateTime? respondedAt}) = _$ResaleOfferImpl;

  factory _ResaleOffer.fromJson(Map<String, dynamic> json) =
      _$ResaleOfferImpl.fromJson;

  @override
  String get id;
  @override
  String get resaleId;
  @override
  String get buyerId;
  @override
  String? get buyerName;
  @override
  double get offeredPrice;
  @override
  String? get message;
  @override
  String get status;
  @override
  DateTime get createdAt;
  @override
  DateTime? get respondedAt;

  /// Create a copy of ResaleOffer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResaleOfferImplCopyWith<_$ResaleOfferImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
