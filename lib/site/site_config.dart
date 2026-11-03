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

/// Where a business runs its venue, events, door, team and payouts: BottlesUp Business on the web (the Business app signs in to the same place). The app links here from a
/// business profile; it does not do those tasks itself.
Uri businessToolsUri({String? origin}) => Uri.parse('${origin ?? siteUrl}/workspaces');

/// The website's privacy policy.
Uri privacyPolicyUri({String? origin}) => Uri.parse('${origin ?? siteUrl}/privacy-policy');

/// The website's page for a venue.
Uri venuePageUri(String venueId, {String? origin}) => Uri.parse('${origin ?? siteUrl}/venues/${Uri.encodeComponent(venueId)}');

/// A map search for an address, which opens in the phone's maps (or the browser).
Uri mapsSearchUri(String address) => Uri.https('www.google.com', '/maps/search/', {'api': '1', 'query': address});

/// Where the link in a password-reset e-mail sends the person: back into the app (its own scheme, registered on both phones). The address must be in the project's list of allowed redirect
/// addresses (Supabase > Authentication > URL Configuration), or the e-mail sends people to the website's address instead.
const String passwordResetRedirect = 'bottlesup://reset-password';
