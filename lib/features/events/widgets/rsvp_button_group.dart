import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/rsvp_status.dart';
import '../providers/enhanced_rsvp_provider.dart';

class RsvpButtonGroup extends ConsumerStatefulWidget {
  final String eventId;
  final RsvpResponse? currentResponse;
  final VoidCallback? onRsvpChanged;

  const RsvpButtonGroup({
    super.key,
    required this.eventId,
    this.currentResponse,
    this.onRsvpChanged,
  });

  @override
  ConsumerState<RsvpButtonGroup> createState() => _RsvpButtonGroupState();
}

class _RsvpButtonGroupState extends ConsumerState<RsvpButtonGroup> {
  bool _isLoading = false;
  RsvpResponse? _selectedResponse;

  @override
  void initState() {
    super.initState();
    _selectedResponse = widget.currentResponse;
  }

  Future<void> _handleRsvpTap(RsvpResponse response) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _selectedResponse = response;
    });

    try {
      await ref.read(myEventRsvpProvider(widget.eventId).notifier).submitRsvp(
            response: response,
          );

      if (mounted) {
        widget.onRsvpChanged?.call();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('RSVP updated to ${_getResponseLabel(response)}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _RsvpButton(
              label: 'Going',
              icon: Icons.check_circle,
              color: Colors.green,
              isSelected: _selectedResponse == RsvpResponse.going,
              isLoading: _isLoading && _selectedResponse == RsvpResponse.going,
              onTap: () => _handleRsvpTap(RsvpResponse.going),
            ),
          ),
          Container(
            width: 1,
            height: 48,
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
          Expanded(
            child: _RsvpButton(
              label: 'Maybe',
              icon: Icons.help_outline,
              color: Colors.orange,
              isSelected: _selectedResponse == RsvpResponse.maybe,
              isLoading: _isLoading && _selectedResponse == RsvpResponse.maybe,
              onTap: () => _handleRsvpTap(RsvpResponse.maybe),
            ),
          ),
          Container(
            width: 1,
            height: 48,
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
          Expanded(
            child: _RsvpButton(
              label: 'Can\'t Go',
              icon: Icons.cancel_outlined,
              color: Colors.red,
              isSelected: _selectedResponse == RsvpResponse.notGoing,
              isLoading: _isLoading && _selectedResponse == RsvpResponse.notGoing,
              onTap: () => _handleRsvpTap(RsvpResponse.notGoing),
            ),
          ),
        ],
      ),
    );
  }

  String _getResponseLabel(RsvpResponse response) {
    switch (response) {
      case RsvpResponse.going:
        return 'Going';
      case RsvpResponse.maybe:
        return 'Maybe';
      case RsvpResponse.notGoing:
        return 'Not Going';
      case RsvpResponse.notResponded:
        return 'Not Responded';
    }
  }
}

class _RsvpButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final bool isLoading;
  final VoidCallback onTap;

  const _RsvpButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading)
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: color,
                ),
              )
            else
              Icon(
                icon,
                color: isSelected ? color : Colors.grey,
                size: 24,
              ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? color : Colors.grey,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
