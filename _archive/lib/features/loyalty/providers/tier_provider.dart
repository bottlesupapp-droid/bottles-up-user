import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/tier.dart';
import '../models/user_tier_status.dart';
import '../services/tier_service.dart';

part 'tier_provider.g.dart';

@riverpod
class UserTierStatusNotifier extends _$UserTierStatusNotifier {
  @override
  Future<UserTierStatus?> build() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      return null;
    }

    final tierService = TierService();
    return await tierService.getUserTierStatus(user.id);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return null;

      final tierService = TierService();
      return await tierService.getUserTierStatus(user.id);
    });
  }

  Future<void> claimBirthdayReward() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final tierService = TierService();
    await tierService.claimBirthdayReward(user.id);
    await refresh();
  }
}

@riverpod
class AllTiers extends _$AllTiers {
  @override
  List<Tier> build() {
    final tierService = TierService();
    return tierService.getAllTiers();
  }
}

@riverpod
class CurrentTier extends _$CurrentTier {
  @override
  Future<Tier> build() async {
    final status = await ref.watch(userTierStatusNotifierProvider.future);

    if (status == null) {
      return Tier.select();
    }

    final tierService = TierService();
    return tierService.getTierByLevel(status.currentTier);
  }
}

@riverpod
class TierProgress extends _$TierProgress {
  @override
  Future<Map<String, dynamic>> build() async {
    final status = await ref.watch(userTierStatusNotifierProvider.future);

    if (status == null) {
      return {
        'isMaxTier': false,
        'pointsProgress': 0.0,
        'spendProgress': 0.0,
        'pointsNeeded': 500,
        'spendNeeded': 2000.0,
      };
    }

    final tierService = TierService();
    return tierService.getProgressToNextTier(status);
  }
}

@riverpod
class RecentTierTransactions extends _$RecentTierTransactions {
  @override
  Future<List<TierTransaction>> build() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      return [];
    }

    final tierService = TierService();
    return await tierService.getRecentTransactions(user.id);
  }
}

@riverpod
Future<bool> canClaimBirthdayReward(CanClaimBirthdayRewardRef ref) async {
  final user = Supabase.instance.client.auth.currentUser;

  if (user == null) {
    return false;
  }

  final tierService = TierService();
  return await tierService.canClaimBirthdayReward(user.id);
}
