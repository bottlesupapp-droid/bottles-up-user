import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide PaymentIntent;
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:bottles_up_user/core/services/payment_service.dart';
import 'package:bottles_up_user/core/models/payment_models.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../club/models/club_table.dart';
import '../../club/models/bottle.dart';

enum PaymentMethod {
  stripe,
}

class PaymentScreen extends ConsumerStatefulWidget {
  final double amount;
  final String currency;
  final String description;
  final PaymentType paymentType;
  final String? bookingId;
  final Map<String, dynamic>? metadata;
  final Future<void> Function()? onPaymentSuccess;
  final Future<void> Function()? onPaymentFailed;
  // Booking details
  final String? clubName;
  final String? date;
  final String? timeSlot;
  final String? tableName;
  final int? guestCount;
  // Table and bottles data
  final ClubTable? selectedTable;
  final List<Bottle>? selectedBottles;

  const PaymentScreen({
    super.key,
    required this.amount,
    this.currency = 'USD',
    required this.description,
    required this.paymentType,
    this.bookingId,
    this.metadata,
    this.onPaymentSuccess,
    this.onPaymentFailed,
    this.clubName,
    this.date,
    this.timeSlot,
    this.tableName,
    this.guestCount,
    this.selectedTable,
    this.selectedBottles,
  });

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  final PaymentService _paymentService = PaymentService();
  // iOS: embedded card form controller — avoids native payment sheet modal
  // which has a UIKit completion-handler bug on iOS 16+ causing it to hang.
  final CardFormEditController _cardController = CardFormEditController();
  bool _isProcessing = false;
  String? _errorMessage;
  PaymentIntent? _paymentIntent;
  PaymentMethod _selectedPaymentMethod = PaymentMethod.stripe;

  @override
  void initState() {
    super.initState();
    // Rebuild when card form completeness changes so Pay button enables/disables.
    _cardController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }

  bool _canProcessPayment() {
    if (_isProcessing) return false;
    // On iOS with the embedded card form, require all card fields to be filled.
    if (Platform.isIOS) {
      return _cardController.details.complete == true;
    }
    return true;
  }

  Future<void> _processPayment() async {
    try {
      setState(() {
        _isProcessing = true;
        _errorMessage = null;
      });

      await _processStripePayment();
      // Stripe payment redirect happens, return from Stripe is handled via deep links
      return;
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _errorMessage = 'Payment failed: ${e.toString()}';
      });
      await widget.onPaymentFailed?.call();
    }
  }

  Future<void> _processStripePayment() async {
    try {
      debugPrint('💳 Starting payment process...');

      final paymentIntent = await _paymentService.createPaymentIntent(
        paymentType: widget.paymentType.name,
        amount: widget.amount,
        bookingId: widget.bookingId,
        description: widget.description,
        metadata: widget.metadata,
      );

      debugPrint('💳 Payment intent created, confirming payment...');

      final bool success;
      if (Platform.isIOS) {
        // iOS: use embedded CardFormField + confirmPayment.
        // The native payment sheet (presentPaymentSheet) has a UIKit
        // UISheetPresentationController bug on iOS 16+ where the completion
        // handler never fires → the sheet hangs. Using confirmPayment with
        // the mounted CardFormField avoids the modal entirely and fires the
        // completion handler through a simpler, reliable code path.
        success = await _paymentService.confirmPaymentWithCard(
          paymentIntent: paymentIntent,
          userEmail: _paymentService.currentUser?.email,
        );
      } else {
        success = await _paymentService.presentPaymentSheet(
          paymentIntent: paymentIntent,
          enableGooglePay: true,
          enableApplePay: true,
        );
      }

      debugPrint('💳 Payment sheet result: $success');

      if (success) {
        // On iOS the native payment sheet dismisses asynchronously — give the
        // Flutter engine 100 ms to reclaim the responder chain before any UI
        // ops or Supabase writes.
        await Future.delayed(const Duration(milliseconds: 100));
        if (!mounted) return;

        // Run booking-creation FIRST so the record lands in DB before the
        // success dialog shows and the user can navigate away.
        try {
          await widget.onPaymentSuccess?.call();
        } catch (callbackError) {
          // Payment charged successfully but booking insert failed.
          // Show the error so the user knows to contact support.
          debugPrint('❌ Booking insert failed after payment: $callbackError');
          if (mounted) {
            setState(() { _isProcessing = false; });
            _showErrorDialog(
              'Payment was charged but your booking could not be saved.\n'
              'Please contact support with this reference: ${DateTime.now().millisecondsSinceEpoch}',
            );
          }
          return;
        }

        if (!mounted) return;
        setState(() { _isProcessing = false; });
        _showSuccessDialog();
      }
    } on PaymentException catch (e) {
      debugPrint('💳 Payment exception: ${e.message}');
      if (mounted) {
        if (e.message.contains('cancelled') || e.message.contains('canceled')) {
          setState(() {
            _isProcessing = false;
            _errorMessage = null;
          });
        } else {
          setState(() {
            _isProcessing = false;
            _errorMessage = e.message;
          });
          _showErrorDialog(e.message);
          await widget.onPaymentFailed?.call();
        }
      }
    } catch (e) {
      debugPrint('💳 Payment error: $e');
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _errorMessage = 'Payment failed: ${e.toString()}';
        });
        _showErrorDialog(e.toString());
        await widget.onPaymentFailed?.call();
      }
    }
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Failed'),
        content: Text(
          error.contains('account') || error.contains('incomplete')
              ? 'Your payment account needs additional setup. Please check:\n\n'
                  '• Your payment method is valid\n'
                  '• Your account information is complete\n'
                  '• You have sufficient funds\n\n'
                  'Error: $error'
              : 'Unable to process payment.\n\n$error',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Go back to previous screen
            },
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Retry payment
              setState(() {
                _errorMessage = null;
              });
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    const paymentMethodName = 'Card';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Iconsax.tick_circle,
                color: Colors.green,
                size: 60,
              ),
            ),
            const Gap(20),
            const Text(
              'Payment Successful!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(10),
            Text(
              'Your payment of \$${_getTotal().toStringAsFixed(2)} has been processed successfully via $paymentMethodName.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const Gap(20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pop(); // Close payment screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateTotal() {
    double total = widget.amount; // Use the amount passed from booking

    // Add bottles cost
    if (widget.selectedBottles != null) {
      for (final bottle in widget.selectedBottles!) {
        total += bottle.price;
      }
    }

    total += 10.0; // Service fee
    final tax = total * 0.08; // 8% tax
    total += tax;

    return total;
  }

  double _getBottlesTotal() {
    if (widget.selectedBottles == null || widget.selectedBottles!.isEmpty) return 0.0;
    return widget.selectedBottles!.fold(0.0, (sum, bottle) => sum + bottle.price);
  }

  // Helper methods to get cost breakdown from metadata
  double _getTableCost() {
    if (widget.metadata != null && widget.metadata!['table_cost'] != null) {
      return double.tryParse(widget.metadata!['table_cost']) ?? widget.amount;
    }
    return widget.amount;
  }

  double _getBottlesCost() {
    if (widget.metadata != null && widget.metadata!['bottles_cost'] != null) {
      return double.tryParse(widget.metadata!['bottles_cost']) ?? 0.0;
    }
    return _getBottlesTotal(); // Fallback to old calculation
  }

  double _getServiceFee() {
    if (widget.metadata != null && widget.metadata!['service_fee'] != null) {
      return double.tryParse(widget.metadata!['service_fee']) ?? 0.0;
    }
    return 0.0; // Fallback
  }

  double _getTax() {
    if (widget.metadata != null && widget.metadata!['tax'] != null) {
      return double.tryParse(widget.metadata!['tax']) ?? 0.0;
    }
    return 0.0; // Fallback
  }

  double _getTotal() {
    if (widget.metadata != null && widget.metadata!['total'] != null) {
      return double.tryParse(widget.metadata!['total']) ?? widget.amount;
    }
    return _calculateTotal(); // Fallback to old calculation
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: theme.colorScheme.onSurface,
          ),
        ),
        title: Text(
          'Checkout',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(child: _buildProgressBar(1.0, primaryColor)),
                const Gap(8),
                Expanded(child: _buildProgressBar(0.5, primaryColor)),
                const Gap(8),
                Expanded(child: _buildProgressBar(0.0, primaryColor)),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Main content
          Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TEST MODE BANNER
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      border: Border.all(color: Colors.orange, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: Colors.orange, size: 24),
                        const Gap(12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '🧪 TEST MODE',
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const Gap(4),
                              Text(
                                'Use test card: 4242 4242 4242 4242\nAny CVC, future date',
                                style: TextStyle(
                                  color: Colors.orange.shade700,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildBookingDetails(theme, primaryColor),
                  const Gap(24),
                  _buildTableSection(theme, primaryColor),
                  const Gap(24),
                  _buildBottlesSection(theme, primaryColor),
                  const Gap(24),
                  _buildGuestInfoSection(theme, primaryColor),
                  const Gap(24),
                  _buildPromoCodeSection(theme, primaryColor),
                  const Gap(24),
                  _buildPaymentMethodSection(theme, primaryColor),
                  const Gap(24),
                  _buildSummarySection(theme, primaryColor),
                  const Gap(24),
                  _buildTermsText(theme),
                  const Gap(20),
                ],
              ),
            ),
          ),

          // Fixed bottom payment button
          Positioned(
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
                color: theme.colorScheme.surface.withOpacity(0.9),
                border: Border(
                  top: BorderSide(
                    color: primaryColor.withOpacity(0.1),
                    width: 1,
                  ),
                ),
              ),
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, primaryColor.withOpacity(0.8)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _canProcessPayment() ? _processPayment : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.transparent,
                    disabledForegroundColor: Colors.white.withValues(alpha: 0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isProcessing
                      ? LoadingAnimationWidget.staggeredDotsWave(
                          color: Colors.white,
                          size: 24,
                        )
                      : Text(
                          'Pay \$${_getTotal().toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ),

          // Error overlay
          if (_errorMessage != null)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.red.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Iconsax.warning_2,
                      color: Colors.red,
                      size: 20,
                    ),
                    const Gap(12),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(double progress, Color primaryColor) {
    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(2),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassyCard(Widget child, ThemeData theme, Color primaryColor) {
    return Container(
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: primaryColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: child,
    );
  }

  Widget _buildBookingDetails(ThemeData theme, Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Booking Details',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(12),
        _buildGlassyCard(
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildDetailRow('Date', widget.date ?? 'Not specified', theme),
                _buildDetailRow('Time', widget.timeSlot ?? 'Not specified', theme),
                _buildDetailRow('Location', widget.clubName ?? 'Club Name', theme),
                _buildDetailRow('Table Number', widget.tableName ?? 'Table', theme),
                _buildDetailRow('Guest Capacity', '${widget.guestCount ?? 4} Guests', theme),
              ],
            ),
          ),
          theme,
          primaryColor,
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableSection(ThemeData theme, Color primaryColor) {
    final table = widget.selectedTable;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Table',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(12),
        _buildGlassyCard(
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 80,
                    height: 80,
                    color: primaryColor.withOpacity(0.1),
                    child: table?.imageUrl != null && table!.imageUrl!.isNotEmpty
                        ? Image.network(
                            table.imageUrl!,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                table.isVip ? Iconsax.crown : Iconsax.reserve,
                                size: 40,
                                color: primaryColor,
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: primaryColor,
                                ),
                              );
                            },
                          )
                        : Icon(
                            table?.isVip == true ? Iconsax.crown : Iconsax.reserve,
                            size: 40,
                            color: primaryColor,
                          ),
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            table?.name ?? widget.tableName ?? 'Table',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (table?.isVip == true) ...[
                            const Gap(8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'VIP',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Text(
                        'Up to ${table?.capacity ?? widget.guestCount ?? 4} guests',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                      if (table?.minimumSpend != null) ...[
                        const Gap(4),
                        Text(
                          'Min. Spend: \$${table!.minimumSpend!.toStringAsFixed(0)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                      const Gap(8),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(); // Go back to select a different table
                        },
                        child: Text(
                          'Change',
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          theme,
          primaryColor,
        ),
      ],
    );
  }

  Widget _buildBottlesSection(ThemeData theme, Color primaryColor) {
    final bottles = widget.selectedBottles ?? [];

    if (bottles.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Bottles',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.onSurface.withOpacity(0.1),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Iconsax.cup,
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                  size: 24,
                ),
                const Gap(12),
                Text(
                  'No bottles selected',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Bottles',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(12),
        Column(
          children: bottles.map((bottle) =>
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildBottleItem(bottle, theme, primaryColor),
            )).toList(),
        ),
      ],
    );
  }

  Widget _buildBottleItem(Bottle bottle, ThemeData theme, Color primaryColor) {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: bottle.imageUrl != null && bottle.imageUrl!.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    bottle.imageUrl!,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Iconsax.cup,
                        color: primaryColor,
                        size: 24,
                      );
                    },
                  ),
                )
              : Icon(
                  Iconsax.cup,
                  color: primaryColor,
                  size: 24,
                ),
        ),
        const Gap(16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                bottle.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                bottle.volumeMl != null ? '${bottle.volumeMl}ml' : bottle.category,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const Gap(4),
              Text(
                bottle.formattedPrice,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Selected',
            style: theme.textTheme.bodySmall?.copyWith(
              color: primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }



  Widget _buildGuestInfoSection(ThemeData theme, Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Guest Info',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(12),
        _buildGlassyCard(
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Number of Guests',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                Text(
                  '${widget.guestCount ?? 4}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          theme,
          primaryColor,
        ),
      ],
    );
  }

  Widget _buildPromoCodeSection(ThemeData theme, Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Promo Code',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(12),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Enter code',
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: primaryColor.withOpacity(0.2),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: primaryColor.withOpacity(0.2),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
            ),
            const Gap(12),
            Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'Apply',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSection(ThemeData theme, Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(12),
        if (Platform.isIOS) ...[
          // iOS: embedded card form — avoids the native payment sheet modal
          // which has a known UIKit completion-handler bug causing it to hang.
          Container(
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: primaryColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Iconsax.card, color: primaryColor, size: 20),
                    const Gap(8),
                    Text(
                      'Card Details',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Gap(12),
                CardFormField(
                  controller: _cardController,
                  style: CardFormStyle(
                    backgroundColor: theme.colorScheme.surface,
                    textColor: theme.colorScheme.onSurface,
                    placeholderColor: theme.colorScheme.onSurface.withOpacity(0.4),
                    borderRadius: 10,
                    borderWidth: 1,
                    borderColor: primaryColor.withOpacity(0.3),
                  ),
                ),
              ],
            ),
          ),
        ] else ...[
          // Android: show payment method selection card (uses native payment sheet)
          GestureDetector(
            onTap: () => setState(() => _selectedPaymentMethod = PaymentMethod.stripe),
            child: _buildPaymentMethodCard(
              theme: theme,
              primaryColor: primaryColor,
              method: PaymentMethod.stripe,
              title: 'Stripe Payment',
              subtitle: 'Credit/Debit card via Stripe',
              logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/ba/Stripe_Logo%2C_revised_2016.svg/2560px-Stripe_Logo%2C_revised_2016.svg.png',
              icon: Iconsax.card,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPaymentMethodCard({
    required ThemeData theme,
    required Color primaryColor,
    required PaymentMethod method,
    required String title,
    required String subtitle,
    required IconData icon,
    String? logoUrl,
    bool showBalance = false,
  }) {
    final isSelected = _selectedPaymentMethod == method;

    return Container(
      decoration: BoxDecoration(
        color: isSelected ? primaryColor.withOpacity(0.08) : primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? primaryColor : primaryColor.withOpacity(0.1),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon or Logo
            Container(
              width: 60,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: primaryColor.withValues(alpha: 0.2),
                ),
              ),
              child: logoUrl != null
                  ? Padding(
                      padding: const EdgeInsets.all(8),
                      child: Image.network(
                        logoUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(icon, color: primaryColor, size: 20);
                        },
                      ),
                    )
                  : Icon(icon, color: primaryColor, size: 24),
            ),
            const Gap(16),
            // Title and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(2),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            // Selection indicator
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? primaryColor : theme.colorScheme.onSurface.withOpacity(0.3),
                  width: 2,
                ),
                color: isSelected ? primaryColor : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummarySection(ThemeData theme, Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Summary',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(12),
        Column(
          children: [
            _buildSummaryRow('Table', '\$${_getTableCost().toStringAsFixed(2)}', theme),
            if (_getBottlesCost() > 0)
              _buildSummaryRow('Bottles', '\$${_getBottlesCost().toStringAsFixed(2)}', theme),
            _buildSummaryRow('Service Fee (7%)', '\$${_getServiceFee().toStringAsFixed(2)}', theme),
            _buildSummaryRow('Tax (13%)', '\$${_getTax().toStringAsFixed(2)}', theme),
            const Divider(),
            _buildSummaryRow('Total', '\$${_getTotal().toStringAsFixed(2)}', theme, isTotal: true),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, ThemeData theme, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isTotal ? null : theme.colorScheme.onSurface.withOpacity(0.6),
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsText(ThemeData theme) {
    return Text(
      'By proceeding, you agree to our Terms & Cancellation Policy',
      textAlign: TextAlign.center,
      style: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.onSurface.withOpacity(0.6),
      ),
    );
  }

  IconData _getPaymentTypeIcon() {
    switch (widget.paymentType) {
      case PaymentType.tableBooking:
        return Iconsax.reserve;
      case PaymentType.eventTicket:
        return Iconsax.ticket;
      case PaymentType.bottleService:
        return Iconsax.cup;
      case PaymentType.membership:
        return Iconsax.crown;
    }
  }
}