import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/wallet_pass.dart';
import '../services/wallet_pass_service.dart';

part 'wallet_pass_provider.g.dart';

/// Provider for wallet pass service
@riverpod
WalletPassService walletPassService(WalletPassServiceRef ref) {
  return WalletPassService();
}

/// Provider to check if Apple Wallet is supported
@riverpod
bool isAppleWalletSupported(IsAppleWalletSupportedRef ref) {
  return ref.watch(walletPassServiceProvider).isAppleWalletSupported;
}

/// Provider to get wallet pass for a booking
@riverpod
Future<WalletPass?> walletPassForBooking(
  WalletPassForBookingRef ref, {
  required String bookingId,
  required String passType,
}) async {
  final service = ref.watch(walletPassServiceProvider);
  return service.getPassForBooking(
    bookingId: bookingId,
    passType: passType,
  );
}
