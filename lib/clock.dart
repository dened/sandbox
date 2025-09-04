import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Main entry point of the Flutter application.
/// Runs the [App] widget and handles top-level errors.
void main() => runZonedGuarded<void>(
  () => runApp(const App()),
  (error, stackTrace) => print('Top level exception: $error\n$stackTrace'),
);

/// {@template app}
/// App widget.
/// {@endtemplate}
class App extends StatefulWidget {
  /// {@macro app}
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 10));
    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Material App',
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      appBar: AppBar(title: const Text('Material App Bar')),

      body: SafeArea(
        child: Align(
          alignment: Alignment.topLeft,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(64),
              child: SizedBox.expand(child: CustomPaint(painter: ClockPainter(repaint: _controller))),
            ),
          ),
        ),
      ),
    ),
  );
}

class ClockPainter extends CustomPainter {
  ClockPainter({super.repaint});

  @override
  void paint(Canvas canvas, Size size) {
    final date = DateTime.now();

    canvas
      ..save()
      ..translate(size.width / 2, size.height / 2);

    final clockRadius = size.shortestSide / 2;
    final ciferblatRadius = clockRadius * 0.835;
    final centerRadius = clockRadius * 0.11;

    final hourTickLength = clockRadius * .093;
    final hourArrrowLenght = clockRadius * 0.36;
    final minuteArrrowLenght = clockRadius * 0.54;
    final secondArrrowLenght = clockRadius * 0.58;

    const pinkColor = Color(0xffff5876);
    const grayColor = Color(0xff405b6c);
    const blueColor = Color(0xff86dcff);

    final hourArrowPaint =
        Paint()
          ..color = grayColor
          ..strokeWidth = clockRadius * .12
          ..strokeCap = StrokeCap.round;

    final minuteArrowPaint =
        Paint()
          ..color = const Color.fromARGB(255, 81, 115, 136)
          ..strokeWidth = clockRadius * .12
          ..strokeCap = StrokeCap.round;

    final secondArrowPaint =
        Paint()
          ..color = blueColor
          ..strokeWidth = clockRadius * .06
          ..strokeCap = StrokeCap.round;

    final tickPaint =
        Paint()
          ..color = grayColor
          ..strokeWidth = clockRadius * .062
          ..strokeCap = StrokeCap.round;

    final shadowPaint = Paint()..color = Colors.black12;

    /// Draw inner shadow
    void drawInnerShadow(double radius, double shadowSize) {
      /// If clock is small, do not draw shadow
      if (clockRadius < 128) return;

      final outer = Path()..addOval(Rect.fromCircle(center: Offset.zero, radius: radius));

      final inner = Path()..addOval(Rect.fromCircle(center: Offset.zero, radius: radius).translate(0, -shadowSize));

      final path = Path.combine(PathOperation.difference, outer, inner);

      canvas.drawPath(path, shadowPaint);
    }

    canvas
      ..drawCircle(Offset.zero, clockRadius, Paint()..color = pinkColor)
      ..drawCircle(Offset.zero, ciferblatRadius, Paint()..color = const Color(0xffe4eef9));

    drawInnerShadow(clockRadius, clockRadius * 0.08);
    drawInnerShadow(ciferblatRadius, ciferblatRadius * 0.08);

    /// Draw hours ticks
    {
      final metkaRadius = clockRadius * .73;
      for (var h = 0; h < 12; h += 3) {
        final angle = -math.pi / 2 + h * math.pi / 6;

        final p1 = Offset(
          (metkaRadius - hourTickLength) * math.cos(angle),
          (metkaRadius - hourTickLength) * math.sin(angle),
        );

        final p2 = Offset(metkaRadius * math.cos(angle), metkaRadius * math.sin(angle));

        canvas.drawLine(p1, p2, tickPaint);
      }
    }

    /// Draw arrows
    {
      final hour = date.hour;
      final minute = date.minute;
      final second = date.second;

      final hourAngle = -math.pi / 2 + (hour % 12 + minute / 60) * math.pi / 6;
      final minuteAngle = -math.pi / 2 + (minute + second / 60) * math.pi / 30;
      final secondAngle = -math.pi / 2 + second * math.pi / 30;

      // hour arrow
      canvas
        ..drawLine(
          Offset.zero,
          Offset(hourArrrowLenght * math.cos(hourAngle), hourArrrowLenght * math.sin(hourAngle)),
          hourArrowPaint,
        )
        // minute arrow
        ..drawLine(
          Offset.zero,
          Offset(minuteArrrowLenght * math.cos(minuteAngle), minuteArrrowLenght * math.sin(minuteAngle)),
          minuteArrowPaint,
        )
        // second arrow
        ..drawLine(
          Offset.zero,
          Offset(secondArrrowLenght * math.cos(secondAngle), secondArrrowLenght * math.sin(secondAngle)),
          secondArrowPaint,
        );
    }

    // Draw center
    canvas.drawCircle(Offset.zero, centerRadius, Paint()..color = pinkColor);
    drawInnerShadow(centerRadius, centerRadius * 0.75);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
