import 'package:flutter/material.dart';
import '../services/venue_follow_service.dart';

class FollowVenueButton extends StatefulWidget {
  final String clubId;
  final bool compact;
  final VoidCallback? onFollowChanged;

  const FollowVenueButton({
    super.key,
    required this.clubId,
    this.compact = false,
    this.onFollowChanged,
  });

  @override
  State<FollowVenueButton> createState() => _FollowVenueButtonState();
}

class _FollowVenueButtonState extends State<FollowVenueButton> {
  final _followService = VenueFollowService();
  bool _isFollowing = false;
  bool _isLoading = true;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _checkFollowStatus();
  }

  Future<void> _checkFollowStatus() async {
    try {
      final isFollowing = await _followService.isFollowingVenue(widget.clubId);
      setState(() {
        _isFollowing = isFollowing;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleFollow() async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);

    try {
      final newStatus = await _followService.toggleFollow(widget.clubId);
      setState(() {
        _isFollowing = newStatus;
        _isProcessing = false;
      });

      widget.onFollowChanged?.call();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              newStatus ? 'Following venue' : 'Unfollowed venue',
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      setState(() => _isProcessing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (widget.compact) {
      return IconButton(
        onPressed: _isProcessing ? null : _toggleFollow,
        icon: Icon(
          _isFollowing ? Icons.favorite : Icons.favorite_border,
          color: _isFollowing ? Colors.red : null,
        ),
        tooltip: _isFollowing ? 'Unfollow' : 'Follow',
      );
    }

    return FilledButton.tonal(
      onPressed: _isProcessing ? null : _toggleFollow,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isProcessing)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            Icon(
              _isFollowing ? Icons.check : Icons.add,
              size: 18,
            ),
          const SizedBox(width: 8),
          Text(_isFollowing ? 'Following' : 'Follow'),
        ],
      ),
    );
  }
}
