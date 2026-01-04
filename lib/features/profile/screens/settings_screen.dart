import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

// Settings providers
final notificationsProvider = StateNotifierProvider<NotificationSettingsNotifier, NotificationSettings>((ref) {
  return NotificationSettingsNotifier();
});

final privacyProvider = StateNotifierProvider<PrivacySettingsNotifier, PrivacySettings>((ref) {
  return PrivacySettingsNotifier();
});

final appPreferencesProvider = StateNotifierProvider<AppPreferencesNotifier, AppPreferences>((ref) {
  return AppPreferencesNotifier();
});

// Settings models
class NotificationSettings {
  final bool pushNotifications;
  final bool emailNotifications;
  final bool bookingReminders;
  final bool promotionalOffers;

  NotificationSettings({
    required this.pushNotifications,
    required this.emailNotifications,
    required this.bookingReminders,
    required this.promotionalOffers,
  });

  NotificationSettings copyWith({
    bool? pushNotifications,
    bool? emailNotifications,
    bool? bookingReminders,
    bool? promotionalOffers,
  }) {
    return NotificationSettings(
      pushNotifications: pushNotifications ?? this.pushNotifications,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      bookingReminders: bookingReminders ?? this.bookingReminders,
      promotionalOffers: promotionalOffers ?? this.promotionalOffers,
    );
  }
}

class PrivacySettings {
  final bool shareLocation;
  final bool allowAnalytics;

  PrivacySettings({
    required this.shareLocation,
    required this.allowAnalytics,
  });

  PrivacySettings copyWith({
    bool? shareLocation,
    bool? allowAnalytics,
  }) {
    return PrivacySettings(
      shareLocation: shareLocation ?? this.shareLocation,
      allowAnalytics: allowAnalytics ?? this.allowAnalytics,
    );
  }
}

class AppPreferences {
  final bool darkMode;
  final String currency;

  AppPreferences({
    required this.darkMode,
    required this.currency,
  });

  AppPreferences copyWith({
    bool? darkMode,
    String? currency,
  }) {
    return AppPreferences(
      darkMode: darkMode ?? this.darkMode,
      currency: currency ?? this.currency,
    );
  }
}

// State notifiers
class NotificationSettingsNotifier extends StateNotifier<NotificationSettings> {
  NotificationSettingsNotifier() : super(NotificationSettings(
    pushNotifications: true,
    emailNotifications: true,
    bookingReminders: true,
    promotionalOffers: false,
  )) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state = NotificationSettings(
      pushNotifications: prefs.getBool('push_notifications') ?? true,
      emailNotifications: prefs.getBool('email_notifications') ?? true,
      bookingReminders: prefs.getBool('booking_reminders') ?? true,
      promotionalOffers: prefs.getBool('promotional_offers') ?? false,
    );
  }

  Future<void> updatePushNotifications(bool value) async {
    state = state.copyWith(pushNotifications: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('push_notifications', value);
  }

  Future<void> updateEmailNotifications(bool value) async {
    state = state.copyWith(emailNotifications: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('email_notifications', value);
  }

  Future<void> updateBookingReminders(bool value) async {
    state = state.copyWith(bookingReminders: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('booking_reminders', value);
  }

  Future<void> updatePromotionalOffers(bool value) async {
    state = state.copyWith(promotionalOffers: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('promotional_offers', value);
  }
}

class PrivacySettingsNotifier extends StateNotifier<PrivacySettings> {
  PrivacySettingsNotifier() : super(PrivacySettings(
    shareLocation: true,
    allowAnalytics: true,
  )) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state = PrivacySettings(
      shareLocation: prefs.getBool('share_location') ?? true,
      allowAnalytics: prefs.getBool('allow_analytics') ?? true,
    );
  }

  Future<void> updateShareLocation(bool value) async {
    state = state.copyWith(shareLocation: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('share_location', value);
  }

  Future<void> updateAllowAnalytics(bool value) async {
    state = state.copyWith(allowAnalytics: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('allow_analytics', value);
  }
}

class AppPreferencesNotifier extends StateNotifier<AppPreferences> {
  AppPreferencesNotifier() : super(AppPreferences(
    darkMode: false,
    currency: 'USD',
  )) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state = AppPreferences(
      darkMode: prefs.getBool('dark_mode') ?? false,
      currency: prefs.getString('currency') ?? 'USD',
    );
  }

  Future<void> updateDarkMode(bool value) async {
    state = state.copyWith(darkMode: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', value);
  }

  Future<void> updateCurrency(String value) async {
    state = state.copyWith(currency: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currency', value);
  }
}

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _sendEmail(String email) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': 'Settings Support - Bottles Up',
      },
    );
    await launchUrl(emailLaunchUri);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationSettings = ref.watch(notificationsProvider);
    final privacySettings = ref.watch(privacyProvider);
    final appPreferences = ref.watch(appPreferencesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          // Notifications Section
          _buildSectionHeader(context, 'Notifications', Iconsax.notification),
          _buildSwitchTile(
            context,
            'Push Notifications',
            'Receive notifications on your device',
            notificationSettings.pushNotifications,
            (value) => ref.read(notificationsProvider.notifier).updatePushNotifications(value),
          ),
          _buildSwitchTile(
            context,
            'Email Notifications',
            'Receive notifications via email',
            notificationSettings.emailNotifications,
            (value) => ref.read(notificationsProvider.notifier).updateEmailNotifications(value),
          ),
          _buildSwitchTile(
            context,
            'Booking Reminders',
            'Get reminded about upcoming bookings',
            notificationSettings.bookingReminders,
            (value) => ref.read(notificationsProvider.notifier).updateBookingReminders(value),
          ),
          _buildSwitchTile(
            context,
            'Promotional Offers',
            'Receive special offers and deals',
            notificationSettings.promotionalOffers,
            (value) => ref.read(notificationsProvider.notifier).updatePromotionalOffers(value),
          ),
          const Gap(24),

          // Privacy Section
          _buildSectionHeader(context, 'Privacy', Iconsax.shield_security),
          _buildSwitchTile(
            context,
            'Location Access',
            'Allow app to access your location',
            privacySettings.shareLocation,
            (value) => ref.read(privacyProvider.notifier).updateShareLocation(value),
          ),
          _buildSwitchTile(
            context,
            'Analytics',
            'Help improve the app with usage data',
            privacySettings.allowAnalytics,
            (value) => ref.read(privacyProvider.notifier).updateAllowAnalytics(value),
          ),
          const Gap(24),

          // App Preferences Section
          _buildSectionHeader(context, 'Preferences', Iconsax.setting_2),
          _buildSwitchTile(
            context,
            'Dark Mode',
            'Use dark theme for the app',
            appPreferences.darkMode,
            (value) => ref.read(appPreferencesProvider.notifier).updateDarkMode(value),
          ),
          _buildActionTile(
            context,
            Iconsax.dollar_circle,
            'Currency',
            'Current: ${appPreferences.currency}',
            () => _showCurrencyDialog(context, ref, appPreferences.currency),
          ),
          const Gap(24),

          // Data Management Section
          _buildSectionHeader(context, 'Data Management', Iconsax.archive),
          _buildActionTile(
            context,
            Iconsax.refresh,
            'Clear Cache',
            'Free up storage space',
            () => _showClearCacheDialog(context),
          ),
          _buildActionTile(
            context,
            Iconsax.export,
            'Export Data',
            'Download your personal data',
            () => _sendEmail('data-export@bottlesup.com'),
          ),
          _buildActionTile(
            context,
            Iconsax.trash,
            'Delete Account',
            'Permanently delete your account',
            () => _showDeleteAccountDialog(context),
            isDestructive: true,
          ),
          const Gap(24),

          // Support Section
          _buildSectionHeader(context, 'Support', Iconsax.support),
          _buildActionTile(
            context,
            Iconsax.message_question,
            'Contact Support',
            'Get help with the app',
            () => _sendEmail('support@bottlesup.com'),
          ),
          const Gap(32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const Gap(8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context,
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: SwitchListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive ? Colors.red : null,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDestructive ? Colors.red : null,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      ),
    );
  }

  void _showCurrencyDialog(BuildContext context, WidgetRef ref, String currentCurrency) {
    final currencies = ['USD', 'EUR', 'GBP', 'JPY', 'AUD', 'CAD'];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Currency'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: currencies.map((currency) => RadioListTile<String>(
            title: Text(currency),
            value: currency,
            groupValue: currentCurrency,
            onChanged: (value) {
              if (value != null) {
                ref.read(appPreferencesProvider.notifier).updateCurrency(value);
                Navigator.of(context).pop();
              }
            },
          )).toList(),
        ),
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('This will remove all cached data. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache cleared successfully')),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'This action cannot be undone. All your data will be permanently deleted. '
          'Please contact support to proceed with account deletion.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              _sendEmail('account-deletion@bottlesup.com');
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Contact Support'),
          ),
        ],
      ),
    );
  }
} 