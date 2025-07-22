import 'dart:math' as math;

import 'package:flutter/material.dart';

// Generated widget with ChatGPT
class GrowthChart extends StatelessWidget {
  const GrowthChart({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: const BoxDecoration(
      gradient: RadialGradient(
        center: Alignment.center,

        colors: <Color>[
          Color.fromARGB(255, 36, 34, 21), // Более светлые края
          Color.fromARGB(255, 23, 22, 20), // Более темный центр
        ],
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: kToolbarHeight + MediaQuery.of(context).padding.top - 20.0),
        // Заголовок
        const Text(
          'Стратегия роста RUB',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 16),

        // Доходность
        const Text(
          '+98,53 % за все время',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF4CAF50)),
        ),
        const SizedBox(height: 32),

        // Даты
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('17 февраля 2023', style: TextStyle(fontSize: 14, color: Colors.grey)),
            Text('22 мая 2025', style: TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 8),

        // Пунктирная линия
        SizedBox(height: 1, child: CustomPaint(painter: DashedLinePainter(), size: const Size(double.infinity, 1))),
        const SizedBox(height: 32),

        // График
        SizedBox(height: 200, child: CustomPaint(painter: ChartPainter(), size: const Size(double.infinity, 200))),
        const SizedBox(height: 16),

        // Временные метки
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Н', style: TextStyle(fontSize: 14, color: Colors.grey)),
            Text('М', style: TextStyle(fontSize: 14, color: Colors.grey)),
            Text('6М', style: TextStyle(fontSize: 14, color: Colors.grey)),
            Text('Г', style: TextStyle(fontSize: 14, color: Colors.grey)),
            Text('Все', style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    ),
  );
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.grey.withValues(alpha: 0.5)
          ..strokeWidth = 1;

    const dashWidth = 4.0;
    const dashSpace = 4.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(math.min(startX + dashWidth, size.width), 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white
          ..strokeWidth = 2.5
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

    // Генерируем точки для восходящего тренда с небольшими колебаниями
    final points = <Offset>[];
    const numPoints = 50;

    for (var i = 0; i < numPoints; i++) {
      final x = (i / (numPoints - 1)) * size.width;

      // Основной восходящий тренд
      final baseY = size.height - (i / (numPoints - 1)) * size.height * 0.8;

      // Добавляем небольшие случайные колебания
      final random = math.Random(i); // Фиксированный seed для воспроизводимости
      final noise = (random.nextDouble() - 0.5) * 20;

      // Добавляем некоторую волнистость
      final wave = math.sin(i * 0.3) * 8;

      final y = baseY + noise + wave;
      points.add(Offset(x, math.max(20, math.min(size.height - 20, y))));
    }

    // Рисуем плавную кривую через точки
    if (points.length > 1) {
      final path = Path()..moveTo(points[0].dx, points[0].dy);

      for (var i = 1; i < points.length; i++) {
        final current = points[i];
        final previous = points[i - 1];

        // Создаем плавную кривую между точками
        final controlPoint1 = Offset(previous.dx + (current.dx - previous.dx) * 0.3, previous.dy);
        final controlPoint2 = Offset(previous.dx + (current.dx - previous.dx) * 0.7, current.dy);

        path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx, controlPoint2.dy, current.dx, current.dy);
      }

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
