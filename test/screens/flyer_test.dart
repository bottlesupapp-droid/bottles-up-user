import 'dart:ui' as ui;

import 'package:bottles_up_user/features/discover/screens/event_page_screen.dart';
import 'package:bottles_up_user/features/discover/widgets/event_card.dart';
import 'package:bottles_up_user/shared/widgets/flyer.dart';
import 'package:bottles_up_user/shared/widgets/site_widgets.dart';
import 'package:bottles_up_user/site/models/site_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';
import '../support/pump_site.dart';

/// What the app asked a picture to be drawn like. The real picture comes through a cache on the phone's disk, which a test phone does not have: a plain box stands in, and this records the
/// address, the fit, the width and the height it was asked for (so a test can tell "cropped to a band" from "whole").
class _Asked {
  _Asked(this.url, this.fit, this.width, this.height);
  final String url;
  final BoxFit fit;
  final double? width;
  final double? height;
}

void main() {
  late FakeWebsite site;
  late List<_Asked> asked;
  var imageHeight = 300.0;

  setUp(() {
    asked = [];
    imageHeight = 300;
    NetworkPicture.imageOverride = (url, fit, width, height) {
      asked.add(_Asked(url, fit, width, height));
      // With no height asked for, a real picture takes the height of the image at this width: stand in with the test's own.
      return SizedBox(key: ValueKey('img:$url'), width: width, height: height ?? imageHeight);
    };
    addTearDown(() => NetworkPicture.imageOverride = null);
    site = FakeWebsite();
  });

  void flyerEvent({String? cover = 'https://img.example/flyer.jpg'}) {
    site.tables['site_events'] = [
      eventRow(cover: cover, tiers: [tierRow(id: 't1', name: 'General', price: 5000, capacity: 100, sold: 20)]),
    ];
  }

  Future<void> openEvent(WidgetTester tester) => pumpSite(tester, const EventPageScreen(eventId: 'e1'), site: site);

  group('the event page shows the whole flyer', () {
    testWidgets('it is drawn to fit, not cropped to a band: the flyer\'s own proportions, the page\'s width, no fixed height', (tester) async {
      flyerEvent();
      await openEvent(tester);
      final flyer = asked.where((a) => a.url == 'https://img.example/flyer.jpg').toList();
      expect(flyer, isNotEmpty);
      for (final a in flyer) {
        expect(a.fit, BoxFit.contain, reason: 'BoxFit.cover is what cut the names, dates, prices and logos off');
        expect(a.width, double.infinity);
        expect(a.height, isNull, reason: 'the old fixed 220 px band is what cropped it');
      }
    });

    testWidgets('a short flyer takes the room it needs and no more', (tester) async {
      flyerEvent();
      imageHeight = 300;
      await openEvent(tester);
      expect(tester.getSize(find.byKey(const Key('flyer'))).height, 300);
    });

    testWidgets('a very tall flyer is held to 60% of the screen (whole inside that), so the page is not pushed off the screen', (tester) async {
      flyerEvent();
      imageHeight = 5000;
      await openEvent(tester); // pumpSite makes the screen 2200 high
      expect(tester.getSize(find.byKey(const Key('flyer'))).height, 2200 * 0.6);
    });

    testWidgets('the event page still has its title and tickets under the flyer', (tester) async {
      flyerEvent();
      await openEvent(tester);
      expect(find.byKey(const Key('event-title')), findsOneWidget);
      expect(find.byKey(const Key('flyer')), findsOneWidget);
      expect(tester.getTopLeft(find.byKey(const Key('event-title'))).dy, greaterThan(tester.getBottomLeft(find.byKey(const Key('flyer'))).dy - 1));
    });

    testWidgets('an event with no flyer shows the quiet band, and nothing to tap', (tester) async {
      flyerEvent(cover: null);
      await openEvent(tester);
      expect(find.byKey(const Key('flyer')), findsNothing);
      expect(find.byKey(const Key('flyer-hint')), findsNothing);
      expect(find.byIcon(Icons.nightlife_outlined), findsOneWidget);
      expect(tester.getSize(find.descendant(of: find.byType(NetworkPicture), matching: find.byType(Container))).height, FlyerImage.emptyHeight);
      expect(FlyerImage.emptyHeight, 220);
    });

    testWidgets('while the flyer loads, the room is held open at the height of a tall flyer so the page does not jump when it arrives', (tester) async {
      flyerEvent();
      await openEvent(tester);
      final picture = tester.widget<NetworkPicture>(find.descendant(of: find.byKey(const Key('flyer')), matching: find.byType(NetworkPicture)));
      expect(picture.placeholderHeight, FlyerImage.loadingHeight);
      expect(FlyerImage.loadingHeight, 280);
    });

    testWidgets('it says it can be opened (a hint on the picture and a label for a screen reader)', (tester) async {
      final semantics = tester.ensureSemantics();
      flyerEvent();
      await openEvent(tester);
      expect(find.byKey(const Key('flyer-hint')), findsOneWidget);
      expect(find.bySemanticsLabel('Event flyer. Double tap to view it full screen.'), findsOneWidget);
      semantics.dispose();
    });
  });

  group('tap to see it full screen', () {
    testWidgets('a tap opens the flyer on its own black screen, whole, with zoom', (tester) async {
      flyerEvent();
      await openEvent(tester);
      expect(find.byKey(const Key('flyer-viewer')), findsNothing);
      await tester.tap(find.byKey(const Key('flyer')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('flyer-viewer')), findsOneWidget);
      final zoom = tester.widget<InteractiveViewer>(find.byKey(const Key('flyer-zoom')));
      expect(zoom.minScale, 1);
      expect(zoom.maxScale, greaterThan(1));
      final shown = asked.where((a) => a.url == 'https://img.example/flyer.jpg' && a.height == double.infinity).toList();
      expect(shown, isNotEmpty, reason: 'the full-screen picture is asked for at the full size of the screen');
      expect(shown.last.fit, BoxFit.contain);
      expect(tester.widget<Scaffold>(find.byKey(const Key('flyer-viewer'))).backgroundColor, Colors.black);
    });

    testWidgets('the cross closes it and the event is where it was', (tester) async {
      flyerEvent();
      await openEvent(tester);
      await tester.tap(find.byKey(const Key('flyer')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('flyer-close')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('flyer-viewer')), findsNothing);
      expect(find.byKey(const Key('event-title')), findsOneWidget);
    });

    testWidgets('the close button has a label for a screen reader', (tester) async {
      flyerEvent();
      await openEvent(tester);
      await tester.tap(find.byKey(const Key('flyer')));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Close'), findsOneWidget);
    });

    testWidgets('it is a full-screen page (a cross, not a back arrow) and says what it is to a screen reader', (tester) async {
      final semantics = tester.ensureSemantics();
      flyerEvent();
      await openEvent(tester);
      await tester.tap(find.byKey(const Key('flyer')));
      await tester.pumpAndSettle();
      final route = ModalRoute.of(tester.element(find.byKey(const Key('flyer-viewer'))))! as MaterialPageRoute<void>;
      expect(route.fullscreenDialog, isTrue);
      expect(find.bySemanticsLabel('Event flyer. Pinch to zoom.'), findsOneWidget);
      semantics.dispose();
    });
  });

  group('a card in a list shows the whole flyer too', () {
    SiteEvent event({String? cover = 'https://img.example/flyer.jpg'}) => parseSiteEvent(eventRow(cover: cover, tiers: [tierRow(id: 't1', name: 'General', price: 5000, capacity: 100, sold: 20)]))!;

    testWidgets('the flyer is drawn whole on top of a blurred copy of itself', (tester) async {
      await pumpSite(tester, SingleChildScrollView(child: EventCard(event: event(), onTap: () {})), site: site);
      final whole = tester.widget<NetworkPicture>(find.byKey(const Key('flyer-thumb-whole')));
      expect(whole.fit, BoxFit.contain, reason: 'the card used to crop the flyer to a 170 px band');
      expect(whole.url, 'https://img.example/flyer.jpg');
      // The blurred copy behind it is the only picture drawn cropped, and it is only a backdrop: it sits inside the blur.
      final behind = find.descendant(of: find.byType(ImageFiltered), matching: find.byType(NetworkPicture));
      expect(behind, findsOneWidget);
      expect(tester.widget<NetworkPicture>(behind).fit, BoxFit.cover);
      final cropped = tester.widgetList<NetworkPicture>(find.byType(NetworkPicture)).where((p) => p.fit == BoxFit.cover).toList();
      expect(cropped, hasLength(1), reason: 'nothing else on the card is cropped');
    });

    testWidgets('the blurred copy is darkened so the flyer on top stands out, and the band is 190 tall', (tester) async {
      await pumpSite(tester, SingleChildScrollView(child: EventCard(event: event(), onTap: () {})), site: site);
      expect(tester.widget<ImageFiltered>(find.byType(ImageFiltered)).imageFilter, ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18), reason: 'the backdrop is really blurred');
      expect(find.descendant(of: find.byType(FlyerThumb), matching: find.byWidgetPredicate((w) => w is ColoredBox && w.color == Colors.black45)), findsOneWidget);
      expect(tester.getSize(find.byType(FlyerThumb)).height, 190);
    });

    testWidgets('a card with no flyer keeps the quiet band', (tester) async {
      await pumpSite(tester, SingleChildScrollView(child: EventCard(event: event(cover: null), onTap: () {})), site: site);
      expect(find.byKey(const Key('flyer-thumb-whole')), findsNothing);
      expect(find.byIcon(Icons.nightlife_outlined), findsOneWidget);
    });

    testWidgets('tapping the card still opens the event (the flyer on a card is not a button)', (tester) async {
      var opened = 0;
      await pumpSite(tester, SingleChildScrollView(child: EventCard(event: event(), onTap: () => opened++)), site: site);
      await tester.tap(find.byKey(const Key('flyer-thumb-whole')));
      expect(opened, 1);
      expect(find.byKey(const Key('flyer-viewer')), findsNothing);
    });

    testWidgets('the card keeps its title, date and price', (tester) async {
      final e = event();
      await pumpSite(tester, SingleChildScrollView(child: EventCard(event: e, onTap: () {})), site: site);
      expect(find.byKey(Key('event-title-${e.id}')), findsOneWidget);
      expect(find.byKey(Key('event-when-${e.id}')), findsOneWidget);
      expect(find.byKey(Key('event-price-${e.id}')), findsOneWidget);
    });
  });

  group('NetworkPicture placeholder', () {
    testWidgets('holds the room open at placeholderHeight when the picture decides its own height', (tester) async {
      NetworkPicture.imageOverride = null; // the real picture, which cannot load a test address: it shows its placeholder
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: NetworkPicture(url: null, placeholderHeight: 123, width: 200))));
      // url null shows the placeholder directly
      expect(tester.getSize(find.descendant(of: find.byType(NetworkPicture), matching: find.byType(Container))).height, 123);
    });

    testWidgets('a fixed height still wins over placeholderHeight', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: NetworkPicture(url: null, height: 50, placeholderHeight: 123, width: 200))));
      expect(tester.getSize(find.descendant(of: find.byType(NetworkPicture), matching: find.byType(Container))).height, 50);
    });
  });
}
