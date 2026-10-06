// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'live_bill.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LiveBill _$LiveBillFromJson(Map<String, dynamic> json) {
  return _LiveBill.fromJson(json);
}

/// @nodoc
mixin _$LiveBill {
  String get id => throw _privateConstructorUsedError;
  String get bookingId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get venueId => throw _privateConstructorUsedError;
  String? get venueName => throw _privateConstructorUsedError;
  List<BillItem> get items => throw _privateConstructorUsedError;
  double get subtotal => throw _privateConstructorUsedError;
  double get tax => throw _privateConstructorUsedError;
  double get serviceCharge => throw _privateConstructorUsedError;
  double get tip => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  DateTime? get closedAt => throw _privateConstructorUsedError;

  /// Serializes this LiveBill to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LiveBill
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LiveBillCopyWith<LiveBill> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LiveBillCopyWith<$Res> {
  factory $LiveBillCopyWith(LiveBill value, $Res Function(LiveBill) then) =
      _$LiveBillCopyWithImpl<$Res, LiveBill>;
  @useResult
  $Res call(
      {String id,
      String bookingId,
      String userId,
      String venueId,
      String? venueName,
      List<BillItem> items,
      double subtotal,
      double tax,
      double serviceCharge,
      double tip,
      double total,
      String status,
      DateTime createdAt,
      DateTime? updatedAt,
      DateTime? closedAt});
}

/// @nodoc
class _$LiveBillCopyWithImpl<$Res, $Val extends LiveBill>
    implements $LiveBillCopyWith<$Res> {
  _$LiveBillCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LiveBill
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bookingId = null,
    Object? userId = null,
    Object? venueId = null,
    Object? venueName = freezed,
    Object? items = null,
    Object? subtotal = null,
    Object? tax = null,
    Object? serviceCharge = null,
    Object? tip = null,
    Object? total = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? closedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      bookingId: null == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      venueId: null == venueId
          ? _value.venueId
          : venueId // ignore: cast_nullable_to_non_nullable
              as String,
      venueName: freezed == venueName
          ? _value.venueName
          : venueName // ignore: cast_nullable_to_non_nullable
              as String?,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<BillItem>,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      tax: null == tax
          ? _value.tax
          : tax // ignore: cast_nullable_to_non_nullable
              as double,
      serviceCharge: null == serviceCharge
          ? _value.serviceCharge
          : serviceCharge // ignore: cast_nullable_to_non_nullable
              as double,
      tip: null == tip
          ? _value.tip
          : tip // ignore: cast_nullable_to_non_nullable
              as double,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      closedAt: freezed == closedAt
          ? _value.closedAt
          : closedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LiveBillImplCopyWith<$Res>
    implements $LiveBillCopyWith<$Res> {
  factory _$$LiveBillImplCopyWith(
          _$LiveBillImpl value, $Res Function(_$LiveBillImpl) then) =
      __$$LiveBillImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String bookingId,
      String userId,
      String venueId,
      String? venueName,
      List<BillItem> items,
      double subtotal,
      double tax,
      double serviceCharge,
      double tip,
      double total,
      String status,
      DateTime createdAt,
      DateTime? updatedAt,
      DateTime? closedAt});
}

/// @nodoc
class __$$LiveBillImplCopyWithImpl<$Res>
    extends _$LiveBillCopyWithImpl<$Res, _$LiveBillImpl>
    implements _$$LiveBillImplCopyWith<$Res> {
  __$$LiveBillImplCopyWithImpl(
      _$LiveBillImpl _value, $Res Function(_$LiveBillImpl) _then)
      : super(_value, _then);

  /// Create a copy of LiveBill
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bookingId = null,
    Object? userId = null,
    Object? venueId = null,
    Object? venueName = freezed,
    Object? items = null,
    Object? subtotal = null,
    Object? tax = null,
    Object? serviceCharge = null,
    Object? tip = null,
    Object? total = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? closedAt = freezed,
  }) {
    return _then(_$LiveBillImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      bookingId: null == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      venueId: null == venueId
          ? _value.venueId
          : venueId // ignore: cast_nullable_to_non_nullable
              as String,
      venueName: freezed == venueName
          ? _value.venueName
          : venueName // ignore: cast_nullable_to_non_nullable
              as String?,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<BillItem>,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      tax: null == tax
          ? _value.tax
          : tax // ignore: cast_nullable_to_non_nullable
              as double,
      serviceCharge: null == serviceCharge
          ? _value.serviceCharge
          : serviceCharge // ignore: cast_nullable_to_non_nullable
              as double,
      tip: null == tip
          ? _value.tip
          : tip // ignore: cast_nullable_to_non_nullable
              as double,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      closedAt: freezed == closedAt
          ? _value.closedAt
          : closedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LiveBillImpl implements _LiveBill {
  const _$LiveBillImpl(
      {required this.id,
      required this.bookingId,
      required this.userId,
      required this.venueId,
      this.venueName,
      required final List<BillItem> items,
      required this.subtotal,
      required this.tax,
      required this.serviceCharge,
      required this.tip,
      required this.total,
      this.status = 'open',
      required this.createdAt,
      this.updatedAt,
      this.closedAt})
      : _items = items;

  factory _$LiveBillImpl.fromJson(Map<String, dynamic> json) =>
      _$$LiveBillImplFromJson(json);

  @override
  final String id;
  @override
  final String bookingId;
  @override
  final String userId;
  @override
  final String venueId;
  @override
  final String? venueName;
  final List<BillItem> _items;
  @override
  List<BillItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final double subtotal;
  @override
  final double tax;
  @override
  final double serviceCharge;
  @override
  final double tip;
  @override
  final double total;
  @override
  @JsonKey()
  final String status;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final DateTime? closedAt;

  @override
  String toString() {
    return 'LiveBill(id: $id, bookingId: $bookingId, userId: $userId, venueId: $venueId, venueName: $venueName, items: $items, subtotal: $subtotal, tax: $tax, serviceCharge: $serviceCharge, tip: $tip, total: $total, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, closedAt: $closedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LiveBillImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.venueId, venueId) || other.venueId == venueId) &&
            (identical(other.venueName, venueName) ||
                other.venueName == venueName) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.tax, tax) || other.tax == tax) &&
            (identical(other.serviceCharge, serviceCharge) ||
                other.serviceCharge == serviceCharge) &&
            (identical(other.tip, tip) || other.tip == tip) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.closedAt, closedAt) ||
                other.closedAt == closedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      bookingId,
      userId,
      venueId,
      venueName,
      const DeepCollectionEquality().hash(_items),
      subtotal,
      tax,
      serviceCharge,
      tip,
      total,
      status,
      createdAt,
      updatedAt,
      closedAt);

  /// Create a copy of LiveBill
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LiveBillImplCopyWith<_$LiveBillImpl> get copyWith =>
      __$$LiveBillImplCopyWithImpl<_$LiveBillImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LiveBillImplToJson(
      this,
    );
  }
}

abstract class _LiveBill implements LiveBill {
  const factory _LiveBill(
      {required final String id,
      required final String bookingId,
      required final String userId,
      required final String venueId,
      final String? venueName,
      required final List<BillItem> items,
      required final double subtotal,
      required final double tax,
      required final double serviceCharge,
      required final double tip,
      required final double total,
      final String status,
      required final DateTime createdAt,
      final DateTime? updatedAt,
      final DateTime? closedAt}) = _$LiveBillImpl;

  factory _LiveBill.fromJson(Map<String, dynamic> json) =
      _$LiveBillImpl.fromJson;

  @override
  String get id;
  @override
  String get bookingId;
  @override
  String get userId;
  @override
  String get venueId;
  @override
  String? get venueName;
  @override
  List<BillItem> get items;
  @override
  double get subtotal;
  @override
  double get tax;
  @override
  double get serviceCharge;
  @override
  double get tip;
  @override
  double get total;
  @override
  String get status;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  DateTime? get closedAt;

  /// Create a copy of LiveBill
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LiveBillImplCopyWith<_$LiveBillImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BillItem _$BillItemFromJson(Map<String, dynamic> json) {
  return _BillItem.fromJson(json);
}

/// @nodoc
mixin _$BillItem {
  String get id => throw _privateConstructorUsedError;
  String get billId => throw _privateConstructorUsedError;
  String get itemName => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  double get pricePerUnit => throw _privateConstructorUsedError;
  double get totalPrice => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime get addedAt => throw _privateConstructorUsedError;
  String? get addedBy => throw _privateConstructorUsedError;

  /// Serializes this BillItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BillItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BillItemCopyWith<BillItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BillItemCopyWith<$Res> {
  factory $BillItemCopyWith(BillItem value, $Res Function(BillItem) then) =
      _$BillItemCopyWithImpl<$Res, BillItem>;
  @useResult
  $Res call(
      {String id,
      String billId,
      String itemName,
      int quantity,
      double pricePerUnit,
      double totalPrice,
      String? category,
      String? notes,
      DateTime addedAt,
      String? addedBy});
}

/// @nodoc
class _$BillItemCopyWithImpl<$Res, $Val extends BillItem>
    implements $BillItemCopyWith<$Res> {
  _$BillItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BillItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? billId = null,
    Object? itemName = null,
    Object? quantity = null,
    Object? pricePerUnit = null,
    Object? totalPrice = null,
    Object? category = freezed,
    Object? notes = freezed,
    Object? addedAt = null,
    Object? addedBy = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      billId: null == billId
          ? _value.billId
          : billId // ignore: cast_nullable_to_non_nullable
              as String,
      itemName: null == itemName
          ? _value.itemName
          : itemName // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      pricePerUnit: null == pricePerUnit
          ? _value.pricePerUnit
          : pricePerUnit // ignore: cast_nullable_to_non_nullable
              as double,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      addedAt: null == addedAt
          ? _value.addedAt
          : addedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      addedBy: freezed == addedBy
          ? _value.addedBy
          : addedBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BillItemImplCopyWith<$Res>
    implements $BillItemCopyWith<$Res> {
  factory _$$BillItemImplCopyWith(
          _$BillItemImpl value, $Res Function(_$BillItemImpl) then) =
      __$$BillItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String billId,
      String itemName,
      int quantity,
      double pricePerUnit,
      double totalPrice,
      String? category,
      String? notes,
      DateTime addedAt,
      String? addedBy});
}

/// @nodoc
class __$$BillItemImplCopyWithImpl<$Res>
    extends _$BillItemCopyWithImpl<$Res, _$BillItemImpl>
    implements _$$BillItemImplCopyWith<$Res> {
  __$$BillItemImplCopyWithImpl(
      _$BillItemImpl _value, $Res Function(_$BillItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of BillItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? billId = null,
    Object? itemName = null,
    Object? quantity = null,
    Object? pricePerUnit = null,
    Object? totalPrice = null,
    Object? category = freezed,
    Object? notes = freezed,
    Object? addedAt = null,
    Object? addedBy = freezed,
  }) {
    return _then(_$BillItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      billId: null == billId
          ? _value.billId
          : billId // ignore: cast_nullable_to_non_nullable
              as String,
      itemName: null == itemName
          ? _value.itemName
          : itemName // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      pricePerUnit: null == pricePerUnit
          ? _value.pricePerUnit
          : pricePerUnit // ignore: cast_nullable_to_non_nullable
              as double,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      addedAt: null == addedAt
          ? _value.addedAt
          : addedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      addedBy: freezed == addedBy
          ? _value.addedBy
          : addedBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BillItemImpl implements _BillItem {
  const _$BillItemImpl(
      {required this.id,
      required this.billId,
      required this.itemName,
      required this.quantity,
      required this.pricePerUnit,
      required this.totalPrice,
      this.category,
      this.notes,
      required this.addedAt,
      this.addedBy});

  factory _$BillItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$BillItemImplFromJson(json);

  @override
  final String id;
  @override
  final String billId;
  @override
  final String itemName;
  @override
  final int quantity;
  @override
  final double pricePerUnit;
  @override
  final double totalPrice;
  @override
  final String? category;
  @override
  final String? notes;
  @override
  final DateTime addedAt;
  @override
  final String? addedBy;

  @override
  String toString() {
    return 'BillItem(id: $id, billId: $billId, itemName: $itemName, quantity: $quantity, pricePerUnit: $pricePerUnit, totalPrice: $totalPrice, category: $category, notes: $notes, addedAt: $addedAt, addedBy: $addedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BillItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.billId, billId) || other.billId == billId) &&
            (identical(other.itemName, itemName) ||
                other.itemName == itemName) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.pricePerUnit, pricePerUnit) ||
                other.pricePerUnit == pricePerUnit) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.addedAt, addedAt) || other.addedAt == addedAt) &&
            (identical(other.addedBy, addedBy) || other.addedBy == addedBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, billId, itemName, quantity,
      pricePerUnit, totalPrice, category, notes, addedAt, addedBy);

  /// Create a copy of BillItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BillItemImplCopyWith<_$BillItemImpl> get copyWith =>
      __$$BillItemImplCopyWithImpl<_$BillItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BillItemImplToJson(
      this,
    );
  }
}

abstract class _BillItem implements BillItem {
  const factory _BillItem(
      {required final String id,
      required final String billId,
      required final String itemName,
      required final int quantity,
      required final double pricePerUnit,
      required final double totalPrice,
      final String? category,
      final String? notes,
      required final DateTime addedAt,
      final String? addedBy}) = _$BillItemImpl;

  factory _BillItem.fromJson(Map<String, dynamic> json) =
      _$BillItemImpl.fromJson;

  @override
  String get id;
  @override
  String get billId;
  @override
  String get itemName;
  @override
  int get quantity;
  @override
  double get pricePerUnit;
  @override
  double get totalPrice;
  @override
  String? get category;
  @override
  String? get notes;
  @override
  DateTime get addedAt;
  @override
  String? get addedBy;

  /// Create a copy of BillItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BillItemImplCopyWith<_$BillItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
