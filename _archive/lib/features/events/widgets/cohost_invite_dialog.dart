import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/event_cohost.dart';
import '../providers/cohost_provider.dart';

class CohostInviteDialog extends ConsumerStatefulWidget {
  final String eventId;
  final String eventName;

  const CohostInviteDialog({
    super.key,
    required this.eventId,
    required this.eventName,
  });

  @override
  ConsumerState<CohostInviteDialog> createState() =>
      _CohostInviteDialogState();
}

class _CohostInviteDialogState extends ConsumerState<CohostInviteDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _messageController = TextEditingController();

  String _selectedPreset = 'Full Access';
  List<CohostPermission> _selectedPermissions =
      CohostPermissionPresets.fullAccess;

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _updatePermissionsFromPreset(String preset) {
    setState(() {
      _selectedPreset = preset;
      switch (preset) {
        case 'Full Access':
          _selectedPermissions = CohostPermissionPresets.fullAccess;
          break;
        case 'Moderator':
          _selectedPermissions = CohostPermissionPresets.moderator;
          break;
        case 'Limited':
          _selectedPermissions = CohostPermissionPresets.limited;
          break;
        case 'Custom':
          // Keep current permissions
          break;
      }
    });
  }

  Future<void> _sendInvite() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // In a real app, you would search for the user by email
      // For now, we'll use mock data
      final mockUserId = 'user_${_emailController.text.hashCode}';

      await ref.read(eventCohostsProvider(widget.eventId).notifier).inviteCohost(
            userId: mockUserId,
            userName: _nameController.text,
            userEmail: _emailController.text,
            permissions: _selectedPermissions,
            message: _messageController.text.isEmpty
                ? null
                : _messageController.text,
          );

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Co-host invitation sent!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Invite Co-Host'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Event: ${widget.eventName}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 16),

              // Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Permission Preset
              DropdownButtonFormField<String>(
                initialValue: _selectedPreset,
                decoration: const InputDecoration(
                  labelText: 'Permission Level',
                  border: OutlineInputBorder(),
                ),
                items: ['Full Access', 'Moderator', 'Limited', 'Custom']
                    .map((preset) => DropdownMenuItem(
                          value: preset,
                          child: Text(preset),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    _updatePermissionsFromPreset(value);
                  }
                },
              ),
              const SizedBox(height: 12),

              // Permission Details
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Permissions:',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _selectedPermissions.map((permission) {
                        return Chip(
                          label: Text(
                            _formatPermission(permission),
                            style: const TextStyle(fontSize: 11),
                          ),
                          deleteIcon: _selectedPreset == 'Custom'
                              ? const Icon(Icons.close, size: 16)
                              : null,
                          onDeleted: _selectedPreset == 'Custom'
                              ? () {
                                  setState(() {
                                    _selectedPermissions.remove(permission);
                                  });
                                }
                              : null,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Message
              TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(
                  labelText: 'Message (Optional)',
                  border: OutlineInputBorder(),
                  hintText: 'Add a personal message...',
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _sendInvite,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Send Invite'),
        ),
      ],
    );
  }

  String _formatPermission(CohostPermission permission) {
    switch (permission) {
      case CohostPermission.editEvent:
        return 'Edit Event';
      case CohostPermission.manageGuestList:
        return 'Manage Guests';
      case CohostPermission.sendAnnouncements:
        return 'Announcements';
      case CohostPermission.moderateChat:
        return 'Moderate Chat';
      case CohostPermission.managePoll:
        return 'Manage Polls';
      case CohostPermission.inviteCohost:
        return 'Invite Co-hosts';
      case CohostPermission.viewAnalytics:
        return 'View Analytics';
    }
  }
}
