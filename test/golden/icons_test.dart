import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandbox/gen/assets.gen.dart';
import 'package:sandbox/generated/painters/calendar_painter.dart';
import 'package:sandbox/generated/painters/game_controller_painter.dart';
import 'package:sandbox/generated/painters/gift_painter.dart';
import 'package:sandbox/generated/painters/thumbs_up_painter.dart';

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
    //         body: Center(child: SvgPicture.asset(Assets.icons.thumbsUp)),
    //       ),
    //     ),
    //   );

    //   await expectLater(find.byType(SvgPicture), matchesGoldenFile('goldenicons/thumbsUp.png'));
    // });
    testWidgets('GameController', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: Center(child: ThumbsUp()))));

      await expectLater(find.byType(ThumbsUp), matchesGoldenFile('goldenicons/thumbsUp.png'));
    });
  });
}
