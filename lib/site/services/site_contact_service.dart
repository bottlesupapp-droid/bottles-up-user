import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/site_contact.dart';
import '../site_error.dart';

/// Reads how to reach BottlesUp from the public `site_content` row (readable by everyone; only a BottlesUp administrator can change it, in the CMS).
class SiteContactService {
  SiteContactService(this._db);

  final SupabaseClient _db;

  /// A row that is missing or empty is not an error: it means nothing is set. A failure to read it is.
  Future<SiteContact> load() async {
    try {
      final row = await _db.from('site_content').select('contact_email, contact_phone, address, social_instagram, social_twitter, social_facebook, social_linkedin').eq('id', 1).maybeSingle();
      return parseSiteContact(row == null ? null : Map<String, dynamic>.from(row));
    } catch (error) {
      logProblem('load contact details', error);
      throw SiteException(loadFailedMessage('the contact details'));
    }
  }
}
