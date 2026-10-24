/// Where the BottlesUp website lives. The website's database and edge functions are the one source of truth for this app (events, tickets, venues, tables, bookings), so
/// links the app shows or shares point there.
const String defaultSiteUrl = 'https://www.bottlesupapp.com';

/// The address links should point at. A configured value is used only if it is a plain https address; anything else (http, garbage, a login embedded in it) is ignored and the real
/// site is used. A path or query on it is dropped: only the origin is kept.
String siteOrigin(String? configured) {
  final raw = (configured ?? '').trim();
  if (raw.isNotEmpty) {
    final uri = Uri.tryParse(raw);
    if (uri != null && uri.scheme == 'https' && uri.userInfo.isEmpty && uri.host.contains('.')) {
      return uri.origin;
    }
  }
  return defaultSiteUrl;
}

const String _configuredSite = String.fromEnvironment('SITE_URL');

/// Where links point in this build: `--dart-define=SITE_URL=https://...` or the real site.
final String siteUrl = siteOrigin(_configuredSite);

/// The website's page for an event (the id works as well as the slug).
Uri eventPageUri(String eventId, {String? origin}) => Uri.parse('${origin ?? siteUrl}/events/${Uri.encodeComponent(eventId)}');

/// The website's privacy policy.
Uri privacyPolicyUri({String? origin}) => Uri.parse('${origin ?? siteUrl}/privacy-policy');
