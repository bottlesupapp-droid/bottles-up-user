import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import '../services/contact_invite_service.dart';

class ContactInviteScreen extends StatefulWidget {
  final String eventId;
  final String eventName;
  final String eventLink;

  const ContactInviteScreen({
    super.key,
    required this.eventId,
    required this.eventName,
    required this.eventLink,
  });

  @override
  State<ContactInviteScreen> createState() => _ContactInviteScreenState();
}

class _ContactInviteScreenState extends State<ContactInviteScreen> {
  final _inviteService = ContactInviteService();
  final _searchController = TextEditingController();

  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  Set<String> _selectedContacts = {};
  bool _isLoading = true;
  bool _permissionGranted = false;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadContacts() async {
    setState(() => _isLoading = true);
    try {
      final granted = await _inviteService.requestContactsPermission();
      if (!granted) {
        setState(() {
          _isLoading = false;
          _permissionGranted = false;
        });
        return;
      }

      final contacts = await _inviteService.getAllContacts();
      setState(() {
        _contacts = contacts;
        _filteredContacts = contacts;
        _isLoading = false;
        _permissionGranted = true;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _filterContacts(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredContacts = _contacts;
      } else {
        _filteredContacts = _contacts.where((contact) {
          return contact.displayName
              .toLowerCase()
              .contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  Future<void> _sendInvites() async {
    if (_selectedContacts.isEmpty) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final selectedContacts = _contacts
          .where((c) => _selectedContacts.contains(c.id))
          .toList();

      await _inviteService.bulkInviteContacts(
        contacts: selectedContacts,
        eventName: widget.eventName,
        eventLink: widget.eventLink,
      );

      if (mounted) {
        Navigator.pop(context); // Close loading
        Navigator.pop(context); // Close screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sent ${_selectedContacts.length} invites!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invite Contacts'),
        actions: [
          if (_selectedContacts.isNotEmpty)
            TextButton(
              onPressed: _sendInvites,
              child: Text(
                'Send (${_selectedContacts.length})',
                style: const TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search contacts...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterContacts('');
                        },
                      )
                    : null,
              ),
              onChanged: _filterContacts,
            ),
          ),

          // Contacts list
          Expanded(
            child: _buildContactsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildContactsList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_permissionGranted) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.contacts, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Contacts Permission Required'),
            const SizedBox(height: 8),
            const Text(
              'Grant permission to invite your contacts',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _loadContacts,
              child: const Text('Grant Permission'),
            ),
          ],
        ),
      );
    }

    if (_filteredContacts.isEmpty) {
      return const Center(
        child: Text('No contacts found'),
      );
    }

    return ListView.builder(
      itemCount: _filteredContacts.length,
      itemBuilder: (context, index) {
        final contact = _filteredContacts[index];
        final isSelected = _selectedContacts.contains(contact.id);

        return CheckboxListTile(
          title: Text(contact.displayName),
          subtitle: contact.phones.isNotEmpty
              ? Text(contact.phones.first.number)
              : contact.emails.isNotEmpty
                  ? Text(contact.emails.first.address)
                  : null,
          secondary: contact.photo != null
              ? CircleAvatar(backgroundImage: MemoryImage(contact.photo!))
              : CircleAvatar(
                  child: Text(
                    contact.displayName.isNotEmpty
                        ? contact.displayName[0].toUpperCase()
                        : '?',
                  ),
                ),
          value: isSelected,
          onChanged: (checked) {
            setState(() {
              if (checked == true) {
                _selectedContacts.add(contact.id);
              } else {
                _selectedContacts.remove(contact.id);
              }
            });
          },
        );
      },
    );
  }
}
