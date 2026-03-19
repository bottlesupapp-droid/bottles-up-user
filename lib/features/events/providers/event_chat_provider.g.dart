// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$eventChatMessagesHash() => r'2839f4e9d1cf2c3bbb02122463c4f27e7925c668';

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

abstract class _$EventChatMessages
    extends BuildlessAutoDisposeAsyncNotifier<List<EventChatMessage>> {
  late final String eventId;

  FutureOr<List<EventChatMessage>> build(
    String eventId,
  );
}

/// See also [EventChatMessages].
@ProviderFor(EventChatMessages)
const eventChatMessagesProvider = EventChatMessagesFamily();

/// See also [EventChatMessages].
class EventChatMessagesFamily
    extends Family<AsyncValue<List<EventChatMessage>>> {
  /// See also [EventChatMessages].
  const EventChatMessagesFamily();

  /// See also [EventChatMessages].
  EventChatMessagesProvider call(
    String eventId,
  ) {
    return EventChatMessagesProvider(
      eventId,
    );
  }

  @override
  EventChatMessagesProvider getProviderOverride(
    covariant EventChatMessagesProvider provider,
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
  String? get name => r'eventChatMessagesProvider';
}

/// See also [EventChatMessages].
class EventChatMessagesProvider extends AutoDisposeAsyncNotifierProviderImpl<
    EventChatMessages, List<EventChatMessage>> {
  /// See also [EventChatMessages].
  EventChatMessagesProvider(
    String eventId,
  ) : this._internal(
          () => EventChatMessages()..eventId = eventId,
          from: eventChatMessagesProvider,
          name: r'eventChatMessagesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$eventChatMessagesHash,
          dependencies: EventChatMessagesFamily._dependencies,
          allTransitiveDependencies:
              EventChatMessagesFamily._allTransitiveDependencies,
          eventId: eventId,
        );

  EventChatMessagesProvider._internal(
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
  FutureOr<List<EventChatMessage>> runNotifierBuild(
    covariant EventChatMessages notifier,
  ) {
    return notifier.build(
      eventId,
    );
  }

  @override
  Override overrideWith(EventChatMessages Function() create) {
    return ProviderOverride(
      origin: this,
      override: EventChatMessagesProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<EventChatMessages,
      List<EventChatMessage>> createElement() {
    return _EventChatMessagesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EventChatMessagesProvider && other.eventId == eventId;
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
mixin EventChatMessagesRef
    on AutoDisposeAsyncNotifierProviderRef<List<EventChatMessage>> {
  /// The parameter `eventId` of this provider.
  String get eventId;
}

class _EventChatMessagesProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<EventChatMessages,
        List<EventChatMessage>> with EventChatMessagesRef {
  _EventChatMessagesProviderElement(super.provider);

  @override
  String get eventId => (origin as EventChatMessagesProvider).eventId;
}

String _$pinnedMessagesHash() => r'2d22200cebef99b1d35114e721a0f2c5bee4e61d';

abstract class _$PinnedMessages
    extends BuildlessAutoDisposeAsyncNotifier<List<EventChatMessage>> {
  late final String eventId;

  FutureOr<List<EventChatMessage>> build(
    String eventId,
  );
}

/// See also [PinnedMessages].
@ProviderFor(PinnedMessages)
const pinnedMessagesProvider = PinnedMessagesFamily();

/// See also [PinnedMessages].
class PinnedMessagesFamily extends Family<AsyncValue<List<EventChatMessage>>> {
  /// See also [PinnedMessages].
  const PinnedMessagesFamily();

  /// See also [PinnedMessages].
  PinnedMessagesProvider call(
    String eventId,
  ) {
    return PinnedMessagesProvider(
      eventId,
    );
  }

  @override
  PinnedMessagesProvider getProviderOverride(
    covariant PinnedMessagesProvider provider,
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
  String? get name => r'pinnedMessagesProvider';
}

/// See also [PinnedMessages].
class PinnedMessagesProvider extends AutoDisposeAsyncNotifierProviderImpl<
    PinnedMessages, List<EventChatMessage>> {
  /// See also [PinnedMessages].
  PinnedMessagesProvider(
    String eventId,
  ) : this._internal(
          () => PinnedMessages()..eventId = eventId,
          from: pinnedMessagesProvider,
          name: r'pinnedMessagesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$pinnedMessagesHash,
          dependencies: PinnedMessagesFamily._dependencies,
          allTransitiveDependencies:
              PinnedMessagesFamily._allTransitiveDependencies,
          eventId: eventId,
        );

  PinnedMessagesProvider._internal(
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
  FutureOr<List<EventChatMessage>> runNotifierBuild(
    covariant PinnedMessages notifier,
  ) {
    return notifier.build(
      eventId,
    );
  }

  @override
  Override overrideWith(PinnedMessages Function() create) {
    return ProviderOverride(
      origin: this,
      override: PinnedMessagesProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<PinnedMessages,
      List<EventChatMessage>> createElement() {
    return _PinnedMessagesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PinnedMessagesProvider && other.eventId == eventId;
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
mixin PinnedMessagesRef
    on AutoDisposeAsyncNotifierProviderRef<List<EventChatMessage>> {
  /// The parameter `eventId` of this provider.
  String get eventId;
}

class _PinnedMessagesProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<PinnedMessages,
        List<EventChatMessage>> with PinnedMessagesRef {
  _PinnedMessagesProviderElement(super.provider);

  @override
  String get eventId => (origin as PinnedMessagesProvider).eventId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
