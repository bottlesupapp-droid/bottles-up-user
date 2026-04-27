// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cohost_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isEventCohostHash() => r'd0fe19602ae2cc0a41eee4ea7c1bea1c9598d61b';

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

/// See also [isEventCohost].
@ProviderFor(isEventCohost)
const isEventCohostProvider = IsEventCohostFamily();

/// See also [isEventCohost].
class IsEventCohostFamily extends Family<AsyncValue<bool>> {
  /// See also [isEventCohost].
  const IsEventCohostFamily();

  /// See also [isEventCohost].
  IsEventCohostProvider call(
    String eventId,
  ) {
    return IsEventCohostProvider(
      eventId,
    );
  }

  @override
  IsEventCohostProvider getProviderOverride(
    covariant IsEventCohostProvider provider,
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
  String? get name => r'isEventCohostProvider';
}

/// See also [isEventCohost].
class IsEventCohostProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [isEventCohost].
  IsEventCohostProvider(
    String eventId,
  ) : this._internal(
          (ref) => isEventCohost(
            ref as IsEventCohostRef,
            eventId,
          ),
          from: isEventCohostProvider,
          name: r'isEventCohostProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$isEventCohostHash,
          dependencies: IsEventCohostFamily._dependencies,
          allTransitiveDependencies:
              IsEventCohostFamily._allTransitiveDependencies,
          eventId: eventId,
        );

  IsEventCohostProvider._internal(
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
    FutureOr<bool> Function(IsEventCohostRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IsEventCohostProvider._internal(
        (ref) => create(ref as IsEventCohostRef),
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
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _IsEventCohostProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IsEventCohostProvider && other.eventId == eventId;
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
mixin IsEventCohostRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `eventId` of this provider.
  String get eventId;
}

class _IsEventCohostProviderElement
    extends AutoDisposeFutureProviderElement<bool> with IsEventCohostRef {
  _IsEventCohostProviderElement(super.provider);

  @override
  String get eventId => (origin as IsEventCohostProvider).eventId;
}

String _$hasCohostPermissionHash() =>
    r'a316c1f0b76b77e3cfe4f3ad43f8fcebc268156e';

/// See also [hasCohostPermission].
@ProviderFor(hasCohostPermission)
const hasCohostPermissionProvider = HasCohostPermissionFamily();

/// See also [hasCohostPermission].
class HasCohostPermissionFamily extends Family<AsyncValue<bool>> {
  /// See also [hasCohostPermission].
  const HasCohostPermissionFamily();

  /// See also [hasCohostPermission].
  HasCohostPermissionProvider call(
    String eventId,
    CohostPermission permission,
  ) {
    return HasCohostPermissionProvider(
      eventId,
      permission,
    );
  }

  @override
  HasCohostPermissionProvider getProviderOverride(
    covariant HasCohostPermissionProvider provider,
  ) {
    return call(
      provider.eventId,
      provider.permission,
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
  String? get name => r'hasCohostPermissionProvider';
}

/// See also [hasCohostPermission].
class HasCohostPermissionProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [hasCohostPermission].
  HasCohostPermissionProvider(
    String eventId,
    CohostPermission permission,
  ) : this._internal(
          (ref) => hasCohostPermission(
            ref as HasCohostPermissionRef,
            eventId,
            permission,
          ),
          from: hasCohostPermissionProvider,
          name: r'hasCohostPermissionProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$hasCohostPermissionHash,
          dependencies: HasCohostPermissionFamily._dependencies,
          allTransitiveDependencies:
              HasCohostPermissionFamily._allTransitiveDependencies,
          eventId: eventId,
          permission: permission,
        );

  HasCohostPermissionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.eventId,
    required this.permission,
  }) : super.internal();

  final String eventId;
  final CohostPermission permission;

  @override
  Override overrideWith(
    FutureOr<bool> Function(HasCohostPermissionRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HasCohostPermissionProvider._internal(
        (ref) => create(ref as HasCohostPermissionRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        eventId: eventId,
        permission: permission,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _HasCohostPermissionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HasCohostPermissionProvider &&
        other.eventId == eventId &&
        other.permission == permission;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, eventId.hashCode);
    hash = _SystemHash.combine(hash, permission.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HasCohostPermissionRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `eventId` of this provider.
  String get eventId;

  /// The parameter `permission` of this provider.
  CohostPermission get permission;
}

class _HasCohostPermissionProviderElement
    extends AutoDisposeFutureProviderElement<bool> with HasCohostPermissionRef {
  _HasCohostPermissionProviderElement(super.provider);

  @override
  String get eventId => (origin as HasCohostPermissionProvider).eventId;
  @override
  CohostPermission get permission =>
      (origin as HasCohostPermissionProvider).permission;
}

String _$myCohostDetailsHash() => r'0ad1392341445ed02216d55e5e165b9b9424690c';

/// See also [myCohostDetails].
@ProviderFor(myCohostDetails)
const myCohostDetailsProvider = MyCohostDetailsFamily();

/// See also [myCohostDetails].
class MyCohostDetailsFamily extends Family<AsyncValue<EventCohost?>> {
  /// See also [myCohostDetails].
  const MyCohostDetailsFamily();

  /// See also [myCohostDetails].
  MyCohostDetailsProvider call(
    String eventId,
  ) {
    return MyCohostDetailsProvider(
      eventId,
    );
  }

  @override
  MyCohostDetailsProvider getProviderOverride(
    covariant MyCohostDetailsProvider provider,
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
  String? get name => r'myCohostDetailsProvider';
}

/// See also [myCohostDetails].
class MyCohostDetailsProvider extends AutoDisposeFutureProvider<EventCohost?> {
  /// See also [myCohostDetails].
  MyCohostDetailsProvider(
    String eventId,
  ) : this._internal(
          (ref) => myCohostDetails(
            ref as MyCohostDetailsRef,
            eventId,
          ),
          from: myCohostDetailsProvider,
          name: r'myCohostDetailsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$myCohostDetailsHash,
          dependencies: MyCohostDetailsFamily._dependencies,
          allTransitiveDependencies:
              MyCohostDetailsFamily._allTransitiveDependencies,
          eventId: eventId,
        );

  MyCohostDetailsProvider._internal(
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
    FutureOr<EventCohost?> Function(MyCohostDetailsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MyCohostDetailsProvider._internal(
        (ref) => create(ref as MyCohostDetailsRef),
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
  AutoDisposeFutureProviderElement<EventCohost?> createElement() {
    return _MyCohostDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MyCohostDetailsProvider && other.eventId == eventId;
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
mixin MyCohostDetailsRef on AutoDisposeFutureProviderRef<EventCohost?> {
  /// The parameter `eventId` of this provider.
  String get eventId;
}

class _MyCohostDetailsProviderElement
    extends AutoDisposeFutureProviderElement<EventCohost?>
    with MyCohostDetailsRef {
  _MyCohostDetailsProviderElement(super.provider);

  @override
  String get eventId => (origin as MyCohostDetailsProvider).eventId;
}

String _$eventCohostsHash() => r'dadac10cfec4943017edac93c2b9c8c34023039c';

abstract class _$EventCohosts
    extends BuildlessAutoDisposeAsyncNotifier<List<EventCohost>> {
  late final String eventId;

  FutureOr<List<EventCohost>> build(
    String eventId,
  );
}

/// See also [EventCohosts].
@ProviderFor(EventCohosts)
const eventCohostsProvider = EventCohostsFamily();

/// See also [EventCohosts].
class EventCohostsFamily extends Family<AsyncValue<List<EventCohost>>> {
  /// See also [EventCohosts].
  const EventCohostsFamily();

  /// See also [EventCohosts].
  EventCohostsProvider call(
    String eventId,
  ) {
    return EventCohostsProvider(
      eventId,
    );
  }

  @override
  EventCohostsProvider getProviderOverride(
    covariant EventCohostsProvider provider,
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
  String? get name => r'eventCohostsProvider';
}

/// See also [EventCohosts].
class EventCohostsProvider extends AutoDisposeAsyncNotifierProviderImpl<
    EventCohosts, List<EventCohost>> {
  /// See also [EventCohosts].
  EventCohostsProvider(
    String eventId,
  ) : this._internal(
          () => EventCohosts()..eventId = eventId,
          from: eventCohostsProvider,
          name: r'eventCohostsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$eventCohostsHash,
          dependencies: EventCohostsFamily._dependencies,
          allTransitiveDependencies:
              EventCohostsFamily._allTransitiveDependencies,
          eventId: eventId,
        );

  EventCohostsProvider._internal(
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
  FutureOr<List<EventCohost>> runNotifierBuild(
    covariant EventCohosts notifier,
  ) {
    return notifier.build(
      eventId,
    );
  }

  @override
  Override overrideWith(EventCohosts Function() create) {
    return ProviderOverride(
      origin: this,
      override: EventCohostsProvider._internal(
        () => create()..eventId = eventId,
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
  AutoDisposeAsyncNotifierProviderElement<EventCohosts, List<EventCohost>>
      createElement() {
    return _EventCohostsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EventCohostsProvider && other.eventId == eventId;
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
mixin EventCohostsRef
    on AutoDisposeAsyncNotifierProviderRef<List<EventCohost>> {
  /// The parameter `eventId` of this provider.
  String get eventId;
}

class _EventCohostsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<EventCohosts,
        List<EventCohost>> with EventCohostsRef {
  _EventCohostsProviderElement(super.provider);

  @override
  String get eventId => (origin as EventCohostsProvider).eventId;
}

String _$myPendingCohostInvitationsHash() =>
    r'0e86bc05d2ea7f81545a988e42b029b1a585c4ef';

/// See also [MyPendingCohostInvitations].
@ProviderFor(MyPendingCohostInvitations)
final myPendingCohostInvitationsProvider = AutoDisposeAsyncNotifierProvider<
    MyPendingCohostInvitations, List<EventCohost>>.internal(
  MyPendingCohostInvitations.new,
  name: r'myPendingCohostInvitationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$myPendingCohostInvitationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MyPendingCohostInvitations
    = AutoDisposeAsyncNotifier<List<EventCohost>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
