import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/ticket_transfer.dart';
import '../services/ticket_transfer_service.dart';

part 'ticket_transfer_provider.g.dart';

// Pending Transfers Provider
@riverpod
class PendingTransfers extends _$PendingTransfers {
  @override
  Future<List<TicketTransfer>> build() async {
    return TicketTransferService().getPendingTransfers();
  }

  Future<void> acceptTransfer(String transferId) async {
    await TicketTransferService().acceptTransfer(transferId);
    ref.invalidateSelf();
  }

  Future<void> rejectTransfer(String transferId) async {
    await TicketTransferService().rejectTransfer(transferId);
    ref.invalidateSelf();
  }
}

// Sent Transfers Provider
@riverpod
class SentTransfers extends _$SentTransfers {
  @override
  Future<List<TicketTransfer>> build() async {
    return TicketTransferService().getSentTransfers();
  }

  Future<void> transferTicket({
    required String ticketId,
    required String toUserEmail,
    String? message,
    Duration? expiryDuration,
  }) async {
    await TicketTransferService().transferTicket(
      ticketId: ticketId,
      toUserEmail: toUserEmail,
      message: message,
      expiryDuration: expiryDuration,
    );
    ref.invalidateSelf();
  }

  Future<void> cancelTransfer(String transferId) async {
    await TicketTransferService().cancelTransfer(transferId);
    ref.invalidateSelf();
  }
}
