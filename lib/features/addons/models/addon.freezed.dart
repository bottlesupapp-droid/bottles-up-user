// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'addon.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Addon _$AddonFromJson(Map<String, dynamic> json) {
  return _Addon.fromJson(json);
}

/// @nodoc
mixin _$Addon {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  AddonCategory get category => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  bool get isAvailable => throw _privateConstructorUsedError;
  bool get requiresApproval => throw _privateConstructorUsedError;
  int? get maxQuantity => throw _privateConstructorUsedError;
  int? get availableStock => throw _privateConstructorUsedError;
  List<String>? get includedItems => throw _privateConstructorUsedError;
  String? get estimatedDuration => throw _privateConstructorUsedError;

  /// Serializes this Addon to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Addon
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddonCopyWith<Addon> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddonCopyWith<$Res> {
  factory $AddonCopyWith(Addon value, $Res Function(Addon) then) =
      _$AddonCopyWithImpl<$Res, Addon>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      AddonCategory category,
      double price,
      String? imageUrl,
      bool isAvailable,
      bool requiresApproval,
      int? maxQuantity,
      int? availableStock,
      List<String>? includedItems,
      String? estimatedDuration});
}

/// @nodoc
class _$AddonCopyWithImpl<$Res, $Val extends Addon>
    implements $AddonCopyWith<$Res> {
  _$AddonCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Addon
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? category = null,
    Object? price = null,
    Object? imageUrl = freezed,
    Object? isAvailable = null,
    Object? requiresApproval = null,
    Object? maxQuantity = freezed,
    Object? availableStock = freezed,
    Object? includedItems = freezed,
    Object? estimatedDuration = freezed,
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
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as AddonCategory,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      requiresApproval: null == requiresApproval
          ? _value.requiresApproval
          : requiresApproval // ignore: cast_nullable_to_non_nullable
              as bool,
      maxQuantity: freezed == maxQuantity
          ? _value.maxQuantity
          : maxQuantity // ignore: cast_nullable_to_non_nullable
              as int?,
      availableStock: freezed == availableStock
          ? _value.availableStock
          : availableStock // ignore: cast_nullable_to_non_nullable
              as int?,
      includedItems: freezed == includedItems
          ? _value.includedItems
          : includedItems // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      estimatedDuration: freezed == estimatedDuration
          ? _value.estimatedDuration
          : estimatedDuration // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AddonImplCopyWith<$Res> implements $AddonCopyWith<$Res> {
  factory _$$AddonImplCopyWith(
          _$AddonImpl value, $Res Function(_$AddonImpl) then) =
      __$$AddonImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      AddonCategory category,
      double price,
      String? imageUrl,
      bool isAvailable,
      bool requiresApproval,
      int? maxQuantity,
      int? availableStock,
      List<String>? includedItems,
      String? estimatedDuration});
}

/// @nodoc
class __$$AddonImplCopyWithImpl<$Res>
    extends _$AddonCopyWithImpl<$Res, _$AddonImpl>
    implements _$$AddonImplCopyWith<$Res> {
  __$$AddonImplCopyWithImpl(
      _$AddonImpl _value, $Res Function(_$AddonImpl) _then)
      : super(_value, _then);

  /// Create a copy of Addon
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? category = null,
    Object? price = null,
    Object? imageUrl = freezed,
    Object? isAvailable = null,
    Object? requiresApproval = null,
    Object? maxQuantity = freezed,
    Object? availableStock = freezed,
    Object? includedItems = freezed,
    Object? estimatedDuration = freezed,
  }) {
    return _then(_$AddonImpl(
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
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as AddonCategory,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      requiresApproval: null == requiresApproval
          ? _value.requiresApproval
          : requiresApproval // ignore: cast_nullable_to_non_nullable
              as bool,
      maxQuantity: freezed == maxQuantity
          ? _value.maxQuantity
          : maxQuantity // ignore: cast_nullable_to_non_nullable
              as int?,
      availableStock: freezed == availableStock
          ? _value.availableStock
          : availableStock // ignore: cast_nullable_to_non_nullable
              as int?,
      includedItems: freezed == includedItems
          ? _value._includedItems
          : includedItems // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      estimatedDuration: freezed == estimatedDuration
          ? _value.estimatedDuration
          : estimatedDuration // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AddonImpl implements _Addon {
  const _$AddonImpl(
      {required this.id,
      required this.name,
      required this.description,
      required this.category,
      required this.price,
      this.imageUrl,
      this.isAvailable = true,
      this.requiresApproval = false,
      this.maxQuantity,
      this.availableStock,
      final List<String>? includedItems,
      this.estimatedDuration})
      : _includedItems = includedItems;

  factory _$AddonImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddonImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final AddonCategory category;
  @override
  final double price;
  @override
  final String? imageUrl;
  @override
  @JsonKey()
  final bool isAvailable;
  @override
  @JsonKey()
  final bool requiresApproval;
  @override
  final int? maxQuantity;
  @override
  final int? availableStock;
  final List<String>? _includedItems;
  @override
  List<String>? get includedItems {
    final value = _includedItems;
    if (value == null) return null;
    if (_includedItems is EqualUnmodifiableListView) return _includedItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? estimatedDuration;

  @override
  String toString() {
    return 'Addon(id: $id, name: $name, description: $description, category: $category, price: $price, imageUrl: $imageUrl, isAvailable: $isAvailable, requiresApproval: $requiresApproval, maxQuantity: $maxQuantity, availableStock: $availableStock, includedItems: $includedItems, estimatedDuration: $estimatedDuration)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddonImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            (identical(other.requiresApproval, requiresApproval) ||
                other.requiresApproval == requiresApproval) &&
            (identical(other.maxQuantity, maxQuantity) ||
                other.maxQuantity == maxQuantity) &&
            (identical(other.availableStock, availableStock) ||
                other.availableStock == availableStock) &&
            const DeepCollectionEquality()
                .equals(other._includedItems, _includedItems) &&
            (identical(other.estimatedDuration, estimatedDuration) ||
                other.estimatedDuration == estimatedDuration));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      category,
      price,
      imageUrl,
      isAvailable,
      requiresApproval,
      maxQuantity,
      availableStock,
      const DeepCollectionEquality().hash(_includedItems),
      estimatedDuration);

  /// Create a copy of Addon
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddonImplCopyWith<_$AddonImpl> get copyWith =>
      __$$AddonImplCopyWithImpl<_$AddonImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AddonImplToJson(
      this,
    );
  }
}

abstract class _Addon implements Addon {
  const factory _Addon(
      {required final String id,
      required final String name,
      required final String description,
      required final AddonCategory category,
      required final double price,
      final String? imageUrl,
      final bool isAvailable,
      final bool requiresApproval,
      final int? maxQuantity,
      final int? availableStock,
      final List<String>? includedItems,
      final String? estimatedDuration}) = _$AddonImpl;

  factory _Addon.fromJson(Map<String, dynamic> json) = _$AddonImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  AddonCategory get category;
  @override
  double get price;
  @override
  String? get imageUrl;
  @override
  bool get isAvailable;
  @override
  bool get requiresApproval;
  @override
  int? get maxQuantity;
  @override
  int? get availableStock;
  @override
  List<String>? get includedItems;
  @override
  String? get estimatedDuration;

  /// Create a copy of Addon
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddonImplCopyWith<_$AddonImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BookingAddon _$BookingAddonFromJson(Map<String, dynamic> json) {
  return _BookingAddon.fromJson(json);
}

/// @nodoc
mixin _$BookingAddon {
  String get id => throw _privateConstructorUsedError;
  String get bookingId => throw _privateConstructorUsedError;
  String get addonId => throw _privateConstructorUsedError;
  String get addonName => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  double get totalPrice => throw _privateConstructorUsedError;
  AddonStatus get status => throw _privateConstructorUsedError;
  String? get specialInstructions => throw _privateConstructorUsedError;
  DateTime? get scheduledTime => throw _privateConstructorUsedError;
  DateTime? get approvedAt => throw _privateConstructorUsedError;
  DateTime? get deliveredAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this BookingAddon to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookingAddon
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingAddonCopyWith<BookingAddon> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingAddonCopyWith<$Res> {
  factory $BookingAddonCopyWith(
          BookingAddon value, $Res Function(BookingAddon) then) =
      _$BookingAddonCopyWithImpl<$Res, BookingAddon>;
  @useResult
  $Res call(
      {String id,
      String bookingId,
      String addonId,
      String addonName,
      double price,
      int quantity,
      double totalPrice,
      AddonStatus status,
      String? specialInstructions,
      DateTime? scheduledTime,
      DateTime? approvedAt,
      DateTime? deliveredAt,
      DateTime createdAt});
}

/// @nodoc
class _$BookingAddonCopyWithImpl<$Res, $Val extends BookingAddon>
    implements $BookingAddonCopyWith<$Res> {
  _$BookingAddonCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingAddon
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bookingId = null,
    Object? addonId = null,
    Object? addonName = null,
    Object? price = null,
    Object? quantity = null,
    Object? totalPrice = null,
    Object? status = null,
    Object? specialInstructions = freezed,
    Object? scheduledTime = freezed,
    Object? approvedAt = freezed,
    Object? deliveredAt = freezed,
    Object? createdAt = null,
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
      addonId: null == addonId
          ? _value.addonId
          : addonId // ignore: cast_nullable_to_non_nullable
              as String,
      addonName: null == addonName
          ? _value.addonName
          : addonName // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AddonStatus,
      specialInstructions: freezed == specialInstructions
          ? _value.specialInstructions
          : specialInstructions // ignore: cast_nullable_to_non_nullable
              as String?,
      scheduledTime: freezed == scheduledTime
          ? _value.scheduledTime
          : scheduledTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      approvedAt: freezed == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deliveredAt: freezed == deliveredAt
          ? _value.deliveredAt
          : deliveredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BookingAddonImplCopyWith<$Res>
    implements $BookingAddonCopyWith<$Res> {
  factory _$$BookingAddonImplCopyWith(
          _$BookingAddonImpl value, $Res Function(_$BookingAddonImpl) then) =
      __$$BookingAddonImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String bookingId,
      String addonId,
      String addonName,
      double price,
      int quantity,
      double totalPrice,
      AddonStatus status,
      String? specialInstructions,
      DateTime? scheduledTime,
      DateTime? approvedAt,
      DateTime? deliveredAt,
      DateTime createdAt});
}

/// @nodoc
class __$$BookingAddonImplCopyWithImpl<$Res>
    extends _$BookingAddonCopyWithImpl<$Res, _$BookingAddonImpl>
    implements _$$BookingAddonImplCopyWith<$Res> {
  __$$BookingAddonImplCopyWithImpl(
      _$BookingAddonImpl _value, $Res Function(_$BookingAddonImpl) _then)
      : super(_value, _then);

  /// Create a copy of BookingAddon
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bookingId = null,
    Object? addonId = null,
    Object? addonName = null,
    Object? price = null,
    Object? quantity = null,
    Object? totalPrice = null,
    Object? status = null,
    Object? specialInstructions = freezed,
    Object? scheduledTime = freezed,
    Object? approvedAt = freezed,
    Object? deliveredAt = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$BookingAddonImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      bookingId: null == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String,
      addonId: null == addonId
          ? _value.addonId
          : addonId // ignore: cast_nullable_to_non_nullable
              as String,
      addonName: null == addonName
          ? _value.addonName
          : addonName // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AddonStatus,
      specialInstructions: freezed == specialInstructions
          ? _value.specialInstructions
          : specialInstructions // ignore: cast_nullable_to_non_nullable
              as String?,
      scheduledTime: freezed == scheduledTime
          ? _value.scheduledTime
          : scheduledTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      approvedAt: freezed == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deliveredAt: freezed == deliveredAt
          ? _value.deliveredAt
          : deliveredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingAddonImpl implements _BookingAddon {
  const _$BookingAddonImpl(
      {required this.id,
      required this.bookingId,
      required this.addonId,
      required this.addonName,
      required this.price,
      required this.quantity,
      required this.totalPrice,
      this.status = AddonStatus.pending,
      this.specialInstructions,
      this.scheduledTime,
      this.approvedAt,
      this.deliveredAt,
      required this.createdAt});

  factory _$BookingAddonImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingAddonImplFromJson(json);

  @override
  final String id;
  @override
  final String bookingId;
  @override
  final String addonId;
  @override
  final String addonName;
  @override
  final double price;
  @override
  final int quantity;
  @override
  final double totalPrice;
  @override
  @JsonKey()
  final AddonStatus status;
  @override
  final String? specialInstructions;
  @override
  final DateTime? scheduledTime;
  @override
  final DateTime? approvedAt;
  @override
  final DateTime? deliveredAt;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'BookingAddon(id: $id, bookingId: $bookingId, addonId: $addonId, addonName: $addonName, price: $price, quantity: $quantity, totalPrice: $totalPrice, status: $status, specialInstructions: $specialInstructions, scheduledTime: $scheduledTime, approvedAt: $approvedAt, deliveredAt: $deliveredAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingAddonImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.addonId, addonId) || other.addonId == addonId) &&
            (identical(other.addonName, addonName) ||
                other.addonName == addonName) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.specialInstructions, specialInstructions) ||
                other.specialInstructions == specialInstructions) &&
            (identical(other.scheduledTime, scheduledTime) ||
                other.scheduledTime == scheduledTime) &&
            (identical(other.approvedAt, approvedAt) ||
                other.approvedAt == approvedAt) &&
            (identical(other.deliveredAt, deliveredAt) ||
                other.deliveredAt == deliveredAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      bookingId,
      addonId,
      addonName,
      price,
      quantity,
      totalPrice,
      status,
      specialInstructions,
      scheduledTime,
      approvedAt,
      deliveredAt,
      createdAt);

  /// Create a copy of BookingAddon
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingAddonImplCopyWith<_$BookingAddonImpl> get copyWith =>
      __$$BookingAddonImplCopyWithImpl<_$BookingAddonImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingAddonImplToJson(
      this,
    );
  }
}

abstract class _BookingAddon implements BookingAddon {
  const factory _BookingAddon(
      {required final String id,
      required final String bookingId,
      required final String addonId,
      required final String addonName,
      required final double price,
      required final int quantity,
      required final double totalPrice,
      final AddonStatus status,
      final String? specialInstructions,
      final DateTime? scheduledTime,
      final DateTime? approvedAt,
      final DateTime? deliveredAt,
      required final DateTime createdAt}) = _$BookingAddonImpl;

  factory _BookingAddon.fromJson(Map<String, dynamic> json) =
      _$BookingAddonImpl.fromJson;

  @override
  String get id;
  @override
  String get bookingId;
  @override
  String get addonId;
  @override
  String get addonName;
  @override
  double get price;
  @override
  int get quantity;
  @override
  double get totalPrice;
  @override
  AddonStatus get status;
  @override
  String? get specialInstructions;
  @override
  DateTime? get scheduledTime;
  @override
  DateTime? get approvedAt;
  @override
  DateTime? get deliveredAt;
  @override
  DateTime get createdAt;

  /// Create a copy of BookingAddon
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingAddonImplCopyWith<_$BookingAddonImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
