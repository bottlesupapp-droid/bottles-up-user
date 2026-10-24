import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/loyalty_tier.dart';

class TierNotificationService {
  static final TierNotificationService _instance = TierNotificationService._internal();
  factory TierNotificationService() => _instance;
  TierNotificationService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;
  RealtimeChannel? _tierChannel;

  // Subscribe to tier changes and show notifications
  void subscribeToTierChanges(BuildContext context) {
    final currentUser = _supabase.auth.currentUser;
    if (currentUser == null) return;

    _tierChannel = _supabase.channel('tier_notifications_${currentUser.id}');

    _tierChannel!
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'user_loyalty',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: currentUser.id,
          ),
          callback: (payload) {
            final oldTier = payload.oldRecord['tier_id'] as String?;
            final newTier = payload.newRecord['tier_id'] as String?;

            if (oldTier != null && newTier != null && oldTier != newTier) {
              _showTierUpgradeNotification(context, newTier);
            }
          },
        )
        .subscribe();
  }

  // Unsubscribe from notifications
  void unsubscribe() {
    _tierChannel?.unsubscribe();
    _tierChannel = null;
  }

  // Show tier upgrade notification
  Future<void> _showTierUpgradeNotification(
    BuildContext context,
    String newTierId,
  ) async {
    try {
      final response = await _supabase
          .from('loyalty_tiers')
          .select()
          .eq('id', newTierId)
          .single();

      final tier = LoyaltyTier.fromSupabase(response);

      if (!context.mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => TierUpgradeDialog(tier: tier),
      );
    } catch (e) {
      // Error loading tier data
    }
  }

  // Check for pending upgrade notifications
  Future<LoyaltyTier?> checkPendingUpgrade() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return null;

      final response = await _supabase
          .from('tier_upgrade_notifications')
          .select('*, tier:loyalty_tiers(*)')
          .eq('user_id', currentUser.id)
          .eq('is_shown', false)
          .maybeSingle();

      if (response == null) return null;

      // Mark as shown
      await _supabase
          .from('tier_upgrade_notifications')
          .update({'is_shown': true})
          .eq('id', response['id']);

      return LoyaltyTier.fromSupabase(response['tier'] as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  // Create upgrade notification
  Future<void> createUpgradeNotification({
    required String tierId,
    required int newPoints,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return;

      await _supabase.from('tier_upgrade_notifications').insert({
        'user_id': currentUser.id,
        'tier_id': tierId,
        'points_at_upgrade': newPoints,
        'is_shown': false,
      });
    } catch (e) {
      // Non-critical error
    }
  }
}

// Tier upgrade dialog widget
class TierUpgradeDialog extends StatelessWidget {
  final LoyaltyTier tier;

  const TierUpgradeDialog({
    super.key,
    required this.tier,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _getTierColor(tier.level),
              _getTierColor(tier.level).withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Celebration icon
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getTierIcon(tier.level),
                size: 64,
                color: _getTierColor(tier.level),
              ),
            ),
            const SizedBox(height: 24),

            // Congratulations text
            const Text(
              '🎉 Congratulations! 🎉',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            const Text(
              'You\'ve been upgraded to',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              tier.name,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),

            // Benefits preview
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'New Benefits Unlocked:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...tier.benefits.take(3).map((benefit) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                benefit,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                  if (tier.benefits.length > 3)
                    Text(
                      '+${tier.benefits.length - 3} more benefits',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.8),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Close button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: _getTierColor(tier.level),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Awesome!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTierColor(TierLevel level) {
    switch (level) {
      case TierLevel.bronze:
        return Colors.brown;
      case TierLevel.silver:
        return Colors.grey;
      case TierLevel.gold:
        return Colors.amber;
      case TierLevel.platinum:
        return Colors.blueGrey;
      case TierLevel.diamond:
        return Colors.cyan;
    }
  }

  IconData _getTierIcon(TierLevel level) {
    switch (level) {
      case TierLevel.bronze:
        return Icons.workspace_premium;
      case TierLevel.silver:
        return Icons.military_tech;
      case TierLevel.gold:
        return Icons.emoji_events;
      case TierLevel.platinum:
        return Icons.diamond;
      case TierLevel.diamond:
        return Icons.auto_awesome;
    }
  }
}
