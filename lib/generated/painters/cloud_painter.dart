// ignore_for_file: cascade_invocations

import 'dart:ui' as ui;
import 'package:flutter/widgets.dart';

/// {@template Cloud}
/// Cloud widget.
/// {@endtemplate}
class Cloud extends StatelessWidget {
  /// {@macro Cloud}
  const Cloud({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width ?? 463.8342590332031, height ?? 463.0),
      painter: CloudPainter(),
    );
  }
}

class CloudPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: Implement scaling based on size.
    // The current implementation uses the original SVG size and does not scale.
    // You can use size.width and size.height to calculate a scale factor.
    // final scaleX = size.width / 463.8342590332031;
    // final scaleY = size.height / 463.0;
    // canvas.scale(scaleX, scaleY);

    var paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = const Color(0xffa3d4f7);
    paint0Fill.blendMode = BlendMode.srcOver;

    var path_0 = Path()..moveTo(375.8359375, 199.95703125)..cubicTo(369.984375, 199.95703125, 364.14453125, 200.5390625, 358.41015625, 201.69921875)..cubicTo(354.0859375, 180.1171875, 340.10546875, 161.70703125, 320.4765625, 151.7421875)..cubicTo(300.8515625, 141.77734375, 277.73828125, 141.359375, 257.76171875, 150.60546875)..cubicTo(239.68359375, 100.80859375, 184.66015625, 75.09765625, 134.86328125, 93.17578125)..cubicTo(85.06640625, 111.25390625, 59.35546875, 166.28125, 77.43359375, 216.07421875)..cubicTo(33.8125, 217.453125, -0.6445310115814209, 253.55859375, 0.0078125, 297.1953125)..cubicTo(0.6640620231628418, 340.8359375, 36.19140625, 375.88671875, 79.8359375, 375.95703125)..lineTo(375.8359375, 375.95703125)..cubicTo(424.43359375, 375.95703125, 463.8359375, 336.55859375, 463.8359375, 287.95703125)..cubicTo(463.8359375, 239.35546875, 424.43359375, 199.95703125, 375.8359375, 199.95703125)..close()..moveTo(375.8359375, 199.95703125);


    canvas.drawPath(path_0, paint0Fill);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

