import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

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

      body: const SafeArea(
        // child: SingleChildScrollView(
        //   child: Column(
        //     children: [
        //       for (int i = 1; i <= 60; i++)
        //         Row(children: [for (int j = 1; j <= 20; j++) const SizedBox.square(dimension: 64, child: Clock())]),
        //     ],
        //   ),
        // ),
        child: Center(child: Clock()),
      ),
    ),
  );
}

class Clock extends StatelessWidget {
  const Clock({super.key});

  @override
  Widget build(BuildContext context) =>
      const Center(child: Padding(padding: EdgeInsets.all(8), child: SizedBox.expand(child: ClockWidget())));
}

class ClockWidget extends LeafRenderObjectWidget {
  const ClockWidget({super.key});

  @override
  RenderObject createRenderObject(BuildContext context) => ClockRenderBox();

  @override
  void updateRenderObject(BuildContext context, covariant ClockRenderBox renderObject) {}
}

class ClockRenderBox extends RenderBox with WidgetsBindingObserver {
  ClockRenderBox() : _clockPainter = _ArrowsPainter(), _dialPainter = _DialPainter();

  final _ArrowsPainter _clockPainter;
  final _DialPainter _dialPainter;

  /// Vsync loop ticker
  Ticker? _ticker;
  Duration _lastElapsed = Duration.zero;

  void _onTick(Duration elapsed) {
    /// Redraw only if the second has changed
    if (elapsed.inSeconds != _lastElapsed.inSeconds) {
      _lastElapsed = elapsed;
      markNeedsPaint();
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    WidgetsBinding.instance.addObserver(this);
    _ticker ??= Ticker(_onTick, debugLabel: 'ClockRenderBox')..start();
  }

  @override
  Size computeDryLayout(covariant BoxConstraints constraints) {
    /// Use the biggest size that fits within the constraints
    final size = constraints.biggest;

    _dialPainter.layout(size);
    _clockPainter.layout(size);

    return size;
  }

  @override
  void performLayout() {
    size = constraints.biggest;
    _dialPainter.layout(size);
    _clockPainter.layout(size);
  }

  @override
  void performResize() {
    size = computeDryLayout(constraints);
  }

  @override
  void detach() {
    super.detach();
    WidgetsBinding.instance.removeObserver(this);
    _ticker?.dispose();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas =
        context.canvas
          ..save()
          ..translate(offset.dx, offset.dy)
          ..clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    _dialPainter.paintDial(canvas, size);
    _clockPainter.paint(canvas, size, DateTime.now());
    _dialPainter.paintCenter(canvas, size);

    canvas.restore();
  }
}

/// A painter responsible for drawing Dial
class _DialPainter {
  /// A cached Picture of the dial to optimize performance.
  Picture? _dialPicture;

  /// A cached Picture of the pink center circle.
  /// We use another Picture to avoid redrawing the center circle.
  /// While we need draw arrows between dial and center circle.
  Picture? _centerPicture;

  void layout(Size size) {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder)..translate(size.width / 2, size.height / 2);

    final clockRadius = size.shortestSide / 2;
    final innerRadius = clockRadius * 0.835;

    final hourTickLength = clockRadius * .093;

    const pinkColor = Color(0xffff5876);
    const grayColor = Color(0xff405b6c);

    final tickPaint =
        Paint()
          ..color = grayColor
          ..strokeWidth = clockRadius * .062
          ..strokeCap = StrokeCap.round;

    final shadowPaint = Paint()..color = Colors.black12;

    void drawInnerShadow(Canvas canvas, double radius, double shadowSize) {
      /// If clock is small, do not draw shadow
      if (clockRadius < 128) return;

      /// Create two circles, one slightly smaller than the other
      final outer = Path()..addOval(Rect.fromCircle(center: Offset.zero, radius: radius));

      /// Translate the inner circle down to create a shadow effect
      final inner = Path()..addOval(Rect.fromCircle(center: Offset.zero, radius: radius).translate(0, -shadowSize));

      final path = Path.combine(PathOperation.difference, outer, inner);

      canvas.drawPath(path, shadowPaint);
    }

    /// Record the dial
    canvas
      ..drawCircle(Offset.zero, clockRadius, Paint()..color = pinkColor)
      ..drawCircle(Offset.zero, innerRadius, Paint()..color = const Color(0xffe4eef9));

    drawInnerShadow(canvas, clockRadius, clockRadius * 0.08);
    drawInnerShadow(canvas, innerRadius, innerRadius * 0.08);

    /// Record hours ticks
    {
      final tickRadius = clockRadius * .73;
      for (var h = 0; h < 12; h += 3) {
        final angle = -math.pi / 2 + h * math.pi / 6;

        final p1 = Offset(
          (tickRadius - hourTickLength) * math.cos(angle),
          (tickRadius - hourTickLength) * math.sin(angle),
        );

        final p2 = Offset(tickRadius * math.cos(angle), tickRadius * math.sin(angle));

        canvas.drawLine(p1, p2, tickPaint);
      }
    }
    _dialPicture = recorder.endRecording();

    // Record center circle
    {
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder)..translate(size.width / 2, size.height / 2);

      final centerRadius = clockRadius * 0.11;
      canvas.drawCircle(Offset.zero, centerRadius, Paint()..color = pinkColor);
      drawInnerShadow(canvas, centerRadius, centerRadius * 0.75);
      _centerPicture = recorder.endRecording();
    }
  }

  /// Paints the recorded picture onto the given [canvas].
  ///
  /// This method is called during the paint phase of the [RenderBox].
  void paintDial(Canvas canvas, Size size) {
    // Draw the pre-recorded picture
    if (_dialPicture case Picture picture) {
      canvas.drawPicture(picture);
    }
  }

  /// Paints the recorded picture onto the given [canvas].
  ///
  /// This method is called during the paint phase of the [RenderBox].
  void paintCenter(Canvas canvas, Size size) {
    // Draw the pre-recorded picture
    if (_centerPicture case Picture picture) {
      canvas.drawPicture(picture);
    }
  }
}

/// A painter responsible for drawing arrows
class _ArrowsPainter {
  _ArrowsPainter();

  late Paint _hourArrowPaint;
  late Paint _minuteArrowPaint;
  late Paint _secondArrowPaint;

  double _hourArrrowLenght = 0;
  double _minuteArrrowLenght = 0;
  double _secondArrrowLenght = 0;

  void layout(Size size) {
    final clockRadius = size.shortestSide / 2;

    _hourArrrowLenght = clockRadius * 0.36;
    _minuteArrrowLenght = clockRadius * 0.54;
    _secondArrrowLenght = clockRadius * 0.58;

    const grayColor = Color(0xff405b6c);
    const blueColor = Color(0xff86dcff);

    _hourArrowPaint =
        Paint()
          ..color = grayColor
          ..strokeWidth = clockRadius * .12
          ..strokeCap = StrokeCap.round;

    _minuteArrowPaint =
        Paint()
          ..color = const Color.fromARGB(255, 81, 115, 136)
          ..strokeWidth = clockRadius * .12
          ..strokeCap = StrokeCap.round;

    _secondArrowPaint =
        Paint()
          ..color = blueColor
          ..strokeWidth = clockRadius * .06
          ..strokeCap = StrokeCap.round;
  }

  void paint(Canvas canvas, Size size, DateTime date) {
    canvas
      ..save()
      ..translate(size.width / 2, size.height / 2);

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
        Offset(_hourArrrowLenght * math.cos(hourAngle), _hourArrrowLenght * math.sin(hourAngle)),
        _hourArrowPaint,
      )
      // minute arrow
      ..drawLine(
        Offset.zero,
        Offset(_minuteArrrowLenght * math.cos(minuteAngle), _minuteArrrowLenght * math.sin(minuteAngle)),
        _minuteArrowPaint,
      )
      // second arrow
      ..drawLine(
        Offset.zero,
        Offset(_secondArrrowLenght * math.cos(secondAngle), _secondArrrowLenght * math.sin(secondAngle)),
        _secondArrowPaint,
      )
      ..restore();
  }
}
