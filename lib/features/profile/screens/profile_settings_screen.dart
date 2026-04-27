import 'package:flutter/material.dart';
import '../models/user_preferences.dart';
import '../services/user_preferences_service.dart';
import '../services/privacy_settings_service.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen>
    with SingleTickerProviderStateMixin {
  final UserPreferencesService _preferencesService = UserPreferencesService();
  final NotificationSettingsService _notificationService = NotificationSettingsService();
  final PrivacySettingsService _privacyService = PrivacySettingsService();

  late TabController _tabController;
  UserPreferences? _preferences;
  NotificationSettings? _notificationSettings;
  PrivacySettings? _privacySettings;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadSettings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);

    try {
      final prefs = await _preferencesService.getUserPreferences();
      final notifSettings = await _notificationService.getNotificationSettings();
      final privSettings = await _privacyService.getPrivacySettings();

      setState(() {
        _preferences = prefs;
        _notificationSettings = notifSettings;
        _privacySettings = privSettings;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'General'),
            Tab(text: 'Notifications'),
            Tab(text: 'Privacy'),
            Tab(text: 'Display'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildGeneralTab(),
                _buildNotificationsTab(),
                _buildPrivacyTab(),
                _buildDisplayTab(),
              ],
            ),
    );
  }

  Widget _buildGeneralTab() {
    if (_preferences == null) return const SizedBox.shrink();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Booking Preferences',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ListTile(
          title: const Text('Default Party Size'),
          subtitle: Text('${_preferences!.defaultPartySize} people'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showPartySizeDialog(),
        ),
        const Divider(),
        const SizedBox(height: 24),
        const Text(
          'Search & Discovery',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text('Personalized Recommendations'),
          subtitle: const Text('Get venue suggestions based on your preferences'),
          value: _preferences!.personalizedRecommendations,
          onChanged: (value) async {
            await _preferencesService.updatePreferences({
              'personalized_recommendations': value,
            });
            _loadSettings();
          },
        ),
        SwitchListTile(
          title: const Text('Save Search History'),
          subtitle: const Text('Remember your past searches'),
          value: _preferences!.saveSearchHistory,
          onChanged: (value) async {
            await _preferencesService.updatePreferences({
              'save_search_history': value,
            });
            _loadSettings();
          },
        ),
        const Divider(),
        const SizedBox(height: 16),
        ListTile(
          title: const Text('Language'),
          subtitle: Text(_preferences!.language.toUpperCase()),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showLanguageDialog(),
        ),
      ],
    );
  }

  Widget _buildNotificationsTab() {
    if (_notificationSettings == null) return const SizedBox.shrink();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Push Notifications',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text('Enable Push Notifications'),
          value: _notificationSettings!.pushEnabled,
          onChanged: (value) async {
            await _notificationService.updatePushSettings(enabled: value);
            _loadSettings();
          },
        ),
        if (_notificationSettings!.pushEnabled) ...[
          _buildNotificationTile(
            'Bookings',
            _notificationSettings!.pushBookings,
            (value) async {
              await _notificationService.updatePushSettings(bookings: value);
              _loadSettings();
            },
          ),
          _buildNotificationTile(
            'Events',
            _notificationSettings!.pushEvents,
            (value) async {
              await _notificationService.updatePushSettings(events: value);
              _loadSettings();
            },
          ),
          _buildNotificationTile(
            'Messages',
            _notificationSettings!.pushMessages,
            (value) async {
              await _notificationService.updatePushSettings(messages: value);
              _loadSettings();
            },
          ),
          _buildNotificationTile(
            'Friend Requests',
            _notificationSettings!.pushFriendRequests,
            (value) async {
              await _notificationService.updatePushSettings(friendRequests: value);
              _loadSettings();
            },
          ),
          _buildNotificationTile(
            'Promotions',
            _notificationSettings!.pushPromotions,
            (value) async {
              await _notificationService.updatePushSettings(promotions: value);
              _loadSettings();
            },
          ),
        ],
        const Divider(),
        const SizedBox(height: 24),
        const Text(
          'Email Notifications',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text('Enable Email Notifications'),
          value: _notificationSettings!.emailEnabled,
          onChanged: (value) async {
            await _notificationService.updateEmailSettings(enabled: value);
            _loadSettings();
          },
        ),
        if (_notificationSettings!.emailEnabled) ...[
          _buildNotificationTile(
            'Booking Confirmations',
            _notificationSettings!.emailBookings,
            (value) async {
              await _notificationService.updateEmailSettings(bookings: value);
              _loadSettings();
            },
          ),
          _buildNotificationTile(
            'Weekly Digest',
            _notificationSettings!.emailWeeklyDigest,
            (value) async {
              await _notificationService.updateEmailSettings(weeklyDigest: value);
              _loadSettings();
            },
          ),
        ],
        const Divider(),
        const SizedBox(height: 24),
        const Text(
          'Quiet Hours',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Mute notifications during specific hours',
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text('Enable Quiet Hours'),
          value: _notificationSettings!.quietHoursEnabled,
          onChanged: (value) async {
            await _notificationService.updateQuietHours(enabled: value);
            _loadSettings();
          },
        ),
        if (_notificationSettings!.quietHoursEnabled) ...[
          ListTile(
            title: const Text('Start Time'),
            subtitle: Text(_notificationSettings!.quietHoursStart ?? '22:00'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showTimePickerDialog(true),
          ),
          ListTile(
            title: const Text('End Time'),
            subtitle: Text(_notificationSettings!.quietHoursEnd ?? '08:00'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showTimePickerDialog(false),
          ),
        ],
      ],
    );
  }

  Widget _buildPrivacyTab() {
    if (_privacySettings == null) return const SizedBox.shrink();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Profile Visibility',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text('Show Email'),
          subtitle: const Text('Let others see your email address'),
          value: _privacySettings!.showEmail,
          onChanged: (value) async {
            await _privacyService.updateContactVisibility(showEmail: value);
            _loadSettings();
          },
        ),
        SwitchListTile(
          title: const Text('Show Phone'),
          subtitle: const Text('Let others see your phone number'),
          value: _privacySettings!.showPhone,
          onChanged: (value) async {
            await _privacyService.updateContactVisibility(showPhone: value);
            _loadSettings();
          },
        ),
        SwitchListTile(
          title: const Text('Show Location'),
          subtitle: const Text('Display your city/region'),
          value: _privacySettings!.showLocation,
          onChanged: (value) async {
            await _privacyService.updatePersonalInfoVisibility(showLocation: value);
            _loadSettings();
          },
        ),
        const Divider(),
        const SizedBox(height: 24),
        const Text(
          'Social Settings',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text('Allow Tagging'),
          subtitle: const Text('Friends can tag you in posts'),
          value: _privacySettings!.allowTagging,
          onChanged: (value) async {
            await _privacyService.updateSocialSettings(allowTagging: value);
            _loadSettings();
          },
        ),
        SwitchListTile(
          title: const Text('Allow Mentions'),
          subtitle: const Text('Others can mention you'),
          value: _privacySettings!.allowMentions,
          onChanged: (value) async {
            await _privacyService.updateSocialSettings(allowMentions: value);
            _loadSettings();
          },
        ),
        const Divider(),
        const SizedBox(height: 24),
        const Text(
          'Data & Privacy',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text('Data Sharing'),
          subtitle: const Text('Share anonymized data for app improvements'),
          value: _privacySettings!.allowDataSharing,
          onChanged: (value) async {
            await _privacyService.updateDataSharing(allowDataSharing: value);
            _loadSettings();
          },
        ),
        SwitchListTile(
          title: const Text('Marketing Emails'),
          subtitle: const Text('Receive promotional offers and updates'),
          value: _privacySettings!.allowMarketingEmails,
          onChanged: (value) async {
            await _privacyService.updateDataSharing(allowMarketingEmails: value);
            _loadSettings();
          },
        ),
        const SizedBox(height: 16),
        ListTile(
          title: const Text('Blocked Users'),
          subtitle: Text('${_privacySettings!.blockedUsers.length} users blocked'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showBlockedUsersScreen(),
        ),
      ],
    );
  }

  Widget _buildDisplayTab() {
    if (_preferences == null) return const SizedBox.shrink();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Appearance',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ListTile(
          title: const Text('Theme'),
          subtitle: Text(_getThemeLabel(_preferences!.themeMode)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showThemeDialog(),
        ),
        const Divider(),
        const SizedBox(height: 24),
        const Text(
          'Units',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ListTile(
          title: const Text('Distance Unit'),
          subtitle: Text(_preferences!.distanceUnit == DistanceUnit.kilometers
              ? 'Kilometers'
              : 'Miles'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showDistanceUnitDialog(),
        ),
        ListTile(
          title: const Text('Currency'),
          subtitle: Text(_preferences!.currency.name.toUpperCase()),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showCurrencyDialog(),
        ),
        const Divider(),
        const SizedBox(height: 24),
        const Text(
          'Accessibility',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ListTile(
          title: const Text('Font Size'),
          subtitle: Slider(
            value: _preferences!.fontSize,
            min: 0.8,
            max: 1.5,
            divisions: 7,
            label: '${(_preferences!.fontSize * 100).toInt()}%',
            onChanged: (value) async {
              await _preferencesService.updateAccessibilityPreferences(
                fontSize: value,
              );
              _loadSettings();
            },
          ),
        ),
        SwitchListTile(
          title: const Text('High Contrast'),
          subtitle: const Text('Increase contrast for better visibility'),
          value: _preferences!.highContrast,
          onChanged: (value) async {
            await _preferencesService.updateAccessibilityPreferences(
              highContrast: value,
            );
            _loadSettings();
          },
        ),
        const Divider(),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text('Show Tutorials'),
          subtitle: const Text('Display helpful tips and guides'),
          value: _preferences!.showTutorials,
          onChanged: (value) async {
            await _preferencesService.updateDisplayPreferences(
              showTutorials: value,
            );
            _loadSettings();
          },
        ),
      ],
    );
  }

  Widget _buildNotificationTile(
    String title,
    bool value,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: SwitchListTile(
        title: Text(title),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  String _getThemeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System Default';
    }
  }

  Future<void> _showPartySizeDialog() async {
    // Show dialog to select party size
  }

  Future<void> _showLanguageDialog() async {
    // Show dialog to select language
  }

  Future<void> _showThemeDialog() async {
    // Show dialog to select theme
  }

  Future<void> _showDistanceUnitDialog() async {
    // Show dialog to select distance unit
  }

  Future<void> _showCurrencyDialog() async {
    // Show dialog to select currency
  }

  Future<void> _showTimePickerDialog(bool isStart) async {
    // Show time picker for quiet hours
  }

  void _showBlockedUsersScreen() {
    // Navigate to blocked users screen
  }
}
