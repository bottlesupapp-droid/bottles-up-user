import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../site/providers/site_providers.dart';
import '../../../site/rules/profile_rules.dart';
import '../../../site/site_error.dart';

/// A username box that says, as the person types, whether the name is taken. The website has the last word when the form is saved.
class UsernameField extends ConsumerStatefulWidget {
  const UsernameField({super.key, required this.controller, this.fieldKey = const Key('username-field')});

  final TextEditingController controller;
  final Key fieldKey;

  @override
  ConsumerState<UsernameField> createState() => _UsernameFieldState();
}

class _UsernameFieldState extends ConsumerState<UsernameField> {
  Timer? _debounce;
  String? _message;
  bool _good = false;
  bool _checking = false;
  int _serial = 0;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _changed(String text) {
    _debounce?.cancel();
    final problem = text.trim().isEmpty ? null : usernameProblem(text);
    setState(() {
      _good = false;
      _message = problem;
      _checking = false;
    });
    if (text.trim().isEmpty || problem != null) return;
    _debounce = Timer(const Duration(milliseconds: 400), () => _check(text));
  }

  Future<void> _check(String text) async {
    final mine = ++_serial;
    setState(() => _checking = true);
    String? message;
    var good = false;
    try {
      good = await ref.read(socialProfilesServiceProvider).usernameAvailable(text);
      message = good ? 'Available' : 'That username is not available.';
    } on SiteException catch (e) {
      message = e.message;
    }
    // A slower answer to an older word must not overwrite the answer to what is typed now.
    if (!mounted || mine != _serial) return;
    setState(() {
      _checking = false;
      _good = good;
      _message = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      key: widget.fieldKey,
      controller: widget.controller,
      autocorrect: false,
      enableSuggestions: false,
      textInputAction: TextInputAction.next,
      maxLength: 30,
      decoration: InputDecoration(
        labelText: 'Username',
        prefixText: '@',
        counterText: '',
        helperText: _checking ? 'Checking...' : _message,
        helperStyle: TextStyle(color: _good ? Colors.green.shade700 : (_message != null && !_checking ? theme.colorScheme.error : null)),
      ),
      onChanged: _changed,
    );
  }
}
