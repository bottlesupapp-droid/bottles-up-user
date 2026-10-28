import '../models/jobs.dart';
import '../when.dart';

/// The limits the website enforces on a job listing and an application. The app checks the same things first so a person is told before they send, but the website has the last word.
const int minJobTitleLength = 5;
const int maxJobTitleLength = 120;
const int minJobDescriptionLength = 20;
const int maxJobDescriptionLength = 4000;
const int maxJobRequirementsLength = 2000;
const int minCompensationLength = 2;
const int maxCompensationLength = 200;
const int maxJobLocationLength = 120;
const int maxJobScheduleLength = 200;
const int maxJobDeadlineDays = 365;
const int minApplicationLength = 20;
const int maxApplicationLength = 2000;
const int maxApplicationLinkLength = 300;
const int maxApplicationReplyLength = 1000;

DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

int _len(String? s) => s?.trim().length ?? 0;

/// The sentence for what is wrong with a listing, or null when it can be sent. [today] is the day the person is on.
String? checkJob({
  required String? title,
  required JobKind? kind,
  required String? description,
  String? requirements,
  required String? compensation,
  String? location,
  required bool remote,
  String? schedule,
  required DateTime? deadline,
  required DateTime today,
}) {
  final t = _len(title);
  if (t < minJobTitleLength || t > maxJobTitleLength) return 'Write a title of $minJobTitleLength to $maxJobTitleLength characters.';
  if (kind == null) return 'Choose what kind of job it is.';
  final d = _len(description);
  if (d < minJobDescriptionLength || d > maxJobDescriptionLength) return 'Describe the job in $minJobDescriptionLength to $maxJobDescriptionLength characters.';
  if (_len(requirements) > maxJobRequirementsLength) return 'Keep the requirements to $maxJobRequirementsLength characters.';
  final c = _len(compensation);
  if (c < minCompensationLength || c > maxCompensationLength) return 'Say what it pays ($minCompensationLength to $maxCompensationLength characters).';
  if (_len(location) > maxJobLocationLength) return 'Keep the location to $maxJobLocationLength characters.';
  if (!remote && _len(location) == 0) return 'Say where it is, or that it can be done remotely.';
  if (_len(schedule) > maxJobScheduleLength) return 'Keep the schedule to $maxJobScheduleLength characters.';
  final day = _day(today);
  if (deadline == null || _day(deadline).isBefore(day) || _day(deadline).isAfter(DateTime(day.year, day.month, day.day + maxJobDeadlineDays))) {
    return 'Choose a last day to apply, from today to a year away.';
  }
  return null;
}

final RegExp _https = RegExp(r'^https://\S+$');

/// The sentence for what is wrong with an application, or null.
String? checkApplication({required String? message, String? link}) {
  final m = _len(message);
  if (m < minApplicationLength || m > maxApplicationLength) return 'Write a message of $minApplicationLength to $maxApplicationLength characters.';
  final l = link?.trim() ?? '';
  if (l.isNotEmpty && (l.length > maxApplicationLinkLength || !_https.hasMatch(l))) return 'A link must start with https:// and be up to $maxApplicationLinkLength characters.';
  return null;
}

/// The sentence for what is wrong with a reply to an application, or null.
String? checkReply(String? reply) => _len(reply) > maxApplicationReplyLength ? 'Keep the reply to $maxApplicationReplyLength characters.' : null;

/// How long is left to apply: "Last day today", "1 day left", "5 days left", or "Closed" when the day has passed.
String deadlineText(DateTime deadline, DateTime today) {
  final left = _day(deadline).difference(_day(today)).inDays;
  if (left < 0) return 'Closed';
  if (left == 0) return 'Last day today';
  if (left == 1) return '1 day left';
  return '$left days left';
}

/// "Apply by Fri, Nov 6".
String applyByText(DateTime deadline) => 'Apply by ${formatDay(deadline)}';
