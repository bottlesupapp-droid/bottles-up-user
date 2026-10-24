// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$venueListHash() => r'ee96e29ed4991be9197bbb5bc8b6671792aafe20';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$VenueList
    extends BuildlessAutoDisposeAsyncNotifier<List<Venue>> {
  late final String? city;
  late final int? minCapacity;
  late final double? maxPrice;
  late final List<String>? amenities;

  FutureOr<List<Venue>> build({
    String? city,
    int? minCapacity,
    double? maxPrice,
    List<String>? amenities,
  });
}

/// See also [VenueList].
@ProviderFor(VenueList)
const venueListProvider = VenueListFamily();

/// See also [VenueList].
class VenueListFamily extends Family<AsyncValue<List<Venue>>> {
  /// See also [VenueList].
  const VenueListFamily();

  /// See also [VenueList].
  VenueListProvider call({
    String? city,
    int? minCapacity,
    double? maxPrice,
    List<String>? amenities,
  }) {
    return VenueListProvider(
      city: city,
      minCapacity: minCapacity,
      maxPrice: maxPrice,
      amenities: amenities,
    );
  }

  @override
  VenueListProvider getProviderOverride(
    covariant VenueListProvider provider,
  ) {
    return call(
      city: provider.city,
      minCapacity: provider.minCapacity,
      maxPrice: provider.maxPrice,
      amenities: provider.amenities,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'venueListProvider';
}

/// See also [VenueList].
class VenueListProvider
    extends AutoDisposeAsyncNotifierProviderImpl<VenueList, List<Venue>> {
  /// See also [VenueList].
  VenueListProvider({
    String? city,
    int? minCapacity,
    double? maxPrice,
    List<String>? amenities,
  }) : this._internal(
          () => VenueList()
            ..city = city
            ..minCapacity = minCapacity
            ..maxPrice = maxPrice
            ..amenities = amenities,
          from: venueListProvider,
          name: r'venueListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$venueListHash,
          dependencies: VenueListFamily._dependencies,
          allTransitiveDependencies: VenueListFamily._allTransitiveDependencies,
          city: city,
          minCapacity: minCapacity,
          maxPrice: maxPrice,
          amenities: amenities,
        );

  VenueListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.city,
    required this.minCapacity,
    required this.maxPrice,
    required this.amenities,
  }) : super.internal();

  final String? city;
  final int? minCapacity;
  final double? maxPrice;
  final List<String>? amenities;

  @override
  FutureOr<List<Venue>> runNotifierBuild(
    covariant VenueList notifier,
  ) {
    return notifier.build(
      city: city,
      minCapacity: minCapacity,
      maxPrice: maxPrice,
      amenities: amenities,
    );
  }

  @override
  Override overrideWith(VenueList Function() create) {
    return ProviderOverride(
      origin: this,
      override: VenueListProvider._internal(
        () => create()
          ..city = city
          ..minCapacity = minCapacity
          ..maxPrice = maxPrice
          ..amenities = amenities,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        city: city,
        minCapacity: minCapacity,
        maxPrice: maxPrice,
        amenities: amenities,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<VenueList, List<Venue>>
      createElement() {
    return _VenueListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VenueListProvider &&
        other.city == city &&
        other.minCapacity == minCapacity &&
        other.maxPrice == maxPrice &&
        other.amenities == amenities;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, city.hashCode);
    hash = _SystemHash.combine(hash, minCapacity.hashCode);
    hash = _SystemHash.combine(hash, maxPrice.hashCode);
    hash = _SystemHash.combine(hash, amenities.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin VenueListRef on AutoDisposeAsyncNotifierProviderRef<List<Venue>> {
  /// The parameter `city` of this provider.
  String? get city;

  /// The parameter `minCapacity` of this provider.
  int? get minCapacity;

  /// The parameter `maxPrice` of this provider.
  double? get maxPrice;

  /// The parameter `amenities` of this provider.
  List<String>? get amenities;
}

class _VenueListProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<VenueList, List<Venue>>
    with VenueListRef {
  _VenueListProviderElement(super.provider);

  @override
  String? get city => (origin as VenueListProvider).city;
  @override
  int? get minCapacity => (origin as VenueListProvider).minCapacity;
  @override
  double? get maxPrice => (origin as VenueListProvider).maxPrice;
  @override
  List<String>? get amenities => (origin as VenueListProvider).amenities;
}

String _$venueDetailHash() => r'5427aefa59f73de33c19e9e289fdce41e42b9d30';

abstract class _$VenueDetail extends BuildlessAutoDisposeAsyncNotifier<Venue> {
  late final String venueId;

  FutureOr<Venue> build(
    String venueId,
  );
}

/// See also [VenueDetail].
@ProviderFor(VenueDetail)
const venueDetailProvider = VenueDetailFamily();

/// See also [VenueDetail].
class VenueDetailFamily extends Family<AsyncValue<Venue>> {
  /// See also [VenueDetail].
  const VenueDetailFamily();

  /// See also [VenueDetail].
  VenueDetailProvider call(
    String venueId,
  ) {
    return VenueDetailProvider(
      venueId,
    );
  }

  @override
  VenueDetailProvider getProviderOverride(
    covariant VenueDetailProvider provider,
  ) {
    return call(
      provider.venueId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'venueDetailProvider';
}

/// See also [VenueDetail].
class VenueDetailProvider
    extends AutoDisposeAsyncNotifierProviderImpl<VenueDetail, Venue> {
  /// See also [VenueDetail].
  VenueDetailProvider(
    String venueId,
  ) : this._internal(
          () => VenueDetail()..venueId = venueId,
          from: venueDetailProvider,
          name: r'venueDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$venueDetailHash,
          dependencies: VenueDetailFamily._dependencies,
          allTransitiveDependencies:
              VenueDetailFamily._allTransitiveDependencies,
          venueId: venueId,
        );

  VenueDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.venueId,
  }) : super.internal();

  final String venueId;

  @override
  FutureOr<Venue> runNotifierBuild(
    covariant VenueDetail notifier,
  ) {
    return notifier.build(
      venueId,
    );
  }

  @override
  Override overrideWith(VenueDetail Function() create) {
    return ProviderOverride(
      origin: this,
      override: VenueDetailProvider._internal(
        () => create()..venueId = venueId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        venueId: venueId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<VenueDetail, Venue> createElement() {
    return _VenueDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VenueDetailProvider && other.venueId == venueId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, venueId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin VenueDetailRef on AutoDisposeAsyncNotifierProviderRef<Venue> {
  /// The parameter `venueId` of this provider.
  String get venueId;
}

class _VenueDetailProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<VenueDetail, Venue>
    with VenueDetailRef {
  _VenueDetailProviderElement(super.provider);

  @override
  String get venueId => (origin as VenueDetailProvider).venueId;
}

String _$venueSearchHash() => r'43d3693093880da4c593c04fcb306e65ea04c3ce';

abstract class _$VenueSearch
    extends BuildlessAutoDisposeAsyncNotifier<List<Venue>> {
  late final String query;

  FutureOr<List<Venue>> build(
    String query,
  );
}

/// See also [VenueSearch].
@ProviderFor(VenueSearch)
const venueSearchProvider = VenueSearchFamily();

/// See also [VenueSearch].
class VenueSearchFamily extends Family<AsyncValue<List<Venue>>> {
  /// See also [VenueSearch].
  const VenueSearchFamily();

  /// See also [VenueSearch].
  VenueSearchProvider call(
    String query,
  ) {
    return VenueSearchProvider(
      query,
    );
  }

  @override
  VenueSearchProvider getProviderOverride(
    covariant VenueSearchProvider provider,
  ) {
    return call(
      provider.query,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'venueSearchProvider';
}

/// See also [VenueSearch].
class VenueSearchProvider
    extends AutoDisposeAsyncNotifierProviderImpl<VenueSearch, List<Venue>> {
  /// See also [VenueSearch].
  VenueSearchProvider(
    String query,
  ) : this._internal(
          () => VenueSearch()..query = query,
          from: venueSearchProvider,
          name: r'venueSearchProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$venueSearchHash,
          dependencies: VenueSearchFamily._dependencies,
          allTransitiveDependencies:
              VenueSearchFamily._allTransitiveDependencies,
          query: query,
        );

  VenueSearchProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  FutureOr<List<Venue>> runNotifierBuild(
    covariant VenueSearch notifier,
  ) {
    return notifier.build(
      query,
    );
  }

  @override
  Override overrideWith(VenueSearch Function() create) {
    return ProviderOverride(
      origin: this,
      override: VenueSearchProvider._internal(
        () => create()..query = query,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<VenueSearch, List<Venue>>
      createElement() {
    return _VenueSearchProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VenueSearchProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin VenueSearchRef on AutoDisposeAsyncNotifierProviderRef<List<Venue>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _VenueSearchProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<VenueSearch, List<Venue>>
    with VenueSearchRef {
  _VenueSearchProviderElement(super.provider);

  @override
  String get query => (origin as VenueSearchProvider).query;
}

String _$venueRatingsHash() => r'9d90d6bbec5fa8a7ece589eaa73ce1e85162d681';

abstract class _$VenueRatings
    extends BuildlessAutoDisposeAsyncNotifier<List<VenueRating>> {
  late final String venueId;

  FutureOr<List<VenueRating>> build(
    String venueId,
  );
}

/// See also [VenueRatings].
@ProviderFor(VenueRatings)
const venueRatingsProvider = VenueRatingsFamily();

/// See also [VenueRatings].
class VenueRatingsFamily extends Family<AsyncValue<List<VenueRating>>> {
  /// See also [VenueRatings].
  const VenueRatingsFamily();

  /// See also [VenueRatings].
  VenueRatingsProvider call(
    String venueId,
  ) {
    return VenueRatingsProvider(
      venueId,
    );
  }

  @override
  VenueRatingsProvider getProviderOverride(
    covariant VenueRatingsProvider provider,
  ) {
    return call(
      provider.venueId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'venueRatingsProvider';
}

/// See also [VenueRatings].
class VenueRatingsProvider extends AutoDisposeAsyncNotifierProviderImpl<
    VenueRatings, List<VenueRating>> {
  /// See also [VenueRatings].
  VenueRatingsProvider(
    String venueId,
  ) : this._internal(
          () => VenueRatings()..venueId = venueId,
          from: venueRatingsProvider,
          name: r'venueRatingsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$venueRatingsHash,
          dependencies: VenueRatingsFamily._dependencies,
          allTransitiveDependencies:
              VenueRatingsFamily._allTransitiveDependencies,
          venueId: venueId,
        );

  VenueRatingsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.venueId,
  }) : super.internal();

  final String venueId;

  @override
  FutureOr<List<VenueRating>> runNotifierBuild(
    covariant VenueRatings notifier,
  ) {
    return notifier.build(
      venueId,
    );
  }

  @override
  Override overrideWith(VenueRatings Function() create) {
    return ProviderOverride(
      origin: this,
      override: VenueRatingsProvider._internal(
        () => create()..venueId = venueId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        venueId: venueId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<VenueRatings, List<VenueRating>>
      createElement() {
    return _VenueRatingsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VenueRatingsProvider && other.venueId == venueId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, venueId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin VenueRatingsRef
    on AutoDisposeAsyncNotifierProviderRef<List<VenueRating>> {
  /// The parameter `venueId` of this provider.
  String get venueId;
}

class _VenueRatingsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<VenueRatings,
        List<VenueRating>> with VenueRatingsRef {
  _VenueRatingsProviderElement(super.provider);

  @override
  String get venueId => (origin as VenueRatingsProvider).venueId;
}

String _$venueInquiriesHash() => r'3f66249676eea6c39960c4a97610459dc8c82add';

/// See also [VenueInquiries].
@ProviderFor(VenueInquiries)
final venueInquiriesProvider = AutoDisposeAsyncNotifierProvider<VenueInquiries,
    List<VenueInquiry>>.internal(
  VenueInquiries.new,
  name: r'venueInquiriesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$venueInquiriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$VenueInquiries = AutoDisposeAsyncNotifier<List<VenueInquiry>>;
String _$venueComparisonsHash() => r'a03dac997d31856261b072e588bf7bed7d9f786b';

/// See also [VenueComparisons].
@ProviderFor(VenueComparisons)
final venueComparisonsProvider = AutoDisposeAsyncNotifierProvider<
    VenueComparisons, List<VenueComparison>>.internal(
  VenueComparisons.new,
  name: r'venueComparisonsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$venueComparisonsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$VenueComparisons = AutoDisposeAsyncNotifier<List<VenueComparison>>;
String _$venueComparisonDetailHash() =>
    r'90fb31f3d572a9e053b073ad103ae9008e796dac';

abstract class _$VenueComparisonDetail
    extends BuildlessAutoDisposeAsyncNotifier<Map<String, dynamic>> {
  late final List<String> venueIds;

  FutureOr<Map<String, dynamic>> build(
    List<String> venueIds,
  );
}

/// See also [VenueComparisonDetail].
@ProviderFor(VenueComparisonDetail)
const venueComparisonDetailProvider = VenueComparisonDetailFamily();

/// See also [VenueComparisonDetail].
class VenueComparisonDetailFamily
    extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [VenueComparisonDetail].
  const VenueComparisonDetailFamily();

  /// See also [VenueComparisonDetail].
  VenueComparisonDetailProvider call(
    List<String> venueIds,
  ) {
    return VenueComparisonDetailProvider(
      venueIds,
    );
  }

  @override
  VenueComparisonDetailProvider getProviderOverride(
    covariant VenueComparisonDetailProvider provider,
  ) {
    return call(
      provider.venueIds,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'venueComparisonDetailProvider';
}

/// See also [VenueComparisonDetail].
class VenueComparisonDetailProvider
    extends AutoDisposeAsyncNotifierProviderImpl<VenueComparisonDetail,
        Map<String, dynamic>> {
  /// See also [VenueComparisonDetail].
  VenueComparisonDetailProvider(
    List<String> venueIds,
  ) : this._internal(
          () => VenueComparisonDetail()..venueIds = venueIds,
          from: venueComparisonDetailProvider,
          name: r'venueComparisonDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$venueComparisonDetailHash,
          dependencies: VenueComparisonDetailFamily._dependencies,
          allTransitiveDependencies:
              VenueComparisonDetailFamily._allTransitiveDependencies,
          venueIds: venueIds,
        );

  VenueComparisonDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.venueIds,
  }) : super.internal();

  final List<String> venueIds;

  @override
  FutureOr<Map<String, dynamic>> runNotifierBuild(
    covariant VenueComparisonDetail notifier,
  ) {
    return notifier.build(
      venueIds,
    );
  }

  @override
  Override overrideWith(VenueComparisonDetail Function() create) {
    return ProviderOverride(
      origin: this,
      override: VenueComparisonDetailProvider._internal(
        () => create()..venueIds = venueIds,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        venueIds: venueIds,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<VenueComparisonDetail,
      Map<String, dynamic>> createElement() {
    return _VenueComparisonDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VenueComparisonDetailProvider && other.venueIds == venueIds;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, venueIds.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin VenueComparisonDetailRef
    on AutoDisposeAsyncNotifierProviderRef<Map<String, dynamic>> {
  /// The parameter `venueIds` of this provider.
  List<String> get venueIds;
}

class _VenueComparisonDetailProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<VenueComparisonDetail,
        Map<String, dynamic>> with VenueComparisonDetailRef {
  _VenueComparisonDetailProviderElement(super.provider);

  @override
  List<String> get venueIds =>
      (origin as VenueComparisonDetailProvider).venueIds;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
