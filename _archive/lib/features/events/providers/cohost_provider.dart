import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/event_cohost.dart';
import '../services/cohost_service.dart';

part 'cohost_provider.g.dart';

@riverpod
class EventCohosts extends _$EventCohosts {
  @override
  Future<List<EventCohost>> build(String eventId) async {
    final cohostService = CohostService();
    return await cohostService.getEventCohosts(eventId);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  Future<void> inviteCohost({
    required String userId,
    required String userName,
    String? userEmail,
    required List<CohostPermission> permissions,
    String? message,
  }) async {
    final cohostService = CohostService();
    await cohostService.inviteCohost(
      eventId: eventId,
      userId: userId,
      userName: userName,
      userEmail: userEmail,
      permissions: permissions,
      message: message,
    );
    await refresh();
  }

  Future<void> removeCohost(String cohostId) async {
    final cohostService = CohostService();
    await cohostService.removeCohost(cohostId);
    await refresh();
  }

  Future<void> updatePermissions({
    required String cohostId,
    required List<CohostPermission> permissions,
  }) async {
    final cohostService = CohostService();
    await cohostService.updatePermissions(
      cohostId: cohostId,
      permissions: permissions,
    );
    await refresh();
  }
}

@riverpod
class MyPendingCohostInvitations extends _$MyPendingCohostInvitations {
  @override
  Future<List<EventCohost>> build() async {
    final cohostService = CohostService();
    return await cohostService.getPendingInvitations();
  }

  Future<void> acceptInvitation(String cohostId) async {
    final cohostService = CohostService();
    await cohostService.acceptInvitation(cohostId);
    ref.invalidateSelf();
  }

  Future<void> declineInvitation(String cohostId) async {
    final cohostService = CohostService();
    await cohostService.declineInvitation(cohostId);
    ref.invalidateSelf();
  }
}

@riverpod
Future<bool> isEventCohost(IsEventCohostRef ref, String eventId) async {
  final authState = await ref.watch(authProvider.future);
  if (authState == null) return false;

  final cohostService = CohostService();
  return await cohostService.isCohost(eventId, authState.id);
}

@riverpod
Future<bool> hasCohostPermission(
  HasCohostPermissionRef ref,
  String eventId,
  CohostPermission permission,
) async {
  final authState = await ref.watch(authProvider.future);
  if (authState == null) return false;

  final cohostService = CohostService();
  return await cohostService.hasPermission(
    eventId: eventId,
    userId: authState.id,
    permission: permission,
  );
}

@riverpod
Future<EventCohost?> myCohostDetails(
  MyCohostDetailsRef ref,
  String eventId,
) async {
  final authState = await ref.watch(authProvider.future);
  if (authState == null) return null;

  final cohostService = CohostService();
  return await cohostService.getCohostDetails(
    eventId: eventId,
    userId: authState.id,
  );
}
