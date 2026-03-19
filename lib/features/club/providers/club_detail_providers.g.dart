// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'club_detail_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$clubTablesHash() => r'a940c56dd21a34751c5c42a7c19c2b0e6e3802df';

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

abstract class _$ClubTables
    extends BuildlessAutoDisposeAsyncNotifier<List<ClubTable>> {
  late final String clubId;

  FutureOr<List<ClubTable>> build(
    String clubId,
  );
}

/// See also [ClubTables].
@ProviderFor(ClubTables)
const clubTablesProvider = ClubTablesFamily();

/// See also [ClubTables].
class ClubTablesFamily extends Family<AsyncValue<List<ClubTable>>> {
  /// See also [ClubTables].
  const ClubTablesFamily();

  /// See also [ClubTables].
  ClubTablesProvider call(
    String clubId,
  ) {
    return ClubTablesProvider(
      clubId,
    );
  }

  @override
  ClubTablesProvider getProviderOverride(
    covariant ClubTablesProvider provider,
  ) {
    return call(
      provider.clubId,
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
  String? get name => r'clubTablesProvider';
}

/// See also [ClubTables].
class ClubTablesProvider
    extends AutoDisposeAsyncNotifierProviderImpl<ClubTables, List<ClubTable>> {
  /// See also [ClubTables].
  ClubTablesProvider(
    String clubId,
  ) : this._internal(
          () => ClubTables()..clubId = clubId,
          from: clubTablesProvider,
          name: r'clubTablesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$clubTablesHash,
          dependencies: ClubTablesFamily._dependencies,
          allTransitiveDependencies:
              ClubTablesFamily._allTransitiveDependencies,
          clubId: clubId,
        );

  ClubTablesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.clubId,
  }) : super.internal();

  final String clubId;

  @override
  FutureOr<List<ClubTable>> runNotifierBuild(
    covariant ClubTables notifier,
  ) {
    return notifier.build(
      clubId,
    );
  }

  @override
  Override overrideWith(ClubTables Function() create) {
    return ProviderOverride(
      origin: this,
      override: ClubTablesProvider._internal(
        () => create()..clubId = clubId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        clubId: clubId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ClubTables, List<ClubTable>>
      createElement() {
    return _ClubTablesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ClubTablesProvider && other.clubId == clubId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, clubId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ClubTablesRef on AutoDisposeAsyncNotifierProviderRef<List<ClubTable>> {
  /// The parameter `clubId` of this provider.
  String get clubId;
}

class _ClubTablesProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ClubTables, List<ClubTable>>
    with ClubTablesRef {
  _ClubTablesProviderElement(super.provider);

  @override
  String get clubId => (origin as ClubTablesProvider).clubId;
}

String _$availableClubTablesHash() =>
    r'41f71b26856e140845b8e08aacb7449df25d076c';

abstract class _$AvailableClubTables
    extends BuildlessAutoDisposeAsyncNotifier<List<ClubTable>> {
  late final String clubId;
  late final DateTime date;
  late final String timeSlot;
  late final int guestCount;

  FutureOr<List<ClubTable>> build({
    required String clubId,
    required DateTime date,
    required String timeSlot,
    required int guestCount,
  });
}

/// See also [AvailableClubTables].
@ProviderFor(AvailableClubTables)
const availableClubTablesProvider = AvailableClubTablesFamily();

/// See also [AvailableClubTables].
class AvailableClubTablesFamily extends Family<AsyncValue<List<ClubTable>>> {
  /// See also [AvailableClubTables].
  const AvailableClubTablesFamily();

  /// See also [AvailableClubTables].
  AvailableClubTablesProvider call({
    required String clubId,
    required DateTime date,
    required String timeSlot,
    required int guestCount,
  }) {
    return AvailableClubTablesProvider(
      clubId: clubId,
      date: date,
      timeSlot: timeSlot,
      guestCount: guestCount,
    );
  }

  @override
  AvailableClubTablesProvider getProviderOverride(
    covariant AvailableClubTablesProvider provider,
  ) {
    return call(
      clubId: provider.clubId,
      date: provider.date,
      timeSlot: provider.timeSlot,
      guestCount: provider.guestCount,
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
  String? get name => r'availableClubTablesProvider';
}

/// See also [AvailableClubTables].
class AvailableClubTablesProvider extends AutoDisposeAsyncNotifierProviderImpl<
    AvailableClubTables, List<ClubTable>> {
  /// See also [AvailableClubTables].
  AvailableClubTablesProvider({
    required String clubId,
    required DateTime date,
    required String timeSlot,
    required int guestCount,
  }) : this._internal(
          () => AvailableClubTables()
            ..clubId = clubId
            ..date = date
            ..timeSlot = timeSlot
            ..guestCount = guestCount,
          from: availableClubTablesProvider,
          name: r'availableClubTablesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$availableClubTablesHash,
          dependencies: AvailableClubTablesFamily._dependencies,
          allTransitiveDependencies:
              AvailableClubTablesFamily._allTransitiveDependencies,
          clubId: clubId,
          date: date,
          timeSlot: timeSlot,
          guestCount: guestCount,
        );

  AvailableClubTablesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.clubId,
    required this.date,
    required this.timeSlot,
    required this.guestCount,
  }) : super.internal();

  final String clubId;
  final DateTime date;
  final String timeSlot;
  final int guestCount;

  @override
  FutureOr<List<ClubTable>> runNotifierBuild(
    covariant AvailableClubTables notifier,
  ) {
    return notifier.build(
      clubId: clubId,
      date: date,
      timeSlot: timeSlot,
      guestCount: guestCount,
    );
  }

  @override
  Override overrideWith(AvailableClubTables Function() create) {
    return ProviderOverride(
      origin: this,
      override: AvailableClubTablesProvider._internal(
        () => create()
          ..clubId = clubId
          ..date = date
          ..timeSlot = timeSlot
          ..guestCount = guestCount,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        clubId: clubId,
        date: date,
        timeSlot: timeSlot,
        guestCount: guestCount,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<AvailableClubTables, List<ClubTable>>
      createElement() {
    return _AvailableClubTablesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AvailableClubTablesProvider &&
        other.clubId == clubId &&
        other.date == date &&
        other.timeSlot == timeSlot &&
        other.guestCount == guestCount;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, clubId.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);
    hash = _SystemHash.combine(hash, timeSlot.hashCode);
    hash = _SystemHash.combine(hash, guestCount.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AvailableClubTablesRef
    on AutoDisposeAsyncNotifierProviderRef<List<ClubTable>> {
  /// The parameter `clubId` of this provider.
  String get clubId;

  /// The parameter `date` of this provider.
  DateTime get date;

  /// The parameter `timeSlot` of this provider.
  String get timeSlot;

  /// The parameter `guestCount` of this provider.
  int get guestCount;
}

class _AvailableClubTablesProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<AvailableClubTables,
        List<ClubTable>> with AvailableClubTablesRef {
  _AvailableClubTablesProviderElement(super.provider);

  @override
  String get clubId => (origin as AvailableClubTablesProvider).clubId;
  @override
  DateTime get date => (origin as AvailableClubTablesProvider).date;
  @override
  String get timeSlot => (origin as AvailableClubTablesProvider).timeSlot;
  @override
  int get guestCount => (origin as AvailableClubTablesProvider).guestCount;
}

String _$clubBottlesHash() => r'871b03e2fadb49602ea92fa537eec6b1eaa5fcbd';

abstract class _$ClubBottles
    extends BuildlessAutoDisposeAsyncNotifier<List<Bottle>> {
  late final String clubId;

  FutureOr<List<Bottle>> build(
    String clubId,
  );
}

/// See also [ClubBottles].
@ProviderFor(ClubBottles)
const clubBottlesProvider = ClubBottlesFamily();

/// See also [ClubBottles].
class ClubBottlesFamily extends Family<AsyncValue<List<Bottle>>> {
  /// See also [ClubBottles].
  const ClubBottlesFamily();

  /// See also [ClubBottles].
  ClubBottlesProvider call(
    String clubId,
  ) {
    return ClubBottlesProvider(
      clubId,
    );
  }

  @override
  ClubBottlesProvider getProviderOverride(
    covariant ClubBottlesProvider provider,
  ) {
    return call(
      provider.clubId,
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
  String? get name => r'clubBottlesProvider';
}

/// See also [ClubBottles].
class ClubBottlesProvider
    extends AutoDisposeAsyncNotifierProviderImpl<ClubBottles, List<Bottle>> {
  /// See also [ClubBottles].
  ClubBottlesProvider(
    String clubId,
  ) : this._internal(
          () => ClubBottles()..clubId = clubId,
          from: clubBottlesProvider,
          name: r'clubBottlesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$clubBottlesHash,
          dependencies: ClubBottlesFamily._dependencies,
          allTransitiveDependencies:
              ClubBottlesFamily._allTransitiveDependencies,
          clubId: clubId,
        );

  ClubBottlesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.clubId,
  }) : super.internal();

  final String clubId;

  @override
  FutureOr<List<Bottle>> runNotifierBuild(
    covariant ClubBottles notifier,
  ) {
    return notifier.build(
      clubId,
    );
  }

  @override
  Override overrideWith(ClubBottles Function() create) {
    return ProviderOverride(
      origin: this,
      override: ClubBottlesProvider._internal(
        () => create()..clubId = clubId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        clubId: clubId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ClubBottles, List<Bottle>>
      createElement() {
    return _ClubBottlesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ClubBottlesProvider && other.clubId == clubId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, clubId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ClubBottlesRef on AutoDisposeAsyncNotifierProviderRef<List<Bottle>> {
  /// The parameter `clubId` of this provider.
  String get clubId;
}

class _ClubBottlesProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ClubBottles, List<Bottle>>
    with ClubBottlesRef {
  _ClubBottlesProviderElement(super.provider);

  @override
  String get clubId => (origin as ClubBottlesProvider).clubId;
}

String _$featuredClubBottlesHash() =>
    r'2e3e3a37fa2214def8c0835d0c09e7a2894cf74a';

abstract class _$FeaturedClubBottles
    extends BuildlessAutoDisposeAsyncNotifier<List<Bottle>> {
  late final String clubId;

  FutureOr<List<Bottle>> build(
    String clubId,
  );
}

/// See also [FeaturedClubBottles].
@ProviderFor(FeaturedClubBottles)
const featuredClubBottlesProvider = FeaturedClubBottlesFamily();

/// See also [FeaturedClubBottles].
class FeaturedClubBottlesFamily extends Family<AsyncValue<List<Bottle>>> {
  /// See also [FeaturedClubBottles].
  const FeaturedClubBottlesFamily();

  /// See also [FeaturedClubBottles].
  FeaturedClubBottlesProvider call(
    String clubId,
  ) {
    return FeaturedClubBottlesProvider(
      clubId,
    );
  }

  @override
  FeaturedClubBottlesProvider getProviderOverride(
    covariant FeaturedClubBottlesProvider provider,
  ) {
    return call(
      provider.clubId,
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
  String? get name => r'featuredClubBottlesProvider';
}

/// See also [FeaturedClubBottles].
class FeaturedClubBottlesProvider extends AutoDisposeAsyncNotifierProviderImpl<
    FeaturedClubBottles, List<Bottle>> {
  /// See also [FeaturedClubBottles].
  FeaturedClubBottlesProvider(
    String clubId,
  ) : this._internal(
          () => FeaturedClubBottles()..clubId = clubId,
          from: featuredClubBottlesProvider,
          name: r'featuredClubBottlesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$featuredClubBottlesHash,
          dependencies: FeaturedClubBottlesFamily._dependencies,
          allTransitiveDependencies:
              FeaturedClubBottlesFamily._allTransitiveDependencies,
          clubId: clubId,
        );

  FeaturedClubBottlesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.clubId,
  }) : super.internal();

  final String clubId;

  @override
  FutureOr<List<Bottle>> runNotifierBuild(
    covariant FeaturedClubBottles notifier,
  ) {
    return notifier.build(
      clubId,
    );
  }

  @override
  Override overrideWith(FeaturedClubBottles Function() create) {
    return ProviderOverride(
      origin: this,
      override: FeaturedClubBottlesProvider._internal(
        () => create()..clubId = clubId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        clubId: clubId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<FeaturedClubBottles, List<Bottle>>
      createElement() {
    return _FeaturedClubBottlesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FeaturedClubBottlesProvider && other.clubId == clubId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, clubId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FeaturedClubBottlesRef
    on AutoDisposeAsyncNotifierProviderRef<List<Bottle>> {
  /// The parameter `clubId` of this provider.
  String get clubId;
}

class _FeaturedClubBottlesProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<FeaturedClubBottles,
        List<Bottle>> with FeaturedClubBottlesRef {
  _FeaturedClubBottlesProviderElement(super.provider);

  @override
  String get clubId => (origin as FeaturedClubBottlesProvider).clubId;
}

String _$clubAmenitiesHash() => r'6e5825ef45168900d3348ad4b7c3ebc519a758ba';

abstract class _$ClubAmenities
    extends BuildlessAutoDisposeAsyncNotifier<List<ClubAmenity>> {
  late final String clubId;

  FutureOr<List<ClubAmenity>> build(
    String clubId,
  );
}

/// See also [ClubAmenities].
@ProviderFor(ClubAmenities)
const clubAmenitiesProvider = ClubAmenitiesFamily();

/// See also [ClubAmenities].
class ClubAmenitiesFamily extends Family<AsyncValue<List<ClubAmenity>>> {
  /// See also [ClubAmenities].
  const ClubAmenitiesFamily();

  /// See also [ClubAmenities].
  ClubAmenitiesProvider call(
    String clubId,
  ) {
    return ClubAmenitiesProvider(
      clubId,
    );
  }

  @override
  ClubAmenitiesProvider getProviderOverride(
    covariant ClubAmenitiesProvider provider,
  ) {
    return call(
      provider.clubId,
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
  String? get name => r'clubAmenitiesProvider';
}

/// See also [ClubAmenities].
class ClubAmenitiesProvider extends AutoDisposeAsyncNotifierProviderImpl<
    ClubAmenities, List<ClubAmenity>> {
  /// See also [ClubAmenities].
  ClubAmenitiesProvider(
    String clubId,
  ) : this._internal(
          () => ClubAmenities()..clubId = clubId,
          from: clubAmenitiesProvider,
          name: r'clubAmenitiesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$clubAmenitiesHash,
          dependencies: ClubAmenitiesFamily._dependencies,
          allTransitiveDependencies:
              ClubAmenitiesFamily._allTransitiveDependencies,
          clubId: clubId,
        );

  ClubAmenitiesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.clubId,
  }) : super.internal();

  final String clubId;

  @override
  FutureOr<List<ClubAmenity>> runNotifierBuild(
    covariant ClubAmenities notifier,
  ) {
    return notifier.build(
      clubId,
    );
  }

  @override
  Override overrideWith(ClubAmenities Function() create) {
    return ProviderOverride(
      origin: this,
      override: ClubAmenitiesProvider._internal(
        () => create()..clubId = clubId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        clubId: clubId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ClubAmenities, List<ClubAmenity>>
      createElement() {
    return _ClubAmenitiesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ClubAmenitiesProvider && other.clubId == clubId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, clubId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ClubAmenitiesRef
    on AutoDisposeAsyncNotifierProviderRef<List<ClubAmenity>> {
  /// The parameter `clubId` of this provider.
  String get clubId;
}

class _ClubAmenitiesProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ClubAmenities,
        List<ClubAmenity>> with ClubAmenitiesRef {
  _ClubAmenitiesProviderElement(super.provider);

  @override
  String get clubId => (origin as ClubAmenitiesProvider).clubId;
}

String _$clubHoursDataHash() => r'9f4f68ca71b40bf13d9b62bcdf45c9b04c88efbc';

abstract class _$ClubHoursData
    extends BuildlessAutoDisposeAsyncNotifier<List<ClubHours>> {
  late final String clubId;

  FutureOr<List<ClubHours>> build(
    String clubId,
  );
}

/// See also [ClubHoursData].
@ProviderFor(ClubHoursData)
const clubHoursDataProvider = ClubHoursDataFamily();

/// See also [ClubHoursData].
class ClubHoursDataFamily extends Family<AsyncValue<List<ClubHours>>> {
  /// See also [ClubHoursData].
  const ClubHoursDataFamily();

  /// See also [ClubHoursData].
  ClubHoursDataProvider call(
    String clubId,
  ) {
    return ClubHoursDataProvider(
      clubId,
    );
  }

  @override
  ClubHoursDataProvider getProviderOverride(
    covariant ClubHoursDataProvider provider,
  ) {
    return call(
      provider.clubId,
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
  String? get name => r'clubHoursDataProvider';
}

/// See also [ClubHoursData].
class ClubHoursDataProvider extends AutoDisposeAsyncNotifierProviderImpl<
    ClubHoursData, List<ClubHours>> {
  /// See also [ClubHoursData].
  ClubHoursDataProvider(
    String clubId,
  ) : this._internal(
          () => ClubHoursData()..clubId = clubId,
          from: clubHoursDataProvider,
          name: r'clubHoursDataProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$clubHoursDataHash,
          dependencies: ClubHoursDataFamily._dependencies,
          allTransitiveDependencies:
              ClubHoursDataFamily._allTransitiveDependencies,
          clubId: clubId,
        );

  ClubHoursDataProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.clubId,
  }) : super.internal();

  final String clubId;

  @override
  FutureOr<List<ClubHours>> runNotifierBuild(
    covariant ClubHoursData notifier,
  ) {
    return notifier.build(
      clubId,
    );
  }

  @override
  Override overrideWith(ClubHoursData Function() create) {
    return ProviderOverride(
      origin: this,
      override: ClubHoursDataProvider._internal(
        () => create()..clubId = clubId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        clubId: clubId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ClubHoursData, List<ClubHours>>
      createElement() {
    return _ClubHoursDataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ClubHoursDataProvider && other.clubId == clubId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, clubId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ClubHoursDataRef on AutoDisposeAsyncNotifierProviderRef<List<ClubHours>> {
  /// The parameter `clubId` of this provider.
  String get clubId;
}

class _ClubHoursDataProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ClubHoursData,
        List<ClubHours>> with ClubHoursDataRef {
  _ClubHoursDataProviderElement(super.provider);

  @override
  String get clubId => (origin as ClubHoursDataProvider).clubId;
}

String _$availableTimeSlotsHash() =>
    r'd48537614c2427b287325d81eeb42b24d135f1b5';

abstract class _$AvailableTimeSlots
    extends BuildlessAutoDisposeAsyncNotifier<List<String>> {
  late final String clubId;
  late final DateTime date;
  late final int guestCount;

  FutureOr<List<String>> build({
    required String clubId,
    required DateTime date,
    required int guestCount,
  });
}

/// See also [AvailableTimeSlots].
@ProviderFor(AvailableTimeSlots)
const availableTimeSlotsProvider = AvailableTimeSlotsFamily();

/// See also [AvailableTimeSlots].
class AvailableTimeSlotsFamily extends Family<AsyncValue<List<String>>> {
  /// See also [AvailableTimeSlots].
  const AvailableTimeSlotsFamily();

  /// See also [AvailableTimeSlots].
  AvailableTimeSlotsProvider call({
    required String clubId,
    required DateTime date,
    required int guestCount,
  }) {
    return AvailableTimeSlotsProvider(
      clubId: clubId,
      date: date,
      guestCount: guestCount,
    );
  }

  @override
  AvailableTimeSlotsProvider getProviderOverride(
    covariant AvailableTimeSlotsProvider provider,
  ) {
    return call(
      clubId: provider.clubId,
      date: provider.date,
      guestCount: provider.guestCount,
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
  String? get name => r'availableTimeSlotsProvider';
}

/// See also [AvailableTimeSlots].
class AvailableTimeSlotsProvider extends AutoDisposeAsyncNotifierProviderImpl<
    AvailableTimeSlots, List<String>> {
  /// See also [AvailableTimeSlots].
  AvailableTimeSlotsProvider({
    required String clubId,
    required DateTime date,
    required int guestCount,
  }) : this._internal(
          () => AvailableTimeSlots()
            ..clubId = clubId
            ..date = date
            ..guestCount = guestCount,
          from: availableTimeSlotsProvider,
          name: r'availableTimeSlotsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$availableTimeSlotsHash,
          dependencies: AvailableTimeSlotsFamily._dependencies,
          allTransitiveDependencies:
              AvailableTimeSlotsFamily._allTransitiveDependencies,
          clubId: clubId,
          date: date,
          guestCount: guestCount,
        );

  AvailableTimeSlotsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.clubId,
    required this.date,
    required this.guestCount,
  }) : super.internal();

  final String clubId;
  final DateTime date;
  final int guestCount;

  @override
  FutureOr<List<String>> runNotifierBuild(
    covariant AvailableTimeSlots notifier,
  ) {
    return notifier.build(
      clubId: clubId,
      date: date,
      guestCount: guestCount,
    );
  }

  @override
  Override overrideWith(AvailableTimeSlots Function() create) {
    return ProviderOverride(
      origin: this,
      override: AvailableTimeSlotsProvider._internal(
        () => create()
          ..clubId = clubId
          ..date = date
          ..guestCount = guestCount,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        clubId: clubId,
        date: date,
        guestCount: guestCount,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<AvailableTimeSlots, List<String>>
      createElement() {
    return _AvailableTimeSlotsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AvailableTimeSlotsProvider &&
        other.clubId == clubId &&
        other.date == date &&
        other.guestCount == guestCount;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, clubId.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);
    hash = _SystemHash.combine(hash, guestCount.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AvailableTimeSlotsRef
    on AutoDisposeAsyncNotifierProviderRef<List<String>> {
  /// The parameter `clubId` of this provider.
  String get clubId;

  /// The parameter `date` of this provider.
  DateTime get date;

  /// The parameter `guestCount` of this provider.
  int get guestCount;
}

class _AvailableTimeSlotsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<AvailableTimeSlots,
        List<String>> with AvailableTimeSlotsRef {
  _AvailableTimeSlotsProviderElement(super.provider);

  @override
  String get clubId => (origin as AvailableTimeSlotsProvider).clubId;
  @override
  DateTime get date => (origin as AvailableTimeSlotsProvider).date;
  @override
  int get guestCount => (origin as AvailableTimeSlotsProvider).guestCount;
}

String _$bookingValidatorHash() => r'0616dd4c27f34eba4db90308d4380e3857ee9311';

abstract class _$BookingValidator
    extends BuildlessAutoDisposeAsyncNotifier<bool> {
  late final String clubId;
  late final DateTime date;
  late final String timeSlot;
  late final int guestCount;
  late final String? tableId;

  FutureOr<bool> build({
    required String clubId,
    required DateTime date,
    required String timeSlot,
    required int guestCount,
    String? tableId,
  });
}

/// See also [BookingValidator].
@ProviderFor(BookingValidator)
const bookingValidatorProvider = BookingValidatorFamily();

/// See also [BookingValidator].
class BookingValidatorFamily extends Family<AsyncValue<bool>> {
  /// See also [BookingValidator].
  const BookingValidatorFamily();

  /// See also [BookingValidator].
  BookingValidatorProvider call({
    required String clubId,
    required DateTime date,
    required String timeSlot,
    required int guestCount,
    String? tableId,
  }) {
    return BookingValidatorProvider(
      clubId: clubId,
      date: date,
      timeSlot: timeSlot,
      guestCount: guestCount,
      tableId: tableId,
    );
  }

  @override
  BookingValidatorProvider getProviderOverride(
    covariant BookingValidatorProvider provider,
  ) {
    return call(
      clubId: provider.clubId,
      date: provider.date,
      timeSlot: provider.timeSlot,
      guestCount: provider.guestCount,
      tableId: provider.tableId,
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
  String? get name => r'bookingValidatorProvider';
}

/// See also [BookingValidator].
class BookingValidatorProvider
    extends AutoDisposeAsyncNotifierProviderImpl<BookingValidator, bool> {
  /// See also [BookingValidator].
  BookingValidatorProvider({
    required String clubId,
    required DateTime date,
    required String timeSlot,
    required int guestCount,
    String? tableId,
  }) : this._internal(
          () => BookingValidator()
            ..clubId = clubId
            ..date = date
            ..timeSlot = timeSlot
            ..guestCount = guestCount
            ..tableId = tableId,
          from: bookingValidatorProvider,
          name: r'bookingValidatorProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$bookingValidatorHash,
          dependencies: BookingValidatorFamily._dependencies,
          allTransitiveDependencies:
              BookingValidatorFamily._allTransitiveDependencies,
          clubId: clubId,
          date: date,
          timeSlot: timeSlot,
          guestCount: guestCount,
          tableId: tableId,
        );

  BookingValidatorProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.clubId,
    required this.date,
    required this.timeSlot,
    required this.guestCount,
    required this.tableId,
  }) : super.internal();

  final String clubId;
  final DateTime date;
  final String timeSlot;
  final int guestCount;
  final String? tableId;

  @override
  FutureOr<bool> runNotifierBuild(
    covariant BookingValidator notifier,
  ) {
    return notifier.build(
      clubId: clubId,
      date: date,
      timeSlot: timeSlot,
      guestCount: guestCount,
      tableId: tableId,
    );
  }

  @override
  Override overrideWith(BookingValidator Function() create) {
    return ProviderOverride(
      origin: this,
      override: BookingValidatorProvider._internal(
        () => create()
          ..clubId = clubId
          ..date = date
          ..timeSlot = timeSlot
          ..guestCount = guestCount
          ..tableId = tableId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        clubId: clubId,
        date: date,
        timeSlot: timeSlot,
        guestCount: guestCount,
        tableId: tableId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<BookingValidator, bool>
      createElement() {
    return _BookingValidatorProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BookingValidatorProvider &&
        other.clubId == clubId &&
        other.date == date &&
        other.timeSlot == timeSlot &&
        other.guestCount == guestCount &&
        other.tableId == tableId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, clubId.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);
    hash = _SystemHash.combine(hash, timeSlot.hashCode);
    hash = _SystemHash.combine(hash, guestCount.hashCode);
    hash = _SystemHash.combine(hash, tableId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin BookingValidatorRef on AutoDisposeAsyncNotifierProviderRef<bool> {
  /// The parameter `clubId` of this provider.
  String get clubId;

  /// The parameter `date` of this provider.
  DateTime get date;

  /// The parameter `timeSlot` of this provider.
  String get timeSlot;

  /// The parameter `guestCount` of this provider.
  int get guestCount;

  /// The parameter `tableId` of this provider.
  String? get tableId;
}

class _BookingValidatorProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<BookingValidator, bool>
    with BookingValidatorRef {
  _BookingValidatorProviderElement(super.provider);

  @override
  String get clubId => (origin as BookingValidatorProvider).clubId;
  @override
  DateTime get date => (origin as BookingValidatorProvider).date;
  @override
  String get timeSlot => (origin as BookingValidatorProvider).timeSlot;
  @override
  int get guestCount => (origin as BookingValidatorProvider).guestCount;
  @override
  String? get tableId => (origin as BookingValidatorProvider).tableId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
