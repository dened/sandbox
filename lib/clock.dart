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
              child: SizedBox.expand(child: CustomPaint(painter: RPSCustomPainter(repaint: _controller))),
            ),
          ),
        ),
      ),
    ),
  );
}

class RPSCustomPainter extends CustomPainter {
  RPSCustomPainter({super.repaint});

  @override
  void paint(Canvas canvas, Size size) {
    const originalSize = 512.0;
    final scale = size.shortestSide / originalSize;
    final dx = (size.width - originalSize * scale) / 2;
    final dy = (size.height - originalSize * scale) / 2;

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

    /// тень внешнего круга
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

    /// Draw hour arrow
    {
      final hour = date.hour;
      final minute = date.minute;
      final second = date.second;

      final hourAngle = -math.pi / 2 + (hour % 12 + minute / 60) * math.pi / 6;
      final minuteAngle = -math.pi / 2 + (minute + second / 60) * math.pi / 30;
      final secondAngle = -math.pi / 2 + second * math.pi / 30;

      // Draw hour arrow
      canvas
        ..drawLine(
          Offset.zero,
          Offset(hourArrrowLenght * math.cos(hourAngle), hourArrrowLenght * math.sin(hourAngle)),
          hourArrowPaint,
        )
        // Draw minute arrow
        ..drawLine(
          Offset.zero,
          Offset(minuteArrrowLenght * math.cos(minuteAngle), minuteArrrowLenght * math.sin(minuteAngle)),
          minuteArrowPaint,
        )
        // Draw second arrow
        ..drawLine(
          Offset.zero,
          Offset(secondArrrowLenght * math.cos(secondAngle), secondArrrowLenght * math.sin(secondAngle)),
          secondArrowPaint,
        );
    }

    canvas.drawCircle(Offset.zero, centerRadius, Paint()..color = pinkColor);

    drawInnerShadow(centerRadius, centerRadius * 0.75);

    // generated code
    canvas
      ..restore()
      ..save()
      ..translate(dx, dy)
      ..scale(scale);

    final shapes = <_Shape>[
      // _Shape(_path0, const Color(0xffff5876).withAlpha(100)), // внешний круг (фон)
      // _Shape(_path1, const Color(0xffe6485d)), // тень внешнего круга
      // _Shape(_path2, const Color(0xffe4eef9).withAlpha(100)), // внутренняя белая зона
      // _Shape(_path3, const Color(0xffd5e0f2)), // тень внутренней зоны
      // _Shape(_path4, const Color(0xff405b6c).withAlpha(100)), // стрелка (правая, часовая)
      // _Shape(_path5, const Color(0xff405b6c)), // стрелка (левая, минутная)
      // _Shape(_path6, const Color(0xff86dcff)), // верх стрелки (указатель)
      // _Shape(_path7, const Color(0xff2d4456)), // основание часовой стрелки
      // _Shape(_path8, const Color(0xff2d4456)), // основание минутной стрелки
      // _Shape(_path9, const Color(0xffff5876)), // центр (розовый кружок)
      // _Shape(_path10, const Color(0xffe6485d)), // тень центра
      // _Shape(_path11, const Color(0xff405b6c).withAlpha(100)), // метка сверху (12 часов)
      // _Shape(_path12, const Color(0xff405b6c)), // метка снизу (6 часов)
      // _Shape(_path13, const Color(0xff405b6c)), // метка справа (3 часа)
      // _Shape(_path14, const Color(0xff405b6c)), // метка слева (9 часов)
    ];

    for (final s in shapes) {
      final paint = Paint()..color = s.color;
      canvas.drawPath(s.build(), paint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Shape {
  _Shape(this.build, this.color);
  final Path Function() build;
  final Color color;
}

/// --- Paths ---

Path _path0() {
  // внешний круг (основной фон часов)
  return Path()
    ..moveTo(512, 256)
    ..cubicTo(512, 252.89, 511.944, 249.792, 511.835, 246.709)
    ..cubicTo(506.944, 109.628, 394.275, 0, 256, 0)
    ..cubicTo(117.725, 0, 5.056, 109.628, 0.166, 246.709)
    ..cubicTo(0.056, 249.792, 0, 252.89, 0, 256)
    ..cubicTo(0, 397.385, 131.502, 502.71, 256, 502.71)
    ..cubicTo(382.754, 502.71, 512, 397.385, 512, 256)
    ..close();
}

Path _path1() {
  // тень внешнего круга
  return Path()
    ..moveTo(256, 493.419)
    ..cubicTo(117.727, 493.419, 5.078, 383.788, 0.186, 246.709)
    ..cubicTo(0.075, 249.795, 0, 252.888, 0, 256)
    ..cubicTo(0, 397.385, 114.615, 512, 256, 512)
    ..cubicTo(397.385, 512, 512, 397.385, 512, 256)
    ..cubicTo(512, 252.888, 511.925, 249.795, 511.815, 246.71)
    ..cubicTo(506.922, 383.789, 394.273, 493.419, 256, 493.419)
    ..close();
}

Path _path2() {
  // внутренняя белая зона циферблата
  return Path()
    ..moveTo(469.419, 246.709)
    ..cubicTo(464.555, 133.042, 370.865, 42.382, 256, 42.382)
    ..cubicTo(141.135, 42.382, 47.445, 133.042, 42.581, 246.709)
    ..cubicTo(42.449, 249.79, 42.58, 456.03, 256, 456.03)
    ..cubicTo(469.42, 456.03, 469.551, 249.79, 469.419, 246.709)
    ..close();
}

Path _path3() {
  // тень внутренней зоны
  return Path()
    ..moveTo(256, 451.037)
    ..cubicTo(141.136, 451.037, 47.461, 360.375, 42.595, 246.709)
    ..cubicTo(42.463, 249.791, 42.382, 252.885, 42.382, 256)
    ..cubicTo(42.382, 373.977, 138.022, 469.617, 256, 469.617)
    ..cubicTo(373.978, 469.617, 469.618, 373.978, 469.618, 256)
    ..cubicTo(469.618, 252.886, 469.536, 249.791, 469.405, 246.71)
    ..cubicTo(464.539, 360.376, 370.864, 451.037, 256, 451.037)
    ..close();
}

Path _path4() {
  // часовая стрелка (правая, длинная часть)
  return Path()
    ..moveTo(333.595, 181.05)
    ..cubicTo(327.506, 175.045, 317.702, 175.112, 311.698, 181.2)
    ..lineTo(275.364, 218.037)
    ..lineTo(279.015, 235.574)
    ..lineTo(295.987, 241.228)
    ..lineTo(333.746, 202.947)
    ..cubicTo(339.75, 196.859, 339.683, 187.055, 333.595, 181.05)
    ..close();
}

Path _path5() {
  // минутная стрелка (левая, длинная часть)
  return Path()
    ..moveTo(234.082, 219.447)
    ..lineTo(151.68, 146.015)
    ..cubicTo(145.295, 140.325, 135.508, 140.889, 129.819, 147.274)
    ..cubicTo(124.13, 153.658, 124.693, 163.446, 131.078, 169.135)
    ..lineTo(215.103, 244.013)
    ..lineTo(232.612, 238.173)
    ..close();
}

Path _path6() {
  // верх стрелки (указатель минутной стрелки)
  return Path()
    ..moveTo(365.636, 355.837)
    ..cubicTo(363.878, 355.837, 362.112, 355.242, 360.66, 354.023)
    ..lineTo(262.587, 271.645)
    ..cubicTo(259.314, 268.895, 258.888, 264.011, 261.638, 260.738)
    ..cubicTo(264.388, 257.463, 269.271, 257.038, 272.546, 259.789)
    ..lineTo(370.619, 342.168)
    ..cubicTo(373.892, 344.918, 374.318, 349.802, 371.568, 353.075)
    ..cubicTo(370.037, 354.898, 367.844, 355.837, 365.636, 355.837)
    ..close();
}

Path _path7() {
  // основание часовой стрелки
  return Path()
    ..moveTo(215.103, 244.013)
    ..lineTo(229.563, 256.899)
    ..lineTo(248.133, 250.589)
    ..lineTo(247.126, 231.07)
    ..lineTo(234.083, 219.447)
    ..cubicTo(225.008, 224.9, 218.139, 233.637, 215.103, 244.013)
    ..close();
}

Path _path8() {
  // основание минутной стрелки
  return Path()
    ..moveTo(275.363, 218.038)
    ..lineTo(263.069, 230.502)
    ..lineTo(263.069, 254.968)
    ..lineTo(282.435, 254.968)
    ..lineTo(295.987, 241.229)
    ..cubicTo(292.263, 231.153, 284.836, 222.88, 275.363, 218.038)
    ..close();
}

Path _path9() {
  // центр (розовый кружок)
  return Path()
    ..moveTo(280.783, 246.708)
    ..cubicTo(277.021, 236.678, 267.344, 229.539, 256, 229.539)
    ..cubicTo(244.656, 229.539, 234.979, 236.678, 231.217, 246.708)
    ..cubicTo(230.133, 249.599, 231.145, 273.17, 256, 273.17)
    ..cubicTo(280.855, 273.17, 281.867, 249.599, 280.783, 246.708)
    ..close();
}

Path _path10() {
  // тень центра
  return Path()
    ..moveTo(256, 263.88)
    ..cubicTo(244.656, 263.88, 234.983, 256.74, 231.221, 246.71)
    ..cubicTo(230.136, 249.601, 229.539, 252.73, 229.539, 256)
    ..cubicTo(229.539, 270.614, 241.386, 282.46, 256, 282.46)
    ..cubicTo(270.613, 282.46, 282.459, 270.613, 282.459, 256)
    ..cubicTo(282.459, 252.73, 281.862, 249.601, 280.778, 246.71)
    ..cubicTo(277.017, 256.739, 267.344, 263.88, 256, 263.88)
    ..close();
}

Path _path11() {
  // метка сверху (12 часов)
  return Path()
    ..moveTo(263.757, 93.573)
    ..lineTo(263.757, 69.546)
    ..cubicTo(263.757, 65.262, 260.284, 61.789, 256, 61.789)
    ..cubicTo(251.716, 61.789, 248.243, 65.262, 248.243, 69.546)
    ..lineTo(248.243, 93.573)
    ..cubicTo(248.243, 97.857, 251.715, 101.33, 256, 101.33)
    ..cubicTo(260.285, 101.33, 263.757, 97.857, 263.757, 93.573)
    ..close();
}

Path _path12() {
  // метка снизу (6 часов)
  return Path()
    ..moveTo(248.243, 418.427)
    ..lineTo(248.243, 442.454)
    ..cubicTo(248.243, 446.738, 251.715, 450.211, 256, 450.211)
    ..cubicTo(260.285, 450.211, 263.757, 446.738, 263.757, 442.454)
    ..lineTo(263.757, 418.427)
    ..cubicTo(263.757, 414.143, 260.284, 410.67, 256, 410.67)
    ..cubicTo(251.716, 410.67, 248.243, 414.143, 248.243, 418.427)
    ..close();
}

Path _path13() {
  // метка справа (3 часа)
  return Path()
    ..moveTo(442.454, 263.757)
    ..cubicTo(446.739, 263.757, 450.211, 260.284, 450.211, 256)
    ..cubicTo(450.211, 251.716, 446.738, 248.243, 442.454, 248.243)
    ..lineTo(418.427, 248.243)
    ..cubicTo(414.143, 248.243, 410.67, 251.716, 410.67, 256)
    ..cubicTo(410.67, 260.284, 414.143, 263.757, 418.427, 263.757)
    ..close();
}

Path _path14() {
  // метка слева (9 часов)
  return Path()
    ..moveTo(69.546, 248.243)
    ..cubicTo(65.261, 248.243, 61.789, 251.716, 61.789, 256)
    ..cubicTo(61.789, 260.284, 65.261, 263.757, 69.546, 263.757)
    ..lineTo(93.573, 263.757)
    ..cubicTo(97.858, 263.757, 101.33, 260.284, 101.33, 256)
    ..cubicTo(101.33, 251.716, 97.857, 248.243, 93.573, 248.243)
    ..close();
}
