# What the BottlesUp customer app collects (27 Oct 2026)

The one list the store forms are answered from: Apple's App Privacy answers and the privacy manifest (`ios/Runner/PrivacyInfo.xcprivacy`), Google Play's Data safety form, and the in-app screen Profile > What this app collects (`lib/features/profile/logic/data_collected.dart`). `test/platform/store_config_test.dart` keeps the manifest, the in-app list and this file in step: change them together. Nothing here has been entered into App Store Connect or the Play Console; that is the owner's step.

All of it is collected for the app's own function (an account, tickets, bookings, a social profile and what is posted and said on it), is linked to the account, is not used for tracking, and is not shared for advertising. The BottlesUp account is the same one the BottlesUp website uses, and the data sits in BottlesUp's own Supabase project.

| Apple's kind | What it is here | Where it comes from |
|---|---|---|
| `Name` | your name; the name on a ticket or booking; the name of each guest you invite | sign-up, profile, buying, inviting a guest |
| `EmailAddress` | your sign-in e-mail; the e-mail of each guest you invite (their ticket is sent there) | sign-up, inviting a guest |
| `PhoneNumber` | an optional number on your profile and on a booking; a phone sign-in | profile, booking |
| `UserID` | your account id and username | sign-up, Edit profile |
| `PhotosorVideos` | a profile picture; the photos and videos the person picks from their phone for a post, a story or a reel | Edit profile, Create |
| `EmailsorTextMessages` | the messages sent in direct, group and booking conversations | Inbox |
| `OtherUserContent` | captions, comments, reviews, a bio, interests and links on a profile, the reason given when reporting a post, comment, message or person; the few words typed for a caption idea (sent to Anthropic, see below) | Create, comments, reviews, profile, report sheet |
| `ProductInteraction` | likes, saves, follows, blocks and which stories were seen, stored so the feed, the counts and the "seen" marks work | feed, profiles, stories |
| `CustomerSupport` | the reason given when asking for a refund or reporting a payment | My Night |
| `PurchaseHistory` | tickets bought, tables booked, bottles ordered, amounts paid; shares of a friend's table asked of the person or paid by them, and who a host asked | buying, booking, splitting a bill |
| `OtherDataTypes` | an optional age | Edit profile |

For Google Play's Data safety form the same facts apply: personal info (name, e-mail, phone, user ids, age), photos and videos, messages, other user-generated content, app interactions (declared as app functionality only), app activity is not collected for analytics, financial info is not collected (card details are typed on Stripe's page and never reach the app), data is encrypted in transit (HTTPS), and a person can ask for deletion in the app (Profile > Delete account) and on the website.

## The social side (added with the feed, stories, reels, messages and caption ideas)

- **Where it sits.** The pictures and videos of posts, stories and reels are in a PRIVATE storage bucket (`social-media`), shown by short-lived signed addresses to the people the post is for. (The profile picture stays in the public `media` bucket, as before.) Everything else is in closed tables reached only through database functions.
- **Caption ideas go to a third party.** When a person taps "Caption ideas", the few words they typed (and the name of a place or event they tagged) are sent by the website's `suggest-caption` function to Anthropic's API, which writes three drafts. The picture, the account and other people's words are not sent, BottlesUp stores neither the request nor the reply (it only counts how many a person has asked for today), and the function logs no text. Anthropic is a service provider here, not an advertiser; Anthropic's own terms govern what it does with the words. This must be named in the store forms as data shared with a third-party service, and in the website's privacy policy. The feature is off until the `ai_captions` switch is on.
- **What is deleted, and when.** A story is hidden after 24 hours and deleted a week after that; notifications read more than 90 days ago and caption-request counts older than two days are deleted nightly (`social_housekeeping`). Posts, comments, reviews, messages and reports stay until their owner deletes them, or until the account is deleted: deleting an account removes the person's profiles and everything that names them (proved by `tests/db/tests/540_social_account_deletion.sql`), and the `delete-account` function removes their folders in the storage bucket (a daily `sweep-social-media` run catches any that were missed).
- **Reports.** A report keeps who reported, what and why, for the BottlesUp team only; the person reported is never told who reported them.
- **Search text is not kept.** What a person types in the search box is used to find people and is not stored.

## Not collected

Location, contacts, microphone, camera, advertising id, device id, browsing or search history, analytics, crash reports, health or fitness data. No SDK in the app does any of this: the app has no analytics, advertising, crash-reporting, Firebase or Stripe SDK (guarded in `test/platform/store_config_test.dart`: adding one of those packages fails a test until its declaration is written).

## Things to know before answering the forms

- **The profile picture is stored in a public storage bucket** (`media`) and shown by its web address: anyone who has the address can open the picture. The in-app text says so. Making the bucket private (signed addresses) is a website/database change, not an app change.
- **Guests' names and e-mails are other people's data**, typed by the host and used only to send the guest's ticket. They are declared under Name and EmailAddress.
- **The in-app browser page that takes payment is Stripe's**, opened with the system's browser view. The app cannot read anything typed there, so payment information is not declared as collected by the app.
- **No plugin needs a "required reason" declaration of its own** (checked 27 Oct in the plugins' folders): app_links, google_sign_in_ios, image_picker_ios, path_provider_foundation, shared_preferences_foundation, sqflite_darwin and url_launcher_ios ship their own privacy manifests; share_plus and sign_in_with_apple use none of the listed system APIs. Re-check when a plugin is added or updated.
- **Google and Apple sign-in code is in the app but no button shows it**, so no third-party sign-in is offered (Apple's rule about offering Sign in with Apple does not apply while that holds). If the buttons come back, revisit this file, the entitlements and the Apple rule.
- **Apple's own checker has not run on this manifest**: it runs when a build is archived and uploaded. After the first upload, read any e-mail Apple sends about the privacy manifest.
