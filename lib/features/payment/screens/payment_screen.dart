import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:bottles_up_user/core/services/payment_service.dart';
import 'package:bottles_up_user/core/models/payment_models.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../club/models/club_table.dart';
import '../../club/models/bottle.dart';

enum PaymentMethod {
  stripe,
  googlePay,
  applePay,
  wallet,
}

class PaymentScreen extends ConsumerStatefulWidget {
  final double amount;
  final String currency;
  final String description;
  final PaymentType paymentType;
  final String? bookingId;
  final Map<String, dynamic>? metadata;
  final VoidCallback? onPaymentSuccess;
  final VoidCallback? onPaymentFailed;
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
  bool _isProcessing = false;
  String? _errorMessage;
  PaymentIntent? _paymentIntent;
  PaymentMethod _selectedPaymentMethod = PaymentMethod.stripe;
  double _walletBalance = 250.00; // Mock wallet balance - should come from user profile

  @override
  void initState() {
    super.initState();
    // In the new system, we create the session when the user clicks pay
    // or we can pre-create it here if we want to follow the old pattern
  }

  Future<void> _createPaymentIntent() async {
    // This method is now replaced by createCheckoutSession in the new service
    // We'll handle Stripe payment by redirecting to the checkout URL
  }

  bool _canProcessPayment() {
    if (_isProcessing) return false;

    // For Stripe, we don't need a pre-created intent anymore in the new system
    if (_selectedPaymentMethod == PaymentMethod.stripe) {
      return true;
    }

    // For Wallet, check if sufficient balance
    if (_selectedPaymentMethod == PaymentMethod.wallet && _walletBalance < _getTotal()) {
      return false;
    }

    return true;
  }

  Future<void> _processPayment() async {
    try {
      setState(() {
        _isProcessing = true;
        _errorMessage = null;
      });

      bool success = false;

      switch (_selectedPaymentMethod) {
        case PaymentMethod.stripe:
          await _processStripePayment();
          // Stripe payment redirect happens, so we don't return a simple success here
          // The return from Stripe is handled via deep links
          return;
        case PaymentMethod.googlePay:
          success = await _processGooglePayPayment();
          break;
        case PaymentMethod.applePay:
          success = await _processApplePayPayment();
          break;
        case PaymentMethod.wallet:
          success = await _processWalletPayment();
          break;
      }

      if (success) {
        // Payment successful
        _showSuccessDialog();
        widget.onPaymentSuccess?.call();
      } else {
        // Payment was canceled
        setState(() {
          _isProcessing = false;
        });
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _errorMessage = 'Payment failed: ${e.toString()}';
      });
      widget.onPaymentFailed?.call();
    }
  }

  Future<void> _processStripePayment() async {
    try {
      // Step 1: Create checkout session
      final result = await _paymentService.createCheckoutSession(
        paymentType: widget.paymentType.name,
        amount: widget.amount,
        bookingId: widget.bookingId,
        description: widget.description,
        metadata: widget.metadata,
      );

      // Step 2: Open Stripe checkout URL
      final opened = await _paymentService.openCheckoutUrl(result.checkoutUrl);

      if (!opened) {
        throw Exception('Failed to open payment page');
      }

      // Step 3: The user is now in the browser. 
      // In a real app, we'd wait for them to return or use a listener.
      // For this UI, we'll just show a message that they've been redirected.
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Redirecting to secure payment page...'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      throw Exception('Stripe payment failed: ${e.toString()}');
    }
  }

  Future<bool> _processGooglePayPayment() async {
    // Simulate Google Pay processing
    // In production, integrate with Google Pay SDK
    await Future.delayed(const Duration(seconds: 2));

    // Mock success - replace with actual Google Pay integration
    // Using flutter_stripe's Google Pay support or google_pay package
    print('Processing Google Pay payment for \$${_getTotal()}');

    return true;
  }

  Future<bool> _processApplePayPayment() async {
    // Simulate Apple Pay processing
    // In production, integrate with Apple Pay SDK via Stripe or PassKit
    await Future.delayed(const Duration(seconds: 2));

    // Mock success - replace with actual Apple Pay integration
    // Using flutter_stripe's Apple Pay support or pay package
    print('Processing Apple Pay payment for \$${_getTotal()}');

    return true;
  }

  Future<bool> _processWalletPayment() async {
    final total = _getTotal();

    // Check if wallet has sufficient balance
    if (_walletBalance < total) {
      throw Exception('Insufficient wallet balance. Please top up your wallet or choose another payment method.');
    }

    // Simulate wallet deduction
    await Future.delayed(const Duration(seconds: 1));

    // In production, call API to deduct from user's wallet
    // await WalletService.deductBalance(userId: currentUserId, amount: total);
    print('Processing Wallet payment for \$${total}');
    print('New balance: \$${(_walletBalance - total).toStringAsFixed(2)}');

    setState(() {
      _walletBalance -= total;
    });

    return true;
  }

  void _showSuccessDialog() {
    String paymentMethodName;
    switch (_selectedPaymentMethod) {
      case PaymentMethod.stripe:
        paymentMethodName = 'Stripe';
        break;
      case PaymentMethod.googlePay:
        paymentMethodName = 'Google Pay';
        break;
      case PaymentMethod.applePay:
        paymentMethodName = 'Apple Pay';
        break;
      case PaymentMethod.wallet:
        paymentMethodName = 'Wallet';
        break;
    }

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
            if (_selectedPaymentMethod == PaymentMethod.wallet) ...[
              const Gap(12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Iconsax.wallet_2,
                      size: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const Gap(8),
                    Text(
                      'New Balance: \$${_walletBalance.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
        // Stripe Payment
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
        const Gap(12),
        // Google Pay
        GestureDetector(
          onTap: () => setState(() => _selectedPaymentMethod = PaymentMethod.googlePay),
          child: _buildPaymentMethodCard(
            theme: theme,
            primaryColor: primaryColor,
            method: PaymentMethod.googlePay,
            title: 'Google Pay',
            subtitle: 'Pay with Google Pay',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f2/Google_Pay_Logo.svg/2560px-Google_Pay_Logo.svg.png',
            icon: Iconsax.card,
          ),
        ),
        const Gap(12),
        // Apple Pay
        GestureDetector(
          onTap: () => setState(() => _selectedPaymentMethod = PaymentMethod.applePay),
          child: _buildPaymentMethodCard(
            theme: theme,
            primaryColor: primaryColor,
            method: PaymentMethod.applePay,
            title: 'Apple Pay',
            subtitle: 'Pay with Apple Pay',
            logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b0/Apple_Pay_logo.svg/2560px-Apple_Pay_logo.svg.png',
            icon: Iconsax.card,
          ),
        ),
        const Gap(12),
        // Wallet
        GestureDetector(
          onTap: () => setState(() => _selectedPaymentMethod = PaymentMethod.wallet),
          child: _buildPaymentMethodCard(
            theme: theme,
            primaryColor: primaryColor,
            method: PaymentMethod.wallet,
            title: 'Wallet',
            subtitle: 'Available balance: \$${_walletBalance.toStringAsFixed(2)}',
            icon: Iconsax.wallet_2,
            showBalance: true,
          ),
        ),
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
    final isWalletInsufficient = method == PaymentMethod.wallet && _walletBalance < _getTotal();

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
                  if (isWalletInsufficient) ...[
                    const Gap(4),
                    Row(
                      children: [
                        Icon(
                          Icons.warning_rounded,
                          size: 14,
                          color: Colors.orange,
                        ),
                        const Gap(4),
                        Text(
                          'Insufficient balance',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.orange,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
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