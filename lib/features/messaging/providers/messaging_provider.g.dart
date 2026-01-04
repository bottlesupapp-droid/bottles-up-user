// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messaging_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$messagingServiceHash() => r'80fff51d736fb943b4c405a90ac7f917a5b11075';

/// Provider for MessagingService instance
///
/// Copied from [messagingService].
@ProviderFor(messagingService)
final messagingServiceProvider = AutoDisposeProvider<MessagingService>.internal(
  messagingService,
  name: r'messagingServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$messagingServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MessagingServiceRef = AutoDisposeProviderRef<MessagingService>;
String _$conversationsHash() => r'a826a5653711883f2a1a87975139d8c4dfc102b9';

/// Provider to get all conversations for the current user
///
/// Copied from [conversations].
@ProviderFor(conversations)
final conversationsProvider =
    AutoDisposeFutureProvider<List<Conversation>>.internal(
  conversations,
  name: r'conversationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$conversationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ConversationsRef = AutoDisposeFutureProviderRef<List<Conversation>>;
String _$conversationHash() => r'51030a08d8ec5b27afc55e25cdcc144b739996de';

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

/// Provider to get a specific conversation by ID
///
/// Copied from [conversation].
@ProviderFor(conversation)
const conversationProvider = ConversationFamily();

/// Provider to get a specific conversation by ID
///
/// Copied from [conversation].
class ConversationFamily extends Family<AsyncValue<Conversation?>> {
  /// Provider to get a specific conversation by ID
  ///
  /// Copied from [conversation].
  const ConversationFamily();

  /// Provider to get a specific conversation by ID
  ///
  /// Copied from [conversation].
  ConversationProvider call(
    String conversationId,
  ) {
    return ConversationProvider(
      conversationId,
    );
  }

  @override
  ConversationProvider getProviderOverride(
    covariant ConversationProvider provider,
  ) {
    return call(
      provider.conversationId,
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
  String? get name => r'conversationProvider';
}

/// Provider to get a specific conversation by ID
///
/// Copied from [conversation].
class ConversationProvider extends AutoDisposeFutureProvider<Conversation?> {
  /// Provider to get a specific conversation by ID
  ///
  /// Copied from [conversation].
  ConversationProvider(
    String conversationId,
  ) : this._internal(
          (ref) => conversation(
            ref as ConversationRef,
            conversationId,
          ),
          from: conversationProvider,
          name: r'conversationProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$conversationHash,
          dependencies: ConversationFamily._dependencies,
          allTransitiveDependencies:
              ConversationFamily._allTransitiveDependencies,
          conversationId: conversationId,
        );

  ConversationProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.conversationId,
  }) : super.internal();

  final String conversationId;

  @override
  Override overrideWith(
    FutureOr<Conversation?> Function(ConversationRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ConversationProvider._internal(
        (ref) => create(ref as ConversationRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        conversationId: conversationId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Conversation?> createElement() {
    return _ConversationProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ConversationProvider &&
        other.conversationId == conversationId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, conversationId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ConversationRef on AutoDisposeFutureProviderRef<Conversation?> {
  /// The parameter `conversationId` of this provider.
  String get conversationId;
}

class _ConversationProviderElement
    extends AutoDisposeFutureProviderElement<Conversation?>
    with ConversationRef {
  _ConversationProviderElement(super.provider);

  @override
  String get conversationId => (origin as ConversationProvider).conversationId;
}

String _$conversationMessagesHash() =>
    r'7032634ad4acb89d15259cbc5c0d545c425556dd';

/// Provider to get messages for a conversation
///
/// Copied from [conversationMessages].
@ProviderFor(conversationMessages)
const conversationMessagesProvider = ConversationMessagesFamily();

/// Provider to get messages for a conversation
///
/// Copied from [conversationMessages].
class ConversationMessagesFamily extends Family<AsyncValue<List<Message>>> {
  /// Provider to get messages for a conversation
  ///
  /// Copied from [conversationMessages].
  const ConversationMessagesFamily();

  /// Provider to get messages for a conversation
  ///
  /// Copied from [conversationMessages].
  ConversationMessagesProvider call(
    String conversationId, {
    int limit = 50,
    int offset = 0,
  }) {
    return ConversationMessagesProvider(
      conversationId,
      limit: limit,
      offset: offset,
    );
  }

  @override
  ConversationMessagesProvider getProviderOverride(
    covariant ConversationMessagesProvider provider,
  ) {
    return call(
      provider.conversationId,
      limit: provider.limit,
      offset: provider.offset,
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
  String? get name => r'conversationMessagesProvider';
}

/// Provider to get messages for a conversation
///
/// Copied from [conversationMessages].
class ConversationMessagesProvider
    extends AutoDisposeFutureProvider<List<Message>> {
  /// Provider to get messages for a conversation
  ///
  /// Copied from [conversationMessages].
  ConversationMessagesProvider(
    String conversationId, {
    int limit = 50,
    int offset = 0,
  }) : this._internal(
          (ref) => conversationMessages(
            ref as ConversationMessagesRef,
            conversationId,
            limit: limit,
            offset: offset,
          ),
          from: conversationMessagesProvider,
          name: r'conversationMessagesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$conversationMessagesHash,
          dependencies: ConversationMessagesFamily._dependencies,
          allTransitiveDependencies:
              ConversationMessagesFamily._allTransitiveDependencies,
          conversationId: conversationId,
          limit: limit,
          offset: offset,
        );

  ConversationMessagesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.conversationId,
    required this.limit,
    required this.offset,
  }) : super.internal();

  final String conversationId;
  final int limit;
  final int offset;

  @override
  Override overrideWith(
    FutureOr<List<Message>> Function(ConversationMessagesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ConversationMessagesProvider._internal(
        (ref) => create(ref as ConversationMessagesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        conversationId: conversationId,
        limit: limit,
        offset: offset,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Message>> createElement() {
    return _ConversationMessagesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ConversationMessagesProvider &&
        other.conversationId == conversationId &&
        other.limit == limit &&
        other.offset == offset;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, conversationId.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);
    hash = _SystemHash.combine(hash, offset.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ConversationMessagesRef on AutoDisposeFutureProviderRef<List<Message>> {
  /// The parameter `conversationId` of this provider.
  String get conversationId;

  /// The parameter `limit` of this provider.
  int get limit;

  /// The parameter `offset` of this provider.
  int get offset;
}

class _ConversationMessagesProviderElement
    extends AutoDisposeFutureProviderElement<List<Message>>
    with ConversationMessagesRef {
  _ConversationMessagesProviderElement(super.provider);

  @override
  String get conversationId =>
      (origin as ConversationMessagesProvider).conversationId;
  @override
  int get limit => (origin as ConversationMessagesProvider).limit;
  @override
  int get offset => (origin as ConversationMessagesProvider).offset;
}

String _$searchUsersHash() => r'2f0b38806d20fc6f6cc87195b1e8c5617daa694e';

/// Provider to search users
///
/// Copied from [searchUsers].
@ProviderFor(searchUsers)
const searchUsersProvider = SearchUsersFamily();

/// Provider to search users
///
/// Copied from [searchUsers].
class SearchUsersFamily extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// Provider to search users
  ///
  /// Copied from [searchUsers].
  const SearchUsersFamily();

  /// Provider to search users
  ///
  /// Copied from [searchUsers].
  SearchUsersProvider call(
    String query,
  ) {
    return SearchUsersProvider(
      query,
    );
  }

  @override
  SearchUsersProvider getProviderOverride(
    covariant SearchUsersProvider provider,
  ) {
    return call(
      provider.query,
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
  String? get name => r'searchUsersProvider';
}

/// Provider to search users
///
/// Copied from [searchUsers].
class SearchUsersProvider
    extends AutoDisposeFutureProvider<List<Map<String, dynamic>>> {
  /// Provider to search users
  ///
  /// Copied from [searchUsers].
  SearchUsersProvider(
    String query,
  ) : this._internal(
          (ref) => searchUsers(
            ref as SearchUsersRef,
            query,
          ),
          from: searchUsersProvider,
          name: r'searchUsersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchUsersHash,
          dependencies: SearchUsersFamily._dependencies,
          allTransitiveDependencies:
              SearchUsersFamily._allTransitiveDependencies,
          query: query,
        );

  SearchUsersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  Override overrideWith(
    FutureOr<List<Map<String, dynamic>>> Function(SearchUsersRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchUsersProvider._internal(
        (ref) => create(ref as SearchUsersRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Map<String, dynamic>>> createElement() {
    return _SearchUsersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchUsersProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchUsersRef
    on AutoDisposeFutureProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _SearchUsersProviderElement
    extends AutoDisposeFutureProviderElement<List<Map<String, dynamic>>>
    with SearchUsersRef {
  _SearchUsersProviderElement(super.provider);

  @override
  String get query => (origin as SearchUsersProvider).query;
}

String _$conversationMessagesNotifierHash() =>
    r'2514ef91e71e71460cfe7f2c4046e49cd9a18837';

abstract class _$ConversationMessagesNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<Message>> {
  late final String conversationId;

  FutureOr<List<Message>> build(
    String conversationId,
  );
}

/// StateNotifier for managing real-time messages in a conversation
///
/// Copied from [ConversationMessagesNotifier].
@ProviderFor(ConversationMessagesNotifier)
const conversationMessagesNotifierProvider =
    ConversationMessagesNotifierFamily();

/// StateNotifier for managing real-time messages in a conversation
///
/// Copied from [ConversationMessagesNotifier].
class ConversationMessagesNotifierFamily
    extends Family<AsyncValue<List<Message>>> {
  /// StateNotifier for managing real-time messages in a conversation
  ///
  /// Copied from [ConversationMessagesNotifier].
  const ConversationMessagesNotifierFamily();

  /// StateNotifier for managing real-time messages in a conversation
  ///
  /// Copied from [ConversationMessagesNotifier].
  ConversationMessagesNotifierProvider call(
    String conversationId,
  ) {
    return ConversationMessagesNotifierProvider(
      conversationId,
    );
  }

  @override
  ConversationMessagesNotifierProvider getProviderOverride(
    covariant ConversationMessagesNotifierProvider provider,
  ) {
    return call(
      provider.conversationId,
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
  String? get name => r'conversationMessagesNotifierProvider';
}

/// StateNotifier for managing real-time messages in a conversation
///
/// Copied from [ConversationMessagesNotifier].
class ConversationMessagesNotifierProvider
    extends AutoDisposeAsyncNotifierProviderImpl<ConversationMessagesNotifier,
        List<Message>> {
  /// StateNotifier for managing real-time messages in a conversation
  ///
  /// Copied from [ConversationMessagesNotifier].
  ConversationMessagesNotifierProvider(
    String conversationId,
  ) : this._internal(
          () => ConversationMessagesNotifier()..conversationId = conversationId,
          from: conversationMessagesNotifierProvider,
          name: r'conversationMessagesNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$conversationMessagesNotifierHash,
          dependencies: ConversationMessagesNotifierFamily._dependencies,
          allTransitiveDependencies:
              ConversationMessagesNotifierFamily._allTransitiveDependencies,
          conversationId: conversationId,
        );

  ConversationMessagesNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.conversationId,
  }) : super.internal();

  final String conversationId;

  @override
  FutureOr<List<Message>> runNotifierBuild(
    covariant ConversationMessagesNotifier notifier,
  ) {
    return notifier.build(
      conversationId,
    );
  }

  @override
  Override overrideWith(ConversationMessagesNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: ConversationMessagesNotifierProvider._internal(
        () => create()..conversationId = conversationId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        conversationId: conversationId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ConversationMessagesNotifier,
      List<Message>> createElement() {
    return _ConversationMessagesNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ConversationMessagesNotifierProvider &&
        other.conversationId == conversationId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, conversationId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ConversationMessagesNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<List<Message>> {
  /// The parameter `conversationId` of this provider.
  String get conversationId;
}

class _ConversationMessagesNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<
        ConversationMessagesNotifier,
        List<Message>> with ConversationMessagesNotifierRef {
  _ConversationMessagesNotifierProviderElement(super.provider);

  @override
  String get conversationId =>
      (origin as ConversationMessagesNotifierProvider).conversationId;
}

String _$conversationsNotifierHash() =>
    r'8f039b83a1be21104342b06c360deb2ca8fb09ab';

/// StateNotifier for managing conversations list with real-time updates
///
/// Copied from [ConversationsNotifier].
@ProviderFor(ConversationsNotifier)
final conversationsNotifierProvider = AutoDisposeAsyncNotifierProvider<
    ConversationsNotifier, List<Conversation>>.internal(
  ConversationsNotifier.new,
  name: r'conversationsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$conversationsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ConversationsNotifier = AutoDisposeAsyncNotifier<List<Conversation>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
