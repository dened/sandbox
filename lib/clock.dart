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
  // ignore: avoid_print
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

/// {@template clock_widget}
/// A widget that displays a custom-rendered analog clock.
///
/// This widget uses a [LeafRenderObjectWidget] to create a [ClockRenderBox]
/// for efficient custom painting and animation.
/// {@endtemplate}
@immutable
class ClockWidget extends LeafRenderObjectWidget {
  /// {@macro clock_widget}
  const ClockWidget({this.dimension = double.infinity, this.animationDuration = const Duration(seconds: 2), super.key});

  /// The desired size (width and height) of the clock.
  ///
  /// If set to [double.infinity], the clock will expand to fill the available space.
  final double dimension;

  /// Duration for the initial catching up animation.
  final Duration animationDuration;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      ClockRenderBox(dimension: dimension, animationDuration: animationDuration);

  @override
  void updateRenderObject(BuildContext context, covariant ClockRenderBox renderObject) {
    renderObject.dimension = dimension;
    renderObject._animator.animationDuration = animationDuration;
  }
}

/// A custom [RenderBox] that lays out and paints an analog clock.
///
/// This class manages the animation loop via a [Ticker] and delegates the
/// actual drawing to specialized painter classes for different parts of the clock
/// (dial, hands, and center). This separation of concerns and caching of static
/// parts (`Picture`) ensures high performance.
class ClockRenderBox extends RenderBox {
  /// Creates a [ClockRenderBox].
  ///
  /// Initializes the painters responsible for drawing different parts of the clock.
  ClockRenderBox({required double dimension, required Duration animationDuration, DateTime? initTime})
    : _dimension = dimension,
      _dialPainter = _DialPainter(),
      _arrowsPainter = _ArrowsPainter(),
      _centerPainter = _CenterPainter() {
    _animator = _ClockAnimator(
      onUpdate: markNeedsPaint,
      initTime: initTime ?? DateTime(2025, 1, 1, 12, 22, 35),
      animationDuration: animationDuration,
    );
  }

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

  /// The animator responsible for managing the clock's state and animation.
  late final _ClockAnimator _animator;

  @override
  Size computeDryLayout(covariant BoxConstraints constraints) {
    if (dimension.isFinite) {
      return constraints.constrain(Size.square(dimension));
    }
    return constraints.biggest;
  }

  @override
  void performLayout() {
    // Set the size of the render box to the biggest available space or the specified dimension.
    size = computeDryLayout(constraints);

    // Prepare painters with the new size. This pre-calculates layouts and caches static drawings.
    _dialPainter.prepare(size);
    _arrowsPainter.prepare(size);
    _centerPainter.prepare(size);
  }

  @override
  void detach() {
    super.detach();
    _animator.dispose();
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

    final angles = _animator.currentAngles;
    _arrowsPainter.paint(canvas, size, hourAngle: angles.hour, minuteAngle: angles.minute, secondAngle: angles.second);

    // Paint the center circle on top of the hands.
    _centerPainter.paint(canvas);

    canvas.restore();
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) => false;

  @override
  void handleEvent(PointerEvent event, covariant BoxHitTestEntry entry) {
    if (event is! PointerDownEvent) return;
    if (_animator.state != _ClockState.idle) {
      _animator.stop();
    } else {
      _animator.start();
    }
  }
}

/// A mixin that provides shared properties and methods for clock part painters.
///
/// This helps to centralize common drawing logic and constants, such as colors
/// and radius calculations.
mixin _ClockPartPainterMixin {
  /// Colors used in the clock.
  static const pinkColor = Color(0xffff5876);
  static const grayColor = Color(0xFF405B6C);
  static const blueColor = Color(0xff86dcff);
  static const lightGrayColor = Color(0xffe4eef9);

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

    final hourTickLength = clockRadius * 0.093;

    final tickPaint =
        Paint()
          ..color = _ClockPartPainterMixin.grayColor
          ..strokeWidth = clockRadius * 0.062
          ..strokeCap = StrokeCap.round;

    /// Records the main dial face (background circles and shadows).
    canvas
      ..drawCircle(Offset.zero, clockRadius, Paint()..color = _ClockPartPainterMixin.pinkColor)
      ..drawCircle(Offset.zero, innerRadius, Paint()..color = _ClockPartPainterMixin.lightGrayColor);

    drawInnerShadow(canvas, clockRadius, clockRadius * 0.08);
    drawInnerShadow(canvas, innerRadius, innerRadius * 0.08);

    /// Records the hour ticks.
    final tickRadius = clockRadius * 0.73;
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
    canvas.drawCircle(Offset.zero, centerRadius, Paint()..color = _ClockPartPainterMixin.pinkColor);
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
          ..color = _ClockPartPainterMixin.grayColor
          ..strokeWidth = clockRadius * 0.12
          ..strokeCap = StrokeCap.round;

    _minuteArrowPaint =
        Paint()
          ..color = _ClockPartPainterMixin.grayColor
          ..strokeWidth = clockRadius * 0.12
          ..strokeCap = StrokeCap.round;

    _secondArrowPaint =
        Paint()
          ..color = _ClockPartPainterMixin.blueColor
          ..strokeWidth = clockRadius * 0.06
          ..strokeCap = StrokeCap.round;
  }

  /// Paints the clock hands on the canvas for a given date.
  void paint(
    Canvas canvas,
    Size size, {
    required double hourAngle,
    required double minuteAngle,
    required double secondAngle,
  }) {
    canvas
      ..save()
      ..translate(size.width / 2, size.height / 2)
      // Draw the hour hand.
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

/// The animation state of the clock.
enum _ClockState {
  /// The clock is stopped and showing the initial time.
  idle,

  /// The clock is animating to catch up to the current time.
  catchingUp,

  /// The clock is running and synchronized with the current time.
  running,
}

/// A helper class to manage the animation state and logic for the clock.
///
/// This class encapsulates the ticker, animation states (idle, catching up, running),
/// and the calculation of hand angles, separating the animation logic from the
/// rendering logic in [ClockRenderBox].
class _ClockAnimator {
  _ClockAnimator({required this.onUpdate, required DateTime initTime, required this.animationDuration})
    : _initTime = initTime,
      _clockTime = initTime;

  /// A callback to be invoked when the animator's state changes and a repaint is needed.
  final VoidCallback onUpdate;

  /// The initial time for the clock, used for resetting.
  final DateTime _initTime;

  /// The current time displayed by the clock.
  late DateTime _clockTime;

  /// The ticker that drives the animation.
  Ticker? _ticker;

  /// The current state of the clock's animation.
  _ClockState _state = _ClockState.idle;
  _ClockState get state => _state;

  // Animation state for the initial "catching up" animation.
  DateTime _animationStartTime = DateTime.now();

  /// Duration for the initial catching up animation.
  Duration animationDuration;

  double _progress = 0;

  // Start, target, and current angles for the hands animation.
  Animatable<double>? _hourTween, _minuteTween, _secondTween;

  /// Returns the current angles of the clock hands.
  ({double hour, double minute, double second}) get currentAngles => switch (_state) {
    _ClockState.running => _getAnglesFromTime(_clockTime),
    _ClockState.catchingUp => (
      hour: _hourTween!.transform(_progress),
      minute: _minuteTween!.transform(_progress),
      second: _secondTween!.transform(_progress),
    ),
    _ClockState.idle => _getAnglesFromTime(_initTime),
  };

  /// Calculates the angles for each hand based on a given [DateTime].
  ({double hour, double minute, double second}) _getAnglesFromTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute;
    final second = time.second + time.millisecond / 1000.0;

    // Calculate the angle for each hand.
    // The starting point is -pi/2 radians (12 o'clock).
    final hourAngle = -math.pi / 2 + (hour % 12 + minute / 60 + second / 3600) * math.pi / 6;
    // A minute/second step is pi/30 radians (6 degrees).
    final minuteAngle = -math.pi / 2 + (minute + second / 60) * math.pi / 30;
    final secondAngle = -math.pi / 2 + second * math.pi / 30;

    return (hour: hourAngle, minute: minuteAngle, second: secondAngle);
  }

  Animatable<double> _createAngleTween(double begin, double end) {
    var targetAngle = end;
    // Ensure the animation always moves clockwise by adding a full circle (2 * pi)
    // if the target angle is smaller than the beginning angle.
    if (targetAngle < begin) {
      targetAngle += 2 * math.pi;
    }
    return Tween<double>(begin: begin, end: targetAngle).chain(CurveTween(curve: Curves.easeInOut));
  }

  /// Starts the clock animation.
  ///
  /// Transitions the clock from the `idle` state to `catchingUp`, initiating
  /// a [animationDuration] animation to synchronize with the current time.
  void start() {
    if (_state != _ClockState.idle) return;
    _animationStartTime = DateTime.now();
    final targetTime = _animationStartTime.add(animationDuration);

    final startAngles = _getAnglesFromTime(_clockTime);
    final targetAngles = _getAnglesFromTime(targetTime);

    _hourTween = _createAngleTween(startAngles.hour, targetAngles.hour);
    _minuteTween = _createAngleTween(startAngles.minute, targetAngles.minute);
    _secondTween = _createAngleTween(startAngles.second, targetAngles.second);

    _state = _ClockState.catchingUp;
    _ticker ??= Ticker(_onTick);
    _ticker?.start();
  }

  /// Stops the clock animation and resets it to the initial time.
  ///
  /// Transitions the clock to the `idle` state.
  void stop() {
    if (_state == _ClockState.idle) return;
    _state = _ClockState.idle;
    _ticker?.stop();
    _clockTime = _initTime;
    _progress = 0.0;
    onUpdate();
  }

  /// Called by the ticker on each frame to update the animation state.
  void _onTick(Duration elapsed) {
    final now = DateTime.now();
    switch (_state) {
      case _ClockState.idle:
        break;
      case _ClockState.catchingUp:
        final animationElapsed = now.difference(_animationStartTime);
        if (animationElapsed >= animationDuration) {
          _state = _ClockState.running;
          _clockTime = now;
          _progress = 1;
          onUpdate();
        } else {
          _progress = animationElapsed.inMicroseconds / animationDuration.inMicroseconds;
          onUpdate();
        }
        break;
      case _ClockState.running:
        _clockTime = now;
        onUpdate();
        break;
    }
  }

  /// Releases the resources used by this animator.
  void dispose() {
    _ticker?.dispose();
  }
}
