import 'package:bottles_up_user/site/models/site_event.dart';
import 'package:bottles_up_user/site/money.dart';
import 'package:bottles_up_user/site/rules/event_rules.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';

SiteEvent event(Map<String, dynamic> row) => parseSiteEvent(row)!;

void main() {
  final friday = event(eventRow(id: 'a', title: 'Friday Night', category: 'Nightlife'));
  final brunch = event(eventRow(id: 'b', title: 'Sunday Brunch', category: 'Day party', venue: 'Rooftop', lineup: const ['Mia Moon']));
  final plain = event(eventRow(id: 'c', title: 'Open Mic', category: null));

  test('categories are listed once each, in the order they first appear, and events without one add nothing', () {
    expect(categoriesOf([friday, brunch, friday, plain]), ['Nightlife', 'Day party']);
    expect(categoriesOf(const []), isEmpty);
  });

  group('filterEvents', () {
    final all = [friday, brunch, plain];

    test('no words and no category keeps everything', () {
      expect(filterEvents(all), all);
      expect(filterEvents(all, query: '   '), all);
    });

    test('matches the title, venue, address, category and the acts, ignoring case and spaces around', () {
      expect(filterEvents(all, query: ' BRUNCH ').map((e) => e.id), ['b']);
      expect(filterEvents(all, query: 'rooftop').map((e) => e.id), ['b']);
      expect(filterEvents(all, query: 'king st').map((e) => e.id), ['a', 'b', 'c']);
      expect(filterEvents(all, query: 'day party').map((e) => e.id), ['b']);
      expect(filterEvents(all, query: 'mia').map((e) => e.id), ['b']);
      expect(filterEvents(all, query: 'dj one').map((e) => e.id), ['a', 'c']);
      expect(filterEvents(all, query: 'nothing like this'), isEmpty);
    });

    test('a category narrows, and works together with words', () {
      expect(filterEvents(all, category: 'Nightlife').map((e) => e.id), ['a']);
      expect(filterEvents(all, category: 'Nightlife', query: 'brunch'), isEmpty);
    });
  });

  group('priceLabelFor', () {
    test('says from what price, free, sold out, or coming soon', () {
      expect(priceLabelFor(event(eventRow(tiers: [tierRow(price: 7500), tierRow(id: 't2', price: 5000)]))), 'From ${formatMoney(5000, currency: 'cad')}');
      expect(priceLabelFor(event(eventRow(tiers: [tierRow(price: 0)]))), 'Free');
      expect(priceLabelFor(event(eventRow(tiers: [tierRow(capacity: 10, sold: 10)]))), 'Sold out');
      expect(priceLabelFor(event(eventRow(tiers: const []))), 'Tickets coming soon');
    });

    test('the cheapest type that is still on sale sets the price, not a sold out one', () {
      expect(priceLabelFor(event(eventRow(tiers: [tierRow(id: 'gone', price: 1000, capacity: 5, sold: 5), tierRow(id: 'open', price: 4000)]))), 'From ${formatMoney(4000, currency: 'cad')}');
    });
  });

  group('when events happen', () {
    // Saturday 24 Oct 2026, 10pm (tonight is Saturday's night); Sunday 25 Oct 2026, 2am is still Saturday's night.
    SiteEvent at(String id, String start, {String? end}) => event(eventRow(id: id, start: start, end: end, cover: null));
    final saturdayNight = DateTime(2026, 10, 24, 22);

    test('before six in the morning it is still the night before', () {
      expect(nightOfInstant(DateTime(2026, 10, 25, 2)), DateTime(2026, 10, 24));
      expect(nightOfInstant(DateTime(2026, 10, 25, 5, 59)), DateTime(2026, 10, 24));
      expect(nightOfInstant(DateTime(2026, 10, 25, 6)), DateTime(2026, 10, 25));
      expect(nightOfInstant(DateTime(2026, 10, 24, 22)), DateTime(2026, 10, 24));
    });

    test('tonight is an event that starts in tonight\'s night, or is on now', () {
      final local = DateTime.utc(2026, 10, 24, 23).toLocal();
      final here = event(eventRow(id: 'a', start: DateTime(local.year, local.month, local.day, 23).toUtc().toIso8601String(), end: DateTime(local.year, local.month, local.day + 1, 5).toUtc().toIso8601String(), cover: null));
      final tonight = DateTime(local.year, local.month, local.day, 22);
      expect(happensTonight(here, tonight), isTrue);
      final tomorrow = event(eventRow(id: 'b', start: DateTime(local.year, local.month, local.day + 1, 23).toUtc().toIso8601String(), end: DateTime(local.year, local.month, local.day + 2, 5).toUtc().toIso8601String(), cover: null));
      expect(happensTonight(tomorrow, tonight), isFalse);
      expect(happensTonight(here, DateTime(local.year, local.month, local.day + 1, 2)), isTrue, reason: 'at 2am it is still the same night, and the event is on');
    });

    test('this weekend is Friday, Saturday and Sunday night; from Monday to Thursday it looks ahead, from Friday it includes the weekend that is on', () {
      DateTime d(int day, int h) => DateTime(2026, 10, day, h);
      SiteEvent on(DateTime when) => event(eventRow(id: 'x${when.day}${when.hour}', start: when.toUtc().toIso8601String(), end: when.add(const Duration(hours: 5)).toUtc().toIso8601String(), cover: null));
      // Wednesday 21 Oct: the weekend is Fri 23 to Sun 25.
      final wed = d(21, 12);
      expect(happensThisWeekend(on(d(23, 23)), wed), isTrue);
      expect(happensThisWeekend(on(d(24, 23)), wed), isTrue);
      expect(happensThisWeekend(on(d(25, 22)), wed), isTrue);
      expect(happensThisWeekend(on(d(22, 23)), wed), isFalse, reason: 'Thursday');
      expect(happensThisWeekend(on(d(26, 22)), wed), isFalse, reason: 'Monday night');
      expect(happensThisWeekend(on(d(30, 23)), wed), isFalse, reason: 'next weekend');
      // Saturday 24 Oct, 10pm: the weekend that is on.
      expect(happensThisWeekend(on(d(23, 23)), saturdayNight), isTrue);
      expect(happensThisWeekend(on(d(25, 22)), saturdayNight), isTrue);
      expect(happensThisWeekend(on(d(30, 23)), saturdayNight), isFalse);
      // Sunday 25 Oct, 2am is still Saturday's night; Monday 26 Oct 3am is still Sunday's night.
      expect(happensThisWeekend(on(d(24, 23)), d(25, 2)), isTrue);
      expect(happensThisWeekend(on(d(30, 23)), d(26, 3)), isFalse);
      // Monday 26 Oct, noon: next weekend is Fri 30 Oct to Sun 1 Nov.
      expect(happensThisWeekend(on(d(30, 23)), d(26, 12)), isTrue);
      expect(happensThisWeekend(on(DateTime(2026, 11, 1, 22)), d(26, 12)), isTrue);
    });

    test('filterEventsByDate keeps all for any date', () {
      final all = [at('a', '2099-10-24T23:00:00Z'), at('b', '2099-10-25T23:00:00Z')];
      expect(filterEventsByDate(all, DateFilter.any, DateTime(2099, 1, 1)), all);
    });
  });
}
