/// The kinds of notification the website writes, in the groups a person switches on and off together. [kinds] are the website's names.
const List<({String key, String label, String hint, List<String> kinds})> notificationGroups = [
  (key: 'followers', label: 'New followers and requests', hint: 'Someone follows you, asks to follow you, or accepts your request', kinds: ['follow', 'follow_request', 'follow_accepted']),
  (key: 'likes', label: 'Likes', hint: 'Someone likes one of your posts', kinds: ['like']),
  (key: 'comments', label: 'Comments and replies', hint: 'Someone comments on your post or replies to your comment', kinds: ['comment', 'reply']),
  (key: 'tags', label: 'Tags', hint: 'Someone tags you in a post', kinds: ['tag']),
  (key: 'review_replies', label: 'Replies to your reviews', hint: 'A venue or organizer answers a review you wrote', kinds: ['review_reply']),
];

/// A group is on when every kind in it is on; a kind the website did not mention counts as on (that is how it starts).
bool notificationGroupOn(Map<String, bool> prefs, List<String> kinds) => kinds.every((k) => prefs[k] ?? true);
