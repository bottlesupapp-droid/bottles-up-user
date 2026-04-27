// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enhanced_rsvp_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$eventRsvpCountsHash() => r'36a5159b8e03f4e1a66a30578f0e53b3cf60765d';

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

abstract class _$EventRsvpCounts
    extends BuildlessAutoDisposeAsyncNotifier<RsvpCounts> {
  late final String eventId;

  FutureOr<RsvpCounts> build(
    String eventId,
  );
}

/// See also [EventRsvpCounts].
@ProviderFor(EventRsvpCounts)
const eventRsvpCountsProvider = EventRsvpCountsFamily();

/// See also [EventRsvpCounts].
class EventRsvpCountsFamily extends Family<AsyncValue<RsvpCounts>> {
  /// See also [EventRsvpCounts].
  const EventRsvpCountsFamily();

  /// See also [EventRsvpCounts].
  EventRsvpCountsProvider call(
    String eventId,
  ) {
    return EventRsvpCountsProvider(
      eventId,
    );
  }

  @override
  EventRsvpCountsProvider getProviderOverride(
    covariant EventRsvpCountsProvider provider,
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
  String? get name => r'eventRsvpCountsProvider';
}

/// See also [EventRsvpCounts].
class EventRsvpCountsProvider
    extends AutoDisposeAsyncNotifierProviderImpl<EventRsvpCounts, RsvpCounts> {
  /// See also [EventRsvpCounts].
  EventRsvpCountsProvider(
    String eventId,
  ) : this._internal(
          () => EventRsvpCounts()..eventId = eventId,
          from: eventRsvpCountsProvider,
          name: r'eventRsvpCountsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$eventRsvpCountsHash,
          dependencies: EventRsvpCountsFamily._dependencies,
          allTransitiveDependencies:
              EventRsvpCountsFamily._allTransitiveDependencies,
          eventId: eventId,
        );

  EventRsvpCountsProvider._internal(
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
  FutureOr<RsvpCounts> runNotifierBuild(
    covariant EventRsvpCounts notifier,
  ) {
    return notifier.build(
      eventId,
    );
  }

  @override
  Override overrideWith(EventRsvpCounts Function() create) {
    return ProviderOverride(
      origin: this,
      override: EventRsvpCountsProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<EventRsvpCounts, RsvpCounts>
      createElement() {
    return _EventRsvpCountsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EventRsvpCountsProvider && other.eventId == eventId;
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
mixin EventRsvpCountsRef on AutoDisposeAsyncNotifierProviderRef<RsvpCounts> {
  /// The parameter `eventId` of this provider.
  String get eventId;
}

class _EventRsvpCountsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<EventRsvpCounts, RsvpCounts>
    with EventRsvpCountsRef {
  _EventRsvpCountsProviderElement(super.provider);

  @override
  String get eventId => (origin as EventRsvpCountsProvider).eventId;
}

String _$eventRsvpListHash() => r'4cccc92694c7fa0120d2a11319dd7fb98e35b14e';

abstract class _$EventRsvpList
    extends BuildlessAutoDisposeAsyncNotifier<List<EnhancedEventRSVP>> {
  late final String eventId;

  FutureOr<List<EnhancedEventRSVP>> build(
    String eventId,
  );
}

/// See also [EventRsvpList].
@ProviderFor(EventRsvpList)
const eventRsvpListProvider = EventRsvpListFamily();

/// See also [EventRsvpList].
class EventRsvpListFamily extends Family<AsyncValue<List<EnhancedEventRSVP>>> {
  /// See also [EventRsvpList].
  const EventRsvpListFamily();

  /// See also [EventRsvpList].
  EventRsvpListProvider call(
    String eventId,
  ) {
    return EventRsvpListProvider(
      eventId,
    );
  }

  @override
  EventRsvpListProvider getProviderOverride(
    covariant EventRsvpListProvider provider,
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
  String? get name => r'eventRsvpListProvider';
}

/// See also [EventRsvpList].
class EventRsvpListProvider extends AutoDisposeAsyncNotifierProviderImpl<
    EventRsvpList, List<EnhancedEventRSVP>> {
  /// See also [EventRsvpList].
  EventRsvpListProvider(
    String eventId,
  ) : this._internal(
          () => EventRsvpList()..eventId = eventId,
          from: eventRsvpListProvider,
          name: r'eventRsvpListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$eventRsvpListHash,
          dependencies: EventRsvpListFamily._dependencies,
          allTransitiveDependencies:
              EventRsvpListFamily._allTransitiveDependencies,
          eventId: eventId,
        );

  EventRsvpListProvider._internal(
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
  FutureOr<List<EnhancedEventRSVP>> runNotifierBuild(
    covariant EventRsvpList notifier,
  ) {
    return notifier.build(
      eventId,
    );
  }

  @override
  Override overrideWith(EventRsvpList Function() create) {
    return ProviderOverride(
      origin: this,
      override: EventRsvpListProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<EventRsvpList,
      List<EnhancedEventRSVP>> createElement() {
    return _EventRsvpListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EventRsvpListProvider && other.eventId == eventId;
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
mixin EventRsvpListRef
    on AutoDisposeAsyncNotifierProviderRef<List<EnhancedEventRSVP>> {
  /// The parameter `eventId` of this provider.
  String get eventId;
}

class _EventRsvpListProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<EventRsvpList,
        List<EnhancedEventRSVP>> with EventRsvpListRef {
  _EventRsvpListProviderElement(super.provider);

  @override
  String get eventId => (origin as EventRsvpListProvider).eventId;
}

String _$myEventRsvpHash() => r'1025c7f36292f5dde7787affcd6b4a74f82f2cef';

abstract class _$MyEventRsvp
    extends BuildlessAutoDisposeAsyncNotifier<EnhancedEventRSVP?> {
  late final String eventId;

  FutureOr<EnhancedEventRSVP?> build(
    String eventId,
  );
}

/// See also [MyEventRsvp].
@ProviderFor(MyEventRsvp)
const myEventRsvpProvider = MyEventRsvpFamily();

/// See also [MyEventRsvp].
class MyEventRsvpFamily extends Family<AsyncValue<EnhancedEventRSVP?>> {
  /// See also [MyEventRsvp].
  const MyEventRsvpFamily();

  /// See also [MyEventRsvp].
  MyEventRsvpProvider call(
    String eventId,
  ) {
    return MyEventRsvpProvider(
      eventId,
    );
  }

  @override
  MyEventRsvpProvider getProviderOverride(
    covariant MyEventRsvpProvider provider,
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
  String? get name => r'myEventRsvpProvider';
}

/// See also [MyEventRsvp].
class MyEventRsvpProvider extends AutoDisposeAsyncNotifierProviderImpl<
    MyEventRsvp, EnhancedEventRSVP?> {
  /// See also [MyEventRsvp].
  MyEventRsvpProvider(
    String eventId,
  ) : this._internal(
          () => MyEventRsvp()..eventId = eventId,
          from: myEventRsvpProvider,
          name: r'myEventRsvpProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$myEventRsvpHash,
          dependencies: MyEventRsvpFamily._dependencies,
          allTransitiveDependencies:
              MyEventRsvpFamily._allTransitiveDependencies,
          eventId: eventId,
        );

  MyEventRsvpProvider._internal(
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
  FutureOr<EnhancedEventRSVP?> runNotifierBuild(
    covariant MyEventRsvp notifier,
  ) {
    return notifier.build(
      eventId,
    );
  }

  @override
  Override overrideWith(MyEventRsvp Function() create) {
    return ProviderOverride(
      origin: this,
      override: MyEventRsvpProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<MyEventRsvp, EnhancedEventRSVP?>
      createElement() {
    return _MyEventRsvpProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MyEventRsvpProvider && other.eventId == eventId;
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
mixin MyEventRsvpRef
    on AutoDisposeAsyncNotifierProviderRef<EnhancedEventRSVP?> {
  /// The parameter `eventId` of this provider.
  String get eventId;
}

class _MyEventRsvpProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<MyEventRsvp,
        EnhancedEventRSVP?> with MyEventRsvpRef {
  _MyEventRsvpProviderElement(super.provider);

  @override
  String get eventId => (origin as MyEventRsvpProvider).eventId;
}

String _$friendsAttendingEventHash() =>
    r'3d7d4652a0768239340ccff8bde01c82f9159004';

abstract class _$FriendsAttendingEvent
    extends BuildlessAutoDisposeAsyncNotifier<List<FriendAttending>> {
  late final String eventId;

  FutureOr<List<FriendAttending>> build(
    String eventId,
  );
}

/// See also [FriendsAttendingEvent].
@ProviderFor(FriendsAttendingEvent)
const friendsAttendingEventProvider = FriendsAttendingEventFamily();

/// See also [FriendsAttendingEvent].
class FriendsAttendingEventFamily
    extends Family<AsyncValue<List<FriendAttending>>> {
  /// See also [FriendsAttendingEvent].
  const FriendsAttendingEventFamily();

  /// See also [FriendsAttendingEvent].
  FriendsAttendingEventProvider call(
    String eventId,
  ) {
    return FriendsAttendingEventProvider(
      eventId,
    );
  }

  @override
  FriendsAttendingEventProvider getProviderOverride(
    covariant FriendsAttendingEventProvider provider,
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
  String? get name => r'friendsAttendingEventProvider';
}

/// See also [FriendsAttendingEvent].
class FriendsAttendingEventProvider
    extends AutoDisposeAsyncNotifierProviderImpl<FriendsAttendingEvent,
        List<FriendAttending>> {
  /// See also [FriendsAttendingEvent].
  FriendsAttendingEventProvider(
    String eventId,
  ) : this._internal(
          () => FriendsAttendingEvent()..eventId = eventId,
          from: friendsAttendingEventProvider,
          name: r'friendsAttendingEventProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$friendsAttendingEventHash,
          dependencies: FriendsAttendingEventFamily._dependencies,
          allTransitiveDependencies:
              FriendsAttendingEventFamily._allTransitiveDependencies,
          eventId: eventId,
        );

  FriendsAttendingEventProvider._internal(
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
  FutureOr<List<FriendAttending>> runNotifierBuild(
    covariant FriendsAttendingEvent notifier,
  ) {
    return notifier.build(
      eventId,
    );
  }

  @override
  Override overrideWith(FriendsAttendingEvent Function() create) {
    return ProviderOverride(
      origin: this,
      override: FriendsAttendingEventProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<FriendsAttendingEvent,
      List<FriendAttending>> createElement() {
    return _FriendsAttendingEventProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FriendsAttendingEventProvider && other.eventId == eventId;
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
mixin FriendsAttendingEventRef
    on AutoDisposeAsyncNotifierProviderRef<List<FriendAttending>> {
  /// The parameter `eventId` of this provider.
  String get eventId;
}

class _FriendsAttendingEventProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<FriendsAttendingEvent,
        List<FriendAttending>> with FriendsAttendingEventRef {
  _FriendsAttendingEventProviderElement(super.provider);

  @override
  String get eventId => (origin as FriendsAttendingEventProvider).eventId;
}

String _$eventGuestListVisibilityHash() =>
    r'0c363dca27369b218b6cc2a4d877fb0fa1e21dbb';

abstract class _$EventGuestListVisibility
    extends BuildlessAutoDisposeAsyncNotifier<GuestListVisibility> {
  late final String eventId;

  FutureOr<GuestListVisibility> build(
    String eventId,
  );
}

/// See also [EventGuestListVisibility].
@ProviderFor(EventGuestListVisibility)
const eventGuestListVisibilityProvider = EventGuestListVisibilityFamily();

/// See also [EventGuestListVisibility].
class EventGuestListVisibilityFamily
    extends Family<AsyncValue<GuestListVisibility>> {
  /// See also [EventGuestListVisibility].
  const EventGuestListVisibilityFamily();

  /// See also [EventGuestListVisibility].
  EventGuestListVisibilityProvider call(
    String eventId,
  ) {
    return EventGuestListVisibilityProvider(
      eventId,
    );
  }

  @override
  EventGuestListVisibilityProvider getProviderOverride(
    covariant EventGuestListVisibilityProvider provider,
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
  String? get name => r'eventGuestListVisibilityProvider';
}

/// See also [EventGuestListVisibility].
class EventGuestListVisibilityProvider
    extends AutoDisposeAsyncNotifierProviderImpl<EventGuestListVisibility,
        GuestListVisibility> {
  /// See also [EventGuestListVisibility].
  EventGuestListVisibilityProvider(
    String eventId,
  ) : this._internal(
          () => EventGuestListVisibility()..eventId = eventId,
          from: eventGuestListVisibilityProvider,
          name: r'eventGuestListVisibilityProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$eventGuestListVisibilityHash,
          dependencies: EventGuestListVisibilityFamily._dependencies,
          allTransitiveDependencies:
              EventGuestListVisibilityFamily._allTransitiveDependencies,
          eventId: eventId,
        );

  EventGuestListVisibilityProvider._internal(
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
  FutureOr<GuestListVisibility> runNotifierBuild(
    covariant EventGuestListVisibility notifier,
  ) {
    return notifier.build(
      eventId,
    );
  }

  @override
  Override overrideWith(EventGuestListVisibility Function() create) {
    return ProviderOverride(
      origin: this,
      override: EventGuestListVisibilityProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<EventGuestListVisibility,
      GuestListVisibility> createElement() {
    return _EventGuestListVisibilityProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EventGuestListVisibilityProvider &&
        other.eventId == eventId;
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
mixin EventGuestListVisibilityRef
    on AutoDisposeAsyncNotifierProviderRef<GuestListVisibility> {
  /// The parameter `eventId` of this provider.
  String get eventId;
}

class _EventGuestListVisibilityProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<EventGuestListVisibility,
        GuestListVisibility> with EventGuestListVisibilityRef {
  _EventGuestListVisibilityProviderElement(super.provider);

  @override
  String get eventId => (origin as EventGuestListVisibilityProvider).eventId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
