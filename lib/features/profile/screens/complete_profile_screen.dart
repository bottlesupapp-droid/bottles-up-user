import 'package:bottles_up_user/features/auth/models/country.dart';
import 'package:bottles_up_user/features/auth/providers/auth_provider.dart';
import 'package:bottles_up_user/features/profile/logic/profile_completion.dart';
import 'package:bottles_up_user/features/profile/widgets/date_of_birth_field.dart';
import 'package:bottles_up_user/routing/profile_gate.dart';
import 'package:bottles_up_user/site/providers/site_providers.dart';
import 'package:bottles_up_user/site/services/profile_completion_service.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

/// Shown before the home screen to anyone whose profile lacks an e-mail, a phone number or a date of birth (every sign-in method ends up here when it did not provide them). The age is
/// worked out from the date of birth, and nobody under [minimumAge] gets through.
class CompleteProfileScreen extends ConsumerStatefulWidget {
  const CompleteProfileScreen({super.key, this.redirectTo});

  /// Where to go once the profile is complete (the screen the person was heading for), if it is a place inside the app.
  final String? redirectTo;

  @override
  ConsumerState<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends ConsumerState<CompleteProfileScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  Country _country = supportedCountries.first;
  DateTime? _dateOfBirth;
  bool _emailKnown = false;
  bool _loading = true;
  bool _saving = false;
  String? _loadError;
  String? _saveError;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final details = await ref.read(profileCompletionServiceProvider).load();
      if (!mounted) return;
      if (profileGaps(details, clock.now()).complete) {
        _finish();
        return;
      }
      final known = details.knownEmail;
      final split = splitPhone(details.phone, supportedCountries, supportedCountries.first);
      setState(() {
        _email.text = known ?? '';
        _emailKnown = known != null && emailProblem(known) == null;
        _country = split.country;
        _phone.text = split.national;
        _dateOfBirth = details.dateOfBirth;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadError = 'We could not load your profile. Check your connection and try again.';
      });
    }
  }

  void _finish() {
    ref.read(profileGateProvider).markComplete();
    context.go(safeReturnPath(widget.redirectTo) ?? '/home');
  }

  Future<void> _save() async {
    if (!(_form.currentState?.validate() ?? false)) return;
    setState(() {
      _saving = true;
      _saveError = null;
    });
    try {
      await ref.read(profileCompletionServiceProvider).save(email: _email.text, phone: phoneFor(_country, _phone.text), dateOfBirth: _dateOfBirth!);
      if (!mounted) return;
      _finish();
    } on EmailTakenException {
      if (!mounted) return;
      setState(() => _saveError = 'Another BottlesUp account already uses that e-mail address. Use a different one, or sign out and sign in to that account.');
    } on UnderAgeException {
      if (!mounted) return;
      setState(() => _saveError = 'You must be $minimumAge or older to use BottlesUp.');
    } catch (_) {
      if (!mounted) return;
      setState(() => _saveError = 'We could not save your details. Check your connection and try again.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _loadError != null
                      ? _failure(theme)
                      : _formView(theme),
            ),
          ),
        ),
      ),
    );
  }

  Widget _failure(ThemeData theme) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_loadError!, key: const Key('cp-load-error'), textAlign: TextAlign.center, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 16),
            FilledButton(key: const Key('cp-retry'), onPressed: _load, child: const Text('Try again')),
            const SizedBox(height: 8),
            _signOutButton(),
          ],
        ),
      );

  Widget _signOutButton() => TextButton(
        key: const Key('cp-sign-out'),
        onPressed: _saving ? null : () => ref.read(authStateProvider.notifier).signOut(),
        child: const Text('Not you? Sign out'),
      );

  Widget _formView(ThemeData theme) => SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Complete your profile', key: const Key('cp-title'), style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                'Venues use these to reach you about your bookings and to check you are old enough. It takes a minute.',
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 24),
              TextFormField(
                key: const Key('cp-email'),
                controller: _email,
                readOnly: _emailKnown,
                enabled: !_saving,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  helperText: _emailKnown ? 'From your sign-in' : null,
                  prefixIcon: const Icon(Iconsax.sms),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: emailProblem,
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 120,
                    child: DropdownButtonFormField<Country>(
                      key: const Key('cp-country'),
                      initialValue: _country,
                      isExpanded: true,
                      decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16)),
                      items: [for (final c in supportedCountries) DropdownMenuItem(value: c, child: Text('${c.code} ${c.phoneCode}', overflow: TextOverflow.ellipsis))],
                      onChanged: _saving ? null : (c) => setState(() => _country = c ?? _country),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      key: const Key('cp-phone'),
                      controller: _phone,
                      enabled: !_saving,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(labelText: 'Phone number', prefixIcon: const Icon(Iconsax.call), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                      validator: phoneProblem,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DateOfBirthField(initialValue: _dateOfBirth, enabled: !_saving, onChanged: (d) => _dateOfBirth = d),
              if (_saveError != null) ...[
                const SizedBox(height: 16),
                Text(_saveError!, key: const Key('cp-error'), style: TextStyle(color: theme.colorScheme.error)),
              ],
              const SizedBox(height: 24),
              FilledButton(
                key: const Key('cp-save'),
                onPressed: _saving ? null : _save,
                style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: _saving ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Continue'),
              ),
              const SizedBox(height: 8),
              _signOutButton(),
            ],
          ),
        ),
      );
}
