// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$eventPollsHash() => r'a129d931541e94d90a4a078f91c9bd9d1de8bedd';

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

abstract class _$EventPolls
    extends BuildlessAutoDisposeAsyncNotifier<List<EventPoll>> {
  late final String eventId;

  FutureOr<List<EventPoll>> build(
    String eventId,
  );
}

/// See also [EventPolls].
@ProviderFor(EventPolls)
const eventPollsProvider = EventPollsFamily();

/// See also [EventPolls].
class EventPollsFamily extends Family<AsyncValue<List<EventPoll>>> {
  /// See also [EventPolls].
  const EventPollsFamily();

  /// See also [EventPolls].
  EventPollsProvider call(
    String eventId,
  ) {
    return EventPollsProvider(
      eventId,
    );
  }

  @override
  EventPollsProvider getProviderOverride(
    covariant EventPollsProvider provider,
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
  String? get name => r'eventPollsProvider';
}

/// See also [EventPolls].
class EventPollsProvider
    extends AutoDisposeAsyncNotifierProviderImpl<EventPolls, List<EventPoll>> {
  /// See also [EventPolls].
  EventPollsProvider(
    String eventId,
  ) : this._internal(
          () => EventPolls()..eventId = eventId,
          from: eventPollsProvider,
          name: r'eventPollsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$eventPollsHash,
          dependencies: EventPollsFamily._dependencies,
          allTransitiveDependencies:
              EventPollsFamily._allTransitiveDependencies,
          eventId: eventId,
        );

  EventPollsProvider._internal(
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
  FutureOr<List<EventPoll>> runNotifierBuild(
    covariant EventPolls notifier,
  ) {
    return notifier.build(
      eventId,
    );
  }

  @override
  Override overrideWith(EventPolls Function() create) {
    return ProviderOverride(
      origin: this,
      override: EventPollsProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<EventPolls, List<EventPoll>>
      createElement() {
    return _EventPollsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EventPollsProvider && other.eventId == eventId;
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
mixin EventPollsRef on AutoDisposeAsyncNotifierProviderRef<List<EventPoll>> {
  /// The parameter `eventId` of this provider.
  String get eventId;
}

class _EventPollsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<EventPolls, List<EventPoll>>
    with EventPollsRef {
  _EventPollsProviderElement(super.provider);

  @override
  String get eventId => (origin as EventPollsProvider).eventId;
}

String _$pollDetailHash() => r'ef14575f3ab6d06a8a504bd74d6aaed86e74ccdc';

abstract class _$PollDetail
    extends BuildlessAutoDisposeAsyncNotifier<EventPoll> {
  late final String pollId;

  FutureOr<EventPoll> build(
    String pollId,
  );
}

/// See also [PollDetail].
@ProviderFor(PollDetail)
const pollDetailProvider = PollDetailFamily();

/// See also [PollDetail].
class PollDetailFamily extends Family<AsyncValue<EventPoll>> {
  /// See also [PollDetail].
  const PollDetailFamily();

  /// See also [PollDetail].
  PollDetailProvider call(
    String pollId,
  ) {
    return PollDetailProvider(
      pollId,
    );
  }

  @override
  PollDetailProvider getProviderOverride(
    covariant PollDetailProvider provider,
  ) {
    return call(
      provider.pollId,
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
  String? get name => r'pollDetailProvider';
}

/// See also [PollDetail].
class PollDetailProvider
    extends AutoDisposeAsyncNotifierProviderImpl<PollDetail, EventPoll> {
  /// See also [PollDetail].
  PollDetailProvider(
    String pollId,
  ) : this._internal(
          () => PollDetail()..pollId = pollId,
          from: pollDetailProvider,
          name: r'pollDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$pollDetailHash,
          dependencies: PollDetailFamily._dependencies,
          allTransitiveDependencies:
              PollDetailFamily._allTransitiveDependencies,
          pollId: pollId,
        );

  PollDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.pollId,
  }) : super.internal();

  final String pollId;

  @override
  FutureOr<EventPoll> runNotifierBuild(
    covariant PollDetail notifier,
  ) {
    return notifier.build(
      pollId,
    );
  }

  @override
  Override overrideWith(PollDetail Function() create) {
    return ProviderOverride(
      origin: this,
      override: PollDetailProvider._internal(
        () => create()..pollId = pollId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        pollId: pollId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<PollDetail, EventPoll>
      createElement() {
    return _PollDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PollDetailProvider && other.pollId == pollId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pollId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PollDetailRef on AutoDisposeAsyncNotifierProviderRef<EventPoll> {
  /// The parameter `pollId` of this provider.
  String get pollId;
}

class _PollDetailProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<PollDetail, EventPoll>
    with PollDetailRef {
  _PollDetailProviderElement(super.provider);

  @override
  String get pollId => (origin as PollDetailProvider).pollId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
