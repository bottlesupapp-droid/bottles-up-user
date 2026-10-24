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
}
