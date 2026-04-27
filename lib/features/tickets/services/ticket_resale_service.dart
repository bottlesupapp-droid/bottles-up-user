import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/ticket_resale.dart';

class TicketResaleService {
  static final TicketResaleService _instance = TicketResaleService._internal();
  factory TicketResaleService() => _instance;
  TicketResaleService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // List ticket for resale
  Future<TicketResale> listTicketForResale({
    required String ticketId,
    required String eventId,
    required double originalPrice,
    required double listingPrice,
    String? description,
    int quantity = 1,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Validate ticket ownership
      final ticket = await _supabase
          .from('event_tickets')
          .select()
          .eq('id', ticketId)
          .eq('user_id', currentUser.id)
          .single();

      if (ticket['status'] != 'active') {
        throw Exception('Ticket cannot be resold');
      }

      // Check if already listed
      final existing = await _supabase
          .from('ticket_resales')
          .select()
          .eq('ticket_id', ticketId)
          .eq('status', ResaleStatus.listed.name)
          .maybeSingle();

      if (existing != null) {
        throw Exception('Ticket already listed for resale');
      }

      final listingData = {
        'ticket_id': ticketId,
        'seller_id': currentUser.id,
        'event_id': eventId,
        'original_price': originalPrice,
        'listing_price': listingPrice,
        'seller_name': currentUser.userMetadata?['full_name'],
        'description': description,
        'quantity': quantity,
        'status': ResaleStatus.listed.name,
      };

      final response = await _supabase
          .from('ticket_resales')
          .insert(listingData)
          .select()
          .single();

      // Update ticket status
      await _supabase
          .from('event_tickets')
          .update({'status': 'listed_for_resale'})
          .eq('id', ticketId);

      return TicketResale.fromSupabase(response);
    } catch (e) {
      throw Exception('Failed to list ticket: $e');
    }
  }

  // Get available resale tickets for event
  Future<List<TicketResale>> getResaleTicketsForEvent(String eventId) async {
    try {
      final response = await _supabase
          .from('ticket_resales')
          .select('''
            *,
            events:event_id (name, event_date)
          ''')
          .eq('event_id', eventId)
          .eq('status', ResaleStatus.listed.name)
          .order('listing_price', ascending: true);

      return (response as List).map((data) {
        if (data['events'] != null) {
          data['event_name'] = data['events']['name'];
          data['event_date'] = data['events']['event_date'];
        }
        return TicketResale.fromSupabase(data);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  // Get user's resale listings
  Future<List<TicketResale>> getUserResaleListings() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return [];

      final response = await _supabase
          .from('ticket_resales')
          .select('''
            *,
            events:event_id (name, event_date)
          ''')
          .eq('seller_id', currentUser.id)
          .order('listed_at', ascending: false);

      return (response as List).map((data) {
        if (data['events'] != null) {
          data['event_name'] = data['events']['name'];
          data['event_date'] = data['events']['event_date'];
        }
        return TicketResale.fromSupabase(data);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  // Purchase resale ticket
  Future<void> purchaseResaleTicket(String resaleId) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Get resale listing
      final listing = await _supabase
          .from('ticket_resales')
          .select()
          .eq('id', resaleId)
          .single();

      if (listing['status'] != ResaleStatus.listed.name) {
        throw Exception('Ticket no longer available');
      }

      // Process payment (handled by payment service)
      // This would integrate with Stripe/payment gateway

      // Transfer ticket ownership
      await _supabase
          .from('event_tickets')
          .update({
            'user_id': currentUser.id,
            'status': 'active',
          })
          .eq('id', listing['ticket_id']);

      // Update resale listing
      await _supabase
          .from('ticket_resales')
          .update({
            'status': ResaleStatus.sold.name,
            'buyer_id': currentUser.id,
            'buyer_name': currentUser.userMetadata?['full_name'],
            'sold_at': DateTime.now().toIso8601String(),
          })
          .eq('id', resaleId);
    } catch (e) {
      throw Exception('Failed to purchase ticket: $e');
    }
  }

  // Cancel resale listing
  Future<void> cancelResaleListing(String resaleId) async {
    try {
      final listing = await _supabase
          .from('ticket_resales')
          .select()
          .eq('id', resaleId)
          .single();

      await _supabase
          .from('ticket_resales')
          .update({'status': ResaleStatus.cancelled.name})
          .eq('id', resaleId);

      // Restore ticket status
      await _supabase
          .from('event_tickets')
          .update({'status': 'active'})
          .eq('id', listing['ticket_id']);
    } catch (e) {
      throw Exception('Failed to cancel listing: $e');
    }
  }

  // Make offer on resale ticket
  Future<ResaleOffer> makeOffer({
    required String resaleId,
    required double offeredPrice,
    String? message,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final offerData = {
        'resale_id': resaleId,
        'buyer_id': currentUser.id,
        'buyer_name': currentUser.userMetadata?['full_name'],
        'offered_price': offeredPrice,
        'message': message,
        'status': 'pending',
      };

      final response = await _supabase
          .from('resale_offers')
          .insert(offerData)
          .select()
          .single();

      return ResaleOffer.fromSupabase(response);
    } catch (e) {
      throw Exception('Failed to make offer: $e');
    }
  }

  // Get offers for resale listing
  Future<List<ResaleOffer>> getOffersForListing(String resaleId) async {
    try {
      final response = await _supabase
          .from('resale_offers')
          .select()
          .eq('resale_id', resaleId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((data) => ResaleOffer.fromSupabase(data))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Accept offer
  Future<void> acceptOffer(String offerId) async {
    try {
      final offer = await _supabase
          .from('resale_offers')
          .select()
          .eq('id', offerId)
          .single();

      await _supabase
          .from('resale_offers')
          .update({
            'status': 'accepted',
            'responded_at': DateTime.now().toIso8601String(),
          })
          .eq('id', offerId);

      // Update listing price and initiate sale
      await purchaseResaleTicket(offer['resale_id']);
    } catch (e) {
      throw Exception('Failed to accept offer: $e');
    }
  }
}
