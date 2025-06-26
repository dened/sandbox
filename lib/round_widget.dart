import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

void main() => runZonedGuarded<void>(
  () => runApp(const App()),
  (error, stackTrace) => print('Top level exception: $error\n$stackTrace'), // ignore: avoid_print
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
      body: const SafeArea(
        child: Column(children: [Center(child: Text('Hello World')), SizedBox(height: 20), Circle()]),
      ),
    ),
  );
}

class Circle extends LeafRenderObjectWidget {
  /// Creates a circle widget with a given radius and color.
  const Circle({super.key, this.radius = 50.0, this.color = Colors.blue});

  final double radius;
  final Color color;

  @override
  RenderObject createRenderObject(BuildContext context) => CircleRenderBox();

  @override
  void updateRenderObject(BuildContext context, covariant CircleRenderBox renderObject) {
    renderObject.painter = CirclePainter();
  }
}

class CircleRenderBox extends RenderBox {
  CircleRenderBox() : painter = CirclePainter();

  CirclePainter painter;

  Ticker? _ticker;

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

  @override
  void attach(PipelineOwner owner) {
    // TODO: implement attach
    super.attach(owner);
    _ticker ??= Ticker(_onTick)..start();
  }

  void _onTick(Duration elapsed) {
    markNeedsPaint();
  }

  @override
  void performLayout() {
    size = painter.size;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) => painter.size;
}

class CirclePainter {
  CirclePainter();

  Size get size => const Size(800, 800);

  void paint(Canvas canvas, Size size) {
    final now = DateTime.now();
    final seconds = (now.second + now.millisecond / 1000) * 4; // Scale seconds to a range suitable for radius and color
    final mix = seconds.toInt() % 255; // Ensure mix is within 0-255 range
    final color = Color.fromARGB(255, 255 - mix, 0 + mix, 255 - mix);
    // print('Current time: ${now.millisecond}, seconds: $seconds, radius: $radius, color: $color');
    final paint = Paint()..color = color;
    canvas.drawPaint(Paint()..color = Colors.blueAccent.withValues(alpha: 0.1));
    // canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, paint);

    var angle = (now.second + now.millisecond / 1000) * 6; // Scale seconds to degrees

    // Draw points around the circle
    final points = Float32List(120 * 2 * 23);
    for (var r = 0; r < 23; r++) {
      final radians = (angle * (r + 1) / 12) * (math.pi / 180);
      for (var i = 0; i < 120; i++) {
        final radius = r * 15 + 20; // Adjust radius for each circle
        final pointAngle = radians + (i * math.pi / (60 - r * 2)); 
        final x = size.width / 2 + (size.width / 2 - radius) * math.cos(pointAngle);
        final y = size.height / 2 + (size.height / 2 - radius) * math.sin(pointAngle * (r % 2 == 0 ? 1 : -1));
        canvas.drawCircle(Offset(x, y), 5, paint);
        points[i + r * 120 * 2] = x;
        points[i * 2 + r * 120 * 2 + 1] = y;
      }
    }

    // canvas.drawRawPoints(PointMode.points, points, paint);
  }
}
