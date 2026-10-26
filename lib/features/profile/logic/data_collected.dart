/// What the app collects, in words a person can read (Profile > What this app collects). The same facts are declared to Apple in `ios/Runner/PrivacyInfo.xcprivacy` and written out in
/// `docs/DATA_COLLECTED_USER_APP.md`; `test/platform/store_config_test.dart` keeps the three in step. Change them together.
class DataSection {
  const DataSection(this.title, this.lines);

  final String title;
  final List<String> lines;
}

const List<DataSection> dataCollected = [
  DataSection('Your account', [
    'Your name and e-mail address, or your phone number if you sign in with it.',
    'An optional phone number and an optional age on your profile.',
    'Your account id, which links your tickets and bookings to you. The same account works on the BottlesUp website.',
  ]),
  DataSection('Your tickets and bookings', [
    'The tickets you buy, the tables you book, the bottles you order and what you paid.',
    'The name and e-mail address of each guest you invite: their ticket is sent there.',
    'The reason you give when you ask a venue for a refund or report a problem with a payment.',
  ]),
  DataSection('Photos', [
    'A profile picture, only if you choose one from your photos. The app reads only the photo you pick. It is stored with BottlesUp and shown by its web address.',
  ]),
  DataSection('Payments', [
    'You pay on Stripe\'s own page. Your card details are typed there and never reach the app or BottlesUp. BottlesUp keeps what you bought and what was paid.',
  ]),
  DataSection('What the app does not collect', [
    'Your location, your contacts, an advertising id, your browsing or search history, or analytics about how you use the app. There is no crash reporting and no advertising.',
  ]),
  DataSection('On your phone', [
    'Your sign-in is kept on your phone so you stay signed in, until you sign out.',
  ]),
  DataSection('Deleting it', [
    'Profile > Delete account removes your sign-in. Records of payments already made are kept.',
  ]),
];
