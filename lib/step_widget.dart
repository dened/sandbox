// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

typedef DotInfo = ({Offset offset, Size size});
typedef StepData = ({String title, String subtitle});
final data = <StepData>[
  (title: 'Nevsky', subtitle: '10:50'),
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
// Kirovskii zavod - 12:20

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

class Stepper extends LeafRenderObjectWidget {
  /// {@macro step_widget}
  const Stepper({required this.steps, super.key});

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

class StepperRenderObject extends RenderBox with WidgetsBindingObserver {
  StepperRenderObject({required this.painter});

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
    WidgetsBinding.instance.addObserver(this);
    _animationTicker ??= Ticker(_onTick)..start();
  }

  void _onTick(Duration elapsed) {
    if (painter._isDirty) {
      markNeedsPaint();
      markNeedsLayout();
      if (painter._tappedIndexMap.isEmpty) {
        painter._isDirty = false; // Reset dirty flag if no points left
      }
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
      hitTarget = hitTestSelf(position);
      result.add(BoxHitTestEntry(this, position));
    }
    return hitTarget || hitTestChildren(result, position: position);
  }

  @override
  void handleEvent(PointerEvent event, covariant BoxHitTestEntry entry) {
    if (event is! PointerDownEvent) return;
    painter.handleTap(event);
  }

  @override
  Size computeDryLayout(covariant BoxConstraints constraints) =>
      constraints.constrain(painter.layout(maxWidth: constraints.maxWidth));

  @override
  void performLayout() {
    // Implement layout logic here
    size = constraints.constrain(painter.layout(maxWidth: constraints.maxWidth)); // Example size, adjust as needed
  }

  @override
  void performResize() {
    size = computeDryLayout(constraints);
  }

  @override
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

const animationEnterDuration = Duration(milliseconds: 300);
const animationExitDuration = Duration(milliseconds: 150);
final animationDuration = animationEnterDuration + animationExitDuration;

class StepPainter {
  StepPainter({required this.steps, required this.theme, required this.textDirection, required this.textScaler})
    : _size = Size.zero;

  ThemeData theme;
  TextDirection textDirection;
  TextScaler textScaler;

  List<StepData> steps;

  Picture? _picture;

  final _gestureTargets = <({Rect boundary, VoidCallback onTap})>[];

  Size _size;

  Size get size => _size;
  set size(Size value) {
    if (_size != value) {
      _size = value;
    }
  }

  bool _isDirty = false;

  final Map<int, DateTime> _tappedIndexMap = {};

  Size layout({required double maxWidth}) {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
      ellipsis: '...',
      maxLines: 2,
    );

    const iconSize = 32.0; // Width for the stepper icon
    const middleIconSize = 16.0; // Width for the middle icon
    const padding = 16.0; // Padding between steps

    final pointsF32 = Float32List(math.max(steps.length - 2, 0) * 2);
    final linesF32 = Float32List(math.max(steps.length - 1, 0) * 4);

    var height = padding;
    final pointsInfoList = <DotInfo>[];

    double getScaleByIndex(int i) {
      DateTime? animationStartTime;

      if (!_tappedIndexMap.containsKey(i)) return 1;

      final tapTime = _tappedIndexMap[i];
      if (tapTime?.isAfter(DateTime.now().subtract(animationDuration)) ?? false) {
        animationStartTime = tapTime;
      } else {
        _tappedIndexMap.remove(i);
        return 1;
      }

      final elapsed = DateTime.now().difference(animationStartTime!);

      if (elapsed < animationEnterDuration) {
        final progress = (elapsed.inMilliseconds / animationEnterDuration.inMilliseconds).clamp(0.0, 1.0);
        return 1.0 + (0.5 * progress);
      } else if (elapsed < animationExitDuration + animationEnterDuration) {
        final progress = ((elapsed.inMilliseconds - animationEnterDuration.inMilliseconds) /
                animationExitDuration.inMilliseconds)
            .clamp(0.0, 1.0);
        return 1.5 - (0.5 * progress);
      }

      return 1;
    }

    bool isScaled(double scale) => scale > 1.01;

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

      if (i > 0) {
        height += padding;
      }

      var currentScale = getScaleByIndex(i);

      var heightStart = height;
      if (isFirst) {
        final offset = Offset(iconSize / 2, height + iconSize / 2);
        canvas.drawCircle(offset, iconSize / 2, Paint()..color = Colors.blue);
        pointsInfoList.add((offset: offset, size: const Size(iconSize, iconSize)));
      } else if (isLast) {
        final offset = Offset(iconSize / 2, height + iconSize / 2);
        canvas.drawCircle(offset, iconSize / 2, Paint()..color = Colors.grey);
        pointsInfoList.add((offset: offset, size: const Size(iconSize, iconSize)));
        //
      } else {
        final offset = Offset(iconSize / 2, height + iconSize / 2);
        pointsF32[(i - 1) * 2] = offset.dx;
        pointsF32[(i - 1) * 2 + 1] = offset.dy;

        pointsInfoList.add((offset: offset, size: const Size(middleIconSize, middleIconSize)));
      }

      // draw the stepper title
      final titleTextStyle = getScaledTextStyle(theme.textTheme.titleLarge, currentScale);
      textPainter
        ..text = TextSpan(text: step.title, style: titleTextStyle)
        ..layout(maxWidth: maxWidth - iconSize - padding)
        ..paint(canvas, Offset(iconSize + padding, height));
      height += textPainter.height;

      // draw the stepper subtitle
      final subtitleStyle = getScaledTextStyle(theme.textTheme.bodyMedium, currentScale);

      textPainter
        ..text = TextSpan(text: step.subtitle, style: subtitleStyle)
        ..layout(maxWidth: maxWidth - iconSize - padding)
        ..paint(canvas, Offset(iconSize + padding, height));
      height += textPainter.height;

      _gestureTargets.add((
        boundary: Rect.fromLTWH(0, heightStart, maxWidth, textPainter.height + padding * 2),
        onTap: () {
          // This onTap is for debugging, the actual tap handling is in handleTap
          print('Tapped step: ${step.title}');
        },
      ));
    }
    height += padding; // Add padding after the last step

    for (var i = 0; i < pointsInfoList.length - 1; i++) {
      final start = pointsInfoList[i].offset;
      final end = pointsInfoList[i + 1].offset;
      final startSize = pointsInfoList[i].size;
      final endSize = pointsInfoList[i + 1].size;

      linesF32[i * 4] = start.dx;
      linesF32[i * 4 + 1] = start.dy + startSize.height / 2 + padding / 4;
      linesF32[i * 4 + 2] = end.dx;
      linesF32[i * 4 + 3] = end.dy - endSize.height / 2 - padding / 4;
    }

    if (pointsF32.isNotEmpty) {
      canvas.drawRawPoints(
        PointMode.points,
        pointsF32,
        Paint()
          ..color = Colors.green
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke
          ..strokeWidth = middleIconSize,
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

    return _size = Size(
      maxWidth,
      height, // Example height calculation, adjust as needed
    );
  }

  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..isAntiAlias = true
        ..blendMode = BlendMode.src
        ..color = Colors.grey.shade200
        ..style = PaintingStyle.fill,
    );

    if (_picture case Picture picture) {
      canvas.drawPicture(picture);
    }
  }

  void handleTap(PointerDownEvent event) {
    if ((event.buttons & kPrimaryButton) == 0) return;

    final localPosition = event.localPosition;

    for (final target in _gestureTargets) {
      if (target.boundary.contains(localPosition)) {
        target.onTap();
        final tappedIndex = _gestureTargets.indexOf(target);

        if (!_tappedIndexMap.containsKey(tappedIndex)) {
          _tappedIndexMap[tappedIndex] = DateTime.now();
          _isDirty = true;
        }
        return;
      }
    }
  }
}
