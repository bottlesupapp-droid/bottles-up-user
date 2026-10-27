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
    'Your account id, which links your tickets, bookings and posts to you. The same account works on the BottlesUp website.',
  ]),
  DataSection('Your tickets and bookings', [
    'The tickets you buy, the tables you book, the bottles you order and what you paid.',
    'The name and e-mail address of each guest you invite: their ticket is sent there.',
    'The reason you give when you ask a venue for a refund or report a problem with a payment.',
    'If you ask friends to pay their share of your table, who you asked, how much and whether they paid. If a friend asks you, the host\'s first name, the venue, the night and your share, and your payment.',
  ]),
  DataSection('Hiring professionals', [
    'If you ask a professional (a DJ, a photographer and so on) for a job: the day, the place, the number of guests, your budget and what you wrote, their quote, the booking and what was paid. The professional sees your name and username.',
    'The reason you give if you cancel a booking or say something went wrong. BottlesUp reads it if it has to decide.',
    'If you are the professional: the services you list with their prices, the days you mark as busy, and the quotes and bookings you make.',
  ]),
  DataSection('Events at venues and teams', [
    'If you ask a venue to host your event: the day, the hours, the kind of event, how many people you expect, the space, equipment, staffing, your budget and what you wrote, the venue\'s offer and whether you agreed, the schedule and tasks you and the venue add, and the professionals and public event you link. The venue sees the name and username of the person who asked.',
    'If you run a professional\'s profile and invite people to its team: their usernames, the role you give them and when they accepted or left. Every invitation and change is logged for the owner and for BottlesUp.',
    'The money in a venue hire is agreed here and settled between you and the venue: BottlesUp does not take it.',
  ]),
  DataSection('Your profile', [
    'A username, and if you add them a short bio, your city, links to your pages and up to ten interests. Your profile is public unless you make it private in Privacy settings.',
    'If you open a business profile (a DJ, a photographer, an event group), its name, its category and the same details.',
  ]),
  DataSection('Photos and videos', [
    'A profile picture, only if you choose one from your photos. The app reads only the photo you pick. It is stored with BottlesUp and shown by its web address.',
    'The photos and videos you choose from your phone for a post, a story or a reel. They are stored privately with BottlesUp and shown only to the people who may see that post. A story is hidden after a day and deleted a week later.',
  ]),
  DataSection('What you write and do', [
    'Your captions, comments and reviews, and the reason you give when you report something. Posts, comments and reviews stay until you delete them.',
    'Your likes, saves, follows, blocks and which stories you have seen.',
  ]),
  DataSection('Your messages', [
    'The messages you send in direct, group and booking conversations, and who is in each conversation. You can delete a message you sent.',
  ]),
  DataSection('Notifications', [
    'A list of what happened to you (a new follower, a like, a comment, a message), kept so it is there when you open Notifications. Ones you have read are removed after 90 days. You choose which kinds you get in Notification settings.',
  ]),
  DataSection('Caption ideas', [
    'If you ask for caption ideas, the few words you typed (and the name of the place or event you tagged) are sent to an AI service run by Anthropic, which writes three drafts. Your picture, your account and other people\'s words are not sent, and BottlesUp does not keep the words. Nothing is posted until you choose.',
  ]),
  DataSection('Payments', [
    'You pay on Stripe\'s own page. Your card details are typed there and never reach the app or BottlesUp. BottlesUp keeps what you bought and what was paid.',
  ]),
  DataSection('What the app does not collect', [
    'Your location, your contacts, an advertising id, your browsing or search history (what you search for is used to show results and is not kept), or analytics about how you use the app. There is no crash reporting and no advertising.',
  ]),
  DataSection('On your phone', [
    'Your sign-in is kept on your phone so you stay signed in, until you sign out.',
  ]),
  DataSection('Deleting it', [
    'Profile > Delete account removes your sign-in, your profiles and everything you posted, wrote, sent or saved, and your pictures and videos. Records of payments already made are kept.',
  ]),
];
