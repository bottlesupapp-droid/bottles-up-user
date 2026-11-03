import 'package:bottles_up_user/site/models/billing.dart';
import 'package:bottles_up_user/site/rules/billing_rules.dart';
import 'package:bottles_up_user/site/when.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/billing_fixtures.dart';

void main() {
  group('a tip', () {
    test('needs an amount of more than nothing and no more than the most', () {
      expect(checkTip(cents: null), 'Choose an amount.');
      expect(checkTip(cents: 0), 'Choose an amount.');
      expect(checkTip(cents: -100), 'Choose an amount.');
      expect(checkTip(cents: 1), isNull);
      expect(checkTip(cents: maxTipCents), isNull);
      expect(checkTip(cents: maxTipCents + 1), 'The most a tip can be is \$10,000.00.');
    });

    test('keeps its words to 200 characters, counted without the spaces round them', () {
      expect(checkTip(cents: 500, message: 'x' * 200), isNull);
      expect(checkTip(cents: 500, message: 'x' * 201), 'Keep the message to 200 characters.');
      expect(checkTip(cents: 500, message: '  ${'x' * 200}  '), isNull);
      expect(checkTip(cents: 500, message: null), isNull);
      expect(maxTipMessageLength, 200);
    });

    test('is offered at four set amounts', () {
      expect(tipChoices, [500, 1000, 2000, 5000]);
    });
  });

  group('a referral code', () {
    test('is tidied the way the website reads it', () {
      expect(normalizeReferralCode(' ab cd-12 34 '), 'ABCD1234');
      expect(normalizeReferralCode('abcd1234'), 'ABCD1234');
      expect(normalizeReferralCode('AB\tCD\n1234'), 'ABCD1234');
    });

    test('is eight capitals and digits', () {
      expect(checkReferralCode('ABCD1234'), isNull);
      expect(checkReferralCode('abcd-1234'), isNull);
      expect(checkReferralCode('ABCD123'), 'A code has 8 letters and numbers.');
      expect(checkReferralCode('ABCD12345'), 'A code has 8 letters and numbers.');
      expect(checkReferralCode('ABCD123!'), 'A code has 8 letters and numbers.');
      expect(checkReferralCode(''), 'A code has 8 letters and numbers.');
      expect(referralCodeLength, 8);
    });
  });

  group('a commission', () {
    test('is shown as a percentage', () {
      expect(percentText(0), '0%');
      expect(percentText(500), '5%');
      expect(percentText(250), '2.5%');
      expect(percentText(1234), '12.34%');
      expect(percentText(1005), '10.05%');
      expect(percentText(1050), '10.5%');
      expect(percentText(5), '0.05%');
      expect(percentText(10000), '100%');
    });
  });

  group('a subscription in words', () {
    final day = DateTime(2027, 3, 5, 12);
    Subscription sub({String status = 'active', bool cancelAtEnd = false, String? end = '2027-03-05T12:00:00'}) => parseSubscription(subscriptionRow(status: status, cancelAtEnd: cancelAtEnd, end: end))!;

    test('says when it renews', () {
      expect(subscriptionLine(sub()), 'It renews on ${formatDay(day)}.');
      expect(subscriptionLine(sub(end: null)), 'It renews by itself.');
    });

    test('says when it will end, if it will not renew', () {
      expect(subscriptionLine(sub(cancelAtEnd: true)), 'It will not renew: it ends on ${formatDay(day)}.');
      expect(subscriptionLine(sub(cancelAtEnd: true, end: null)), 'It will end at the end of this period.');
    });

    test('says a late payment is the thing to fix', () {
      expect(subscriptionLine(sub(status: 'past_due')), 'The last payment did not go through. Update your card to keep the lower commission.');
      expect(subscriptionLine(sub(status: 'past_due', cancelAtEnd: true)), startsWith('The last payment did not go through.'));
    });

    test('says when it ended', () {
      expect(subscriptionLine(sub(status: 'cancelled')), 'This subscription ended on ${formatDay(day)}.');
      expect(subscriptionLine(sub(status: 'cancelled', end: null)), 'This subscription has ended.');
      expect(subscriptionLine(sub(status: 'cancelled', cancelAtEnd: true)), 'This subscription ended on ${formatDay(day)}.');
    });
  });

  test('a price is shown with how often it is paid', () {
    final plans = parseBillingPlans(plansRow())!;
    expect(planPriceText(plans, SubPlan.monthly), '\$29.99 a month');
    expect(planPriceText(plans, SubPlan.yearly), '\$299.00 a year');
  });
}
