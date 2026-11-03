import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/features.dart';
import '../site_error.dart';

/// Asks BottlesUp which parts of the app are switched on. Anyone may ask, signed in or not. When the answer cannot be had, everything new stays off.
class FeaturesService {
  FeaturesService(this._db);

  final SupabaseClient _db;

  Future<SiteFeatures> features() async {
    try {
      return SiteFeatures.parse(await _db.rpc('site_features', params: const <String, dynamic>{}));
    } catch (error) {
      logProblem('read the feature switches', error);
      return const SiteFeatures.allOff();
    }
  }
}
