import 'package:flutter/material.dart';

// Generated widget with ChatGPT
class RiskLevelWidget extends StatelessWidget {
  const RiskLevelWidget({super.key});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.all(16),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2))],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Заголовок с иконкой
        Row(
          children: [
            const Text(
              'Уровень риска',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(width: 8),
            Icon(Icons.help_outline, size: 16, color: Colors.grey[400]),
          ],
        ),
        const SizedBox(height: 16),

        // Уровень риска
        const Text('Средний', style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),

        // Индикатор риска
        Container(
          height: 6,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: Colors.grey[200]),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: const Color(0xFFE6D73A)),
                ),
              ),
              const Expanded(flex: 5, child: SizedBox()),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Описание
        const Text(
          'Мы ответственно отбираем авторов и следим за сделками — но даже при этом возможна просадка портфеля',
          style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.4),
        ),
        const SizedBox(height: 24),

        // Условия
        const Text('Условия', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
        const SizedBox(height: 16),

        // Список условий
        _buildConditionRow('Комиссия за сделки', 'Нет'),
        const SizedBox(height: 12),
        _buildConditionRow('Комиссия за следование', '0,333%', hasIcon: true),
        const SizedBox(height: 12),
        _buildConditionRow('Комиссия за результат', '20,0%', hasIcon: true),
        const SizedBox(height: 20),

        // Полные условия
        TextButton(
          onPressed: () {},
          child: const Text(
            'Полные условия',
            style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 16),

        // Подробнее о стратегии
        Text('Подробнее о стратегии', style: TextStyle(color: Colors.grey[400], fontSize: 14)),
      ],
    ),
  );

  Widget _buildConditionRow(String label, String value, {bool hasIcon = false}) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 16, color: Colors.black)),
          if (hasIcon) ...[const SizedBox(width: 8), Icon(Icons.help_outline, size: 16, color: Colors.grey[400])],
        ],
      ),
      Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black)),
    ],
  );
}
