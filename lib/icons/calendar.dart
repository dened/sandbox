// ignore_for_file: cascade_invocations, deprecated_member_use

import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

/// {@template calendar}
/// Calendar widget.
/// {@endtemplate}
class Calendar extends StatelessWidget {
  /// {@macro calendar}
  const Calendar({
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
    path_0.moveTo(453.477, 42.994);
    path_0.lineTo(58.519, 42.994);
    path_0.cubicTo(47.427, 42.994, 38.424, 51.997, 38.424, 63.089);
    path_0.lineTo(38.424, 477.713);
    path_0.cubicTo(38.424, 488.805, 47.427, 497.808, 58.519, 497.808);
    path_0.lineTo(453.47700000000003, 497.808);
    path_0.cubicTo(464.569, 497.808, 473.572, 488.805, 473.572, 477.71299999999997);
    path_0.lineTo(473.572, 63.089);
    path_0.cubicTo(473.572, 51.997, 464.571, 42.994, 453.477, 42.994);
    path_0.close();

    var paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.shader = ui.Gradient.linear(
      const Offset(180.266, 102.034),
      const Offset(296.266, 359.734),
      [const Color(0xff00A6F9).withOpacity(1), const Color(0xff0071E2).withOpacity(1)],
      [0, 1],
    );
    canvas.drawPath(path_0, paint0Fill);

    var path_1 = Path();
    path_1.moveTo(453.474, 497.808);
    path_1.lineTo(58.524, 497.808);
    path_1.cubicTo(47.426, 497.808, 38.429, 488.812, 38.429, 477.71299999999997);
    path_1.lineTo(38.429, 260.019);
    path_1.lineTo(473.56899999999996, 260.019);
    path_1.lineTo(473.56899999999996, 477.71299999999997);
    path_1.cubicTo(473.569, 488.812, 464.572, 497.808, 453.474, 497.808);
    path_1.close();

    var paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.shader = ui.Gradient.linear(
      const Offset(107.49, 222.1),
      const Offset(405.9, 534.9),
      [const Color(0xffC2CECE).withOpacity(1), const Color(0xff97AAAA).withOpacity(1)],
      [0, 1],
    );
    canvas.drawPath(path_1, paint1Fill);

    var path_2 = Path();
    path_2.moveTo(453.474, 497.808);
    path_2.lineTo(58.524, 497.808);
    path_2.cubicTo(47.426, 497.808, 38.429, 488.812, 38.429, 477.71299999999997);
    path_2.lineTo(38.429, 435.51399999999995);
    path_2.lineTo(473.56899999999996, 435.51399999999995);
    path_2.lineTo(473.56899999999996, 477.71299999999997);
    path_2.cubicTo(473.569, 488.812, 464.572, 497.808, 453.474, 497.808);
    path_2.close();

    var paint2Fill = Paint()..style = PaintingStyle.fill;
    paint2Fill.shader = ui.Gradient.linear(
      const Offset(255.9, 492.0),
      const Offset(255.9, 447.5),
      [
        const Color(0xffC2CECE).withOpacity(0),
        const Color(0xffAFBCBC).withOpacity(0.179),
        const Color(0xff5B6A6A).withOpacity(1),
      ],
      [0, 0.179, 1],
    );
    canvas.drawPath(path_2, paint2Fill);

    var path_3 = Path();
    path_3.moveTo(491.894, 448.911);
    path_3.lineTo(20.103, 448.911);
    path_3.cubicTo(7.195000000000002, 448.911, -2.3649999999999984, 436.915, 0.5150000000000006, 424.333);
    path_3.lineTo(38.429, 258.68000000000006);
    path_3.lineTo(473.56899999999996, 258.68000000000006);
    path_3.lineTo(511.48299999999995, 424.3330000000001);
    path_3.cubicTo(514.363, 436.915, 504.802, 448.911, 491.894, 448.911);
    path_3.close();

    var paint3Fill = Paint()..style = PaintingStyle.fill;
    paint3Fill.shader = ui.Gradient.linear(
      const Offset(69.1, 274.7),
      const Offset(548.9, 490.5),
      [const Color(0xff00A6F9).withOpacity(1), const Color(0xff0071E2).withOpacity(1)],
      [0, 1],
    );
    canvas.drawPath(path_3, paint3Fill);

    var path_4 = Path();
    path_4.moveTo(491.894, 448.911);
    path_4.lineTo(20.103, 448.911);
    path_4.cubicTo(7.195000000000002, 448.911, -2.3649999999999984, 436.915, 0.5150000000000006, 424.333);
    path_4.lineTo(38.429, 258.68000000000006);
    path_4.lineTo(473.56899999999996, 258.68000000000006);
    path_4.lineTo(511.48299999999995, 424.3330000000001);
    path_4.cubicTo(514.363, 436.915, 504.802, 448.911, 491.894, 448.911);
    path_4.close();

    var paint4Fill = Paint()..style = PaintingStyle.fill;
    paint4Fill.shader = ui.Gradient.linear(
      const Offset(255.9, 430.5),
      const Offset(255.9, 457.3),
      [const Color(0xff008BF2).withOpacity(0), const Color(0xff0046E2).withOpacity(1)],
      [0.0001, 1],
    );
    canvas.drawPath(path_4, paint4Fill);

    var path_5 = Path();
    path_5.moveTo(491.894, 448.911);
    path_5.cubicTo(504.802, 448.911, 514.362, 436.915, 511.482, 424.333);
    path_5.lineTo(473.56800000000004, 258.68000000000006);
    path_5.lineTo(38.429, 258.68000000000006);
    path_5.lineTo(228.66, 448.911);
    path_5.lineTo(491.894, 448.911);
    path_5.close();

    var paint5Fill = Paint()..style = PaintingStyle.fill;
    paint5Fill.shader = ui.Gradient.linear(
      const Offset(346.8, 349.5),
      const Offset(43.2, 45.5),
      [const Color(0xff008BF2).withOpacity(0), const Color(0xff0046E2).withOpacity(1)],
      [0.0001, 1],
    );
    canvas.drawPath(path_5, paint5Fill);

    var path_6 = Path();
    path_6.moveTo(473.569, 448.911);
    path_6.lineTo(38.429, 448.911);
    path_6.lineTo(38.429, 449.581);
    path_6.lineTo(86.656, 497.808);
    path_6.lineTo(453.474, 497.808);
    path_6.cubicTo(464.572, 497.808, 473.56899999999996, 488.812, 473.56899999999996, 477.71299999999997);
    path_6.lineTo(473.56899999999996, 448.911);
    path_6.close();

    var paint6Fill = Paint()..style = PaintingStyle.fill;
    paint6Fill.shader = ui.Gradient.linear(
      const Offset(223.5, 409.6),
      const Offset(174.2, 348.6),
      [
        const Color(0xffC2CECE).withOpacity(0),
        const Color(0xffAFBCBC).withOpacity(0.179),
        const Color(0xff5B6A6A).withOpacity(1),
      ],
      [0, 0.179, 1],
    );
    canvas.drawPath(path_6, paint6Fill);

    var path_7 = Path();
    path_7.moveTo(152.136, 298.536);
    path_7.lineTo(152.136, 213.755);
    path_7.cubicTo(152.136, 191.422, 158.058, 175.006, 169.908, 164.518);
    path_7.cubicTo(181.753, 154.029, 197.58599999999998, 148.786, 217.396, 148.786);
    path_7.cubicTo(237.207, 148.786, 253.08599999999998, 154.03, 265.031, 164.518);
    path_7.cubicTo(276.976, 175.007, 282.948, 191.421, 282.948, 213.755);
    path_7.lineTo(282.948, 298.536);
    path_7.cubicTo(282.948, 320.874, 276.976, 337.285, 265.03099999999995, 347.773);
    path_7.cubicTo(253.08499999999995, 358.262, 237.20799999999994, 363.505, 217.39599999999996, 363.505);
    path_7.cubicTo(197.58499999999995, 363.505, 181.75199999999995, 358.26099999999997, 169.90799999999996, 347.773);
    path_7.cubicTo(158.059, 337.284, 152.136, 320.873, 152.136, 298.536);
    path_7.close();
    path_7.moveTo(183.019, 298.536);
    path_7.cubicTo(183.019, 323.592, 194.477, 336.12, 217.398, 336.12);
    path_7.cubicTo(228.469, 336.12, 237.014, 333.015, 243.036, 326.796);
    path_7.cubicTo(249.054, 320.58299999999997, 252.067, 311.164, 252.067, 298.536);
    path_7.lineTo(252.067, 213.755);
    path_7.cubicTo(252.067, 201.132, 249.054, 191.712, 243.036, 185.495);
    path_7.cubicTo(237.014, 179.282, 228.469, 176.171, 217.398, 176.171);
    path_7.cubicTo(194.477, 176.171, 183.019, 188.69899999999998, 183.019, 213.755);
    path_7.lineTo(183.019, 298.536);
    path_7.close();

    var paint7Fill = Paint()..style = PaintingStyle.fill;
    paint7Fill.color = const Color(0xffFFFFFF).withOpacity(1);
    canvas.drawPath(path_7, paint7Fill);

    var path_8 = Path();
    path_8.moveTo(301.885, 192.779);
    path_8.cubicTo(301.885, 187.73, 303.923, 183.748, 308.003, 180.833);
    path_8.lineTo(338.303, 151.699);
    path_8.cubicTo(340.437, 149.56400000000002, 343.06, 148.494, 346.169, 148.494);
    path_8.cubicTo(349.666, 148.494, 352.82, 149.419, 355.638, 151.262);
    path_8.cubicTo(358.452, 153.109, 359.86199999999997, 155.586, 359.86199999999997, 158.691);
    path_8.lineTo(359.86199999999997, 351.56);
    path_8.cubicTo(359.86199999999997, 354.669, 358.30499999999995, 357.146, 355.20099999999996, 358.989);
    path_8.cubicTo(352.092, 360.83599999999996, 348.49999999999994, 361.75699999999995, 344.421, 361.75699999999995);
    path_8.cubicTo(340.146, 361.75699999999995, 336.504, 360.83799999999997, 333.496, 358.989);
    path_8.cubicTo(330.483, 357.145, 328.97999999999996, 354.669, 328.97999999999996, 351.56);
    path_8.lineTo(328.97999999999996, 189.573);
    path_8.lineTo(318.78299999999996, 202.392);
    path_8.cubicTo(316.84, 204.335, 314.70399999999995, 205.305, 312.37299999999993, 205.305);
    path_8.cubicTo(309.4599999999999, 205.305, 306.98299999999995, 203.994, 304.94399999999996, 201.372);
    path_8.cubicTo(302.904, 198.751, 301.885, 195.888, 301.885, 192.779);
    path_8.close();

    var paint8Fill = Paint()..style = PaintingStyle.fill;
    paint8Fill.color = const Color(0xffFFFFFF).withOpacity(1);
    canvas.drawPath(path_8, paint8Fill);

    var path_9 = Path();
    path_9.moveTo(252.06, 258.679);
    path_9.lineTo(252.06, 298.534);
    path_9.cubicTo(252.06, 311.167, 249.059, 320.585, 243.031, 326.801);
    path_9.cubicTo(237.01600000000002, 333.018, 228.469, 336.125, 217.40300000000002, 336.125);
    path_9.cubicTo(194.48100000000002, 336.125, 183.014, 323.585, 183.014, 298.53499999999997);
    path_9.lineTo(183.014, 258.67999999999995);
    path_9.lineTo(152.13500000000002, 258.67999999999995);
    path_9.lineTo(152.13500000000002, 298.53499999999997);
    path_9.cubicTo(152.13500000000002, 320.881, 158.056, 337.29099999999994, 169.91200000000003, 347.76699999999994);
    path_9.cubicTo(
      181.75400000000005,
      358.25699999999995,
      197.59000000000003,
      363.5079999999999,
      217.40300000000002,
      363.5079999999999,
    );
    path_9.cubicTo(237.204, 363.5079999999999, 253.092, 358.25699999999995, 265.028, 347.76699999999994);
    path_9.cubicTo(276.978, 337.29099999999994, 282.952, 320.87999999999994, 282.952, 298.53499999999997);
    path_9.lineTo(282.952, 258.67999999999995);
    path_9.lineTo(252.06, 258.679);
    path_9.lineTo(252.06, 258.679);
    path_9.close();

    var paint9Fill = Paint()..style = PaintingStyle.fill;
    paint9Fill.shader = ui.Gradient.linear(
      const Offset(217.0, 292.8),
      const Offset(217.0, 139.8),
      [
        const Color(0xffC2CECE).withOpacity(0),
        const Color(0xffAFBCBC).withOpacity(0.179),
        const Color(0xff5B6A6A).withOpacity(1),
      ],
      [0, 0.179, 1],
    );
    canvas.drawPath(path_9, paint9Fill);

    var path_10 = Path();
    path_10.moveTo(328.983, 258.679);
    path_10.lineTo(328.983, 351.558);
    path_10.cubicTo(328.983, 354.666, 330.484, 357.144, 333.497, 358.993);
    path_10.cubicTo(336.498, 360.842, 340.141, 361.752, 344.415, 361.752);
    path_10.cubicTo(348.50100000000003, 361.752, 352.09200000000004, 360.841, 355.199, 358.993);
    path_10.cubicTo(358.307, 357.144, 359.861, 354.666, 359.861, 351.558);
    path_10.lineTo(359.861, 258.679);
    path_10.lineTo(328.983, 258.679);
    path_10.close();

    var paint10Fill = Paint()..style = PaintingStyle.fill;
    paint10Fill.shader = ui.Gradient.linear(
      const Offset(344.4, 292.8),
      const Offset(344.4, 139.8),
      [
        const Color(0xffC2CECE).withOpacity(0),
        const Color(0xffAFBCBC).withOpacity(0.179),
        const Color(0xff5B6A6A).withOpacity(1),
      ],
      [0, 0.179, 1],
    );
    canvas.drawPath(path_10, paint10Fill);

    var path_11 = Path();
    path_11.moveTo(511.485, 424.328);
    path_11.lineTo(473.572, 258.679);
    path_11.lineTo(473.572, 63.089);
    path_11.cubicTo(473.572, 51.997, 464.569, 42.994, 453.477, 42.994);
    path_11.lineTo(443.97299999999996, 42.994);
    path_11.cubicTo(455.06499999999994, 42.994, 464.068, 51.997, 464.068, 63.089);
    path_11.lineTo(464.068, 258.679);
    path_11.lineTo(501.981, 424.328);
    path_11.cubicTo(504.861, 436.921, 495.296, 448.90999999999997, 482.395, 448.90999999999997);
    path_11.lineTo(491.899, 448.90999999999997);
    path_11.cubicTo(504.8, 448.911, 514.365, 436.92, 511.485, 424.328);
    path_11.close();

    var paint11Fill = Paint()..style = PaintingStyle.fill;
    paint11Fill.shader = ui.Gradient.linear(
      const Offset(474.0, 244.6),
      const Offset(371.0, 271.4),
      [const Color(0xff008BF2).withOpacity(0), const Color(0xff0046E2).withOpacity(1)],
      [0.0001, 1],
    );
    canvas.drawPath(path_11, paint11Fill);

    var path_12 = Path();
    path_12.moveTo(170.864, 78.79);
    path_12.cubicTo(
      167.20600000000002,
      75.361,
      164.90200000000002,
      70.51100000000001,
      164.90200000000002,
      65.09800000000001,
    );
    path_12.lineTo(164.90200000000002, 42.994);
    path_12.lineTo(202.412, 42.994);
    path_12.lineTo(233.046, 73.628);
    path_12.cubicTo(242.81, 83.392, 248.296, 96.636, 248.296, 110.445);
    path_12.lineTo(248.296, 110.445);
    path_12.cubicTo(248.296, 120.56099999999999, 240.513, 129.261, 230.40699999999998, 129.718);
    path_12.cubicTo(224.647, 129.97799999999998, 219.46099999999998, 127.627, 215.85, 123.77699999999999);
    path_12.lineTo(170.864, 78.79);
    path_12.close();

    var paint12Fill = Paint()..style = PaintingStyle.fill;
    paint12Fill.shader = ui.Gradient.linear(
      const Offset(221.9, 95.9),
      const Offset(182.2, 56.1),
      [const Color(0xff008BF2).withOpacity(0), const Color(0xff0046E2).withOpacity(1)],
      [0.0001, 1],
    );
    canvas.drawPath(path_12, paint12Fill);

    var path_13 = Path();
    path_13.moveTo(183.658, 83.854);
    path_13.lineTo(183.658, 83.854);
    path_13.cubicTo(173.29999999999998, 83.854, 164.903, 75.457, 164.903, 65.099);
    path_13.lineTo(164.903, 32.947);
    path_13.cubicTo(164.903, 22.589000000000002, 173.29999999999998, 14.192000000000004, 183.658, 14.192000000000004);
    path_13.lineTo(183.658, 14.192000000000004);
    path_13.cubicTo(194.016, 14.192000000000004, 202.41299999999998, 22.589000000000006, 202.41299999999998, 32.947);
    path_13.lineTo(202.41299999999998, 65.09800000000001);
    path_13.cubicTo(202.413, 75.457, 194.016, 83.854, 183.658, 83.854);
    path_13.close();

    var paint13Fill = Paint()..style = PaintingStyle.fill;
    paint13Fill.shader = ui.Gradient.linear(
      const Offset(183.6, 15.9),
      const Offset(183.6, 230.1),
      [
        const Color(0xffFFC200).withOpacity(1),
        const Color(0xffFFBB00).withOpacity(1),
        const Color(0xffFFA801).withOpacity(1),
        const Color(0xffFF9102).withOpacity(1),
      ],
      [0, 0.268, 0.659, 1],
    );
    canvas.drawPath(path_13, paint13Fill);

    var path_14 = Path();
    path_14.moveTo(183.658, 14.192);
    path_14.lineTo(183.658, 83.85400000000001);
    path_14.cubicTo(
      194.016,
      83.85400000000001,
      202.41299999999998,
      75.45700000000001,
      202.41299999999998,
      65.09900000000002,
    );
    path_14.lineTo(202.41299999999998, 32.947);
    path_14.cubicTo(202.413, 22.589, 194.016, 14.192, 183.658, 14.192);
    path_14.close();

    var paint14Fill = Paint()..style = PaintingStyle.fill;
    paint14Fill.shader = ui.Gradient.linear(
      const Offset(186.6, 48.7),
      const Offset(203.6, 48.7),
      [
        const Color(0xffFFC200).withOpacity(0),
        const Color(0xffFFBB00).withOpacity(0.203),
        const Color(0xffFFA700).withOpacity(0.499),
        const Color(0xffFF8800).withOpacity(0.852),
        const Color(0xffFF7800).withOpacity(1),
      ],
      [0, 0.203, 0.499, 0.852, 1],
    );
    canvas.drawPath(path_14, paint14Fill);

    var path_15 = Path();
    path_15.moveTo(307.173, 78.79);
    path_15.cubicTo(303.515, 75.361, 301.211, 70.51100000000001, 301.211, 65.09800000000001);
    path_15.lineTo(301.211, 42.994);
    path_15.lineTo(338.721, 42.994);
    path_15.lineTo(369.355, 73.628);
    path_15.cubicTo(379.119, 83.392, 384.605, 96.636, 384.605, 110.445);
    path_15.lineTo(384.605, 110.445);
    path_15.cubicTo(384.605, 120.56099999999999, 376.822, 129.261, 366.716, 129.718);
    path_15.cubicTo(360.956, 129.97799999999998, 355.77, 127.627, 352.159, 123.77699999999999);
    path_15.lineTo(307.173, 78.79);
    path_15.close();

    var paint15Fill = Paint()..style = PaintingStyle.fill;
    paint15Fill.shader = ui.Gradient.linear(
      const Offset(358.2, 95.9),
      const Offset(318.0, 56.1),
      [const Color(0xff008BF2).withOpacity(0), const Color(0xff0046E2).withOpacity(1)],
      [0.0001, 1],
    );
    canvas.drawPath(path_15, paint15Fill);

    var path_16 = Path();
    path_16.moveTo(319.968, 83.854);
    path_16.lineTo(319.968, 83.854);
    path_16.cubicTo(309.61, 83.854, 301.213, 75.457, 301.213, 65.099);
    path_16.lineTo(301.213, 32.947);
    path_16.cubicTo(301.213, 22.589000000000002, 309.61, 14.192000000000004, 319.968, 14.192000000000004);
    path_16.lineTo(319.968, 14.192000000000004);
    path_16.cubicTo(330.326, 14.192000000000004, 338.723, 22.589000000000006, 338.723, 32.947);
    path_16.lineTo(338.723, 65.09800000000001);
    path_16.cubicTo(338.723, 75.457, 330.325, 83.854, 319.968, 83.854);
    path_16.close();

    var paint16Fill = Paint()..style = PaintingStyle.fill;
    paint16Fill.shader = ui.Gradient.linear(
      const Offset(319.9, 15.9),
      const Offset(319.9, 230.1),
      [
        const Color(0xffFFC200).withOpacity(1),
        const Color(0xffFFBB00).withOpacity(1),
        const Color(0xffFFA801).withOpacity(1),
        const Color(0xffFF9102).withOpacity(1),
      ],
      [0, 0.268, 0.659, 1],
    );
    canvas.drawPath(path_16, paint16Fill);

    var path_17 = Path();
    path_17.moveTo(319.968, 14.192);
    path_17.lineTo(319.968, 83.85400000000001);
    path_17.cubicTo(
      330.326,
      83.85400000000001,
      338.723,
      75.45700000000001,
      338.723,
      65.09900000000002,
    );
    path_17.lineTo(338.723, 32.947);
    path_17.cubicTo(338.723, 22.589, 330.325, 14.192, 319.968, 14.192);
    path_17.close();

    var paint17Fill = Paint()..style = PaintingStyle.fill;
    paint17Fill.shader = ui.Gradient.linear(
      const Offset(322.9, 48.7),
      const Offset(339.9, 48.7),
      [
        const Color(0xffFFC200).withOpacity(0),
        const Color(0xffFFBB00).withOpacity(0.203),
        const Color(0xffFFA700).withOpacity(0.499),
        const Color(0xffFF8800).withOpacity(0.852),
        const Color(0xffFF7800).withOpacity(1),
      ],
      [0, 0.203, 0.499, 0.852, 1],
    );
    canvas.drawPath(path_17, paint17Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}