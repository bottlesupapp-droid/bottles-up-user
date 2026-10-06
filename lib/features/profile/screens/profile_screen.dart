import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../features/payment/screens/payment_history_screen.dart';
import '../../../shared/widgets/loading_indicator.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ScrollController scrollController = ScrollController();
    return ProfileScreenInternal(scrollController: scrollController);
  }
}

class ProfileScreenInternal extends ConsumerWidget {
  final ScrollController scrollController;
  
  const ProfileScreenInternal({
    super.key,
    required this.scrollController,
  });

  Future<bool> _showLogoutConfirmation(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          FilledButton(
            onPressed: () => context.pop(true),
            child: const Text('Logout'),
          ),
        ],
      ),
    ) ?? false;
  }

  Future<bool> _showDeleteAccountConfirmation(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Account',
          style: TextStyle(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => context.pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    ) ?? false;
  }

  void _handleLogout(BuildContext context, WidgetRef ref) async {
    final shouldLogout = await _showLogoutConfirmation(context);
    if (shouldLogout) {
      try {
        await ref.read(authStateProvider.notifier).signOut();

        if (context.mounted) {
          context.go('/login');
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Logout failed: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _handleDeleteAccount(BuildContext context, WidgetRef ref) async {
    final shouldDelete = await _showDeleteAccountConfirmation(context);
    if (shouldDelete) {
      try {
        await ref.read(authStateProvider.notifier).deleteAccount();

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
          context.go('/login');
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete account: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  String _getProfileImageUrl(User user) {
    // Try to get profile picture from user metadata or profiles table
    String? avatarUrl = user.userMetadata?['avatar_url'] as String?;

    // If no avatar URL, generate a placeholder with user's initials or email
    if (avatarUrl == null || avatarUrl.isEmpty) {
      final String name = user.userMetadata?['name'] as String? ?? user.email ?? 'User';
      return 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(name)}&background=random&color=fff&size=200';
    }

    return avatarUrl;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    
    return Scaffold(
      body: authState.maybeMap(
        authenticated: (state) => Theme(
          data: Theme.of(context).copyWith(
            listTileTheme: const ListTileThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                // Header with title
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Profile',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                // Profile Image and Name
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(_getProfileImageUrl(state.user)),
                            fit: BoxFit.cover,
                          ),
                          border: Border.all(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.2),
                            width: 4,
                          ),
                        ),
                      ),
                      if (state.user.emailConfirmedAt != null) // Show verified badge if email is confirmed
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Iconsax.verify,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const Gap(12),
                Text(
                  (state.user.userMetadata?['name'] as String?) ?? 'User',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Gap(4),
                Text(
                  state.user.email ?? 'No email provided',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                ),
                const Gap(32),

                // Premium Plan Button - Commented out as requested
                /*
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ClipPath(
                    clipper: ShapeBorderClipper(
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    child: Material(
                      color: Theme.of(context).colorScheme.primary,
                      child: InkWell(
                        onTap: () {
                          // TODO: Handle premium plan tap
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .onPrimary
                                .withValues(alpha: 0.2),
                            child: Icon(
                              Iconsax.crown,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          title: Text(
                            'Get Premium Plan',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          subtitle: Text(
                            'Unlock exclusive features and benefits',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary
                                          .withValues(alpha: 0.8),
                                    ),
                          ),
                          trailing: Icon(
                            Iconsax.arrow_right_1,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Gap(32),
                */

                // Menu Items
                ListTile(
                  leading: const Icon(Iconsax.user),
                  title: const Text('Edit Profile'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 20),
                  onTap: () => context.push('/profile/edit'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Iconsax.clipboard_text),
                  title: const Text('My Orders'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 20),
                  onTap: () => context.push('/profile/orders'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Iconsax.card),
                  title: const Text('Payment History'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 20),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PaymentHistoryScreen(),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Iconsax.setting_2),
                  title: const Text('Settings'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 20),
                  onTap: () => context.push('/profile/settings'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Iconsax.document_text),
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 20),
                  onTap: () => context.push('/profile/privacy-policy'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Iconsax.document_text_1),
                  title: const Text('Terms & Conditions'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 20),
                  onTap: () => context.push('/profile/terms-conditions'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    Iconsax.trash,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  title: Text(
                    'Delete Account',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: authState.maybeMap(
                    loading: (_) => const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    orElse: () => const Icon(Icons.arrow_forward_ios, size: 20),
                  ),
                  enabled: authState.maybeMap(
                    loading: (_) => false,
                    orElse: () => true,
                  ),
                  onTap: () => _handleDeleteAccount(context, ref),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    Iconsax.logout,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: authState.maybeMap(
                    loading: (_) => const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    orElse: () => const Icon(Icons.arrow_forward_ios, size: 20),
                  ),
                  enabled: authState.maybeMap(
                    loading: (_) => false,
                    orElse: () => true,
                  ),
                  onTap: () => _handleLogout(context, ref),
                ),
                SizedBox(height: kBottomNavigationBarHeight + MediaQuery.of(context).padding.bottom + 32),
              ],
            ),
          ),
        ),
        loading: (_) => const Center(child: LoadingIndicator()),
        orElse: () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Not logged in',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Gap(8),
              FilledButton(
                onPressed: () => context.go('/login'),
                child: const Text('Go to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
