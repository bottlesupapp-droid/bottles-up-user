import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:go_router/go_router.dart';
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

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final PaymentService _paymentService = PaymentService();

  PaymentState _paymentState = PaymentState.idle;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Start payment flow automatically
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initiatePayment();
    });
  }

  /// Step 1: Create Payment Intent and present in-app Payment Sheet
  Future<void> _initiatePayment() async {
    setState(() {
      _paymentState = PaymentState.loading;
      _errorMessage = null;
    });

    try {
      // Call edge function to create payment intent for in-app payment
      final paymentIntent = await _paymentService.createPaymentIntent(
        paymentType: widget.paymentType,
        amount: widget.amount,
        bookingId: widget.bookingId,
        eventId: widget.eventId,
        description: widget.description ?? 'BottlesUp Payment',
        metadata: widget.metadata,
      );

      // Step 2: Present Payment Sheet IN-APP
      setState(() {
        _paymentState = PaymentState.openingCheckout;
      });

      final success = await _paymentService.presentPaymentSheet(
        paymentIntent: paymentIntent,
        enableGooglePay: true,
        enableApplePay: true,
      );

      if (success) {
        setState(() {
          _paymentState = PaymentState.success;
        });
      } else {
        setState(() {
          _paymentState = PaymentState.cancelled;
          _errorMessage = 'Payment was cancelled';
        });
      }
    } on PaymentException catch (e) {
      if (e.message.contains('cancelled') || e.message.contains('canceled')) {
        setState(() {
          _paymentState = PaymentState.cancelled;
          _errorMessage = 'Payment was cancelled';
        });
      } else {
        setState(() {
          _paymentState = PaymentState.failed;
          _errorMessage = e.message;
        });
      }
    } catch (e) {
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
