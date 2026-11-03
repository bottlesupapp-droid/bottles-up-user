import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/recognition.dart';
import '../site_error.dart';

String? _blank(String? s) => s == null || s.trim().isEmpty ? null : s.trim();

/// Verification, ranks, awards and plaques, through the website's functions. BottlesUp decides every one of these; this service carries the asks and the answers and turns a refusal into the
/// sentence it came with.
class RecognitionService {
  RecognitionService(this._db);

  final SupabaseClient _db;

  Future<T> _rpc<T>(String name, Map<String, dynamic> params, T Function(Object? answer) read, String generic) async {
    final Object? answer;
    try {
      answer = await _db.rpc(name, params: params);
    } catch (error) {
      throw siteExceptionFromRpc(error, generic: generic);
    }
    return read(answer);
  }

  /// The ranks, lowest first, with their names, counts and colours.
  Future<List<RankLevel>> levels() => _rpc('rank_levels', const {}, parseRankLevels, loadFailedMessage('the ranks'));

  Future<VerificationInfo> verification(String profile) =>
      _rpc('verification_status', {'p_profile': profile}, (a) => parseVerificationInfo(a) ?? (throw const SiteException('We could not read the answer.')), loadFailedMessage('your verification'));

  /// Asks to be verified, with a few words about oneself.
  Future<VerificationInfo> requestVerification({required String profile, String? note}) => _rpc(
        'verification_request',
        {'p_profile': profile, 'p_note': _blank(note)},
        (a) => parseVerificationInfo(a) ?? (throw const SiteException('We could not read the answer. Look at your verification before trying again.')),
        'The request was not sent. Check your connection and try again.',
      );

  Future<RankStatus> rankStatus(String profile) => _rpc('rank_status', {'p_profile': profile}, (a) => parseRankStatus(a) ?? (throw const SiteException('We could not read the answer.')), loadFailedMessage('your rank'));

  /// Asks BottlesUp to look at the next level.
  Future<RankStatus> requestRank(String profile) => _rpc(
        'rank_request',
        {'p_profile': profile},
        (a) => parseRankStatus(a) ?? (throw const SiteException('We could not read the answer. Look at your rank before trying again.')),
        'The request was not sent. Check your connection and try again.',
      );

  /// The ranks a profile holds. Nothing when ranks are off or the profile is not verified.
  Future<List<Award>> awards({required String actor, required String profile}) => _rpc('awards_of', {'p_actor': actor, 'p_profile': profile}, parseAwards, loadFailedMessage('the awards'));

  Future<List<Plaque>> plaques(String profile) => _rpc('plaques_mine', {'p_profile': profile}, parsePlaques, loadFailedMessage('your plaques'));

  /// Asks for the plaque of an award and gives the address it should go to.
  Future<Plaque> claimPlaque({required String award, required PlaqueAddress address}) => _rpc(
        'plaque_claim',
        {
          'p_award': award,
          'p_recipient': address.recipient.trim(),
          'p_line1': address.line1.trim(),
          'p_line2': _blank(address.line2),
          'p_city': address.city.trim(),
          'p_region': _blank(address.region),
          'p_postal': address.postal.trim(),
          'p_country': address.country.trim(),
          'p_phone': _blank(address.phone),
        },
        (a) => parsePlaque(a) ?? (throw const SiteException('We could not read the answer. Look at your plaques before trying again.')),
        'The request was not sent. Check your connection and try again.',
      );

  /// Takes the request back while it has not been posted: the address is removed at once.
  Future<Plaque> cancelPlaque(String plaque) => _rpc('plaque_cancel', {'p_plaque': plaque}, (a) => parsePlaque(a) ?? (throw const SiteException('We could not read the answer.')), actionFailedMessage);
}
