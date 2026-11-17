import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/social_profile.dart';
import '../site_error.dart';

/// A person's profiles, following and blocking, through the website's `profile_*`, `follow_*` and `block_*` functions. Every function that does something is told which profile it is done
/// AS (`actor`): the website checks, on every call, that the signed-in person may act as it. The sentences the website raises are shown as they come.
class SocialProfilesService {
  SocialProfilesService(this._db);

  final SupabaseClient _db;

  Future<Object?> _rpc(String name, Map<String, dynamic> params, String generic) async {
    try {
      return await _db.rpc(name, params: params);
    } catch (error) {
      throw siteExceptionFromRpc(error, generic: generic);
    }
  }

  SocialProfile _one(Object? json) {
    final p = parseSocialProfile(json);
    if (p == null) throw const SiteException('We could not read that profile. Try again in a moment.');
    return p;
  }

  /// Is this username free for the signed-in person to take? Their own counts as free.
  Future<bool> usernameAvailable(String handle) async =>
      (await _rpc('handle_available', {'p_handle': handle}, 'We could not check that username. Check your connection and try again.')) == true;

  /// Saves the details every account has: name, username, city, bio and links (the website's `save_my_profile`). The photo is left as it is.
  Future<void> saveDetails({required String name, required String username, required String city, String? bio, Map<String, String> links = const {}}) async {
    await _rpc(
      'save_my_profile',
      {'p_name': name.trim(), 'p_username': username.trim().toLowerCase(), 'p_city': city.trim(), 'p_bio': bio?.trim(), 'p_social': links},
      'We could not save your details. Check your connection and try again.',
    );
  }

  /// Creates or updates the person's social profile after [saveDetails].
  Future<SocialProfile> savePersonal({required bool isPrivate, required List<String> interests}) async => _one(await _rpc(
        'profile_save_personal',
        {'p_privacy': isPrivate ? 'private' : 'public', 'p_interests': interests},
        'We could not save your profile. Check your connection and try again.',
      ));

  /// Every profile the person may act as, their own first.
  Future<List<SocialProfile>> myProfiles() async =>
      parseSocialProfiles(await _rpc('profile_my_profiles', const {}, loadFailedMessage('your profiles')));

  Future<SocialProfile> createBusiness({
    required String category,
    required String name,
    required String username,
    String? bio,
    String? city,
  }) async =>
      _one(await _rpc(
        'profile_create_business',
        {'p_category': category, 'p_display_name': name.trim(), 'p_handle': username.trim().toLowerCase(), 'p_bio': bio?.trim(), 'p_city': city?.trim()},
        'We could not create the profile. Check your connection and try again.',
      ));

  Future<SocialProfile> updateBusiness({
    required String profileId,
    required String name,
    String? bio,
    String? city,
    Map<String, String> links = const {},
  }) async =>
      _one(await _rpc(
        'profile_update_business',
        {'p_profile': profileId, 'p_display_name': name.trim(), 'p_bio': bio?.trim(), 'p_city': city?.trim(), 'p_social': links},
        'We could not save the profile. Check your connection and try again.',
      ));

  /// One profile, by username or by id, as [actor] sees it.
  Future<SocialProfile> profile({required String actor, String? handle, String? id}) async =>
      _one(await _rpc('profile_get', {'p_actor': actor, 'p_handle': handle, 'p_id': id}, loadFailedMessage('that profile')));

  Future<List<SocialProfile>> search({required String actor, required String query, int limit = 20}) async =>
      parseSocialProfiles(await _rpc('profile_search', {'p_actor': actor, 'p_query': query.trim(), 'p_limit': limit}, loadFailedMessage('the results')));

  /// Follows (or asks to follow a private profile) and unfollows. Answers the profile as it now stands.
  Future<SocialProfile> setFollow({required String actor, required String target, required bool follow}) async =>
      _one(await _rpc('follow_set', {'p_actor': actor, 'p_target': target, 'p_follow': follow}, actionFailedMessage));

  /// The owner of a private profile answers a request ('accept', 'decline') or removes a follower ('remove').
  Future<void> respond({required String actor, required String other, required String action}) async {
    await _rpc('follow_respond', {'p_actor': actor, 'p_other': other, 'p_action': action}, actionFailedMessage);
  }

  Future<List<SocialProfile>> requests(String actor) async => parseSocialProfiles(await _rpc('follow_requests', {'p_actor': actor}, loadFailedMessage('the requests')));

  /// A page of followers or of the profiles one follows, newest first. [before] is the `at` of the last profile seen.
  Future<List<SocialProfile>> people({required String actor, required String profile, required bool followers, int limit = 30, DateTime? before}) async =>
      parseSocialProfiles(await _rpc(
        'follow_list',
        {'p_actor': actor, 'p_profile': profile, 'p_kind': followers ? 'followers' : 'following', 'p_limit': limit, 'p_before': before?.toUtc().toIso8601String()},
        loadFailedMessage(followers ? 'the followers' : 'who they follow'),
      ));

  Future<void> setBlocked({required String actor, required String target, required bool blocked}) async {
    await _rpc('block_set', {'p_actor': actor, 'p_target': target, 'p_blocked': blocked}, actionFailedMessage);
  }

  Future<List<SocialProfile>> blocked(String actor) async => parseSocialProfiles(await _rpc('block_list', {'p_actor': actor}, loadFailedMessage('the blocked profiles')));
}
