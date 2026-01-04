// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bottle.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Bottle _$BottleFromJson(Map<String, dynamic> json) {
  return _Bottle.fromJson(json);
}

/// @nodoc
mixin _$Bottle {
  String get id => throw _privateConstructorUsedError;
  String get clubId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String? get subcategory => throw _privateConstructorUsedError;
  String? get brand => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  int? get volumeMl => throw _privateConstructorUsedError;
  double? get alcoholContent => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  bool get isAvailable => throw _privateConstructorUsedError;
  bool get isFeatured => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Bottle to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Bottle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BottleCopyWith<Bottle> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BottleCopyWith<$Res> {
  factory $BottleCopyWith(Bottle value, $Res Function(Bottle) then) =
      _$BottleCopyWithImpl<$Res, Bottle>;
  @useResult
  $Res call(
      {String id,
      String clubId,
      String name,
      String category,
      String? subcategory,
      String? brand,
      double price,
      int? volumeMl,
      double? alcoholContent,
      String? description,
      String? imageUrl,
      bool isAvailable,
      bool isFeatured,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$BottleCopyWithImpl<$Res, $Val extends Bottle>
    implements $BottleCopyWith<$Res> {
  _$BottleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Bottle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clubId = null,
    Object? name = null,
    Object? category = null,
    Object? subcategory = freezed,
    Object? brand = freezed,
    Object? price = null,
    Object? volumeMl = freezed,
    Object? alcoholContent = freezed,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? isAvailable = null,
    Object? isFeatured = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      clubId: null == clubId
          ? _value.clubId
          : clubId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      subcategory: freezed == subcategory
          ? _value.subcategory
          : subcategory // ignore: cast_nullable_to_non_nullable
              as String?,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      volumeMl: freezed == volumeMl
          ? _value.volumeMl
          : volumeMl // ignore: cast_nullable_to_non_nullable
              as int?,
      alcoholContent: freezed == alcoholContent
          ? _value.alcoholContent
          : alcoholContent // ignore: cast_nullable_to_non_nullable
              as double?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BottleImplCopyWith<$Res> implements $BottleCopyWith<$Res> {
  factory _$$BottleImplCopyWith(
          _$BottleImpl value, $Res Function(_$BottleImpl) then) =
      __$$BottleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String clubId,
      String name,
      String category,
      String? subcategory,
      String? brand,
      double price,
      int? volumeMl,
      double? alcoholContent,
      String? description,
      String? imageUrl,
      bool isAvailable,
      bool isFeatured,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$BottleImplCopyWithImpl<$Res>
    extends _$BottleCopyWithImpl<$Res, _$BottleImpl>
    implements _$$BottleImplCopyWith<$Res> {
  __$$BottleImplCopyWithImpl(
      _$BottleImpl _value, $Res Function(_$BottleImpl) _then)
      : super(_value, _then);

  /// Create a copy of Bottle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clubId = null,
    Object? name = null,
    Object? category = null,
    Object? subcategory = freezed,
    Object? brand = freezed,
    Object? price = null,
    Object? volumeMl = freezed,
    Object? alcoholContent = freezed,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? isAvailable = null,
    Object? isFeatured = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$BottleImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      clubId: null == clubId
          ? _value.clubId
          : clubId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      subcategory: freezed == subcategory
          ? _value.subcategory
          : subcategory // ignore: cast_nullable_to_non_nullable
              as String?,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      volumeMl: freezed == volumeMl
          ? _value.volumeMl
          : volumeMl // ignore: cast_nullable_to_non_nullable
              as int?,
      alcoholContent: freezed == alcoholContent
          ? _value.alcoholContent
          : alcoholContent // ignore: cast_nullable_to_non_nullable
              as double?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BottleImpl implements _Bottle {
  const _$BottleImpl(
      {required this.id,
      required this.clubId,
      required this.name,
      required this.category,
      this.subcategory,
      this.brand,
      required this.price,
      this.volumeMl,
      this.alcoholContent,
      this.description,
      this.imageUrl,
      this.isAvailable = true,
      this.isFeatured = false,
      this.createdAt,
      this.updatedAt});

  factory _$BottleImpl.fromJson(Map<String, dynamic> json) =>
      _$$BottleImplFromJson(json);

  @override
  final String id;
  @override
  final String clubId;
  @override
  final String name;
  @override
  final String category;
  @override
  final String? subcategory;
  @override
  final String? brand;
  @override
  final double price;
  @override
  final int? volumeMl;
  @override
  final double? alcoholContent;
  @override
  final String? description;
  @override
  final String? imageUrl;
  @override
  @JsonKey()
  final bool isAvailable;
  @override
  @JsonKey()
  final bool isFeatured;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Bottle(id: $id, clubId: $clubId, name: $name, category: $category, subcategory: $subcategory, brand: $brand, price: $price, volumeMl: $volumeMl, alcoholContent: $alcoholContent, description: $description, imageUrl: $imageUrl, isAvailable: $isAvailable, isFeatured: $isFeatured, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BottleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clubId, clubId) || other.clubId == clubId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.subcategory, subcategory) ||
                other.subcategory == subcategory) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.volumeMl, volumeMl) ||
                other.volumeMl == volumeMl) &&
            (identical(other.alcoholContent, alcoholContent) ||
                other.alcoholContent == alcoholContent) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            (identical(other.isFeatured, isFeatured) ||
                other.isFeatured == isFeatured) &&
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
      clubId,
      name,
      category,
      subcategory,
      brand,
      price,
      volumeMl,
      alcoholContent,
      description,
      imageUrl,
      isAvailable,
      isFeatured,
      createdAt,
      updatedAt);

  /// Create a copy of Bottle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BottleImplCopyWith<_$BottleImpl> get copyWith =>
      __$$BottleImplCopyWithImpl<_$BottleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BottleImplToJson(
      this,
    );
  }
}

abstract class _Bottle implements Bottle {
  const factory _Bottle(
      {required final String id,
      required final String clubId,
      required final String name,
      required final String category,
      final String? subcategory,
      final String? brand,
      required final double price,
      final int? volumeMl,
      final double? alcoholContent,
      final String? description,
      final String? imageUrl,
      final bool isAvailable,
      final bool isFeatured,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$BottleImpl;

  factory _Bottle.fromJson(Map<String, dynamic> json) = _$BottleImpl.fromJson;

  @override
  String get id;
  @override
  String get clubId;
  @override
  String get name;
  @override
  String get category;
  @override
  String? get subcategory;
  @override
  String? get brand;
  @override
  double get price;
  @override
  int? get volumeMl;
  @override
  double? get alcoholContent;
  @override
  String? get description;
  @override
  String? get imageUrl;
  @override
  bool get isAvailable;
  @override
  bool get isFeatured;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Bottle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BottleImplCopyWith<_$BottleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
