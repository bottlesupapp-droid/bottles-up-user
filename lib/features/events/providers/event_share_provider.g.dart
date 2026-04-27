// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_share_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$eventShareLinkHash() => r'27d187f958caa74a1e67824c9fc346ba9dae8f22';

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

/// See also [eventShareLink].
@ProviderFor(eventShareLink)
const eventShareLinkProvider = EventShareLinkFamily();

/// See also [eventShareLink].
class EventShareLinkFamily extends Family<AsyncValue<EventShare>> {
  /// See also [eventShareLink].
  const EventShareLinkFamily();

  /// See also [eventShareLink].
  EventShareLinkProvider call(
    String eventId,
  ) {
    return EventShareLinkProvider(
      eventId,
    );
  }

  @override
  EventShareLinkProvider getProviderOverride(
    covariant EventShareLinkProvider provider,
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
  String? get name => r'eventShareLinkProvider';
}

/// See also [eventShareLink].
class EventShareLinkProvider extends AutoDisposeFutureProvider<EventShare> {
  /// See also [eventShareLink].
  EventShareLinkProvider(
    String eventId,
  ) : this._internal(
          (ref) => eventShareLink(
            ref as EventShareLinkRef,
            eventId,
          ),
          from: eventShareLinkProvider,
          name: r'eventShareLinkProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$eventShareLinkHash,
          dependencies: EventShareLinkFamily._dependencies,
          allTransitiveDependencies:
              EventShareLinkFamily._allTransitiveDependencies,
          eventId: eventId,
        );

  EventShareLinkProvider._internal(
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
    FutureOr<EventShare> Function(EventShareLinkRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: EventShareLinkProvider._internal(
        (ref) => create(ref as EventShareLinkRef),
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
  AutoDisposeFutureProviderElement<EventShare> createElement() {
    return _EventShareLinkProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EventShareLinkProvider && other.eventId == eventId;
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
mixin EventShareLinkRef on AutoDisposeFutureProviderRef<EventShare> {
  /// The parameter `eventId` of this provider.
  String get eventId;
}

class _EventShareLinkProviderElement
    extends AutoDisposeFutureProviderElement<EventShare>
    with EventShareLinkRef {
  _EventShareLinkProviderElement(super.provider);

  @override
  String get eventId => (origin as EventShareLinkProvider).eventId;
}

String _$eventSharesHash() => r'b68529d8acede5af65ad83e37e80b9e7f4957e0e';

/// See also [eventShares].
@ProviderFor(eventShares)
const eventSharesProvider = EventSharesFamily();

/// See also [eventShares].
class EventSharesFamily extends Family<AsyncValue<List<EventShare>>> {
  /// See also [eventShares].
  const EventSharesFamily();

  /// See also [eventShares].
  EventSharesProvider call(
    String eventId,
  ) {
    return EventSharesProvider(
      eventId,
    );
  }

  @override
  EventSharesProvider getProviderOverride(
    covariant EventSharesProvider provider,
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
  String? get name => r'eventSharesProvider';
}

/// See also [eventShares].
class EventSharesProvider extends AutoDisposeFutureProvider<List<EventShare>> {
  /// See also [eventShares].
  EventSharesProvider(
    String eventId,
  ) : this._internal(
          (ref) => eventShares(
            ref as EventSharesRef,
            eventId,
          ),
          from: eventSharesProvider,
          name: r'eventSharesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$eventSharesHash,
          dependencies: EventSharesFamily._dependencies,
          allTransitiveDependencies:
              EventSharesFamily._allTransitiveDependencies,
          eventId: eventId,
        );

  EventSharesProvider._internal(
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
    FutureOr<List<EventShare>> Function(EventSharesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: EventSharesProvider._internal(
        (ref) => create(ref as EventSharesRef),
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
  AutoDisposeFutureProviderElement<List<EventShare>> createElement() {
    return _EventSharesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EventSharesProvider && other.eventId == eventId;
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
mixin EventSharesRef on AutoDisposeFutureProviderRef<List<EventShare>> {
  /// The parameter `eventId` of this provider.
  String get eventId;
}

class _EventSharesProviderElement
    extends AutoDisposeFutureProviderElement<List<EventShare>>
    with EventSharesRef {
  _EventSharesProviderElement(super.provider);

  @override
  String get eventId => (origin as EventSharesProvider).eventId;
}

String _$eventShareAnalyticsNotifierHash() =>
    r'9164c9c9b13e8fd7545d373f3af80d0f03db72db';

abstract class _$EventShareAnalyticsNotifier
    extends BuildlessAutoDisposeAsyncNotifier<ShareAnalytics> {
  late final String eventId;

  FutureOr<ShareAnalytics> build(
    String eventId,
  );
}

/// See also [EventShareAnalyticsNotifier].
@ProviderFor(EventShareAnalyticsNotifier)
const eventShareAnalyticsNotifierProvider = EventShareAnalyticsNotifierFamily();

/// See also [EventShareAnalyticsNotifier].
class EventShareAnalyticsNotifierFamily
    extends Family<AsyncValue<ShareAnalytics>> {
  /// See also [EventShareAnalyticsNotifier].
  const EventShareAnalyticsNotifierFamily();

  /// See also [EventShareAnalyticsNotifier].
  EventShareAnalyticsNotifierProvider call(
    String eventId,
  ) {
    return EventShareAnalyticsNotifierProvider(
      eventId,
    );
  }

  @override
  EventShareAnalyticsNotifierProvider getProviderOverride(
    covariant EventShareAnalyticsNotifierProvider provider,
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
  String? get name => r'eventShareAnalyticsNotifierProvider';
}

/// See also [EventShareAnalyticsNotifier].
class EventShareAnalyticsNotifierProvider
    extends AutoDisposeAsyncNotifierProviderImpl<EventShareAnalyticsNotifier,
        ShareAnalytics> {
  /// See also [EventShareAnalyticsNotifier].
  EventShareAnalyticsNotifierProvider(
    String eventId,
  ) : this._internal(
          () => EventShareAnalyticsNotifier()..eventId = eventId,
          from: eventShareAnalyticsNotifierProvider,
          name: r'eventShareAnalyticsNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$eventShareAnalyticsNotifierHash,
          dependencies: EventShareAnalyticsNotifierFamily._dependencies,
          allTransitiveDependencies:
              EventShareAnalyticsNotifierFamily._allTransitiveDependencies,
          eventId: eventId,
        );

  EventShareAnalyticsNotifierProvider._internal(
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
  FutureOr<ShareAnalytics> runNotifierBuild(
    covariant EventShareAnalyticsNotifier notifier,
  ) {
    return notifier.build(
      eventId,
    );
  }

  @override
  Override overrideWith(EventShareAnalyticsNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: EventShareAnalyticsNotifierProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<EventShareAnalyticsNotifier,
      ShareAnalytics> createElement() {
    return _EventShareAnalyticsNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EventShareAnalyticsNotifierProvider &&
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
mixin EventShareAnalyticsNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<ShareAnalytics> {
  /// The parameter `eventId` of this provider.
  String get eventId;
}

class _EventShareAnalyticsNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<EventShareAnalyticsNotifier,
        ShareAnalytics> with EventShareAnalyticsNotifierRef {
  _EventShareAnalyticsNotifierProviderElement(super.provider);

  @override
  String get eventId => (origin as EventShareAnalyticsNotifierProvider).eventId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
