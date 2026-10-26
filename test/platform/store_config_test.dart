import 'dart:io';

import 'package:bottles_up_user/features/profile/logic/data_collected.dart';
import 'package:bottles_up_user/features/profile/screens/data_collected_screen.dart';
import 'package:bottles_up_user/site/site_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// What a store build depends on that no screen shows: the Android build file and manifest, the iOS project, the privacy manifest and the address a password-reset e-mail comes back to. None of
// this can be run here (nothing is built without being asked); these read the files and keep them in step with each other and with what the app says it collects.
void main() {
  String read(String path) => File(path).readAsStringSync();
  final gradle = read('android/app/build.gradle.kts');
  final manifest = read('android/app/src/main/AndroidManifest.xml');
  final plist = read('ios/Runner/Info.plist');
  final project = read('ios/Runner.xcodeproj/project.pbxproj');
  final pubspec = read('pubspec.yaml');

  group('Android build', () {
    test('the version comes from pubspec.yaml, not from numbers typed into the build file', () {
      expect(gradle, contains('versionCode = flutter.versionCode'));
      expect(gradle, contains('versionName = flutter.versionName'));
      expect(gradle, isNot(RegExp(r'versionCode\s*=\s*\d')));
      expect(gradle, isNot(RegExp(r'versionName\s*=\s*"')));
      expect(pubspec, matches(RegExp(r'^version: \d+\.\d+\.\d+\+\d+$', multiLine: true)));
    });

    test('a release build without a signing key stops with a message, and never falls back to the debug key', () {
      expect(gradle, contains('throw GradleException'));
      expect(gradle, contains('android/key.properties was not found'));
      expect(gradle, contains('allowUnsignedRelease'));
      expect(gradle, isNot(contains('signingConfigs.getByName("debug")')));
      for (final k in ['keyAlias', 'keyPassword', 'storeFile', 'storePassword']) {
        expect(gradle, contains('"$k"'), reason: k);
        expect(read('android/key.properties.example'), contains('$k='), reason: k);
      }
    });

    test('the signing key and keystore are never committed', () {
      final ignore = read('android/.gitignore');
      expect(ignore, contains('key.properties'));
      expect(ignore, contains('**/*.jks'));
      expect(ignore, contains('**/*.keystore'));
    });

    test('the Android id is the agreed one, and the app is called BottlesUp', () {
      expect(gradle, contains('applicationId = "com.bottlesup.user"'));
      expect(gradle, contains('namespace = "com.bottlesup.user"'));
      expect(manifest, contains('android:label="BottlesUp"'));
      expect(File('android/app/src/main/kotlin/com/bottlesup/user/MainActivity.kt').existsSync(), isTrue);
    });
  });

  group('Android manifest', () {
    test('a release build can reach the network, and asks for no location', () {
      expect(manifest, contains('<uses-permission android:name="android.permission.INTERNET"/>'));
      expect(RegExp(r'<uses-permission[^>]*LOCATION').hasMatch(manifest.replaceAll(RegExp(r'<!--[\s\S]*?-->'), '')), isFalse);
    });

    test('the app opens from its own scheme only: the password-reset and sign-in links; no payment link, no web addresses', () {
      final all = manifest.replaceAll(RegExp(r'<!--[\s\S]*?-->'), '');
      final live = RegExp(r'<activity[\s\S]*?</activity>').firstMatch(all)!.group(0)!;
      final data = RegExp(r'<data ([^>]*)/>').allMatches(live).map((m) => m.group(1)!.replaceAll(RegExp(r'\s+'), ' ').trim()).toList();
      expect(data, ['android:scheme="bottlesup" android:host="reset-password"', 'android:scheme="bottlesup" android:host="auth-callback"']);
      expect(live, isNot(contains('android:host="payment"')));
      expect(live, isNot(contains('autoVerify')), reason: 'verification is for web addresses, which this app does not take');
      expect(live, isNot(contains('android:scheme="https"')));
      expect(live, isNot(contains('android:scheme="http"')));
    });
  });

  group('the password-reset e-mail comes back into the app', () {
    final uri = Uri.parse(passwordResetRedirect);

    test('the address is on the app\'s own scheme and host', () {
      expect([uri.scheme, uri.host], ['bottlesup', 'reset-password']);
    });

    test('Android opens that address, and iOS has the scheme', () {
      expect(manifest, contains('android:scheme="${uri.scheme}" android:host="${uri.host}"'));
      expect(plist, contains('<string>${uri.scheme}</string>'));
      expect(RegExp(r'<key>CFBundleURLSchemes</key>\s*<array>\s*<string>bottlesup</string>\s*</array>').hasMatch(plist), isTrue);
    });

    test('the code asks for that address, and the link handler reads that host', () {
      expect(read('lib/features/auth/services/auth_service.dart'), contains('redirectTo: passwordResetRedirect'));
      expect(read('lib/features/auth/services/deep_link_handler.dart'), contains("uri.scheme == 'bottlesup' && uri.host == '${uri.host}'"));
    });

    test('no other address of the old kind is left anywhere in the app\'s code', () {
      final all = Directory('lib').listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart')).map((f) => f.readAsStringSync()).join('\n');
      expect(all, isNot(contains('bottlesupapp://')));
      expect(all, isNot(contains('bottlesup://payment')));
    });
  });

  group('iOS project', () {
    test('the bundle id is the agreed one for the app and its tests, and the app is called BottlesUp', () {
      final ids = RegExp(r'PRODUCT_BUNDLE_IDENTIFIER = ([^;]+);').allMatches(project).map((m) => m.group(1)!).toSet();
      expect(ids, {'com.btlup.pop', 'com.btlup.pop.RunnerTests'});
      expect(RegExp(r'<key>CFBundleDisplayName</key>\s*<string>BottlesUp</string>').hasMatch(plist), isTrue);
    });

    test('the version and build number come from pubspec.yaml', () {
      expect(plist, contains(r'<string>$(FLUTTER_BUILD_NAME)</string>'));
      expect(plist, contains(r'<string>$(FLUTTER_BUILD_NUMBER)</string>'));
    });

    test('the app says it uses only the encryption the phone already has (HTTPS), so each upload is not stopped to ask', () {
      expect(RegExp(r'<key>ITSAppUsesNonExemptEncryption</key>\s*<false/>').hasMatch(plist), isTrue);
    });

    test('no location, camera, microphone or contacts wording is asked for, because nothing in the app uses them', () {
      for (final k in ['NSLocation', 'NSCamera', 'NSMicrophone', 'NSContacts', 'NSPhotoLibraryAddUsage']) {
        expect(plist, isNot(contains(k)), reason: k);
      }
    });

    test('the plugins that would need those declarations are not in the app', () {
      for (final p in ['geolocator', 'geocoding', 'firebase_core', 'firebase_messaging', 'flutter_stripe', 'mobile_scanner', 'permission_handler', 'contacts_service', 'sentry_flutter']) {
        expect(pubspec, isNot(contains('\n  $p:')), reason: '$p needs a declaration (privacy manifest, usage text) before it comes back');
      }
    });
  });

  group('the privacy manifest', () {
    final file = File('ios/Runner/PrivacyInfo.xcprivacy');

    // What the app collects, as Apple names the kinds, and where the app says it in words.
    const expected = {
      'Name': 'your name',
      'EmailAddress': 'e-mail',
      'PhoneNumber': 'phone number',
      'UserID': 'account id',
      'PhotosorVideos': 'profile picture',
      'CustomerSupport': 'refund',
      'PurchaseHistory': 'tickets you buy',
      'OtherDataTypes': 'age',
    };

    List<String> declared() => RegExp(r'<string>NSPrivacyCollectedDataType([A-Za-z]+)</string>').allMatches(file.readAsStringSync()).map((m) => m.group(1)!).where((n) => !n.startsWith('Purpose')).toList();

    test('it says the app does not track, names no tracking domain, and every kind is for the app\'s own function', () {
      final t = file.readAsStringSync();
      expect(t, startsWith('<?xml'));
      expect(RegExp(r'<key>NSPrivacyTracking</key>\s*<false/>').hasMatch(t), isTrue);
      expect(RegExp(r'<key>NSPrivacyTrackingDomains</key>\s*<array/>').hasMatch(t), isTrue);
      expect(RegExp(r'<key>NSPrivacyCollectedDataTypeTracking</key>\s*<true/>').hasMatch(t), isFalse);
      final purposes = RegExp(r'<string>(NSPrivacyCollectedDataTypePurpose[A-Za-z]+)</string>').allMatches(t).map((m) => m.group(1)!).toSet();
      expect(purposes, {'NSPrivacyCollectedDataTypePurposeAppFunctionality'}, reason: 'no analytics, no advertising');
      expect(RegExp(r'<key>NSPrivacyCollectedDataTypeLinked</key>\s*<true/>').allMatches(t).length, expected.length);
    });

    test('it declares exactly the kinds of data the app says it collects, each once', () {
      expect(declared().toSet(), expected.keys.toSet());
      expect(declared().length, expected.length);
    });

    test('it never declares what the app says it does not collect (location, contacts, advertising, browsing), nor card details, which stay on Stripe\'s page', () {
      final says = dataCollected.firstWhere((s) => s.title == 'What the app does not collect').lines.join(' ');
      expect(says, allOf(contains('location'), contains('contacts'), contains('advertising id'), contains('browsing')));
      for (final never in ['Location', 'Contacts', 'DeviceID', 'AdvertisingData', 'BrowsingHistory', 'SearchHistory', 'PaymentInfo', 'CreditInfo', 'Health', 'Fitness', 'SensitiveInfo', 'CrashData', 'ProductInteraction']) {
        expect(declared(), isNot(contains(never)), reason: never);
      }
      expect(dataCollected.firstWhere((s) => s.title == 'Payments').lines.join(' '), allOf(contains('Stripe'), contains('never reach')));
    });

    test('every kind declared is said in words in the app\'s own list', () {
      final all = dataCollected.expand((s) => s.lines).join(' ').toLowerCase();
      for (final needle in expected.values) {
        expect(all, contains(needle), reason: needle);
      }
    });

    test('the document the stores are answered from lists the same kinds', () {
      final doc = read('docs/DATA_COLLECTED_USER_APP.md');
      for (final k in expected.keys) {
        expect(doc, contains('`$k`'), reason: k);
      }
    });

    test('the Xcode project carries the file in the Runner app target (not in the tests), so a build bundles it', () {
      final ref = RegExp(r'(\w{24}) /\* PrivacyInfo\.xcprivacy \*/ = \{isa = PBXFileReference;[^}]*path = PrivacyInfo\.xcprivacy;').firstMatch(project);
      expect(ref, isNotNull, reason: 'a file reference');
      final id = ref!.group(1)!;
      final build = RegExp('(\\w{24}) /\\* PrivacyInfo\\.xcprivacy in Resources \\*/ = \\{isa = PBXBuildFile; fileRef = $id ').firstMatch(project);
      expect(build, isNotNull, reason: 'a build file');
      final group = RegExp(r'/\* Runner \*/ = \{\s*isa = PBXGroup;\s*children = \(([^)]*)\)').firstMatch(project)!.group(1)!;
      expect(group, contains(id));
      final phases = RegExp(r'isa = PBXResourcesBuildPhase;[\s\S]*?files = \(([^)]*)\)').allMatches(project).map((m) => m.group(1)!).toList();
      final withIt = phases.where((f) => f.contains(build!.group(1)!)).toList();
      expect(withIt.length, 1);
      expect(withIt.single, contains('Main.storyboard'), reason: 'the app target, not RunnerTests');
    });
  });

  group('What this app collects (the screen)', () {
    testWidgets('lists every section, with its words', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: DataCollectedScreen()));
      expect(find.text('What this app collects'), findsOneWidget);
      for (final s in dataCollected.take(3)) {
        expect(find.text(s.title), findsOneWidget);
      }
      tester.view.physicalSize = const Size(800, 4000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pump();
      for (final s in dataCollected) {
        expect(find.text(s.title), findsOneWidget, reason: s.title);
        for (final l in s.lines) {
          expect(find.text(l), findsOneWidget, reason: l);
        }
      }
    });
  });
}
