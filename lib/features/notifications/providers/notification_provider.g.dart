// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$unreadNotificationCountHash() =>
    r'8508750f86c59b1228736d67d5997d157cadaa06';

/// See also [unreadNotificationCount].
@ProviderFor(unreadNotificationCount)
final unreadNotificationCountProvider = AutoDisposeFutureProvider<int>.internal(
  unreadNotificationCount,
  name: r'unreadNotificationCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$unreadNotificationCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UnreadNotificationCountRef = AutoDisposeFutureProviderRef<int>;
String _$notificationStreamHash() =>
    r'f337d5aa60e81e42ccd8badb93a7ff53ac63fba8';

/// See also [notificationStream].
@ProviderFor(notificationStream)
final notificationStreamProvider =
    AutoDisposeStreamProvider<List<AppNotification>>.internal(
  notificationStream,
  name: r'notificationStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NotificationStreamRef
    = AutoDisposeStreamProviderRef<List<AppNotification>>;
String _$unreadNotificationsHash() =>
    r'532493ff2e352b1c57d998e46d0d1c551bc8082a';

/// See also [unreadNotifications].
@ProviderFor(unreadNotifications)
final unreadNotificationsProvider =
    AutoDisposeProvider<List<AppNotification>>.internal(
  unreadNotifications,
  name: r'unreadNotificationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$unreadNotificationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UnreadNotificationsRef = AutoDisposeProviderRef<List<AppNotification>>;
String _$notificationsByTypeHash() =>
    r'e1b68db9ef007fc8126ca1efbe7b04ff990684f6';

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

/// See also [notificationsByType].
@ProviderFor(notificationsByType)
const notificationsByTypeProvider = NotificationsByTypeFamily();

/// See also [notificationsByType].
class NotificationsByTypeFamily extends Family<List<AppNotification>> {
  /// See also [notificationsByType].
  const NotificationsByTypeFamily();

  /// See also [notificationsByType].
  NotificationsByTypeProvider call(
    NotificationType type,
  ) {
    return NotificationsByTypeProvider(
      type,
    );
  }

  @override
  NotificationsByTypeProvider getProviderOverride(
    covariant NotificationsByTypeProvider provider,
  ) {
    return call(
      provider.type,
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
  String? get name => r'notificationsByTypeProvider';
}

/// See also [notificationsByType].
class NotificationsByTypeProvider
    extends AutoDisposeProvider<List<AppNotification>> {
  /// See also [notificationsByType].
  NotificationsByTypeProvider(
    NotificationType type,
  ) : this._internal(
          (ref) => notificationsByType(
            ref as NotificationsByTypeRef,
            type,
          ),
          from: notificationsByTypeProvider,
          name: r'notificationsByTypeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$notificationsByTypeHash,
          dependencies: NotificationsByTypeFamily._dependencies,
          allTransitiveDependencies:
              NotificationsByTypeFamily._allTransitiveDependencies,
          type: type,
        );

  NotificationsByTypeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
  }) : super.internal();

  final NotificationType type;

  @override
  Override overrideWith(
    List<AppNotification> Function(NotificationsByTypeRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NotificationsByTypeProvider._internal(
        (ref) => create(ref as NotificationsByTypeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<AppNotification>> createElement() {
    return _NotificationsByTypeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NotificationsByTypeProvider && other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin NotificationsByTypeRef on AutoDisposeProviderRef<List<AppNotification>> {
  /// The parameter `type` of this provider.
  NotificationType get type;
}

class _NotificationsByTypeProviderElement
    extends AutoDisposeProviderElement<List<AppNotification>>
    with NotificationsByTypeRef {
  _NotificationsByTypeProviderElement(super.provider);

  @override
  NotificationType get type => (origin as NotificationsByTypeProvider).type;
}

String _$priorityNotificationsHash() =>
    r'9dff08d4ecb43aeeab5b6dfbba5f36814bf63a59';

/// See also [priorityNotifications].
@ProviderFor(priorityNotifications)
final priorityNotificationsProvider =
    AutoDisposeProvider<List<AppNotification>>.internal(
  priorityNotifications,
  name: r'priorityNotificationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$priorityNotificationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PriorityNotificationsRef
    = AutoDisposeProviderRef<List<AppNotification>>;
String _$notificationListHash() => r'060824edcc01b6df43f15b3270e530d1d15cfb66';

/// See also [NotificationList].
@ProviderFor(NotificationList)
final notificationListProvider = AutoDisposeAsyncNotifierProvider<
    NotificationList, List<AppNotification>>.internal(
  NotificationList.new,
  name: r'notificationListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NotificationList = AutoDisposeAsyncNotifier<List<AppNotification>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
