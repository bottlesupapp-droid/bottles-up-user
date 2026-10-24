import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Something went wrong talking to BottlesUp. [message] is a plain sentence a person can read and act on; the technical reason went to the log, never to the screen.
class SiteException implements Exception {
  const SiteException(this.message, {this.status});

  final String message;

  /// The HTTP status when the website answered with one (a refusal such as "not enough tickets left" is a 4xx).
  final int? status;

  @override
  String toString() => 'SiteException($message)';
}

/// Writes the technical reason to the log, with where it happened.
void logProblem(String where, Object error) => debugPrint('$where: $error');

/// The sentence for a list that could not be loaded.
String loadFailedMessage(String what) => 'We could not load $what. Check your connection and try again.';

/// The sentence for something the person asked for that did not go through.
const String actionFailedMessage = 'That did not go through. Check your connection and try again.';

/// What a website function said, when it said it in words for a customer: its own `{"error": "..."}` or `{"message": "..."}` for a refusal (a 4xx, such as "Not enough tickets left in
/// this tier"). A server error (5xx) or anything else is never shown as it came.
SiteException siteExceptionFrom(Object error, {String generic = actionFailedMessage}) {
  if (error is SiteException) return error;
  if (error is FunctionException) {
    final status = error.status;
    final details = error.details;
    if (status == 401) {
      logProblem('website function', error);
      return const SiteException('Your sign-in has expired. Sign in again, then try again.', status: 401);
    }
    if (status >= 400 && status < 500 && details is Map) {
      final said = details['error'] ?? details['message'];
      if (said is String && said.trim().isNotEmpty && said.length <= 200) {
        // The website's bare "Unauthorized" / "Forbidden" are for developers, not for a person.
        if (RegExp(r'^(unauthori[sz]ed|forbidden)\.?$', caseSensitive: false).hasMatch(said.trim())) {
          return SiteException('That is not available to your account.', status: status);
        }
        return SiteException(said.trim(), status: status);
      }
    }
    logProblem('website function', error);
    return SiteException(generic, status: status);
  }
  logProblem('request', error);
  return SiteException(generic);
}
