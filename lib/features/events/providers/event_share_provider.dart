import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/event_share.dart';
import '../services/event_share_service.dart';

part 'event_share_provider.g.dart';

@riverpod
class EventShareAnalyticsNotifier extends _$EventShareAnalyticsNotifier {
  @override
  Future<ShareAnalytics> build(String eventId) async {
    return await EventShareService().getShareAnalytics(eventId);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await EventShareService().getShareAnalytics(eventId);
    });
  }
}

@riverpod
Future<EventShare> eventShareLink(
  EventShareLinkRef ref,
  String eventId,
) async {
  return await EventShareService().getOrCreateShareLink(eventId: eventId);
}

@riverpod
Future<List<EventShare>> eventShares(
  EventSharesRef ref,
  String eventId,
) async {
  return await EventShareService().getEventShares(eventId);
}
