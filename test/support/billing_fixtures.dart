import 'fake_website.dart';

Map<String, dynamic> plansRow({int monthly = 2999, int yearly = 29900, int subscribedBps = 0, int standardBps = 500, String currency = 'cad'}) =>
    {'currency': currency, 'monthly_cents': monthly, 'yearly_cents': yearly, 'subscribed_commission_bps': subscribedBps, 'standard_commission_bps': standardBps};

Map<String, dynamic> subscriptionRow({String id = 'sub1', String profile = 'p-dj', String plan = 'yearly', String status = 'active', String? end = '2027-03-05T12:00:00Z', bool cancelAtEnd = false}) =>
    {'id': id, 'profile': profile, 'plan': plan, 'status': status, 'current_period_end': end, 'cancel_at_period_end': cancelAtEnd};

Map<String, dynamic> statsRow({int referred = 3, int credited = 2, int payable = 500, int paid = 1000, int credit = 500}) =>
    {'referred': referred, 'credited': credited, 'payable_cents': payable, 'paid_cents': paid, 'credit_cents': credit};

Map<String, dynamic> earningsRow({
  Map<String, dynamic>? hiring,
  Map<String, dynamic>? tips,
  Map<String, dynamic>? referrals,
  Map<String, dynamic>? subscription,
}) =>
    {
      'hiring': hiring ?? {'collected_cents': 100000, 'held_cents': 40000, 'earned_cents': 57000, 'withdrawable_cents': 20000, 'paid_cents': 37000, 'commission_cents': 3000},
      'tips': tips ?? {'collected_cents': 3000, 'earned_cents': 2850, 'withdrawable_cents': 1850, 'paid_cents': 1000, 'count': 4},
      'referrals': referrals ?? {'earned_cents': 1500, 'withdrawable_cents': 500, 'paid_cents': 1000},
      'subscription': subscription,
    };

Map<String, dynamic> tipRow({String id = 'tip1', String status = 'created', int amount = 1000, String currency = 'cad'}) =>
    {'id': id, 'status': status, 'amount_cents': amount, 'currency': currency, 'creator': profileRow(id: 'p-dj', kind: 'business', handle: 'djdee', name: 'DJ Dee', category: 'dj')};
