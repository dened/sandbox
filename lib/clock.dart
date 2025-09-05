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
class App extends StatelessWidget {
  /// {@macro app}
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Material App',
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      appBar: AppBar(title: const Text('Material App Bar')),

      body: const SafeArea(
        // Example of a clock with a fixed size.
        child: Center(child: ClockWidget()),
      ),
    ),
  );
}

class ClockWidget extends LeafRenderObjectWidget {
  const ClockWidget({this.dimension = double.infinity, super.key});

  /// The desired size (width and height) of the clock.
  ///
  /// If set to [double.infinity], the clock will expand to fill the available space.
  final double dimension;

  @override
  RenderObject createRenderObject(BuildContext context) => ClockRenderBox(dimension: dimension);

  @override
  void updateRenderObject(BuildContext context, covariant ClockRenderBox renderObject) {
    renderObject.dimension = dimension;
  }
}

/// A custom [RenderBox] that lays out and paints an analog clock.
///
/// This class manages the animation loop via a [Ticker] and delegates the
/// actual drawing to specialized painter classes for different parts of the clock
/// (dial, hands, and center). This separation of concerns and caching of static
/// parts (`Picture`) ensures high performance.
class ClockRenderBox extends RenderBox with WidgetsBindingObserver {
  /// Creates a [ClockRenderBox].
  ///
  /// Initializes the painters responsible for drawing different parts of the clock.
  ClockRenderBox({required double dimension})
    : _dimension = dimension,
      _dialPainter = _DialPainter(),
      _arrowsPainter = _ArrowsPainter(),
      _centerPainter = _CenterPainter();

  double _dimension;
  double get dimension => _dimension;
  set dimension(double value) {
    if (_dimension == value) {
      return;
    }
    _dimension = value;
    markNeedsLayout();
  }

  /// Painter for the static clock face (dial and ticks).
  final _DialPainter _dialPainter;

  /// Painter for the dynamic clock hands.
  final _ArrowsPainter _arrowsPainter;

  /// Painter for the central circle, drawn on top of the hands.
  final _CenterPainter _centerPainter;

  /// A [Ticker] that drives the clock's animation, firing on every frame.
  Ticker? _ticker;

  /// The current time, updated once per second to trigger repaints.
  DateTime _currentTime = DateTime.now();

  /// Called by the ticker on each frame.
  ///
  /// It checks if the current second has changed. If so, it updates [_currentTime]
  /// and marks the render box as needing to be repainted. This is an optimization
  /// to avoid repainting on every single frame, only when the second hand needs to move.
  void _onTick(Duration elapsed) {
    final now = DateTime.now();
    if (now.second != _currentTime.second) {
      _currentTime = now;
      markNeedsPaint(); // Request a repaint.
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    WidgetsBinding.instance.addObserver(this);
    // Create and start the ticker when the render box is attached to the tree.
    _ticker ??= Ticker(_onTick, debugLabel: 'ClockRenderBox')..start();
  }

  @override
  Size computeDryLayout(covariant BoxConstraints constraints) {
    if (dimension.isFinite) {
      return constraints.constrain(Size.square(dimension));
    }
    return constraints.biggest;
  }

  // Prepare painters with the new size. This pre-calculates layouts and caches static drawings.
  void _preparePainters(Size size) {
    _dialPainter.prepare(size);
    _arrowsPainter.prepare(size);
    _centerPainter.prepare(size);
  }

  @override
  void performLayout() {
    // Set the size of the render box to the biggest available space or the specified dimension.
    size = computeDryLayout(constraints);
    // Prepare the painters with the final size.
    _preparePainters(size);
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

    // Paint the clock parts in the correct order (layers).
    _dialPainter.paint(canvas);
    _arrowsPainter.paint(canvas, size, _currentTime);
    _centerPainter.paint(canvas);

    canvas.restore();
  }
}

/// A mixin that provides shared properties and methods for clock part painters.
mixin _ClockPartPainterMixin {
  /// Colors used in the clock.
  final pinkColor = const Color(0xffff5876);
  final grayColor = const Color(0xff405b6c);
  final blueColor = const Color(0xff86dcff);

  double _clockRadius = 0;

  /// Radius of the clock, used for size-dependent calculations.
  double get clockRadius => _clockRadius;

  /// Pre-calculates size-dependent properties.
  /// This is called whenever the clock's size changes.
  @mustCallSuper
  void prepare(Size size) {
    _clockRadius = size.shortestSide / 2;
  }

  /// Draws an inner shadow for a circular shape on the canvas.
  @protected
  void drawInnerShadow(Canvas canvas, double radius, double shadowSize) {
    // Don't draw the shadow if the clock is too small for performance and visual clarity.
    if (clockRadius < 128) return;

    final shadowPaint = Paint()..color = Colors.black12;

    // Create a shadow effect by subtracting a slightly translated circle from the main one.
    final outer = Path()..addOval(Rect.fromCircle(center: Offset.zero, radius: radius));

    // The inner circle is translated upwards to create a "cutout", resulting in a shadow at the top edge.
    final inner = Path()..addOval(Rect.fromCircle(center: Offset.zero, radius: radius).translate(0, -shadowSize));

    // The difference between the two paths creates the shadow shape.
    canvas.drawPath(Path.combine(PathOperation.difference, outer, inner), shadowPaint);
  }
}

/// A painter responsible for drawing the clock's dial.
/// The dial is static and only changes when the size changes, so we cache it as a [Picture] for performance.
class _DialPainter with _ClockPartPainterMixin {
  /// A cached Picture of the dial to optimize performance.
  Picture? _dialPicture;

  @override
  void prepare(Size size) {
    super.prepare(size);

    final recorder = PictureRecorder();
    final canvas = Canvas(recorder)..translate(size.width / 2, size.height / 2);

    final innerRadius = clockRadius * 0.835;

    final hourTickLength = clockRadius * .093;

    final tickPaint =
        Paint()
          ..color = grayColor
          ..strokeWidth = clockRadius * .062
          ..strokeCap = StrokeCap.round;

    /// Records the main dial face (background circles and shadows).
    canvas
      ..drawCircle(Offset.zero, clockRadius, Paint()..color = pinkColor)
      ..drawCircle(Offset.zero, innerRadius, Paint()..color = const Color(0xffe4eef9));

    drawInnerShadow(canvas, clockRadius, clockRadius * 0.08);
    drawInnerShadow(canvas, innerRadius, innerRadius * 0.08);

    /// Records the hour ticks.
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
    _dialPicture = recorder.endRecording();
  }

  /// Paints the cached dial picture onto the canvas.
  void paint(Canvas canvas) {
    if (_dialPicture case Picture picture) {
      canvas.drawPicture(picture);
    }
  }
}

/// A painter for the central circle, drawn on top of the hands.
class _CenterPainter with _ClockPartPainterMixin {
  Picture? _centerPicture;

  @override
  void prepare(Size size) {
    super.prepare(size);

    final recorder = PictureRecorder();
    final canvas = Canvas(recorder)..translate(size.width / 2, size.height / 2);

    final centerRadius = clockRadius * 0.11;
    canvas.drawCircle(Offset.zero, centerRadius, Paint()..color = pinkColor);
    drawInnerShadow(canvas, centerRadius, centerRadius * 0.75);
    _centerPicture = recorder.endRecording();
  }

  /// Paints the cached center circle picture onto the canvas.
  void paint(Canvas canvas) {
    if (_centerPicture case Picture picture) {
      canvas.drawPicture(picture);
    }
  }
}

/// A painter responsible for drawing the clock's hands (hour, minute, and second).
///
/// This painter handles the dynamic elements of the clock that change over time.
/// It pre-calculates size-dependent properties in `prepare` to optimize the `paint` method.
class _ArrowsPainter with _ClockPartPainterMixin {
  _ArrowsPainter();
  late Paint _hourArrowPaint;

  /// Paint for the minute hand.
  late Paint _minuteArrowPaint;

  /// Paint for the second hand.
  late Paint _secondArrowPaint;

  /// Length of the hour hand.
  double _hourArrowLength = 0;

  /// Length of the minute hand.
  double _minuteArrowLength = 0;

  /// Length of the second hand.
  double _secondArrowLength = 0;

  /// Pre-calculates size-dependent properties like hand lengths and paint styles.
  /// This is called whenever the clock's size changes to avoid expensive calculations
  /// during the frequent paint calls.
  @override
  void prepare(Size size) {
    super.prepare(size);

    _hourArrowLength = clockRadius * 0.36;
    _minuteArrowLength = clockRadius * 0.54;
    _secondArrowLength = clockRadius * 0.58;

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

  /// Paints the clock hands on the canvas for a given date.
  void paint(Canvas canvas, Size size, DateTime time) {
    canvas
      ..save()
      ..translate(size.width / 2, size.height / 2);

    final date = time;

    final hour = date.hour;
    final minute = date.minute;
    final second = date.second;

    // Calculate the angle for each hand.
    // The starting point is -pi/2 radians (12 o'clock).
    // An hour step is pi/6 radians (30 degrees).
    final hourAngle = -math.pi / 2 + (hour % 12 + minute / 60) * math.pi / 6;
    // A minute/second step is pi/30 radians (6 degrees).
    final minuteAngle = -math.pi / 2 + (minute + second / 60) * math.pi / 30;
    final secondAngle = -math.pi / 2 + second * math.pi / 30;

    // Draw the hour hand.
    canvas
      ..drawLine(
        Offset.zero,
        Offset(_hourArrowLength * math.cos(hourAngle), _hourArrowLength * math.sin(hourAngle)),
        _hourArrowPaint,
      )
      // Draw the minute hand.
      ..drawLine(
        Offset.zero,
        Offset(_minuteArrowLength * math.cos(minuteAngle), _minuteArrowLength * math.sin(minuteAngle)),
        _minuteArrowPaint,
      )
      // Draw the second hand.
      ..drawLine(
        Offset.zero,
        Offset(_secondArrowLength * math.cos(secondAngle), _secondArrowLength * math.sin(secondAngle)),
        _secondArrowPaint,
      )
      ..restore();
  }
}
