// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$eventAnnouncementsHash() =>
    r'1336269fc65001889c2475fdcb53560c81961f60';

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

abstract class _$EventAnnouncements
    extends BuildlessAutoDisposeAsyncNotifier<List<Announcement>> {
  late final String eventId;

  FutureOr<List<Announcement>> build(
    String eventId,
  );
}

/// See also [EventAnnouncements].
@ProviderFor(EventAnnouncements)
const eventAnnouncementsProvider = EventAnnouncementsFamily();

/// See also [EventAnnouncements].
class EventAnnouncementsFamily extends Family<AsyncValue<List<Announcement>>> {
  /// See also [EventAnnouncements].
  const EventAnnouncementsFamily();

  /// See also [EventAnnouncements].
  EventAnnouncementsProvider call(
    String eventId,
  ) {
    return EventAnnouncementsProvider(
      eventId,
    );
  }

  @override
  EventAnnouncementsProvider getProviderOverride(
    covariant EventAnnouncementsProvider provider,
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
  String? get name => r'eventAnnouncementsProvider';
}

/// See also [EventAnnouncements].
class EventAnnouncementsProvider extends AutoDisposeAsyncNotifierProviderImpl<
    EventAnnouncements, List<Announcement>> {
  /// See also [EventAnnouncements].
  EventAnnouncementsProvider(
    String eventId,
  ) : this._internal(
          () => EventAnnouncements()..eventId = eventId,
          from: eventAnnouncementsProvider,
          name: r'eventAnnouncementsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$eventAnnouncementsHash,
          dependencies: EventAnnouncementsFamily._dependencies,
          allTransitiveDependencies:
              EventAnnouncementsFamily._allTransitiveDependencies,
          eventId: eventId,
        );

  EventAnnouncementsProvider._internal(
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
  FutureOr<List<Announcement>> runNotifierBuild(
    covariant EventAnnouncements notifier,
  ) {
    return notifier.build(
      eventId,
    );
  }

  @override
  Override overrideWith(EventAnnouncements Function() create) {
    return ProviderOverride(
      origin: this,
      override: EventAnnouncementsProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<EventAnnouncements,
      List<Announcement>> createElement() {
    return _EventAnnouncementsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EventAnnouncementsProvider && other.eventId == eventId;
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
mixin EventAnnouncementsRef
    on AutoDisposeAsyncNotifierProviderRef<List<Announcement>> {
  /// The parameter `eventId` of this provider.
  String get eventId;
}

class _EventAnnouncementsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<EventAnnouncements,
        List<Announcement>> with EventAnnouncementsRef {
  _EventAnnouncementsProviderElement(super.provider);

  @override
  String get eventId => (origin as EventAnnouncementsProvider).eventId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
