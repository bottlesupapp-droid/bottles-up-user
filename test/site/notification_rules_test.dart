import 'package:bottles_up_user/site/rules/notification_rules.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('every kind the website writes is in exactly one group', () {
    final kinds = [for (final g in notificationGroups) ...g.kinds];
    expect(kinds.toSet(), {'follow', 'follow_request', 'follow_accepted', 'like', 'comment', 'reply', 'tag', 'review_reply'});
    expect(kinds, hasLength(8));
  });

  test('a group is on when all of its kinds are, and a kind nobody mentioned is on', () {
    expect(notificationGroupOn(const {}, ['like']), isTrue);
    expect(notificationGroupOn(const {'like': false}, ['like']), isFalse);
    expect(notificationGroupOn(const {'comment': true, 'reply': false}, ['comment', 'reply']), isFalse);
    expect(notificationGroupOn(const {'comment': true, 'reply': true}, ['comment', 'reply']), isTrue);
    expect(notificationGroupOn(const {'comment': false}, ['comment', 'reply']), isFalse);
  });

  test('every group says what it is about', () {
    for (final g in notificationGroups) {
      expect(g.label.trim(), isNotEmpty);
      expect(g.hint.trim(), isNotEmpty);
    }
  });
}
