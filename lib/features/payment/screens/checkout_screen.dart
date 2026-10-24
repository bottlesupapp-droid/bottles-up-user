import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/payment_service.dart';

/// Modern checkout screen using Supabase Edge Functions
/// NO hardcoded Stripe keys - all payment processing via edge functions
class CheckoutScreen extends ConsumerStatefulWidget {
  final String paymentType;
  final double amount;
  final String? bookingId;
  final String? eventId;
  final String? description;
  final Map<String, dynamic>? metadata;

  const CheckoutScreen({
    super.key,
    required this.paymentType,
    required this.amount,
    this.bookingId,
    this.eventId,
    this.description,
    this.metadata,
  });

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> with WidgetsBindingObserver {
  final PaymentService _paymentService = PaymentService();

  PaymentState _paymentState = PaymentState.idle;
  String? _errorMessage;
  // Stored after checkout session is created so we can verify on app resume.
  String? _pendingSessionId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    debugPrint('🏦 [CS-1] CheckoutScreen.initState — paymentType=${widget.paymentType} eventId=${widget.eventId} metadata=${widget.metadata}');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('🏦 [CS-2] addPostFrameCallback fired — mounted=$mounted');
      if (widget.paymentType == 'success') {
        debugPrint('🏦 [CS-3] Routing to _handlePaymentSuccess');
        _handlePaymentSuccess();
      } else {
        debugPrint('🏦 [CS-3] Routing to _initiatePayment');
        _initiatePayment();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Called by the OS whenever the app lifecycle changes.
  /// If the user returns from the browser while we're waiting for payment,
  /// verify the session directly — this is the fallback when deep links fail.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('🏦 [CS-LIFECYCLE] state=$state paymentState=$_paymentState pendingSession=$_pendingSessionId');
    if (state == AppLifecycleState.resumed &&
        _paymentState == PaymentState.waitingConfirmation &&
        _pendingSessionId != null) {
      debugPrint('🏦 [CS-LIFECYCLE] App resumed with pending session — verifying payment');
      // Small delay to let the deep link handler run first; if it also fires
      // we'll be in a different state by then and this becomes a no-op.
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted && _paymentState == PaymentState.waitingConfirmation) {
          debugPrint('🏦 [CS-LIFECYCLE] Deep link did not fire — using lifecycle fallback');
          _verifyPendingPayment(_pendingSessionId!);
        }
      });
    }
  }

  /// Verify a pending Stripe checkout session (used by lifecycle fallback).
  Future<void> _verifyPendingPayment(String sessionId) async {
    debugPrint('🏦 [CS-VERIFY-1] _verifyPendingPayment($sessionId)');
    if (!mounted) return;
    setState(() { _paymentState = PaymentState.loading; });
    try {
      final verification = await _paymentService.verifyCheckoutSession(sessionId);
      debugPrint('🏦 [CS-VERIFY-2] result: isPaid=${verification.isPaid} status=${verification.paymentStatus}');
      if (!mounted) return;
      if (verification.isPaid) {
        if (widget.eventId != null && widget.eventId!.isNotEmpty) {
          try { await _createBooking(sessionId, verification.amount); } catch (e) {
            debugPrint('⚠️ [CS-VERIFY] Booking failed: $e');
          }
        }
        if (mounted) setState(() { _paymentState = PaymentState.success; });
      } else {
        // Not paid yet — could still be processing; go back to waiting
        debugPrint('⚠️ [CS-VERIFY-3] Not paid yet (${verification.paymentStatus}) — returning to waiting');
        if (mounted) setState(() { _paymentState = PaymentState.waitingConfirmation; });
      }
    } catch (e, stack) {
      debugPrint('❌ [CS-VERIFY-ERR] $e\n$stack');
      if (mounted) setState(() {
        _paymentState = PaymentState.failed;
        _errorMessage = 'Could not verify payment: $e';
      });
    }
  }

  /// Handle payment success from deep link
  Future<void> _handlePaymentSuccess() async {
    debugPrint('🏦 [CS-SUCCESS-1] _handlePaymentSuccess entry');
    final sessionId = widget.metadata?['session_id'] as String?;
    debugPrint('🏦 [CS-SUCCESS-2] sessionId from metadata: $sessionId');

    if (sessionId == null || sessionId.isEmpty) {
      debugPrint('❌ [CS-SUCCESS-ERR] No session ID found in metadata: ${widget.metadata}');
      setState(() {
        _paymentState = PaymentState.failed;
        _errorMessage = 'Invalid payment session';
      });
      return;
    }

    debugPrint('🏦 [CS-SUCCESS-3] Setting state to loading');
    setState(() {
      _paymentState = PaymentState.loading;
    });

    try {
      debugPrint('🏦 [CS-SUCCESS-4] Calling verifyCheckoutSession($sessionId)');
      final verification = await _paymentService.verifyCheckoutSession(sessionId);
      debugPrint('🏦 [CS-SUCCESS-5] verifyCheckoutSession returned — isPaid=${verification.isPaid} status=${verification.paymentStatus} amount=${verification.amount}');

      if (verification.isPaid) {
        debugPrint('✅ [CS-SUCCESS-6] Payment verified — amount=${verification.amount} ${verification.currency}');

        if (widget.eventId != null && widget.eventId!.isNotEmpty) {
          debugPrint('🏦 [CS-SUCCESS-7] Creating booking for event=${widget.eventId}');
          try {
            await _createBooking(sessionId, verification.amount);
            debugPrint('✅ [CS-SUCCESS-8] Booking created successfully');
          } catch (e, stack) {
            debugPrint('⚠️ [CS-SUCCESS-8-WARN] Booking creation failed: $e');
            debugPrint('⚠️ Stack: $stack');
          }
        } else {
          debugPrint('🏦 [CS-SUCCESS-7] No eventId — skipping booking creation');
        }

        debugPrint('🏦 [CS-SUCCESS-9] Setting state to success — mounted=$mounted');
        if (mounted) {
          setState(() {
            _paymentState = PaymentState.success;
          });
          debugPrint('✅ [CS-SUCCESS-10] State set to success — UI should show success screen');
        }
      } else {
        debugPrint('❌ [CS-SUCCESS-6b] Payment not completed: ${verification.paymentStatus}');
        if (mounted) {
          setState(() {
            _paymentState = PaymentState.failed;
            _errorMessage = 'Payment was not completed. Status: ${verification.paymentStatus}';
          });
        }
      }
    } on PaymentException catch (e) {
      debugPrint('❌ [CS-SUCCESS-ERR] PaymentException: ${e.message}');
      if (mounted) {
        setState(() {
          _paymentState = PaymentState.failed;
          _errorMessage = e.message;
        });
      }
    } catch (e, stack) {
      debugPrint('❌ [CS-SUCCESS-ERR] Unexpected error: $e');
      debugPrint('❌ Stack: $stack');
      if (mounted) {
        setState(() {
          _paymentState = PaymentState.failed;
          _errorMessage = 'Payment verification failed: $e';
        });
      }
    }
  }

  /// Create booking after successful payment
  Future<void> _createBooking(String sessionId, double? amount) async {
    debugPrint('📝 [BOOKING-1] Creating booking — event=${widget.eventId} session=$sessionId amount=$amount');

    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('User not authenticated');
    }

    // Generate confirmation code
    final confirmationCode = 'BU${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';

    // Get ticket quantity from metadata
    final ticketQuantity = widget.metadata?['ticket_quantity'] as int? ?? 1;

    // Create booking record
    final booking = await supabase.from('events_bookings').insert({
      'user_id': user.id,
      'event_id': widget.eventId,
      'ticket_quantity': ticketQuantity,
      'total_amount': amount != null ? (amount / 100) : (widget.amount), // Convert from cents if from Stripe
      'status': 'confirmed',
      'confirmation_code': confirmationCode,
      'payment_status': 'paid',
      'stripe_session_id': sessionId,
      'created_at': DateTime.now().toIso8601String(),
    }).select().single();

    debugPrint('✅ [BOOKING-2] Booking created: ${booking['id']}');
    debugPrint('🎫 [BOOKING-3] Confirmation code: $confirmationCode');
  }

  /// Step 1: Create Checkout Session and redirect to Stripe hosted page
  Future<void> _initiatePayment() async {
    setState(() {
      _paymentState = PaymentState.loading;
      _errorMessage = null;
    });

    try {
      debugPrint('💳 Creating Stripe checkout session...');

      // Call edge function to create checkout session
      final checkoutResult = await _paymentService.createCheckoutSession(
        paymentType: widget.paymentType,
        amount: widget.amount,
        bookingId: widget.bookingId,
        eventId: widget.eventId,
        description: widget.description ?? 'BottlesUp Payment',
        metadata: widget.metadata,
      );

      debugPrint('💳 Checkout session created: ${checkoutResult.checkoutUrl}');

      // Store session ID so the lifecycle fallback can verify it when the
      // app resumes from the browser (in case deep links don't fire).
      _pendingSessionId = checkoutResult.sessionId;
      debugPrint('🏦 [CS-PENDING] Stored pending session: $_pendingSessionId');

      if (mounted) {
        setState(() {
          _paymentState = PaymentState.waitingConfirmation;
        });
      }

      debugPrint('💳 Opening Stripe checkout page...');

      // Open Stripe checkout page in browser
      // User completes payment there and returns via deep link
      await _paymentService.openCheckoutPage(checkoutResult.checkoutUrl);

      // After opening the checkout page, we wait for the deep link callback
      // The deep link handler will update the payment state

    } on PaymentException catch (e) {
      if (!mounted) return;
      debugPrint('❌ Payment error: ${e.message}');
      setState(() {
        _paymentState = PaymentState.failed;
        _errorMessage = e.message;
      });
    } catch (e) {
      if (!mounted) return;
      debugPrint('❌ Payment error: $e');
      setState(() {
        _paymentState = PaymentState.failed;
        _errorMessage = 'Payment failed: $e';
      });
    }
  }

  /// Retry payment
  void _retry() {
    _initiatePayment();
  }

  /// Cancel and go back
  void _cancel() {
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return PopScope(
      canPop: _paymentState == PaymentState.idle ||
          _paymentState == PaymentState.success ||
          _paymentState == PaymentState.failed ||
          _paymentState == PaymentState.cancelled,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: AppBar(
          backgroundColor: theme.colorScheme.surface,
          elevation: 0,
          leading: _canGoBack
              ? IconButton(
                  onPressed: _cancel,
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: theme.colorScheme.onSurface,
                  ),
                )
              : null,
          title: Text(
            'Payment',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: _buildContent(theme, primaryColor),
          ),
        ),
      ),
    );
  }

  bool get _canGoBack =>
      _paymentState == PaymentState.idle ||
      _paymentState == PaymentState.success ||
      _paymentState == PaymentState.failed ||
      _paymentState == PaymentState.cancelled;

  Widget _buildContent(ThemeData theme, Color primaryColor) {
    switch (_paymentState) {
      case PaymentState.idle:
        return _buildIdleState(theme, primaryColor);
      case PaymentState.loading:
        return _buildLoadingState(theme, primaryColor, 'Creating payment session...');
      case PaymentState.openingCheckout:
        return _buildLoadingState(theme, primaryColor, 'Opening payment page...');
      case PaymentState.waitingConfirmation:
        return _buildWaitingState(theme, primaryColor);
      case PaymentState.success:
        return _buildSuccessState(theme, primaryColor);
      case PaymentState.failed:
        return _buildFailedState(theme, primaryColor);
      case PaymentState.cancelled:
        return _buildCancelledState(theme, primaryColor);
    }
  }

  Widget _buildIdleState(ThemeData theme, Color primaryColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Iconsax.card,
          size: 80,
          color: primaryColor,
        ),
        const Gap(24),
        Text(
          'Ready to pay',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(12),
        Text(
          '\$${widget.amount.toStringAsFixed(2)}',
          style: theme.textTheme.displaySmall?.copyWith(
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState(ThemeData theme, Color primaryColor, String message) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LoadingAnimationWidget.threeArchedCircle(
          color: primaryColor,
          size: 60,
        ),
        const Gap(24),
        Text(
          message,
          style: theme.textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        const Gap(12),
        Text(
          'Please wait...',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildWaitingState(ThemeData theme, Color primaryColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Iconsax.card_tick,
            size: 60,
            color: primaryColor,
          ),
        ),
        const Gap(24),
        Text(
          'Waiting for payment',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const Gap(12),
        Text(
          'Complete your payment in the browser window',
          style: theme.textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const Gap(8),
        Text(
          'This screen will update automatically when payment is complete',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          textAlign: TextAlign.center,
        ),
        const Gap(32),
        LoadingAnimationWidget.beat(
          color: primaryColor,
          size: 40,
        ),
      ],
    );
  }

  Widget _buildSuccessState(ThemeData theme, Color primaryColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Iconsax.tick_circle,
            color: Colors.green,
            size: 80,
          ),
        ),
        const Gap(24),
        Text(
          'Payment Successful!',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
          textAlign: TextAlign.center,
        ),
        const Gap(12),
        Text(
          'Your payment of \$${widget.amount.toStringAsFixed(2)} has been processed',
          style: theme.textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const Gap(32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              context.pop();
              // Navigate to orders or confirmation
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'View Order',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFailedState(ThemeData theme, Color primaryColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Iconsax.close_circle,
            color: Colors.red,
            size: 80,
          ),
        ),
        const Gap(24),
        Text(
          'Payment Failed',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
          textAlign: TextAlign.center,
        ),
        const Gap(12),
        Text(
          _errorMessage ?? 'Something went wrong with your payment',
          style: theme.textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const Gap(32),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _cancel,
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.onSurface,
                  side: BorderSide(color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const Gap(12),
            Expanded(
              child: ElevatedButton(
                onPressed: _retry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Retry',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCancelledState(ThemeData theme, Color primaryColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.orange.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Iconsax.info_circle,
            color: Colors.orange,
            size: 80,
          ),
        ),
        const Gap(24),
        Text(
          'Payment Cancelled',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
          textAlign: TextAlign.center,
        ),
        const Gap(12),
        Text(
          'You cancelled the payment',
          style: theme.textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const Gap(32),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _cancel,
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.onSurface,
                  side: BorderSide(color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Go Back',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const Gap(12),
            Expanded(
              child: ElevatedButton(
                onPressed: _retry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Try Again',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Payment flow states
enum PaymentState {
  idle,
  loading,
  openingCheckout,
  waitingConfirmation,
  success,
  failed,
  cancelled,
}
