import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/event.dart';
import '../models/event_rsvp.dart';
import '../providers/event_booking_provider.dart';
import '../services/event_booking_service.dart';
import '../services/email_service.dart';
import '../providers/event_provider.dart'; // For eventByIdProvider
import '../../bookings/providers/user_bookings_provider.dart';
import '../../payment/screens/payment_screen.dart';
import '../../../core/models/payment_models.dart';
import '../widgets/add_to_wallet_button.dart';
import '../widgets/booking_success_dialog.dart';

class EventBookingScreen extends ConsumerStatefulWidget {
  final String eventId;

  const EventBookingScreen({
    super.key,
    required this.eventId,
  });

  @override
  ConsumerState<EventBookingScreen> createState() => _EventBookingScreenState();
}

class _EventBookingScreenState extends ConsumerState<EventBookingScreen> {
  final _supabase = Supabase.instance.client;
  final PageController _pageController = PageController();
  int _ticketQuantity = 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventAsync = ref.watch(eventByIdProvider(widget.eventId));
    final eventConfigAsync = ref.watch(eventConfigurationProvider(widget.eventId));

    return Scaffold(
      body: eventAsync.when(
        data: (eventWithClub) {
          if (eventWithClub == null) {
            return _buildEventUnavailableScreen(context, 'This event is no longer available.');
          }

          // Block booking on past or cancelled events
          final isPast = eventWithClub.eventDate
              .add(const Duration(hours: 3))
              .isBefore(DateTime.now());
          final isCancelled = eventWithClub.status == 'cancelled';

          if (isPast || isCancelled) {
            return _buildEventUnavailableScreen(
              context,
              isPast
                  ? 'Bookings for this event are closed — the event has already taken place.'
                  : 'This event has been cancelled and is no longer accepting bookings.',
            );
          }

          return _buildBookingFlow(context, eventWithClub, eventConfigAsync.value);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const Gap(16),
              Text('Error loading event: $error', textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventUnavailableScreen(BuildContext context, String message) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.event_busy, size: 80, color: Colors.orange),
              const Gap(24),
              Text(
                'Booking Unavailable',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(12),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(32),
              FilledButton.tonal(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookingFlow(BuildContext context, Event eventWithClub, EventConfiguration? config) {
    return Stack(
      children: [
        // Main scrollable content
        NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            _buildEventHeader(context, eventWithClub),
            // Event configuration info
            if (config != null)
              _buildEventConfigurationSliver(context, config),
            // Booking options selector as part of header
            _buildBookingSelectorSliver(context, eventWithClub, config),
          ],
          body: Padding(
            padding: const EdgeInsets.only(bottom: 80), // Space for sticky button
            child: PageView(
              controller: _pageController,
              onPageChanged: (page) {
                // Page changed - could be used for analytics or other tracking
              },
              children: [
                // Guestlist RSVP Form
                if (config?.enableGuestlistRsvp ?? true)
                  _buildGuestlistForm(context, eventWithClub),

                // Table Booking Form
                if (config?.enableTableBooking ?? true)
                  _buildTableBookingForm(context, eventWithClub, config),

                // Ticket Purchase Form
                if (eventWithClub.ticketPrice > 0)
                  _buildTicketPurchaseForm(context, eventWithClub),
              ],
            ),
          ),
        ),

        // Sticky bottom button
        _buildStickyBottomButton(context, eventWithClub, config),
      ],
    );
  }

  Widget _buildStickyBottomButton(BuildContext context, Event event, EventConfiguration? config) {
    final bookingOption = ref.watch(eventBookingStateProvider);

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).padding.bottom + 16,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border(
            top: BorderSide(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: bookingOption == BookingOption.ticket
            ? _buildTicketPurchaseButton(context, event)
            : bookingOption == BookingOption.table
                ? _buildTableBookingButton(context, config)
                : _buildRSVPButton(context),
      ),
    );
  }

  Widget _buildTableBookingButton(BuildContext context, EventConfiguration? config) {
    return Consumer(
      builder: (context, ref, _) {
        final formState = ref.watch(tableBookingFormStateProvider);
        final formNotifier = ref.read(tableBookingFormStateProvider.notifier);
        final submission = ref.watch(tableBookingSubmissionProvider);

        if (formState.selectedTable == null) {
          return const SizedBox.shrink();
        }

        final availableBottlesAsync = ref.watch(availableBottlesProvider(widget.eventId));
        final bottlesTotal = availableBottlesAsync.maybeWhen(
          data: (bottles) => formNotifier.calculateBottlesTotal(bottles),
          orElse: () => 0.0,
        );

        final costs = EventBookingService().calculateTotalCost(
          depositAmount: formState.selectedTable!['deposit_amount'].toDouble(),
          bottlesTotal: bottlesTotal,
          serviceFeeRate: config?.serviceFeeRate ?? 0.07,
          taxRate: config?.taxRate ?? 0.13,
        );

        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: formNotifier.isValid() && !submission.isLoading
                ? () => _proceedToPayment(context, ref, formState, costs)
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: submission.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Proceed to Checkout',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildRSVPButton(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final formState = ref.watch(rSVPFormStateProvider);
        final submission = ref.watch(rSVPSubmissionProvider);
        final formNotifier = ref.read(rSVPFormStateProvider.notifier);

        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: formNotifier.isValid() && !submission.isLoading
                ? () {
                    ref.read(rSVPSubmissionProvider.notifier).submitRSVP(
                      widget.eventId,
                      formState,
                    );
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: submission.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Submit RSVP - FREE',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildEventConfigurationSliver(BuildContext context, EventConfiguration config) {
    return SliverToBoxAdapter(
      child: _buildEventConfiguration(context, config),
    );
  }

  Widget _buildBookingSelectorSliver(BuildContext context, Event event, EventConfiguration? config) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          _buildBookingSelector(context, event, config),
          const Gap(16),
        ],
      ),
    );
  }

  Widget _buildEventHeader(BuildContext context, Event eventWithClub) {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          eventWithClub.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              eventWithClub.primaryImageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
                  child: const Icon(Icons.event, size: 64),
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventConfiguration(BuildContext context, EventConfiguration config) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Event Information',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(12),
          Row(
            children: [
              Icon(Iconsax.user, size: 16, color: Theme.of(context).colorScheme.primary),
              const Gap(8),
              Expanded(child: Text('Max party size: ${config.maxPartySize} people')),
            ],
          ),
          if (config.enableTableBooking) ...[
            const Gap(8),
            Row(
              children: [
                Icon(Iconsax.dollar_circle, size: 16, color: Theme.of(context).colorScheme.primary),
                const Gap(8),
                Expanded(child: Text('Table deposit: \$${config.minTableDeposit.toStringAsFixed(0)} required')),
              ],
            ),
            const Gap(8),
            Row(
              children: [
                Icon(Iconsax.cup, size: 16, color: Theme.of(context).colorScheme.primary),
                const Gap(8),
                const Expanded(child: Text('Minimum 1 bottle per table')),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBookingSelector(BuildContext context, Event event, EventConfiguration? config) {
    final bookingOption = ref.watch(eventBookingStateProvider);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          if (config?.enableGuestlistRsvp ?? true)
            Expanded(
              child: GestureDetector(
                onTap: () {
                  ref.read(eventBookingStateProvider.notifier).setBookingOption(BookingOption.guestlist);
                  _pageController.animateToPage(
                    0, // guestlist is always first when enabled
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    color: bookingOption == BookingOption.guestlist
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Iconsax.user_add,
                        color: bookingOption == BookingOption.guestlist
                            ? Colors.white
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                      const Gap(8),
                      Text(
                        'Option A',
                        style: TextStyle(
                          color: bookingOption == BookingOption.guestlist
                              ? Colors.white
                              : Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'RSVP Only',
                        style: TextStyle(
                          color: bookingOption == BookingOption.guestlist
                              ? Colors.white
                              : Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Free Guestlist',
                        style: TextStyle(
                          color: bookingOption == BookingOption.guestlist
                              ? Colors.white.withValues(alpha: 0.8)
                              : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          if (config?.enableTableBooking ?? true)
            Expanded(
              child: GestureDetector(
                onTap: () {
                  ref.read(eventBookingStateProvider.notifier).setBookingOption(BookingOption.table);
                  // If guestlist is disabled, table is at index 0; otherwise index 1
                  final tablePageIndex = (config?.enableGuestlistRsvp ?? true) ? 1 : 0;
                  _pageController.animateToPage(
                    tablePageIndex,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    color: bookingOption == BookingOption.table
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Iconsax.reserve,
                        color: bookingOption == BookingOption.table
                            ? Colors.white
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                      const Gap(8),
                      Text(
                        'Option B',
                        style: TextStyle(
                          color: bookingOption == BookingOption.table
                              ? Colors.white
                              : Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'Reserve a Table',
                        style: TextStyle(
                          color: bookingOption == BookingOption.table
                              ? Colors.white
                              : Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Deposit Required',
                        style: TextStyle(
                          color: bookingOption == BookingOption.table
                              ? Colors.white.withValues(alpha: 0.8)
                              : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          if (event.ticketPrice > 0)
            Expanded(
              child: GestureDetector(
                onTap: () {
                  ref.read(eventBookingStateProvider.notifier).setBookingOption(BookingOption.ticket);
                  int ticketPageIndex = 0;
                  if (config?.enableGuestlistRsvp ?? true) ticketPageIndex++;
                  if (config?.enableTableBooking ?? true) ticketPageIndex++;
                  _pageController.animateToPage(
                    ticketPageIndex,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(
                    color: bookingOption == BookingOption.ticket
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Iconsax.ticket,
                        color: bookingOption == BookingOption.ticket
                            ? Colors.white
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                      const Gap(8),
                      Text(
                        'Option C',
                        style: TextStyle(
                          color: bookingOption == BookingOption.ticket
                              ? Colors.white
                              : Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'Buy Ticket',
                        style: TextStyle(
                          color: bookingOption == BookingOption.ticket
                              ? Colors.white
                              : Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        event.formattedPrice,
                        style: TextStyle(
                          color: bookingOption == BookingOption.ticket
                              ? Colors.white.withValues(alpha: 0.8)
                              : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Ticket Purchase ────────────────────────────────────────────────────────

  Widget _buildTicketPurchaseForm(BuildContext context, Event event) {
    final price = event.ticketPrice;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Buy Tickets', style: Theme.of(context).textTheme.headlineSmall),
          const Gap(8),
          Text(
            event.name,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
          ),
          const Gap(24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Price per ticket',
                        style: Theme.of(context).textTheme.bodyMedium),
                    Text(event.formattedPrice,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            )),
                  ],
                ),
                const Gap(16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Quantity', style: Theme.of(context).textTheme.bodyMedium),
                    Row(
                      children: [
                        IconButton(
                          onPressed: _ticketQuantity > 1
                              ? () => setState(() => _ticketQuantity--)
                              : null,
                          icon: const Icon(Icons.remove_circle_outline),
                          iconSize: 28,
                        ),
                        SizedBox(
                          width: 36,
                          child: Text(
                            '$_ticketQuantity',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        IconButton(
                          onPressed: _ticketQuantity < 10
                              ? () => setState(() => _ticketQuantity++)
                              : null,
                          icon: const Icon(Icons.add_circle_outline),
                          iconSize: 28,
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            )),
                    Text(
                      '\$${(price * _ticketQuantity).toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Gap(16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Iconsax.ticket, size: 16, color: Theme.of(context).colorScheme.primary),
                const Gap(8),
                Expanded(
                  child: Text(
                    'Your ticket QR code will be available immediately after purchase.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketPurchaseButton(BuildContext context, Event event) {
    final price = event.ticketPrice;
    final total = price * _ticketQuantity;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _proceedToTicketPayment(context, event, total),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          'Buy $_ticketQuantity ${_ticketQuantity == 1 ? 'Ticket' : 'Tickets'} — \$${total.toStringAsFixed(0)}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  Future<void> _proceedToTicketPayment(BuildContext context, Event event, double total) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          amount: total,
          currency: 'USD',
          description: 'Event Ticket — ${event.name}',
          paymentType: PaymentType.eventTicket,
          bookingId: null,
          metadata: {
            'event_id': event.id,
            'ticket_quantity': _ticketQuantity.toString(),
            'ticket_price': event.ticketPrice.toString(),
            'total_amount': total.toString(),
          },
          onPaymentSuccess: () async {
            final confirmationCode =
                'BU${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
            await _supabase.from('events_bookings').insert({
              'user_id': user.id,
              'event_id': event.id,
              'ticket_quantity': _ticketQuantity,
              'ticket_price': event.ticketPrice,
              'total_amount': total,
              'status': 'confirmed',
              'confirmation_code': confirmationCode,
              'payment_status': 'paid',
              'qr_code': confirmationCode,
            });

            ref.invalidate(userBookingsProvider);

            // Send confirmation email
            try {
              final userEmail = user.email;
              if (userEmail != null) {
                final userData = await _supabase.auth.getUser();
                final fullName = userData.user?.userMetadata?['full_name'] as String? ?? userEmail;
                await EmailService().sendPaymentConfirmationEmail(
                  to: userEmail,
                  customerName: fullName,
                  eventName: event.name,
                  eventDate: event.formattedDate,
                  eventTime: event.formattedTime,
                  venue: event.venueDisplay,
                  amount: total,
                  paymentMethod: 'Card',
                  transactionId: confirmationCode,
                );
              }
            } catch (_) {}
          },
        ),
      ),
    );
  }

  // ── Guestlist ──────────────────────────────────────────────────────────────

  Widget _buildGuestlistForm(BuildContext context, Event eventWithClub) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Free Guestlist RSVP',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(8),
          Text(
            'Simply provide your details to get on the guestlist. No payment required.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const Gap(24),

          // RSVP Form
          _RSVPForm(),

          const Gap(16),

          // Error Message
          Consumer(
            builder: (context, ref, child) {
              final submission = ref.watch(rSVPSubmissionProvider);

              return submission.when(
                data: (rsvp) => rsvp != null
                    ? Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.green),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.check_circle, color: Colors.green),
                                Gap(12),
                                Expanded(
                                  child: Text(
                                    'RSVP submitted successfully!',
                                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Gap(16),
                          // Apple Wallet Button
                          AddToWalletButton(
                            eventId: eventWithClub.id,
                            bookingId: rsvp.id,
                            passType: 'rsvp',
                            event: eventWithClub,
                            rsvp: rsvp,
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
                loading: () => const SizedBox.shrink(),
                error: (error, stackTrace) => Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.red),
                      const Gap(12),
                      Expanded(
                        child: Text(
                          error.toString().replaceFirst('Exception: ', ''),
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTableBookingForm(BuildContext context, Event eventWithClub, EventConfiguration? config) {
    final availableTablesAsync = ref.watch(availableTablesProvider(widget.eventId));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reserve a Table',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(8),
          Text(
            'Reserve a VIP table with bottle service. Split payments available.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const Gap(24),

          // Available Tables
          availableTablesAsync.when(
            data: (tables) => _buildTableSelection(context, tables, config),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Text('Error loading tables: $error'),
            ),
          ),

          const Gap(24),

          // Table Booking Form
          _TableBookingForm(),

          const Gap(24),

          // Bottle Selection
          _BottleSelection(eventId: widget.eventId),

          const Gap(24),
        ],
      ),
    );
  }

  Widget _buildTableSelection(BuildContext context, List<Map<String, dynamic>> tables, EventConfiguration? config) {
    final selectedTable = ref.watch(tableBookingFormStateProvider).selectedTable;

    // No tables configured for this event
    if (tables.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select a Table',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.table_restaurant_outlined,
                  size: 48,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                ),
                const Gap(12),
                Text(
                  'No tables available',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const Gap(6),
                Text(
                  'The organiser hasn\'t added table reservations for this event yet.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    // Get the event to access table arrangement image
    final eventAsync = ref.watch(eventByIdProvider(widget.eventId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select a Table',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(12),
        
        // Table arrangement image
        eventAsync.when(
          data: (eventWithClub) {
            if (eventWithClub?.tableArrangementImageUrl != null) {
              return Container(
                width: double.infinity,
                height: 200,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    eventWithClub!.tableArrangementImageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Theme.of(context).colorScheme.surface,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.table_chart,
                              size: 48,
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                            const Gap(8),
                            Text(
                              'Table Arrangement Map',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Theme.of(context).colorScheme.surface,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
          loading: () => const SizedBox.shrink(),
          error: (error, stack) => const SizedBox.shrink(),
        ),

        SizedBox(
          height: 280, // Increased height for larger table cards with images
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: tables.length,
            itemBuilder: (context, index) {
              final table = tables[index];
              final isSelected = selectedTable?['id'] == table['id'];

              return Container(
                width: 280,
                margin: EdgeInsets.only(
                  right: index < tables.length - 1 ? 12 : 0,
                ),
                child: InkWell(
                  onTap: () {
                    ref.read(tableBookingFormStateProvider.notifier).selectTable(table);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                          : Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                              : Colors.black.withValues(alpha: 0.05),
                          blurRadius: isSelected ? 8 : 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Large Table Image
                        Container(
                          height: 140,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            child: Stack(
                              children: [
                                // Table Image
                                if (table['image_url'] != null)
                                  SizedBox(
                                    width: double.infinity,
                                    height: 140,
                                    child: Image.network(
                                      table['image_url'],
                                      width: double.infinity,
                                      height: 140,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: Theme.of(context).colorScheme.surfaceContainer,
                                          child: Center(
                                            child: Icon(
                                              Iconsax.reserve,
                                              size: 48,
                                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                                            ),
                                          ),
                                        );
                                      },
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Container(
                                          color: Theme.of(context).colorScheme.surfaceContainer,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress.expectedTotalBytes != null
                                                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                  : null,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                else
                                  Container(
                                    width: double.infinity,
                                    height: 140,
                                    color: Theme.of(context).colorScheme.surfaceContainer,
                                    child: Center(
                                      child: Icon(
                                        Iconsax.reserve,
                                        size: 48,
                                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                                      ),
                                    ),
                                  ),

                                // Price Badge Overlay
                                Positioned(
                                  top: 12,
                                  right: 12,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.primary,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.2),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      '\$${(table['price'] as double? ?? 100.0).toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Content Section
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Table Name and Info
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      table['name'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (isSelected)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.primary,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        'Selected',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const Gap(8),
                              if (table['description'] != null && table['description'].isNotEmpty) ...[
                                Text(
                                  table['description'],
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                                    fontSize: 12,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Gap(8),
                              ],
                              Row(
                                children: [
                                  Icon(
                                    Iconsax.user,
                                    size: 14,
                                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                                  ),
                                  const Gap(4),
                                  Text(
                                    '${table['capacity']} people',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                                    ),
                                  ),
                                  const Gap(12),
                                  Icon(
                                    Iconsax.cup,
                                    size: 14,
                                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                                  ),
                                  const Gap(4),
                                  Expanded(
                                    child: Text(
                                      '${table['minimum_bottles'] ?? 1} bottle minimum',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }



  void _proceedToPayment(
    BuildContext context,
    WidgetRef ref,
    TableBookingFormData formState,
    Map<String, double> costs,
  ) async {
    final eventId = widget.eventId;
    if (formState.selectedTable == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a table first'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Navigate directly to payment screen without creating booking yet
    try {
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentScreen(
              amount: costs['total']!,
              currency: 'USD',
              description: 'Event Table Booking - ${formState.selectedTable!['name']}',
              paymentType: PaymentType.tableBooking,
              bookingId: null, // No booking created yet
              metadata: {
                'event_id': eventId,
                'table_id': formState.selectedTable!['id'],
                'table_name': formState.selectedTable!['name'],
                'party_size': formState.partySize.toString(),
                'deposit_amount': formState.selectedTable!['deposit_amount'].toString(),
                'minimum_bottles': formState.selectedTable!['minimum_bottles'].toString(),
                'special_requests': formState.specialRequests ?? '',
                'guest_names': formState.guestNames.join(','),
                'split_payment_enabled': formState.enableSplitPayment.toString(),
                'selected_bottles': formState.selectedBottles.toString(),
                // Cost breakdown for accurate payment summary
                'table_cost': costs['deposit']!.toString(),
                'bottles_cost': (costs['bottles'] ?? 0.0).toString(),
                'service_fee': costs['service_fee']!.toString(),
                'tax': costs['tax']!.toString(),
                'total': costs['total']!.toString(),
              },
              onPaymentSuccess: () async {
                // Create booking only after successful payment
                final booking = await EventBookingService().createTableBooking(
                  eventId: eventId,
                  tableId: formState.selectedTable!['id'],
                  partySize: formState.partySize,
                  depositAmount: formState.selectedTable!['deposit_amount'].toDouble(),
                  minimumBottles: formState.selectedTable!['minimum_bottles'],
                  specialRequests: formState.specialRequests,
                  splitPayments: formState.enableSplitPayment ? formState.splitPaymentParticipants : null,
                );
                await EventBookingService().updateDepositPaymentStatus(
                  booking.id,
                  true,
                  null,
                );

                // Invalidate providers so both event detail and bookings tab refresh
                ref.invalidate(userEventTableBookingProvider);
                ref.invalidate(userBookingsProvider);

                // Get event data for the success dialog and email
                final eventWithClub = await ref.read(eventByIdProvider(eventId).future);

                // Send booking confirmation email
                try {
                  if (eventWithClub != null) {
                    final userEmail = booking.userId.isNotEmpty
                        ? (await _supabase.auth.getUser()).user?.email
                        : null;
                    if (userEmail != null) {
                      await EmailService().sendTableBookingConfirmationEmail(
                        to: userEmail,
                        customerName: (await _supabase.auth.getUser()).user?.userMetadata?['full_name'] as String? ?? userEmail,
                        eventName: eventWithClub.name,
                        eventDate: eventWithClub.formattedDate,
                        eventTime: eventWithClub.formattedTime,
                        venue: eventWithClub.venueDisplay,
                        confirmationCode: booking.id.substring(0, 8).toUpperCase(),
                        tableName: formState.selectedTable!['name'],
                        partySize: formState.partySize,
                        depositAmount: formState.selectedTable!['deposit_amount'].toDouble(),
                      );
                    }
                  }
                } catch (_) {
                  // Email failure must not block the booking success flow
                }

                // Show success dialog with Apple Wallet option
                if (context.mounted && eventWithClub != null) {
                  await showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => BookingSuccessDialog(
                      eventId: eventId,
                      bookingId: booking.id,
                      event: eventWithClub,
                      tableBooking: booking,
                      tableName: formState.selectedTable!['name'],
                    ),
                  );
                }
              },
              onPaymentFailed: () async {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Payment failed. Please try again.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              // Event booking specific details
              clubName: ref.read(eventByIdProvider(eventId)).maybeWhen(
                data: (eventWithClub) => eventWithClub?.venueDisplay ?? 'Event Venue',
                orElse: () => 'Event Venue',
              ),
              date: ref.read(eventByIdProvider(eventId)).maybeWhen(
                data: (eventWithClub) => eventWithClub?.formattedDate ?? 'Event Date',
                orElse: () => 'Event Date',
              ),
              timeSlot: ref.read(eventByIdProvider(eventId)).maybeWhen(
                data: (eventWithClub) => eventWithClub?.formattedTime ?? 'Event Time',
                orElse: () => 'Event Time',
              ),
              tableName: formState.selectedTable!['name'],
              guestCount: formState.partySize,
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Booking failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

// RSVP Form Widget
class _RSVPForm extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formNotifier = ref.read(rSVPFormStateProvider.notifier);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'First Name *',
                  border: OutlineInputBorder(),
                ),
                onChanged: formNotifier.updateFirstName,
              ),
            ),
            const Gap(16),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Last Name *',
                  border: OutlineInputBorder(),
                ),
                onChanged: formNotifier.updateLastName,
              ),
            ),
          ],
        ),

        const Gap(16),

        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Email Address *',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: formNotifier.updateEmail,
        ),

        const Gap(16),

        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Phone Number (Optional)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
          onChanged: formNotifier.updatePhone,
        ),

        const Gap(16),

        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Special Requests (Optional)',
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
          maxLines: 3,
          onChanged: formNotifier.updateSpecialRequests,
        ),
      ],
    );
  }
}

// Table Booking Form Widget
class _TableBookingForm extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(tableBookingFormStateProvider);
    final formNotifier = ref.read(tableBookingFormStateProvider.notifier);

    if (formState.selectedTable == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Party Details',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const Gap(16),

        Row(
          children: [
            const Text('Party Size: '),
            const Gap(16),
            Row(
              children: [
                IconButton(
                  onPressed: formState.partySize > 1
                      ? () => formNotifier.updatePartySize(formState.partySize - 1)
                      : null,
                  icon: const Icon(Icons.remove),
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  ),
                ),
                const Gap(16),
                Text(
                  formState.partySize.toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(16),
                IconButton(
                  onPressed: formState.partySize < (formState.selectedTable?['capacity'] ?? 10)
                      ? () => formNotifier.updatePartySize(formState.partySize + 1)
                      : null,
                  icon: const Icon(Icons.add),
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  ),
                ),
              ],
            ),
          ],
        ),

        const Gap(16),

        // Guest Names Section
        ExpansionTile(
          title: Text(
            'Guest Names (Optional)',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            formState.guestNames.isEmpty
              ? 'Add guest names for easier check-in'
              : '${formState.guestNames.length} names added',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Display existing guest names
                  ...formState.guestNames.asMap().entries.map((entry) {
                    final index = entry.key;
                    final name = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: name,
                              decoration: InputDecoration(
                                labelText: 'Guest ${index + 1}',
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () {
                                    final updatedNames = List<String>.from(formState.guestNames);
                                    updatedNames.removeAt(index);
                                    formNotifier.updateGuestNames(updatedNames);
                                  },
                                ),
                              ),
                              onChanged: (value) {
                                final updatedNames = List<String>.from(formState.guestNames);
                                updatedNames[index] = value;
                                formNotifier.updateGuestNames(updatedNames);
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  // Add new guest button
                  if (formState.guestNames.length < formState.partySize)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          final updatedNames = List<String>.from(formState.guestNames);
                          updatedNames.add('');
                          formNotifier.updateGuestNames(updatedNames);
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add Guest Name'),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),

        const Gap(16),

        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Special Requests (Optional)',
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
          maxLines: 3,
          onChanged: formNotifier.updateSpecialRequests,
        ),

        const Gap(16),

        CheckboxListTile(
          title: const Text('Enable Split Payment'),
          subtitle: const Text('Split the cost between multiple people'),
          value: formState.enableSplitPayment,
          onChanged: (value) => formNotifier.setEnableSplitPayment(value ?? false),
          controlAffinity: ListTileControlAffinity.leading,
        ),

        if (formState.enableSplitPayment) ...[
          const Gap(16),
          Text(
            'Split Payment (Coming Soon)',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(8),
          Text(
            'Split payment functionality will be available soon. For now, the primary booker pays the full amount.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ],
    );
  }

}

// Bottle Selection Widget
class _BottleSelection extends ConsumerWidget {
  final String eventId;

  const _BottleSelection({required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottlesAsync = ref.watch(availableBottlesProvider(eventId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Bottles (Optional)',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(8),
        Text(
          'Add bottles to your table reservation for a complete VIP experience',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const Gap(16),

        bottlesAsync.when(
          data: (bottles) {
            if (bottles.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.wine_bar,
                      size: 48,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    const Gap(12),
                    Text(
                      'No bottles available for this event',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }

            // Group bottles by category
            final groupedBottles = <String, List<Map<String, dynamic>>>{};
            for (final bottle in bottles) {
              final category = bottle['category'] as String;
              groupedBottles.putIfAbsent(category, () => []).add(bottle);
            }

            return Column(
              children: groupedBottles.entries.map((entry) {
                final category = entry.key;
                final categoryBottles = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.toUpperCase(),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const Gap(12),
                    SizedBox(
                      height: 240, // Further increased to accommodate enhanced content
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categoryBottles.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 200,
                            margin: EdgeInsets.only(
                              right: index < categoryBottles.length - 1 ? 12 : 0,
                            ),
                            child: _MinimalBottleCard(bottle: categoryBottles[index]),
                          );
                        },
                      ),
                    ),
                    const Gap(16),
                  ],
                );
              }).toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.error, color: Colors.red),
                const Gap(12),
                Expanded(
                  child: Text(
                    'Error loading bottles: $error',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// _BottleCard removed — was dead code with disconnected local state. Use _MinimalBottleCard.

// Minimal Bottle Card Widget for horizontal scrolling
class _MinimalBottleCard extends ConsumerStatefulWidget {
  final Map<String, dynamic> bottle;

  const _MinimalBottleCard({required this.bottle});

  @override
  ConsumerState<_MinimalBottleCard> createState() => _MinimalBottleCardState();
}

class _MinimalBottleCardState extends ConsumerState<_MinimalBottleCard> {
  @override
  Widget build(BuildContext context) {
    final bottle = widget.bottle;
    final formState = ref.watch(tableBookingFormStateProvider);
    final formNotifier = ref.read(tableBookingFormStateProvider.notifier);
    final quantity = formState.selectedBottles[bottle['id']] ?? 0;
    final price = bottle['price'] as double? ?? 0.0;
    final isFeatured = bottle['is_featured'] as bool? ?? false;
    final imageUrl = bottle['image_url'] as String?;
    final brand = bottle['brand'] as String?;
    final volume = bottle['volume_ml'] as int?;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: quantity > 0
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)
              : Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          width: quantity > 0 ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: quantity > 0
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: quantity > 0 ? 8 : 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image and Featured Badge - Enhanced
          Container(
            height: 120, // Increased height for more emphasis
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Stack(
              children: [
                if (imageUrl != null)
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.1),
                          ],
                        ),
                      ),
                      child: Image.network(
                        imageUrl,
                        width: double.infinity,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              Icons.wine_bar,
                              size: 48,
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                else
                  Center(
                    child: Icon(
                      Icons.wine_bar,
                      size: 48,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),

                // Featured Badge
                if (isFeatured)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Text(
                        'FEATURED',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Content - Optimized layout
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10), // Reduced padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Use minimum space needed
                children: [
                  // Name
                  Text(
                    bottle['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Brand and Volume in one line if possible
                  if (brand != null || volume != null) ...[
                    const Gap(2),
                    Row(
                      children: [
                        if (brand != null)
                          Expanded(
                            child: Text(
                              brand,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                                fontSize: 11,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        if (brand != null && volume != null) const Gap(4),
                        if (volume != null)
                          Text(
                            '${volume}ml',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                              fontSize: 11,
                            ),
                          ),
                      ],
                    ),
                  ],
                  const Spacer(),

                  // Price and Quantity - Enhanced UI
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '\$${price.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          if (quantity > 0)
                            Text(
                              '${quantity}x = \$${(price * quantity).toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 11,
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),

                      // Conditional Quantity Controls
                      if (quantity == 0)
                        // Floating Add Button
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () => formNotifier.updateBottleQuantity(bottle['id'], 1),
                              child: const Icon(
                                Icons.add,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      else
                        // Increment/Decrement Controls
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainer,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () => formNotifier.updateBottleQuantity(bottle['id'], quantity - 1),
                                  child: SizedBox(
                                    width: 32,
                                    height: 32,
                                    child: Icon(
                                      Icons.remove,
                                      size: 16,
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                constraints: const BoxConstraints(minWidth: 32),
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  quantity.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () => formNotifier.updateBottleQuantity(bottle['id'], quantity + 1),
                                  child: SizedBox(
                                    width: 32,
                                    height: 32,
                                    child: Icon(
                                      Icons.add,
                                      size: 16,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}