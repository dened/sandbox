import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandbox/icons/game_controller.dart';

void main() {
  group('Icons golden test', () {
    // testWidgets('Calendar', (tester) async {
    //   await tester.pumpWidget(const MaterialApp(home: Scaffold(body: Center(child: Calendar()))));

    //   await expectLater(find.byType(Calendar), matchesGoldenFile('goldenicons/calendar.png'));
    // });
    // testWidgets('GameController', (tester) async {
    //   await tester.pumpWidget(
    //      MaterialApp(
    //       home: Scaffold(
    //         body: Center(child: SvgPicture.asset(Assets.icons.gameController, width: 512, height: 512)),
    //       ),
    //     ),
    //   );

    //   await expectLater(find.byType(SvgPicture), matchesGoldenFile('goldenicons/game_controller.png'));
    // });
    testWidgets('GameController', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: Center(child: GameController()))));

      await expectLater(find.byType(GameController), matchesGoldenFile('goldenicons/game_controller.png'));
    });
  });
}
