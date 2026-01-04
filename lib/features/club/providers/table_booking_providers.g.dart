// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_booking_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tableBookingServiceHash() =>
    r'67ae047e1b024d00df5e87b973fda6c136e5903c';

/// See also [tableBookingService].
@ProviderFor(tableBookingService)
final tableBookingServiceProvider =
    AutoDisposeProvider<TableBookingService>.internal(
  tableBookingService,
  name: r'tableBookingServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tableBookingServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TableBookingServiceRef = AutoDisposeProviderRef<TableBookingService>;
String _$clubBookingDetailsHash() =>
    r'd2951ea812e186b017314393529420b293241651';

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

abstract class _$ClubBookingDetails
    extends BuildlessAutoDisposeAsyncNotifier<Club?> {
  late final String clubId;

  FutureOr<Club?> build(
    String clubId,
  );
}

/// See also [ClubBookingDetails].
@ProviderFor(ClubBookingDetails)
const clubBookingDetailsProvider = ClubBookingDetailsFamily();

/// See also [ClubBookingDetails].
class ClubBookingDetailsFamily extends Family<AsyncValue<Club?>> {
  /// See also [ClubBookingDetails].
  const ClubBookingDetailsFamily();

  /// See also [ClubBookingDetails].
  ClubBookingDetailsProvider call(
    String clubId,
  ) {
    return ClubBookingDetailsProvider(
      clubId,
    );
  }

  @override
  ClubBookingDetailsProvider getProviderOverride(
    covariant ClubBookingDetailsProvider provider,
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
  String? get name => r'clubBookingDetailsProvider';
}

/// See also [ClubBookingDetails].
class ClubBookingDetailsProvider
    extends AutoDisposeAsyncNotifierProviderImpl<ClubBookingDetails, Club?> {
  /// See also [ClubBookingDetails].
  ClubBookingDetailsProvider(
    String clubId,
  ) : this._internal(
          () => ClubBookingDetails()..clubId = clubId,
          from: clubBookingDetailsProvider,
          name: r'clubBookingDetailsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$clubBookingDetailsHash,
          dependencies: ClubBookingDetailsFamily._dependencies,
          allTransitiveDependencies:
              ClubBookingDetailsFamily._allTransitiveDependencies,
          clubId: clubId,
        );

  ClubBookingDetailsProvider._internal(
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
  FutureOr<Club?> runNotifierBuild(
    covariant ClubBookingDetails notifier,
  ) {
    return notifier.build(
      clubId,
    );
  }

  @override
  Override overrideWith(ClubBookingDetails Function() create) {
    return ProviderOverride(
      origin: this,
      override: ClubBookingDetailsProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<ClubBookingDetails, Club?>
      createElement() {
    return _ClubBookingDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ClubBookingDetailsProvider && other.clubId == clubId;
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
mixin ClubBookingDetailsRef on AutoDisposeAsyncNotifierProviderRef<Club?> {
  /// The parameter `clubId` of this provider.
  String get clubId;
}

class _ClubBookingDetailsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ClubBookingDetails, Club?>
    with ClubBookingDetailsRef {
  _ClubBookingDetailsProviderElement(super.provider);

  @override
  String get clubId => (origin as ClubBookingDetailsProvider).clubId;
}

String _$availableTimeSlotsHash() =>
    r'462bb1de58372c906ffe35ace378b7ce88343309';

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

String _$availableTablesHash() => r'7c06f0bc1ef319c646db419d6c89d35607709976';

abstract class _$AvailableTables
    extends BuildlessAutoDisposeAsyncNotifier<List<Map<String, dynamic>>> {
  late final String clubId;
  late final DateTime date;
  late final String timeSlot;
  late final int guestCount;

  FutureOr<List<Map<String, dynamic>>> build({
    required String clubId,
    required DateTime date,
    required String timeSlot,
    required int guestCount,
  });
}

/// See also [AvailableTables].
@ProviderFor(AvailableTables)
const availableTablesProvider = AvailableTablesFamily();

/// See also [AvailableTables].
class AvailableTablesFamily
    extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// See also [AvailableTables].
  const AvailableTablesFamily();

  /// See also [AvailableTables].
  AvailableTablesProvider call({
    required String clubId,
    required DateTime date,
    required String timeSlot,
    required int guestCount,
  }) {
    return AvailableTablesProvider(
      clubId: clubId,
      date: date,
      timeSlot: timeSlot,
      guestCount: guestCount,
    );
  }

  @override
  AvailableTablesProvider getProviderOverride(
    covariant AvailableTablesProvider provider,
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
  String? get name => r'availableTablesProvider';
}

/// See also [AvailableTables].
class AvailableTablesProvider extends AutoDisposeAsyncNotifierProviderImpl<
    AvailableTables, List<Map<String, dynamic>>> {
  /// See also [AvailableTables].
  AvailableTablesProvider({
    required String clubId,
    required DateTime date,
    required String timeSlot,
    required int guestCount,
  }) : this._internal(
          () => AvailableTables()
            ..clubId = clubId
            ..date = date
            ..timeSlot = timeSlot
            ..guestCount = guestCount,
          from: availableTablesProvider,
          name: r'availableTablesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$availableTablesHash,
          dependencies: AvailableTablesFamily._dependencies,
          allTransitiveDependencies:
              AvailableTablesFamily._allTransitiveDependencies,
          clubId: clubId,
          date: date,
          timeSlot: timeSlot,
          guestCount: guestCount,
        );

  AvailableTablesProvider._internal(
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
  FutureOr<List<Map<String, dynamic>>> runNotifierBuild(
    covariant AvailableTables notifier,
  ) {
    return notifier.build(
      clubId: clubId,
      date: date,
      timeSlot: timeSlot,
      guestCount: guestCount,
    );
  }

  @override
  Override overrideWith(AvailableTables Function() create) {
    return ProviderOverride(
      origin: this,
      override: AvailableTablesProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<AvailableTables,
      List<Map<String, dynamic>>> createElement() {
    return _AvailableTablesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AvailableTablesProvider &&
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
mixin AvailableTablesRef
    on AutoDisposeAsyncNotifierProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `clubId` of this provider.
  String get clubId;

  /// The parameter `date` of this provider.
  DateTime get date;

  /// The parameter `timeSlot` of this provider.
  String get timeSlot;

  /// The parameter `guestCount` of this provider.
  int get guestCount;
}

class _AvailableTablesProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<AvailableTables,
        List<Map<String, dynamic>>> with AvailableTablesRef {
  _AvailableTablesProviderElement(super.provider);

  @override
  String get clubId => (origin as AvailableTablesProvider).clubId;
  @override
  DateTime get date => (origin as AvailableTablesProvider).date;
  @override
  String get timeSlot => (origin as AvailableTablesProvider).timeSlot;
  @override
  int get guestCount => (origin as AvailableTablesProvider).guestCount;
}

String _$bookingValidatorHash() => r'b048298b2a20a53868d679fcf0268421d3c116f6';

abstract class _$BookingValidator
    extends BuildlessAutoDisposeAsyncNotifier<bool> {
  late final String clubId;
  late final DateTime date;
  late final String timeSlot;
  late final int guestCount;

  FutureOr<bool> build({
    required String clubId,
    required DateTime date,
    required String timeSlot,
    required int guestCount,
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
  }) {
    return BookingValidatorProvider(
      clubId: clubId,
      date: date,
      timeSlot: timeSlot,
      guestCount: guestCount,
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
  }) : this._internal(
          () => BookingValidator()
            ..clubId = clubId
            ..date = date
            ..timeSlot = timeSlot
            ..guestCount = guestCount,
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
  }) : super.internal();

  final String clubId;
  final DateTime date;
  final String timeSlot;
  final int guestCount;

  @override
  FutureOr<bool> runNotifierBuild(
    covariant BookingValidator notifier,
  ) {
    return notifier.build(
      clubId: clubId,
      date: date,
      timeSlot: timeSlot,
      guestCount: guestCount,
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
mixin BookingValidatorRef on AutoDisposeAsyncNotifierProviderRef<bool> {
  /// The parameter `clubId` of this provider.
  String get clubId;

  /// The parameter `date` of this provider.
  DateTime get date;

  /// The parameter `timeSlot` of this provider.
  String get timeSlot;

  /// The parameter `guestCount` of this provider.
  int get guestCount;
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
}

String _$userBookingsHash() => r'f02cea3db053c7c8c659b49ee81ded1a02e37ef2';

/// See also [UserBookings].
@ProviderFor(UserBookings)
final userBookingsProvider =
    AutoDisposeAsyncNotifierProvider<UserBookings, List<TableBooking>>.internal(
  UserBookings.new,
  name: r'userBookingsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userBookingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UserBookings = AutoDisposeAsyncNotifier<List<TableBooking>>;
String _$bookingCreatorHash() => r'6629c5c9e23a0fe4707c6e328ba65a233cf31859';

/// See also [BookingCreator].
@ProviderFor(BookingCreator)
final bookingCreatorProvider = AutoDisposeNotifierProvider<BookingCreator,
    AsyncValue<TableBooking?>>.internal(
  BookingCreator.new,
  name: r'bookingCreatorProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$bookingCreatorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BookingCreator = AutoDisposeNotifier<AsyncValue<TableBooking?>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
