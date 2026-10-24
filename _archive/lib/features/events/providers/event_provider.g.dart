// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$eventServiceHash() => r'f1b0b6c8a5d58f9d0274862d303a875a1aad179b';

/// Provider for event service
///
/// Copied from [eventService].
@ProviderFor(eventService)
final eventServiceProvider = AutoDisposeProvider<EventService>.internal(
  eventService,
  name: r'eventServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$eventServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EventServiceRef = AutoDisposeProviderRef<EventService>;
String _$eventsHash() => r'fa50776bdf17e71175fddbf5586943fcb458e654';

/// Provider for fetching all events
///
/// Copied from [events].
@ProviderFor(events)
final eventsProvider = AutoDisposeFutureProvider<List<Event>>.internal(
  events,
  name: r'eventsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$eventsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EventsRef = AutoDisposeFutureProviderRef<List<Event>>;
String _$featuredEventsHash() => r'360eb2cd3dea7a8ceee868a1e2e5bae6bb5a092b';

/// Provider for fetching featured events
///
/// Copied from [featuredEvents].
@ProviderFor(featuredEvents)
final featuredEventsProvider = AutoDisposeFutureProvider<List<Event>>.internal(
  featuredEvents,
  name: r'featuredEventsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$featuredEventsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FeaturedEventsRef = AutoDisposeFutureProviderRef<List<Event>>;
String _$eventByIdHash() => r'026f052c8f9b44a2c273460110977996d93b9f7f';

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

/// Provider for fetching a single event by ID
///
/// Copied from [eventById].
@ProviderFor(eventById)
const eventByIdProvider = EventByIdFamily();

/// Provider for fetching a single event by ID
///
/// Copied from [eventById].
class EventByIdFamily extends Family<AsyncValue<Event>> {
  /// Provider for fetching a single event by ID
  ///
  /// Copied from [eventById].
  const EventByIdFamily();

  /// Provider for fetching a single event by ID
  ///
  /// Copied from [eventById].
  EventByIdProvider call(
    String eventId,
  ) {
    return EventByIdProvider(
      eventId,
    );
  }

  @override
  EventByIdProvider getProviderOverride(
    covariant EventByIdProvider provider,
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
  String? get name => r'eventByIdProvider';
}

/// Provider for fetching a single event by ID
///
/// Copied from [eventById].
class EventByIdProvider extends AutoDisposeFutureProvider<Event> {
  /// Provider for fetching a single event by ID
  ///
  /// Copied from [eventById].
  EventByIdProvider(
    String eventId,
  ) : this._internal(
          (ref) => eventById(
            ref as EventByIdRef,
            eventId,
          ),
          from: eventByIdProvider,
          name: r'eventByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$eventByIdHash,
          dependencies: EventByIdFamily._dependencies,
          allTransitiveDependencies: EventByIdFamily._allTransitiveDependencies,
          eventId: eventId,
        );

  EventByIdProvider._internal(
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
    FutureOr<Event> Function(EventByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: EventByIdProvider._internal(
        (ref) => create(ref as EventByIdRef),
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
  AutoDisposeFutureProviderElement<Event> createElement() {
    return _EventByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EventByIdProvider && other.eventId == eventId;
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
mixin EventByIdRef on AutoDisposeFutureProviderRef<Event> {
  /// The parameter `eventId` of this provider.
  String get eventId;
}

class _EventByIdProviderElement extends AutoDisposeFutureProviderElement<Event>
    with EventByIdRef {
  _EventByIdProviderElement(super.provider);

  @override
  String get eventId => (origin as EventByIdProvider).eventId;
}

String _$eventSearchHash() => r'4266f240d76a5de95d95d569791076e1f8b912e3';

/// Provider for searching events
///
/// Copied from [EventSearch].
@ProviderFor(EventSearch)
final eventSearchProvider =
    AutoDisposeAsyncNotifierProvider<EventSearch, List<Event>>.internal(
  EventSearch.new,
  name: r'eventSearchProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$eventSearchHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$EventSearch = AutoDisposeAsyncNotifier<List<Event>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
