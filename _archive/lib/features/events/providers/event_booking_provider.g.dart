// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_booking_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$eventConfigurationHash() =>
    r'76f752019d2f0f76b398f261eb1044b73f290a9b';

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

/// See also [eventConfiguration].
@ProviderFor(eventConfiguration)
const eventConfigurationProvider = EventConfigurationFamily();

/// See also [eventConfiguration].
class EventConfigurationFamily extends Family<AsyncValue<EventConfiguration?>> {
  /// See also [eventConfiguration].
  const EventConfigurationFamily();

  /// See also [eventConfiguration].
  EventConfigurationProvider call(
    String eventId,
  ) {
    return EventConfigurationProvider(
      eventId,
    );
  }

  @override
  EventConfigurationProvider getProviderOverride(
    covariant EventConfigurationProvider provider,
  ) {
    return call(
      provider.eventId,
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
  String? get name => r'eventConfigurationProvider';
}

/// See also [eventConfiguration].
class EventConfigurationProvider
    extends AutoDisposeFutureProvider<EventConfiguration?> {
  /// See also [eventConfiguration].
  EventConfigurationProvider(
    String eventId,
  ) : this._internal(
          (ref) => eventConfiguration(
            ref as EventConfigurationRef,
            eventId,
          ),
          from: eventConfigurationProvider,
          name: r'eventConfigurationProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$eventConfigurationHash,
          dependencies: EventConfigurationFamily._dependencies,
          allTransitiveDependencies:
              EventConfigurationFamily._allTransitiveDependencies,
          eventId: eventId,
        );

  EventConfigurationProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.eventId,
  }) : super.internal();

  final String eventId;

  @override
  Override overrideWith(
    FutureOr<EventConfiguration?> Function(EventConfigurationRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: EventConfigurationProvider._internal(
        (ref) => create(ref as EventConfigurationRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        eventId: eventId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<EventConfiguration?> createElement() {
    return _EventConfigurationProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EventConfigurationProvider && other.eventId == eventId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, eventId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin EventConfigurationRef
    on AutoDisposeFutureProviderRef<EventConfiguration?> {
  /// The parameter `eventId` of this provider.
  String get eventId;
}

class _EventConfigurationProviderElement
    extends AutoDisposeFutureProviderElement<EventConfiguration?>
    with EventConfigurationRef {
  _EventConfigurationProviderElement(super.provider);

  @override
  String get eventId => (origin as EventConfigurationProvider).eventId;
}

String _$availableTablesHash() => r'6759e515c0026a55d273f8b8fdcdca32a85d056b';

/// See also [availableTables].
@ProviderFor(availableTables)
const availableTablesProvider = AvailableTablesFamily();

/// See also [availableTables].
class AvailableTablesFamily
    extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// See also [availableTables].
  const AvailableTablesFamily();

  /// See also [availableTables].
  AvailableTablesProvider call(
    String eventId,
  ) {
    return AvailableTablesProvider(
      eventId,
    );
  }

  @override
  AvailableTablesProvider getProviderOverride(
    covariant AvailableTablesProvider provider,
  ) {
    return call(
      provider.eventId,
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

/// See also [availableTables].
class AvailableTablesProvider
    extends AutoDisposeFutureProvider<List<Map<String, dynamic>>> {
  /// See also [availableTables].
  AvailableTablesProvider(
    String eventId,
  ) : this._internal(
          (ref) => availableTables(
            ref as AvailableTablesRef,
            eventId,
          ),
          from: availableTablesProvider,
          name: r'availableTablesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$availableTablesHash,
          dependencies: AvailableTablesFamily._dependencies,
          allTransitiveDependencies:
              AvailableTablesFamily._allTransitiveDependencies,
          eventId: eventId,
        );

  AvailableTablesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.eventId,
  }) : super.internal();

  final String eventId;

  @override
  Override overrideWith(
    FutureOr<List<Map<String, dynamic>>> Function(AvailableTablesRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AvailableTablesProvider._internal(
        (ref) => create(ref as AvailableTablesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        eventId: eventId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Map<String, dynamic>>> createElement() {
    return _AvailableTablesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AvailableTablesProvider && other.eventId == eventId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, eventId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AvailableTablesRef
    on AutoDisposeFutureProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `eventId` of this provider.
  String get eventId;
}

class _AvailableTablesProviderElement
    extends AutoDisposeFutureProviderElement<List<Map<String, dynamic>>>
    with AvailableTablesRef {
  _AvailableTablesProviderElement(super.provider);

  @override
  String get eventId => (origin as AvailableTablesProvider).eventId;
}

String _$availableBottlesHash() => r'0470c8b873eb1aa4eb07eb8fd85ca669f2e20dd3';

/// See also [availableBottles].
@ProviderFor(availableBottles)
const availableBottlesProvider = AvailableBottlesFamily();

/// See also [availableBottles].
class AvailableBottlesFamily
    extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// See also [availableBottles].
  const AvailableBottlesFamily();

  /// See also [availableBottles].
  AvailableBottlesProvider call(
    String eventId,
  ) {
    return AvailableBottlesProvider(
      eventId,
    );
  }

  @override
  AvailableBottlesProvider getProviderOverride(
    covariant AvailableBottlesProvider provider,
  ) {
    return call(
      provider.eventId,
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
  String? get name => r'availableBottlesProvider';
}

/// See also [availableBottles].
class AvailableBottlesProvider
    extends AutoDisposeFutureProvider<List<Map<String, dynamic>>> {
  /// See also [availableBottles].
  AvailableBottlesProvider(
    String eventId,
  ) : this._internal(
          (ref) => availableBottles(
            ref as AvailableBottlesRef,
            eventId,
          ),
          from: availableBottlesProvider,
          name: r'availableBottlesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$availableBottlesHash,
          dependencies: AvailableBottlesFamily._dependencies,
          allTransitiveDependencies:
              AvailableBottlesFamily._allTransitiveDependencies,
          eventId: eventId,
        );

  AvailableBottlesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.eventId,
  }) : super.internal();

  final String eventId;

  @override
  Override overrideWith(
    FutureOr<List<Map<String, dynamic>>> Function(AvailableBottlesRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AvailableBottlesProvider._internal(
        (ref) => create(ref as AvailableBottlesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        eventId: eventId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Map<String, dynamic>>> createElement() {
    return _AvailableBottlesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AvailableBottlesProvider && other.eventId == eventId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, eventId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AvailableBottlesRef
    on AutoDisposeFutureProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `eventId` of this provider.
  String get eventId;
}

class _AvailableBottlesProviderElement
    extends AutoDisposeFutureProviderElement<List<Map<String, dynamic>>>
    with AvailableBottlesRef {
  _AvailableBottlesProviderElement(super.provider);

  @override
  String get eventId => (origin as AvailableBottlesProvider).eventId;
}

String _$userEventRSVPHash() => r'4b659af56dfc0c7ae64156ce6a0107951d2bf11b';

/// See also [userEventRSVP].
@ProviderFor(userEventRSVP)
const userEventRSVPProvider = UserEventRSVPFamily();

/// See also [userEventRSVP].
class UserEventRSVPFamily extends Family<AsyncValue<EventRSVP?>> {
  /// See also [userEventRSVP].
  const UserEventRSVPFamily();

  /// See also [userEventRSVP].
  UserEventRSVPProvider call(
    String eventId,
  ) {
    return UserEventRSVPProvider(
      eventId,
    );
  }

  @override
  UserEventRSVPProvider getProviderOverride(
    covariant UserEventRSVPProvider provider,
  ) {
    return call(
      provider.eventId,
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
  String? get name => r'userEventRSVPProvider';
}

/// See also [userEventRSVP].
class UserEventRSVPProvider extends AutoDisposeFutureProvider<EventRSVP?> {
  /// See also [userEventRSVP].
  UserEventRSVPProvider(
    String eventId,
  ) : this._internal(
          (ref) => userEventRSVP(
            ref as UserEventRSVPRef,
            eventId,
          ),
          from: userEventRSVPProvider,
          name: r'userEventRSVPProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userEventRSVPHash,
          dependencies: UserEventRSVPFamily._dependencies,
          allTransitiveDependencies:
              UserEventRSVPFamily._allTransitiveDependencies,
          eventId: eventId,
        );

  UserEventRSVPProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.eventId,
  }) : super.internal();

  final String eventId;

  @override
  Override overrideWith(
    FutureOr<EventRSVP?> Function(UserEventRSVPRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserEventRSVPProvider._internal(
        (ref) => create(ref as UserEventRSVPRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        eventId: eventId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<EventRSVP?> createElement() {
    return _UserEventRSVPProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserEventRSVPProvider && other.eventId == eventId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, eventId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserEventRSVPRef on AutoDisposeFutureProviderRef<EventRSVP?> {
  /// The parameter `eventId` of this provider.
  String get eventId;
}

class _UserEventRSVPProviderElement
    extends AutoDisposeFutureProviderElement<EventRSVP?> with UserEventRSVPRef {
  _UserEventRSVPProviderElement(super.provider);

  @override
  String get eventId => (origin as UserEventRSVPProvider).eventId;
}

String _$userEventTableBookingHash() =>
    r'72913504739e278ee04baa0faaba873ce63bbf30';

/// See also [userEventTableBooking].
@ProviderFor(userEventTableBooking)
const userEventTableBookingProvider = UserEventTableBookingFamily();

/// See also [userEventTableBooking].
class UserEventTableBookingFamily
    extends Family<AsyncValue<EventTableBooking?>> {
  /// See also [userEventTableBooking].
  const UserEventTableBookingFamily();

  /// See also [userEventTableBooking].
  UserEventTableBookingProvider call(
    String eventId,
  ) {
    return UserEventTableBookingProvider(
      eventId,
    );
  }

  @override
  UserEventTableBookingProvider getProviderOverride(
    covariant UserEventTableBookingProvider provider,
  ) {
    return call(
      provider.eventId,
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
  String? get name => r'userEventTableBookingProvider';
}

/// See also [userEventTableBooking].
class UserEventTableBookingProvider
    extends AutoDisposeFutureProvider<EventTableBooking?> {
  /// See also [userEventTableBooking].
  UserEventTableBookingProvider(
    String eventId,
  ) : this._internal(
          (ref) => userEventTableBooking(
            ref as UserEventTableBookingRef,
            eventId,
          ),
          from: userEventTableBookingProvider,
          name: r'userEventTableBookingProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userEventTableBookingHash,
          dependencies: UserEventTableBookingFamily._dependencies,
          allTransitiveDependencies:
              UserEventTableBookingFamily._allTransitiveDependencies,
          eventId: eventId,
        );

  UserEventTableBookingProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.eventId,
  }) : super.internal();

  final String eventId;

  @override
  Override overrideWith(
    FutureOr<EventTableBooking?> Function(UserEventTableBookingRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserEventTableBookingProvider._internal(
        (ref) => create(ref as UserEventTableBookingRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        eventId: eventId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<EventTableBooking?> createElement() {
    return _UserEventTableBookingProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserEventTableBookingProvider && other.eventId == eventId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, eventId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserEventTableBookingRef
    on AutoDisposeFutureProviderRef<EventTableBooking?> {
  /// The parameter `eventId` of this provider.
  String get eventId;
}

class _UserEventTableBookingProviderElement
    extends AutoDisposeFutureProviderElement<EventTableBooking?>
    with UserEventTableBookingRef {
  _UserEventTableBookingProviderElement(super.provider);

  @override
  String get eventId => (origin as UserEventTableBookingProvider).eventId;
}

String _$eventBookingStateHash() => r'98d5eb8b5b68a3789631a19ea46df353b9c1594d';

/// See also [EventBookingState].
@ProviderFor(EventBookingState)
final eventBookingStateProvider =
    AutoDisposeNotifierProvider<EventBookingState, BookingOption>.internal(
  EventBookingState.new,
  name: r'eventBookingStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$eventBookingStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$EventBookingState = AutoDisposeNotifier<BookingOption>;
String _$rSVPFormStateHash() => r'c2cfe4fb7c62658447d59d3a4896cbc50ada2c7b';

/// See also [RSVPFormState].
@ProviderFor(RSVPFormState)
final rSVPFormStateProvider =
    AutoDisposeNotifierProvider<RSVPFormState, RSVPFormData>.internal(
  RSVPFormState.new,
  name: r'rSVPFormStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$rSVPFormStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RSVPFormState = AutoDisposeNotifier<RSVPFormData>;
String _$tableBookingFormStateHash() =>
    r'd6a74e75c2ebe8235b025b55a73d9776827ababd';

/// See also [TableBookingFormState].
@ProviderFor(TableBookingFormState)
final tableBookingFormStateProvider = AutoDisposeNotifierProvider<
    TableBookingFormState, TableBookingFormData>.internal(
  TableBookingFormState.new,
  name: r'tableBookingFormStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tableBookingFormStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TableBookingFormState = AutoDisposeNotifier<TableBookingFormData>;
String _$rSVPSubmissionHash() => r'97ff9a7b693006afbe83eb5d1da389df063a784c';

/// See also [RSVPSubmission].
@ProviderFor(RSVPSubmission)
final rSVPSubmissionProvider = AutoDisposeNotifierProvider<RSVPSubmission,
    AsyncValue<EventRSVP?>>.internal(
  RSVPSubmission.new,
  name: r'rSVPSubmissionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$rSVPSubmissionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RSVPSubmission = AutoDisposeNotifier<AsyncValue<EventRSVP?>>;
String _$tableBookingSubmissionHash() =>
    r'0bda8577b7e492a2cbf137672f696eeed4c0d87d';

/// See also [TableBookingSubmission].
@ProviderFor(TableBookingSubmission)
final tableBookingSubmissionProvider = AutoDisposeNotifierProvider<
    TableBookingSubmission, AsyncValue<EventTableBooking?>>.internal(
  TableBookingSubmission.new,
  name: r'tableBookingSubmissionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tableBookingSubmissionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TableBookingSubmission
    = AutoDisposeNotifier<AsyncValue<EventTableBooking?>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
