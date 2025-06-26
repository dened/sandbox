// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

/// Represents information about a dot or a point to be drawn.
typedef DotInfo = ({Offset offset, Size size});

/// Represents the data for a single step in the stepper.
typedef StepData = ({String title, String subtitle});

/// Sample data for the stepper.
final data = <StepData>[
  (title: 'Nevsky', subtitle: '10:50'), // Kirovskii zavod - 12:20
  (title: 'Gostiniy Dvor', subtitle: '11:00'),
  (title: 'Moskovskaya', subtitle: '11:10'),
  (title: 'Leningradskaya', subtitle: '11:20'),
  (title: 'Kirovskaya', subtitle: '11:30'),
  (title: 'Pushkinskaya', subtitle: '11:40'),
  (title: 'Baltiyskaya', subtitle: '11:50'),
  (title: 'Narva', subtitle: '12:00'),
  (title: 'Sadovaya', subtitle: '12:10'),
  (title: 'Kirovskii zavod', subtitle: '12:20'),
];

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
      
      body: SafeArea(
        child: Align(
          alignment: Alignment.topLeft,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(children: [Stepper(steps: data)]),
          ),
        ),
      ),
    ),
  );
}

/// {@template stepper_widget}
/// A custom stepper widget that displays a list of steps with titles and subtitles.
/// It uses a [LeafRenderObjectWidget] for custom painting.
/// {@endtemplate}
class Stepper extends LeafRenderObjectWidget {
  /// {@macro stepper_widget}
  const Stepper({required this.steps, super.key});

  /// The list of steps to display in the stepper.
  final List<StepData> steps;

  @override
  RenderObject createRenderObject(BuildContext context) => StepperRenderObject(
    painter: StepPainter(
      steps: steps,
      theme: Theme.of(context),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
    ),
  );

  @override
  void updateRenderObject(BuildContext context, covariant StepperRenderObject renderObject) {
    renderObject.painter
      ..steps = steps
      ..theme = Theme.of(context)
      ..textDirection = Directionality.of(context)
      ..textScaler = MediaQuery.textScalerOf(context);
  }
}

/// The [RenderBox] for the [Stepper] widget.
///
/// Manages the custom painting, animation, and hit testing for the stepper.
class StepperRenderObject extends RenderBox with WidgetsBindingObserver {
  /// Creates a [StepperRenderObject] with the given [painter].
  StepperRenderObject({required this.painter});

  /// The painter responsible for drawing the stepper content.
  final StepPainter painter;

  Ticker? _animationTicker;

  @override
  bool get isRepaintBoundary => false;

  @override
  bool get alwaysNeedsCompositing => false;

  @override
  bool get sizedByParent => false;

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    WidgetsBinding.instance.addObserver(this); // Observe lifecycle events for ticker management.
    // Initialize and start the ticker to drive continuous updates for animations.
    _animationTicker ??= Ticker(_onTick)..start();
  }

  /// Callback for each tick of the animation ticker.
  ///
  /// If the painter indicates that it's dirty (i.e., there are active animations),
  /// it marks the render object for repaint and relayout.
  /// The `_isDirty` flag in the painter is managed to ensure continuous updates
  /// only when necessary.
  void _onTick(Duration elapsed) {
    if (painter._isDirty) {
      // If there are active animations, request repaint and relayout.
      markNeedsPaint(); // Request a repaint.
      markNeedsLayout(); // Request a relayout, as text size can change due to animation.
    }
  }

  @override
  void detach() {
    super.detach();
    _animationTicker?.dispose();
    _animationTicker = null;
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) => false;

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    var hitTarget = false;
    if (size.contains(position)) {
      hitTarget = hitTestSelf(position); // Check if the render object itself was hit.
      result.add(BoxHitTestEntry(this, position));
    }
    return hitTarget || hitTestChildren(result, position: position);
  }

  @override
  /// Handles pointer events, specifically tap gestures.
  void handleEvent(PointerEvent event, covariant BoxHitTestEntry entry) {
    if (event is! PointerDownEvent) return;
    painter.handleTap(event);
  }

  @override
  /// Computes the intrinsic size of the render object.
  ///
  /// Delegates the layout calculation to the [painter].
  Size computeDryLayout(covariant BoxConstraints constraints) =>
      constraints.constrain(painter.layout(maxWidth: constraints.maxWidth));

  @override
  void performLayout() {
    // Implement layout logic here
    size = constraints.constrain(painter.layout(maxWidth: constraints.maxWidth)); // Example size, adjust as needed
  }

  @override
  /// Performs the actual layout of the render object.
  void performResize() {
    size = computeDryLayout(constraints);
  }

  @override
  /// Paints the content of the stepper onto the canvas.
  ///
  /// Translates the canvas to the correct offset and clips it, then delegates
  /// the actual drawing to the [painter].
  void paint(PaintingContext context, Offset offset) {
    final canvas =
        context.canvas
          ..save()
          ..translate(offset.dx, offset.dy)
          ..clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    painter.paint(canvas, size);

    canvas.restore();
  }
}

/// Duration for the "enter" phase of the animation (scaling up).
const animationEnterDuration = Duration(milliseconds: 300);

/// Duration for the "exit" phase of the animation (scaling down).
const animationExitDuration = Duration(milliseconds: 150);

/// Total duration of the animation (enter + exit).
final animationDuration = animationEnterDuration + animationExitDuration;

/// {@template step_painter}
/// A [CustomPainter] responsible for drawing the stepper's visual elements.
///
/// It calculates the layout, draws the step indicators, titles, subtitles,
/// and handles tap animations.
/// {@endtemplate}
class StepPainter {
  /// {@macro step_painter}
  StepPainter({required this.steps, required this.theme, required this.textDirection, required this.textScaler})
    : _size = Size.zero;

  /// The current theme data for styling.
  ThemeData theme;

  /// The text direction for text layout.
  TextDirection textDirection;

  /// The text scaler for text sizing.
  TextScaler textScaler;

  /// The list of steps to be painted.
  List<StepData> steps;

  /// A cached [Picture] of the static parts of the stepper to optimize painting.
  Picture? _picture;

  /// A list of hit test targets for each step, including their boundary and tap callback.
  final _gestureTargets = <({Rect boundary, VoidCallback onTap})>[];

  /// The computed size of the stepper.
  Size _size;

  /// Getter for the computed size.
  Size get size => _size;

  /// Setter for the computed size.
  set size(Size value) {
    if (_size != value) {
      _size = value;
    }
  }

  /// Flag indicating if there are active animations that require repainting.
  bool _isDirty = false;

  /// A map storing the start time of the tap animation for each step index.
  final Map<int, DateTime> _tappedIndexMap = {};

  // Constants for drawing dimensions.
  static const double _iconDiameter = 32; // Diameter for the first/last step icon (circle)
  static const double _middleDotDiameter = 16; // Diameter for the middle step dots
  static const double _verticalPadding = 16; // Padding between steps and around text

  /// Calculates the layout of the stepper and records the drawing commands.
  ///
  /// This method is called during the layout phase of the [RenderBox].
  /// It determines the size of each step, positions them, and pre-records
  /// the static drawing operations into a [Picture] for efficiency.
  /// It also updates the hit test boundaries for tap detection.
  Size layout({required double maxWidth}) {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);

    final textPainter = TextPainter(
      textDirection: textDirection, // Use provided textDirection
      textAlign: TextAlign.left,
      ellipsis: '...',
      maxLines: 2,
      textScaler: textScaler, // Use provided textScaler
    );

    final pointsF32 = Float32List(math.max(steps.length - 2, 0) * 2);
    final linesF32 = Float32List(math.max(steps.length - 1, 0) * 4);

    var currentHeight = _verticalPadding; // Start with initial padding
    final pointsInfoList = <DotInfo>[];

    /// Calculates the scaling factor for a step based on its animation state.
    ///
    /// Returns 1.0 if no animation is active or completed.
    /// Returns a value between 1.0 and 1.5 during the "enter" phase.
    /// Returns a value between 1.5 and 1.0 during the "exit" phase.
    double getScaleByIndex(int i) {
      final tapTime = _tappedIndexMap[i];
      if (tapTime == null) {
        return 1; // No animation for this index
      }

      final elapsed = DateTime.now().difference(tapTime);

      if (elapsed < animationEnterDuration) {
        final progress = (elapsed.inMilliseconds / animationEnterDuration.inMilliseconds).clamp(0.0, 1.0);
        _isDirty = true; // Keep dirty for animation
        return 1.0 + (0.5 * progress); // Scale from 1.0 to 1.5
      } else if (elapsed < animationDuration) {
        // Check against total duration
        final progress = ((elapsed.inMilliseconds - animationEnterDuration.inMilliseconds) /
                animationExitDuration.inMilliseconds)
            .clamp(0.0, 1.0);
        _isDirty = true; // Keep dirty for animation
        return 1.5 - (0.5 * progress); // Scale from 1.5 to 1.0
      }
      // Animation completed, remove from map and reset dirty flag if no other animations are active
      _tappedIndexMap.remove(i);
      if (_tappedIndexMap.isEmpty) {
        _isDirty = false;
      }
      return 1;
    }

    /// Checks if a given scale indicates an active scaling animation.
    bool isScaled(double scale) => scale > 1.01;

    /// Returns a [TextStyle] scaled by the given factor, if scaling is active.
    TextStyle? getScaledTextStyle(TextStyle? baseStyle, double scale) {
      if (!isScaled(scale)) return baseStyle;
      if (baseStyle == null) return null;
      final baseFontSize = baseStyle.fontSize;
      if (baseFontSize == null) return baseStyle;
      return baseStyle.copyWith(fontSize: baseFontSize * scale);
    }

    _gestureTargets.clear();
    for (var i = 0; i < steps.length; i++) {
      final step = steps[i];
      final isLast = i == steps.length - 1;
      final isFirst = i == 0;

      // Add vertical padding between steps
      if (i > 0) {
        currentHeight += _verticalPadding;
      }

      final currentScale = getScaleByIndex(i);

      final stepTopY = currentHeight; // Y-coordinate for the top of the current step's content

      // Draw the step icon/dot
      final Offset iconCenter;
      final double iconRadius;
      final iconPaint = Paint();

      if (isFirst) {
        iconRadius = _iconDiameter / 2;
        iconCenter = Offset(iconRadius, currentHeight + iconRadius);
        iconPaint.color = Colors.blue;
        canvas.drawCircle(iconCenter, iconRadius, iconPaint);
        pointsInfoList.add((offset: iconCenter, size: const Size(_iconDiameter, _iconDiameter)));
      } else if (isLast) {
        iconRadius = _iconDiameter / 2;
        iconCenter = Offset(iconRadius, currentHeight + iconRadius);
        iconPaint.color = Colors.grey;
        canvas.drawCircle(iconCenter, iconRadius, iconPaint);
        pointsInfoList.add((offset: iconCenter, size: const Size(_iconDiameter, _iconDiameter)));
      } else {
        iconRadius = _middleDotDiameter / 2; // For consistency, though not directly used for drawing here
        iconCenter = Offset(
          _iconDiameter / 2,
          currentHeight + _iconDiameter / 2,
        ); // Position middle dots aligned with large icons
        pointsF32[(i - 1) * 2] = iconCenter.dx;
        pointsF32[(i - 1) * 2 + 1] = iconCenter.dy;
        pointsInfoList.add((offset: iconCenter, size: const Size(_middleDotDiameter, _middleDotDiameter)));
      }

      // Calculate text layout and draw
      const textStartX = _iconDiameter + _verticalPadding;
      var textCurrentY = currentHeight;

      // Draw the stepper title
      final titleTextStyle = getScaledTextStyle(theme.textTheme.titleLarge, currentScale);
      textPainter
        ..text = TextSpan(text: step.title, style: titleTextStyle)
        ..layout(maxWidth: maxWidth - textStartX)
        ..paint(canvas, Offset(textStartX, textCurrentY));
      textCurrentY += textPainter.height;

      // Draw the stepper subtitle
      final subtitleStyle = getScaledTextStyle(theme.textTheme.bodyMedium, currentScale);
      textPainter
        ..text = TextSpan(text: step.subtitle, style: subtitleStyle)
        ..layout(maxWidth: maxWidth - textStartX)
        ..paint(canvas, Offset(textStartX, textCurrentY));
      textCurrentY += textPainter.height;

      // Update currentHeight for the next step
      currentHeight = textCurrentY;

      // Define the hit test boundary for the current step
      _gestureTargets.add((
        boundary: Rect.fromLTWH(0, stepTopY, maxWidth, currentHeight - stepTopY + _verticalPadding),
        onTap: () {
          // This onTap is for debugging, the actual tap handling is in handleTap
          print('Tapped step: ${step.title}');
        },
      ));
    }
    currentHeight += _verticalPadding; // Add padding after the last step

    // Populate lines data for connecting dots
    for (var i = 0; i < pointsInfoList.length - 1; i++) {
      final start = pointsInfoList[i].offset;
      final end = pointsInfoList[i + 1].offset;
      final startSize = pointsInfoList[i].size;
      final endSize = pointsInfoList[i + 1].size;

      linesF32[i * 4] = start.dx; // Start X
      linesF32[i * 4 + 1] = start.dy + startSize.height / 2 + _verticalPadding / 4; // Start Y (adjusted)
      linesF32[i * 4 + 2] = end.dx; // End X
      linesF32[i * 4 + 3] = end.dy - endSize.height / 2 - _verticalPadding / 4; // End Y (adjusted)
    }

    // Draw middle dots (if any)
    if (pointsF32.isNotEmpty) {
      canvas.drawRawPoints(
        PointMode.points,
        pointsF32,
        Paint()
          ..color = Colors.green
          ..strokeCap = StrokeCap.round
          ..style =
              PaintingStyle
                  .fill // Use fill for solid dots
          ..strokeWidth = _middleDotDiameter, // Use diameter as strokeWidth for points
      );
    }

    if (linesF32.isNotEmpty) {
      canvas.drawRawPoints(
        PointMode.lines,
        linesF32,
        Paint()
          ..color = Colors.red
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4.0,
      );
    }
    _picture = recorder.endRecording();
    // Set the computed size of the stepper.
    return _size = Size(maxWidth, currentHeight);
  }

  /// Paints the recorded picture onto the given [canvas].
  ///
  /// This method is called during the paint phase of the [RenderBox].
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..isAntiAlias = true
        ..blendMode = BlendMode.src
        ..color = Colors.grey.shade200
        ..style = PaintingStyle.fill,
    );

    // Draw the pre-recorded picture
    if (_picture case Picture picture) {
      canvas.drawPicture(picture);
    }
  }

  /// Handles tap events on the stepper.
  ///
  /// Determines which step was tapped based on the local position
  /// and triggers the animation for that step.
  void handleTap(PointerDownEvent event) {
    if ((event.buttons & kPrimaryButton) == 0) return;

    final localPosition = event.localPosition;

    for (final target in _gestureTargets) {
      if (target.boundary.contains(localPosition)) {
        target.onTap(); // Debugging print
        final tappedIndex = _gestureTargets.indexOf(target);

        if (!_tappedIndexMap.containsKey(tappedIndex)) {
          // Start animation if not already active for this index
          _tappedIndexMap[tappedIndex] = DateTime.now(); // Record start time of animation
          _isDirty = true; // Mark for continuous repainting
        }
        return;
      }
    }
  }
}
