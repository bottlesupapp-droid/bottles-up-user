import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/contact_invite_service.dart';

class SMSInviteScreen extends StatefulWidget {
  final String eventId;
  final String eventName;
  final String eventLink;

  const SMSInviteScreen({
    super.key,
    required this.eventId,
    required this.eventName,
    required this.eventLink,
  });

  @override
  State<SMSInviteScreen> createState() => _SMSInviteScreenState();
}

class _SMSInviteScreenState extends State<SMSInviteScreen> {
  final _inviteService = ContactInviteService();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final List<String> _phoneNumbers = [];
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _messageController.text =
        'Hey! Join me at ${widget.eventName}\n\nGet tickets here: ${widget.eventLink}\n\nSee you there!';
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _addPhoneNumber() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _phoneNumbers.add(_phoneController.text.trim());
        _phoneController.clear();
      });
    }
  }

  void _removePhoneNumber(int index) {
    setState(() {
      _phoneNumbers.removeAt(index);
    });
  }

  Future<void> _sendInvites() async {
    if (_phoneNumbers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one phone number')),
      );
      return;
    }

    setState(() => _isSending = true);

    try {
      for (final phoneNumber in _phoneNumbers) {
        await _inviteService.sendSMSInvite(
          phoneNumber: phoneNumber,
          eventName: widget.eventName,
          eventLink: widget.eventLink,
        );
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sent ${_phoneNumbers.length} SMS invites!'),
            backgroundColor: Colors.green,
          ),
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
        setState(() => _isSending = false);
      }
    }
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter a phone number';
    }

    // Remove non-digit characters
    final cleaned = value.replaceAll(RegExp(r'\D'), '');

    if (cleaned.length < 10) {
      return 'Phone number must be at least 10 digits';
    }

    if (_phoneNumbers.contains(value.trim())) {
      return 'Phone number already added';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send SMS Invites'),
        actions: [
          if (_phoneNumbers.isNotEmpty && !_isSending)
            TextButton(
              onPressed: _sendInvites,
              child: Text(
                'Send (${_phoneNumbers.length})',
                style: const TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Phone number input
          Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        hintText: '+1 (555) 123-4567',
                        prefixIcon: const Icon(Icons.phone),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[\d\s\(\)\-\+]')),
                      ],
                      validator: _validatePhoneNumber,
                      onFieldSubmitted: (_) => _addPhoneNumber(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _addPhoneNumber,
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
          ),

          // Message preview
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                labelText: 'Message Preview',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 4,
              readOnly: true,
            ),
          ),

          const SizedBox(height: 16),

          // Phone numbers list
          Expanded(
            child: _buildPhoneNumbersList(),
          ),

          // Send button
          if (_phoneNumbers.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isSending ? null : _sendInvites,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isSending
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text('Send ${_phoneNumbers.length} SMS Invites'),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPhoneNumbersList() {
    if (_phoneNumbers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sms, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No phone numbers added',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add phone numbers to send SMS invites',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _phoneNumbers.length,
      itemBuilder: (context, index) {
        final phoneNumber = _phoneNumbers[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: const Icon(Icons.phone),
          ),
          title: Text(phoneNumber),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _removePhoneNumber(index),
          ),
        );
      },
    );
  }
}
