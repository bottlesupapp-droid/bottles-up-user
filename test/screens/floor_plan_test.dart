import 'package:bottles_up_user/features/tables/widgets/floor_plan.dart';
import 'package:bottles_up_user/site/models/venue.dart';
import 'package:bottles_up_user/site/rules/table_rules.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';

TableType table(String id, double x, double y, {String name = 'T'}) => parseTableType({...tableTypeRow(id: id, name: name, floorId: 'f1', x: x, y: y)})!;

const floor = Floor(id: 'f1', venueId: 'v1', label: 'Main floor', imageUrl: 'https://img.example/floor.png', sortOrder: 0);

void main() {
  test('a spot is placed as a percentage of the picture', () {
    final r = hotspotRect(table('a', 10, 20), const Size(400, 200));
    // 10% x 8% of 400 x 200 is 40 x 16 at (40, 40); the height is raised to 30 so a finger can hit it, around the same centre.
    expect([r.left, r.top, r.width, r.height], [40.0, 33.0, 40.0, 30.0]);
    expect(r.center, const Offset(60, 48));
  });

  test('a spot already big enough is not changed', () {
    final t = parseTableType({...tableTypeRow(floorId: 'f1', x: 50, y: 50), 'width': 20.0, 'height': 25.0})!;
    final r = hotspotRect(t, const Size(400, 200));
    expect([r.left, r.top, r.width, r.height], [200.0, 100.0, 80.0, 50.0]);
  });

  Future<void> show(WidgetTester tester, {required Set<String> unavailable, required bool canPick, required void Function(TableType) onPick, List<TableType>? tables}) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: 400,
            child: FloorPlan(
              floor: floor,
              tables: tables ?? [table('a', 10, 20, name: 'A1'), table('b', 60, 20, name: 'B2')],
              unavailable: unavailable,
              canPick: canPick,
              onPick: onPick,
              picture: const AspectRatio(aspectRatio: 2, child: ColoredBox(color: Colors.black)),
            ),
          ),
        ),
      ),
    ));
  }

  testWidgets('spots sit on the picture where the website put them', (tester) async {
    await show(tester, unavailable: {}, canPick: true, onPick: (_) {});
    final plan = tester.getRect(find.byType(FloorPlan));
    final spot = tester.getRect(find.byKey(const Key('spot-a')));
    expect(plan.width, 400);
    expect(plan.height, 200);
    expect(spot.left - plan.left, closeTo(40, 0.01));
    expect(spot.center.dy - plan.top, closeTo(48, 0.01));
    final other = tester.getRect(find.byKey(const Key('spot-b')));
    expect(other.left - plan.left, closeTo(240, 0.01));
  });

  testWidgets('a free spot can be tapped once a date and time are chosen', (tester) async {
    TableType? picked;
    await show(tester, unavailable: {}, canPick: true, onPick: (t) => picked = t);
    await tester.tap(find.byKey(const Key('spot-b')));
    expect(picked?.id, 'b');
  });

  testWidgets('a taken spot cannot be tapped', (tester) async {
    TableType? picked;
    await show(tester, unavailable: {'a'}, canPick: true, onPick: (t) => picked = t);
    await tester.tap(find.byKey(const Key('spot-a')));
    expect(picked, isNull);
    await tester.tap(find.byKey(const Key('spot-b')));
    expect(picked?.id, 'b');
  });

  testWidgets('before a date and time are chosen nothing can be tapped', (tester) async {
    TableType? picked;
    await show(tester, unavailable: {}, canPick: false, onPick: (t) => picked = t);
    await tester.tap(find.byKey(const Key('spot-a')));
    expect(picked, isNull);
  });

  testWidgets('the spots wait for the picture, because they are placed on it', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: FloorPlan(floor: floor, tables: [table('a', 10, 20)], unavailable: const {}, canPick: true, onPick: (_) {})),
    ));
    expect(find.byKey(const Key('spot-a')), findsNothing);
  });
}
