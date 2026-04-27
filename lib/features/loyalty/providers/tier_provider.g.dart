// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tier_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$canClaimBirthdayRewardHash() =>
    r'26373473977192d34949e96f8076b138cfc15d53';

/// See also [canClaimBirthdayReward].
@ProviderFor(canClaimBirthdayReward)
final canClaimBirthdayRewardProvider = AutoDisposeFutureProvider<bool>.internal(
  canClaimBirthdayReward,
  name: r'canClaimBirthdayRewardProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$canClaimBirthdayRewardHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CanClaimBirthdayRewardRef = AutoDisposeFutureProviderRef<bool>;
String _$userTierStatusNotifierHash() =>
    r'b0a4ddc6c179e695fbaef027026d4d0342f6ee83';

/// See also [UserTierStatusNotifier].
@ProviderFor(UserTierStatusNotifier)
final userTierStatusNotifierProvider = AutoDisposeAsyncNotifierProvider<
    UserTierStatusNotifier, UserTierStatus?>.internal(
  UserTierStatusNotifier.new,
  name: r'userTierStatusNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userTierStatusNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UserTierStatusNotifier = AutoDisposeAsyncNotifier<UserTierStatus?>;
String _$allTiersHash() => r'6a011ae16118c476b81ddc144d6fe4f7a1222ccd';

/// See also [AllTiers].
@ProviderFor(AllTiers)
final allTiersProvider =
    AutoDisposeNotifierProvider<AllTiers, List<Tier>>.internal(
  AllTiers.new,
  name: r'allTiersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$allTiersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AllTiers = AutoDisposeNotifier<List<Tier>>;
String _$currentTierHash() => r'2ce002896ce3ea65a1e937ac3190d9cfe64c5288';

/// See also [CurrentTier].
@ProviderFor(CurrentTier)
final currentTierProvider =
    AutoDisposeAsyncNotifierProvider<CurrentTier, Tier>.internal(
  CurrentTier.new,
  name: r'currentTierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$currentTierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentTier = AutoDisposeAsyncNotifier<Tier>;
String _$tierProgressHash() => r'6e9bbb1b6779820df2942442f375c45d54b5e074';

/// See also [TierProgress].
@ProviderFor(TierProgress)
final tierProgressProvider = AutoDisposeAsyncNotifierProvider<TierProgress,
    Map<String, dynamic>>.internal(
  TierProgress.new,
  name: r'tierProgressProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$tierProgressHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TierProgress = AutoDisposeAsyncNotifier<Map<String, dynamic>>;
String _$recentTierTransactionsHash() =>
    r'c46defa8eb2107002280ed8a2514fe998d8565de';

/// See also [RecentTierTransactions].
@ProviderFor(RecentTierTransactions)
final recentTierTransactionsProvider = AutoDisposeAsyncNotifierProvider<
    RecentTierTransactions, List<TierTransaction>>.internal(
  RecentTierTransactions.new,
  name: r'recentTierTransactionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$recentTierTransactionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RecentTierTransactions
    = AutoDisposeAsyncNotifier<List<TierTransaction>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
