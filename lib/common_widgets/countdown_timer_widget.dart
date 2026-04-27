import 'package:flutter/material.dart';
import 'dart:async';

class CountdownTimerWidget extends StatefulWidget {
  final DateTime targetTime;
  final TextStyle? textStyle;
  final bool compact;
  final VoidCallback? onComplete;

  const CountdownTimerWidget({
    super.key,
    required this.targetTime,
    this.textStyle,
    this.compact = false,
    this.onComplete,
  });

  @override
  State<CountdownTimerWidget> createState() => _CountdownTimerWidgetState();
}

class _CountdownTimerWidgetState extends State<CountdownTimerWidget> {
  Timer? _timer;
  Duration _timeRemaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateTimeRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateTimeRemaining();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTimeRemaining() {
    final now = DateTime.now();
    final remaining = widget.targetTime.difference(now);

    if (remaining.isNegative) {
      setState(() => _timeRemaining = Duration.zero);
      _timer?.cancel();
      widget.onComplete?.call();
    } else {
      setState(() => _timeRemaining = remaining);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_timeRemaining == Duration.zero) {
      return Text(
        'Event Started',
        style: widget.textStyle ??
            Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
      );
    }

    final days = _timeRemaining.inDays;
    final hours = _timeRemaining.inHours % 24;
    final minutes = _timeRemaining.inMinutes % 60;
    final seconds = _timeRemaining.inSeconds % 60;

    if (widget.compact) {
      return _buildCompactTimer(days, hours, minutes, seconds);
    }

    return _buildFullTimer(days, hours, minutes, seconds);
  }

  Widget _buildCompactTimer(int days, int hours, int minutes, int seconds) {
    String timeText;
    if (days > 0) {
      timeText = '${days}d ${hours}h';
    } else if (hours > 0) {
      timeText = '${hours}h ${minutes}m';
    } else {
      timeText = '${minutes}m ${seconds}s';
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.access_time,
          size: 16,
          color: widget.textStyle?.color ?? Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 4),
        Text(timeText, style: widget.textStyle),
      ],
    );
  }

  Widget _buildFullTimer(int days, int hours, int minutes, int seconds) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (days > 0) ...[
          _TimeUnit(value: days, label: 'Days'),
          const SizedBox(width: 8),
        ],
        if (days > 0 || hours > 0) ...[
          _TimeUnit(value: hours, label: 'Hours'),
          const SizedBox(width: 8),
        ],
        _TimeUnit(value: minutes, label: 'Min'),
        const SizedBox(width: 8),
        _TimeUnit(value: seconds, label: 'Sec'),
      ],
    );
  }
}

class _TimeUnit extends StatelessWidget {
  final int value;
  final String label;

  const _TimeUnit({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value.toString().padLeft(2, '0'),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
