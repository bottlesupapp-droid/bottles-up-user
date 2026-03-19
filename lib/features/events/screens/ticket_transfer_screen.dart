import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../providers/ticket_transfer_provider.dart';

class TicketTransferScreen extends ConsumerWidget {
  const TicketTransferScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ticket Transfers'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Received', icon: Icon(Icons.inbox)),
              Tab(text: 'Sent', icon: Icon(Icons.send)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _ReceivedTransfersTab(),
            _SentTransfersTab(),
          ],
        ),
      ),
    );
  }
}

class _ReceivedTransfersTab extends ConsumerWidget {
  const _ReceivedTransfersTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transfersAsync = ref.watch(pendingTransfersProvider);

    return transfersAsync.when(
      data: (transfers) {
        if (transfers.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
                Gap(16),
                Text('No pending transfers'),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(pendingTransfersProvider);
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: transfers.length,
            itemBuilder: (context, index) {
              final transfer = transfers[index];
              return _ReceivedTransferCard(transfer: transfer);
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}

class _SentTransfersTab extends ConsumerWidget {
  const _SentTransfersTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transfersAsync = ref.watch(sentTransfersProvider);

    return transfersAsync.when(
      data: (transfers) {
        if (transfers.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.send_outlined, size: 64, color: Colors.grey),
                Gap(16),
                Text('No sent transfers'),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(sentTransfersProvider);
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: transfers.length,
            itemBuilder: (context, index) {
              final transfer = transfers[index];
              return _SentTransferCard(transfer: transfer);
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}

class _ReceivedTransferCard extends ConsumerWidget {
  final dynamic transfer;

  const _ReceivedTransferCard({required this.transfer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpired = transfer.isExpired;
    final isPending = transfer.isPending;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              child: Text(transfer.fromUserName?[0] ?? 'U'),
            ),
            title: Text(transfer.eventName ?? 'Event Ticket'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(4),
                Text('From: ${transfer.fromUserName ?? 'Unknown'}'),
                const Gap(2),
                if (transfer.message != null) ...[
                  Text(
                    transfer.message!,
                    style: const TextStyle(fontStyle: FontStyle.italic),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Gap(2),
                ],
                if (transfer.createdAt != null)
                  Text(
                    timeago.format(transfer.createdAt!),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
              ],
            ),
            trailing: _StatusChip(status: transfer.status),
          ),

          if (isExpired)
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.red.shade50,
              child: const Row(
                children: [
                  Icon(Icons.warning, color: Colors.red, size: 16),
                  Gap(8),
                  Text('This transfer has expired', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),

          if (isPending && !isExpired)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _rejectTransfer(context, ref, transfer.id),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: const Text('Reject'),
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _acceptTransfer(context, ref, transfer.id),
                      child: const Text('Accept'),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _acceptTransfer(BuildContext context, WidgetRef ref, String transferId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Accept Transfer'),
        content: const Text('Are you sure you want to accept this ticket?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Accept'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await ref.read(pendingTransfersProvider.notifier).acceptTransfer(transferId);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ticket accepted successfully!')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  void _rejectTransfer(BuildContext context, WidgetRef ref, String transferId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Transfer'),
        content: const Text('Are you sure you want to reject this ticket?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Reject'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await ref.read(pendingTransfersProvider.notifier).rejectTransfer(transferId);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Transfer rejected')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }
}

class _SentTransferCard extends ConsumerWidget {
  final dynamic transfer;

  const _SentTransferCard({required this.transfer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPending = transfer.isPending;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(transfer.toUserName?[0] ?? 'U'),
        ),
        title: Text(transfer.eventName ?? 'Event Ticket'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(4),
            Text('To: ${transfer.toUserName ?? transfer.toUserEmail ?? 'Unknown'}'),
            if (transfer.createdAt != null) ...[
              const Gap(2),
              Text(
                timeago.format(transfer.createdAt!),
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _StatusChip(status: transfer.status),
            if (isPending)
              TextButton(
                onPressed: () => _cancelTransfer(context, ref, transfer.id),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('Cancel', style: TextStyle(fontSize: 12)),
              ),
          ],
        ),
      ),
    );
  }

  void _cancelTransfer(BuildContext context, WidgetRef ref, String transferId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Transfer'),
        content: const Text('Are you sure you want to cancel this transfer?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await ref.read(sentTransfersProvider.notifier).cancelTransfer(transferId);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Transfer cancelled')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (status) {
      case 'pending':
        color = Colors.orange;
        label = 'Pending';
        break;
      case 'accepted':
        color = Colors.green;
        label = 'Accepted';
        break;
      case 'rejected':
        color = Colors.red;
        label = 'Rejected';
        break;
      case 'cancelled':
        color = Colors.grey;
        label = 'Cancelled';
        break;
      default:
        color = Colors.grey;
        label = status;
    }

    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      backgroundColor: color.withOpacity(0.2),
      labelStyle: TextStyle(color: color),
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
