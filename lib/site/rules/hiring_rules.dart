import '../models/hiring.dart';
import '../models/social_profile.dart';
import '../money.dart';

/// The limits the website enforces on hiring professionals. The app checks the same things first so a person is told before they send, but the website has the last word.
const int minQuoteCents = 1000;
const int maxQuoteCents = 5000000;
const int minTextLength = 3;
const int maxMessageLength = 1000;
const int minScopeLength = 10;
const int maxScopeLength = 1500;
const int minReasonLength = 10;
const int maxReasonLength = 1000;
const int maxQuoteDays = 14;
const int minTitleLength = 3;
const int maxTitleLength = 80;
const int maxDescriptionLength = 1000;
const int maxPriceNoteLength = 80;
const int maxServiceCents = 5000000;
const int maxServices = 20;

/// Whether a profile can be hired: a business profile that is not a venue or an event group (those are run from BottlesUp Business). The website decides for itself; this only decides
/// whether the app shows the way in.
bool isProfessional(SocialProfile p) => p.isBusiness && !p.suspended && p.category != null && p.category != 'venue' && p.category != 'event_group';

/// The smallest deposit the website accepts for [totalCents]: a tenth, rounded up.
int minDepositCents(int totalCents) => (totalCents + 9) ~/ 10;

/// The sentence for what is wrong with a request, or null. [date] is the day of the job.
String? checkRequest({required DateTime? date, required String message, required DateTime today, int? guests, int? budgetCents}) {
  final day = DateTime(today.year, today.month, today.day);
  if (date == null || !date.isAfter(day) || date.isAfter(DateTime(day.year, day.month, day.day + 730))) return 'Choose a date between tomorrow and two years from now.';
  final m = message.trim().length;
  if (m < minTextLength || m > maxMessageLength) return 'Tell them about the job in $minTextLength to $maxMessageLength characters.';
  if (guests != null && (guests < 1 || guests > 100000)) return 'Choose a number of guests between 1 and 100,000.';
  if (budgetCents != null && (budgetCents < 0 || budgetCents > 50000000)) return 'Choose a budget between 0 and 500,000.00.';
  return null;
}

/// The sentence for what is wrong with a quote, or null. [balanceDueBy] is needed when the deposit is less than the total and must fall from today to the day before [eventDate].
String? checkQuote({required int? totalCents, required int? depositCents, required DateTime? balanceDueBy, required String scope, required int? validDays, required DateTime eventDate, required DateTime today}) {
  if (totalCents == null || totalCents < minQuoteCents || totalCents > maxQuoteCents) return 'Choose a total between 10.00 and 50,000.00.';
  if (depositCents == null || depositCents > totalCents || depositCents < minDepositCents(totalCents)) {
    return 'The deposit must be at least a tenth of the total (${formatMoney(minDepositCents(totalCents))}), and no more than the total.';
  }
  final day = DateTime(today.year, today.month, today.day);
  if (depositCents < totalCents) {
    if (balanceDueBy == null || balanceDueBy.isBefore(day) || !balanceDueBy.isBefore(DateTime(eventDate.year, eventDate.month, eventDate.day))) {
      return 'The balance must be due before the date of the job.';
    }
  }
  final s = scope.trim().length;
  if (s < minScopeLength || s > maxScopeLength) return 'Say what is included in $minScopeLength to $maxScopeLength characters.';
  if (validDays == null || validDays < 1 || validDays > maxQuoteDays) return 'A quote can stay open for 1 to $maxQuoteDays days.';
  return null;
}

/// The sentence for what is wrong with a service a professional lists, or null. [fromCents] is optional ("from" price).
String? checkService({required String title, String? description, int? fromCents, String? priceNote}) {
  final t = title.trim().length;
  if (t < minTitleLength || t > maxTitleLength) return 'Give the service a name of $minTitleLength to $maxTitleLength characters.';
  if ((description?.trim().length ?? 0) > maxDescriptionLength) return 'Keep the description to $maxDescriptionLength characters.';
  if ((priceNote?.trim().length ?? 0) > maxPriceNoteLength) return 'Keep the price note to $maxPriceNoteLength characters.';
  if (fromCents != null && (fromCents < 0 || fromCents > maxServiceCents)) return 'Choose a price between 0 and 50,000.00.';
  return null;
}

/// The sentence for a dispute's reason, or null.
String? checkReason(String reason) {
  final n = reason.trim().length;
  return n < minReasonLength || n > maxReasonLength ? 'Say what went wrong in $minReasonLength to $maxReasonLength characters.' : null;
}

/// What cancelling means for the customer, in words, before they press the button. A professional cancelling always pays everything back.
String cancelPolicyText(ProBooking b, {required bool asProvider, required DateTime today}) {
  String money(int c) => formatMoney(c, currency: b.currency);
  if (b.paidCents <= 0) return 'Nothing has been paid, so nothing is charged.';
  if (asProvider) return 'Everything the customer paid (${money(b.paidCents)}) is paid back to them.';
  final days = DateTime(b.eventDate.year, b.eventDate.month, b.eventDate.day).difference(DateTime(today.year, today.month, today.day)).inDays;
  if (days >= b.freeCancelDays) return 'Everything you paid (${money(b.paidCents)}) is paid back to you.';
  final keep = b.keptIfLateCents;
  return 'The job is less than ${b.freeCancelDays} days away, so ${money(keep)} (the deposit, at least 30% of the price) is kept for the professional and ${money(b.paidCents - keep)} is paid back to you.';
}

/// Whether the booking is a day where the professional may mark it done or the customer may confirm or dispute: the day of the job or after.
bool jobDayHasCome(ProBooking b, DateTime today) => !DateTime(b.eventDate.year, b.eventDate.month, b.eventDate.day).isAfter(DateTime(today.year, today.month, today.day));

/// The customer may open a dispute from the day of the job until seven days after.
bool canDispute(ProBooking b, DateTime today) {
  final day = DateTime(b.eventDate.year, b.eventDate.month, b.eventDate.day);
  final t = DateTime(today.year, today.month, today.day);
  return !day.isAfter(t) && !t.isAfter(DateTime(day.year, day.month, day.day + 7));
}
