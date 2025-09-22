// ignore_for_file: cascade_invocations, deprecated_member_use

import 'package:flutter/widgets.dart';

/// {@template calendar}
/// Calendar widget.
/// {@endtemplate}
class GameController extends StatelessWidget {
  /// {@macro calendar}
  const GameController({
    super.key, // ignore: unused_element
  });

  @override
  Widget build(BuildContext context) => CustomPaint(size: const Size(512, 512), painter: RPSCustomPainter());
}

//Copy this CustomPainter code to the Bottom of the File
class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var path_0 = Path();
    path_0.moveTo(29.095, 39.268);
    path_0.lineTo(38.541, 39.268);
    path_0.cubicTo(40.242, 39.268, 41.887, 39.877, 43.178999999999995, 40.984);
    path_0.lineTo(52.306999999999995, 48.812000000000005);
    path_0.cubicTo(52.91799999999999, 49.336000000000006, 53.812, 49.426, 54.49099999999999, 48.995000000000005);
    path_0.cubicTo(
      63.986999999999995,
      42.98500000000001,
      52.468999999999994,
      19.267000000000003,
      50.18599999999999,
      14.961000000000006,
    );
    path_0.cubicTo(
      49.943999999999996,
      14.504000000000005,
      49.544999999999995,
      12.025000000000006,
      49.059999999999995,
      11.848000000000006,
    );
    path_0.lineTo(41.38399999999999, 9.057000000000006);
    path_0.cubicTo(
      40.71099999999999,
      8.812000000000006,
      39.961999999999996,
      8.902000000000006,
      39.36699999999999,
      9.299000000000007,
    );
    path_0.cubicTo(
      39.36699999999999,
      9.299000000000007,
      37.20299999999999,
      10.682000000000006,
      36.71799999999999,
      10.682000000000006,
    );
    path_0.lineTo(28.29299999999999, 10.682000000000006);
    path_0.lineTo(21.74399999999999, 10.682000000000006);
    path_0.cubicTo(
      21.25899999999999,
      10.682000000000006,
      18.82299999999999,
      9.299000000000007,
      18.82299999999999,
      9.299000000000007,
    );
    path_0.cubicTo(
      18.22699999999999,
      8.902000000000006,
      17.47799999999999,
      8.812000000000006,
      16.80599999999999,
      9.057000000000006,
    );
    path_0.lineTo(9.13, 11.848);
    path_0.cubicTo(8.644, 12.025, 8.246, 14.504000000000001, 8.004000000000001, 14.961);
    path_0.cubicTo(5.721, 19.267, -5.797, 42.985, 3.699, 48.995);
    path_0.cubicTo(4.379, 49.425, 5.273, 49.335, 5.883, 48.812);
    path_0.lineTo(15.011, 40.983999999999995);
    path_0.cubicTo(16.303, 39.876999999999995, 17.948, 39.267999999999994, 19.649, 39.267999999999994);
    path_0.lineTo(29.095, 39.267999999999994);
    path_0.close();

    var paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = const Color(0xff38454F).withOpacity(1);
    canvas.drawPath(path_0, paint0Fill);

    var paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.color = const Color(0xff546A79).withOpacity(1);
    canvas.drawCircle(Offset(size.width * 0.6321813, size.height * 0.5201670), size.width * 0.06874151, paint1Fill);

    var paint2Fill = Paint()..style = PaintingStyle.fill;
    paint2Fill.color = const Color(0xff546A79).withOpacity(1);
    canvas.drawCircle(Offset(size.width * 0.2369176, size.height * 0.3483133), size.width * 0.06874151, paint2Fill);

    var paint3Fill = Paint()..style = PaintingStyle.fill;
    paint3Fill.color = const Color(0xffEBBA16).withOpacity(1);
    canvas.drawCircle(Offset(size.width * 0.7524790, size.height * 0.2795717), size.width * 0.03437076, paint3Fill);

    var paint4Fill = Paint()..style = PaintingStyle.fill;
    paint4Fill.color = const Color(0xff7383BF).withOpacity(1);
    canvas.drawCircle(Offset(size.width * 0.6837375, size.height * 0.3483133), size.width * 0.03437076, paint4Fill);

    var paint5Fill = Paint()..style = PaintingStyle.fill;
    paint5Fill.color = const Color(0xffD75A4A).withOpacity(1);
    canvas.drawCircle(Offset(size.width * 0.8212205, size.height * 0.3483133), size.width * 0.03437076, paint5Fill);

    var paint6Fill = Paint()..style = PaintingStyle.fill;
    paint6Fill.color = const Color(0xff61B872).withOpacity(1);
    canvas.drawCircle(Offset(size.width * 0.7524790, size.height * 0.4170548), size.width * 0.03437076, paint6Fill);

    var path_7 = Path();
    path_7.moveTo(31.786, 11.712);
    path_7.cubicTo(31.786, 11.52, 31.767000000000003, 11.331999999999999, 31.732000000000003, 11.151);
    path_7.cubicTo(31.697000000000003, 10.97, 31.621000000000002, 10.813, 31.517000000000003, 10.682);
    path_7.cubicTo(30.346000000000004, 10.682, 29.437000000000005, 10.682, 29.038000000000004, 10.682);
    path_7.cubicTo(28.953000000000003, 10.689, 28.873000000000005, 10.712, 28.787000000000003, 10.712);
    path_7.cubicTo(28.700000000000003, 10.712, 28.62, 10.69, 28.536, 10.682);
    path_7.cubicTo(28.523, 10.682, 28.294, 10.682, 28.294, 10.682);
    path_7.lineTo(26.047, 10.682);
    path_7.cubicTo(25.959, 10.796000000000001, 25.889, 10.927, 25.855, 11.082);
    path_7.cubicTo(25.768, 11.48, 25.761, 11.909, 25.855, 12.353000000000002);
    path_7.cubicTo(26.103, 13.523000000000001, 27.080000000000002, 14.466000000000001, 28.259, 14.667000000000002);
    path_7.cubicTo(30.148, 14.989, 31.786, 13.542, 31.786, 11.712);
    path_7.close();

    var paint7Fill = Paint()..style = PaintingStyle.fill;
    paint7Fill.color = const Color(0xffAFB6BB).withOpacity(1);
    canvas.drawPath(path_7, paint7Fill);

    var path_8 = Path();
    path_8.moveTo(27.286, 27.921);
    path_8.lineTo(24, 27.921);
    path_8.lineTo(24, 24.634999999999998);
    path_8.cubicTo(24, 24.24, 23.68, 23.921, 23.286, 23.921);
    path_8.lineTo(20.715, 23.921);
    path_8.cubicTo(20.32, 23.921, 20.001, 24.241, 20.001, 24.634999999999998);
    path_8.lineTo(20.001, 27.921);
    path_8.lineTo(16.715, 27.921);
    path_8.cubicTo(16.32, 27.921, 16.001, 28.241, 16.001, 28.634999999999998);
    path_8.lineTo(16.001, 31.206);
    path_8.cubicTo(16.001, 31.601, 16.321, 31.919999999999998, 16.715, 31.919999999999998);
    path_8.lineTo(20, 31.919999999999998);
    path_8.lineTo(20, 35.205999999999996);
    path_8.cubicTo(20, 35.601, 20.32, 35.919999999999995, 20.714, 35.919999999999995);
    path_8.lineTo(23.285, 35.919999999999995);
    path_8.cubicTo(23.68, 35.919999999999995, 23.999, 35.599999999999994, 23.999, 35.205999999999996);
    path_8.lineTo(23.999, 31.919999999999995);
    path_8.lineTo(27.285, 31.919999999999995);
    path_8.cubicTo(27.68, 31.919999999999995, 27.999, 31.599999999999994, 27.999, 31.205999999999996);
    path_8.lineTo(27.999, 28.634999999999994);
    path_8.cubicTo(28, 28.241, 27.68, 27.921, 27.286, 27.921);
    path_8.close();

    var paint8Fill = Paint()..style = PaintingStyle.fill;
    paint8Fill.color = const Color(0xff546A79).withOpacity(1);
    canvas.drawPath(path_8, paint8Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
