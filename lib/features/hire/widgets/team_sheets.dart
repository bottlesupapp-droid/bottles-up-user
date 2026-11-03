import 'package:flutter/material.dart';

import '../../../site/models/hire.dart';

/// What the owner chose when inviting or changing a role.
typedef RolePick = ({TeamRole role, Set<String> permissions});

/// Ask for the role of a new member, or change one: the roles, with what each may do, and for a custom role the kinds of work to allow.
Future<({String handle, RolePick pick})?> showInviteSheet(BuildContext context) => showModalBottomSheet<({String handle, RolePick pick})>(context: context, isScrollControlled: true, builder: (_) => const _RoleSheet(invite: true));

Future<({String handle, RolePick pick})?> showRoleSheet(BuildContext context, {required TeamMember member}) =>
    showModalBottomSheet<({String handle, RolePick pick})>(context: context, isScrollControlled: true, builder: (_) => _RoleSheet(invite: false, member: member));

class _RoleSheet extends StatefulWidget {
  const _RoleSheet({required this.invite, this.member});

  final bool invite;
  final TeamMember? member;

  @override
  State<_RoleSheet> createState() => _RoleSheetState();
}

class _RoleSheetState extends State<_RoleSheet> {
  final _handle = TextEditingController();
  late TeamRole _role = widget.member?.role ?? TeamRole.bookingAgent;
  late final Set<String> _allowed = {...?widget.member?.permissions};
  String? _wrong;

  @override
  void dispose() {
    _handle.dispose();
    super.dispose();
  }

  void _done() {
    if (widget.invite && _handle.text.trim().replaceAll('@', '').isEmpty) return setState(() => _wrong = 'Type their username.');
    if (_role == TeamRole.custom && _allowed.isEmpty) return setState(() => _wrong = 'Choose at least one thing a custom role may do.');
    Navigator.pop(context, (handle: _handle.text, pick: (role: _role, permissions: _role == TeamRole.custom ? {..._allowed} : <String>{})));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        key: const Key('role-sheet'),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(widget.invite ? 'Invite someone to the team' : 'Change ${widget.member?.person?.name ?? 'their'} role', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          if (widget.invite) TextField(key: const Key('invite-handle'), controller: _handle, autocorrect: false, decoration: const InputDecoration(labelText: 'Their username', prefixText: '@')),
          const SizedBox(height: 8),
          RadioGroup<TeamRole>(
            groupValue: _role,
            onChanged: (v) => setState(() => _role = v ?? _role),
            child: Column(children: [
              for (final r in TeamRole.values)
                RadioListTile<TeamRole>(key: Key('role-${r.wire}'), contentPadding: EdgeInsets.zero, value: r, title: Text(r.label), subtitle: Text(r.summary)),
            ]),
          ),
          if (_role == TeamRole.custom)
            for (final e in teamPermissionLabels.entries)
              CheckboxListTile(
                key: Key('allow-${e.key}'),
                contentPadding: EdgeInsets.zero,
                value: _allowed.contains(e.key),
                title: Text(e.value),
                onChanged: (v) => setState(() => v == true ? _allowed.add(e.key) : _allowed.remove(e.key)),
              ),
          if (_wrong != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_wrong!, key: const Key('role-problem'), style: TextStyle(color: theme.colorScheme.error))),
          const SizedBox(height: 12),
          FilledButton(key: const Key('role-save'), onPressed: _done, child: Text(widget.invite ? 'Send the invitation' : 'Save')),
        ]),
      ),
    );
  }
}
