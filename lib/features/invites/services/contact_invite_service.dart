import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:share_plus/share_plus.dart';

class ContactInviteService {
  static final ContactInviteService _instance = ContactInviteService._internal();
  factory ContactInviteService() => _instance;
  ContactInviteService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Request contacts permission
  Future<bool> requestContactsPermission() async {
    try {
      return await FlutterContacts.requestPermission();
    } catch (e) {
      return false;
    }
  }

  // Get all contacts
  Future<List<Contact>> getAllContacts() async {
    try {
      if (!await FlutterContacts.requestPermission()) {
        throw Exception('Contacts permission denied');
      }

      return await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: true,
      );
    } catch (e) {
      throw Exception('Failed to get contacts: $e');
    }
  }

  // Search contacts
  Future<List<Contact>> searchContacts(String query) async {
    try {
      final contacts = await getAllContacts();
      return contacts.where((contact) {
        final name = contact.displayName.toLowerCase();
        final searchQuery = query.toLowerCase();
        return name.contains(searchQuery);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  // Send event invite via SMS
  Future<void> sendSMSInvite({
    required String phoneNumber,
    required String eventName,
    required String eventLink,
  }) async {
    try {
      final message = 'Hey! Join me at $eventName\n\nGet tickets here: $eventLink\n\nSee you there!';

      // Use SMS launcher
      await Share.share(message);
    } catch (e) {
      throw Exception('Failed to send SMS: $e');
    }
  }

  // Send event invite via email
  Future<void> sendEmailInvite({
    required String email,
    required String eventName,
    required String eventLink,
    String? personalMessage,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      final senderName = currentUser?.userMetadata?['full_name'] ?? 'A friend';

      final subject = '$senderName invited you to $eventName';
      final body = '''
$senderName has invited you to an event!

Event: $eventName

${personalMessage ?? 'I thought you might be interested in this event!'}

Get your tickets here: $eventLink

Download BottlesUp to see all upcoming events!
      ''';

      // Log invitation
      await _supabase.from('event_invites').insert({
        'sender_id': currentUser?.id,
        'recipient_email': email,
        'event_link': eventLink,
        'invite_type': 'email',
      });

      // Send via email service (handled by backend)
      await _supabase.rpc('send_event_invite_email', params: {
        'recipient_email': email,
        'subject': subject,
        'body': body,
      });
    } catch (e) {
      throw Exception('Failed to send email: $e');
    }
  }

  // Bulk invite contacts
  Future<void> bulkInviteContacts({
    required List<Contact> contacts,
    required String eventName,
    required String eventLink,
  }) async {
    try {
      for (final contact in contacts) {
        // Get phone or email
        if (contact.phones.isNotEmpty) {
          await sendSMSInvite(
            phoneNumber: contact.phones.first.number,
            eventName: eventName,
            eventLink: eventLink,
          );
        } else if (contact.emails.isNotEmpty) {
          await sendEmailInvite(
            email: contact.emails.first.address,
            eventName: eventName,
            eventLink: eventLink,
          );
        }
      }
    } catch (e) {
      throw Exception('Failed to send invites: $e');
    }
  }

  // Get invite stats
  Future<Map<String, int>> getInviteStats() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return {};

      final invites = await _supabase
          .from('event_invites')
          .select('invite_type, status')
          .eq('sender_id', currentUser.id);

      final stats = <String, int>{
        'total': 0,
        'sent': 0,
        'opened': 0,
        'accepted': 0,
      };

      for (final invite in (invites as List)) {
        stats['total'] = (stats['total'] ?? 0) + 1;
        if (invite['status'] == 'sent') stats['sent'] = (stats['sent'] ?? 0) + 1;
        if (invite['status'] == 'opened') stats['opened'] = (stats['opened'] ?? 0) + 1;
        if (invite['status'] == 'accepted') stats['accepted'] = (stats['accepted'] ?? 0) + 1;
      }

      return stats;
    } catch (e) {
      return {};
    }
  }
}
