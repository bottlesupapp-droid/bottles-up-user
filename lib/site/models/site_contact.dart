import '../read.dart';

/// A social page BottlesUp has put in its CMS.
class SocialLink {
  const SocialLink(this.name, this.url);

  final String name;
  final Uri url;
}

/// How to reach BottlesUp, as the BottlesUp team has set it in the CMS (the website's Content page; table `site_content`, one row everybody can read). The app shows exactly these and
/// nothing it makes up: a value the team has not filled in is simply not shown.
class SiteContact {
  const SiteContact({this.email, this.phone, this.address, this.socials = const []});

  final String? email;
  final String? phone;
  final String? address;
  final List<SocialLink> socials;

  bool get hasEmail => email != null;
  bool get hasPhone => phone != null && telUri(phone!) != null;
  bool get isEmpty => email == null && !hasPhone && address == null && socials.isEmpty;
}

/// An absolute web address, or null: the app never opens something it cannot tell is a web page (no `javascript:`, no bare words).
Uri? webUri(String? value) {
  final s = readText(value);
  if (s == null) return null;
  final u = Uri.tryParse(s);
  if (u == null || !u.hasScheme || (u.scheme != 'https' && u.scheme != 'http') || u.host.isEmpty) return null;
  return u;
}

final RegExp _emailShape = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

/// One `site_content` row. Null or an empty row means nothing is set.
SiteContact parseSiteContact(Map<String, dynamic>? row) {
  if (row == null) return const SiteContact();
  final email = readText(row['contact_email']);
  final socials = <SocialLink>[
    for (final (name, key) in const [('Instagram', 'social_instagram'), ('Facebook', 'social_facebook'), ('Twitter', 'social_twitter'), ('LinkedIn', 'social_linkedin')])
      if (webUri(row[key] as String?) case final url?) SocialLink(name, url),
  ];
  return SiteContact(email: email != null && _emailShape.hasMatch(email) ? email : null, phone: readText(row['contact_phone']), address: readText(row['address']), socials: socials);
}

/// `tel:` for a phone number: digits and a leading plus only. Null when there are not enough digits to be a number.
Uri? telUri(String phone) {
  final kept = phone.replaceAll(RegExp(r'[^0-9+]'), '');
  final digits = kept.replaceAll('+', '');
  if (digits.length < 7 || digits.length > 15) return null;
  return Uri(scheme: 'tel', path: kept.startsWith('+') ? '+$digits' : digits);
}

/// A message to BottlesUp, ready in the person's own mail app. Nothing is sent from here: the person reads it and presses send.
Uri supportMailto(String to, {required String subject, required String message, String? from}) {
  final body = StringBuffer(message.trim());
  if (from != null && from.trim().isNotEmpty) body.write('\n\nAccount e-mail: ${from.trim()}');
  // Uri.query would turn spaces into plus signs, which mail apps show literally: build the encoded query by hand.
  return Uri(scheme: 'mailto', path: to, query: 'subject=${Uri.encodeComponent(subject.trim())}&body=${Uri.encodeComponent(body.toString())}');
}
