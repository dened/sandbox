import 'package:flutter/material.dart';

// Generated widget with ChatGPT
class StrategyParameterCard extends StatelessWidget {
  const StrategyParameterCard({super.key});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.all(16),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Заголовок с иконкой вопроса
        const SizedBox(height: 32),

        // Параметры стратегии
        const Text(
          'Параметры стратегии',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),

        const SizedBox(height: 24),

        // Список параметров
        _buildParameterRow('Минимальная сумма', '65 000 ₽', hasIcon: true),
        const SizedBox(height: 20),
        _buildParameterRow('Следуют', '1 507'),
        const SizedBox(height: 20),
        _buildParameterRow('Существует', '2 года 3 мес.'),
        const SizedBox(height: 20),
        _buildParameterRow('Частота сделок', 'ежедневно'),
        const SizedBox(height: 32),

        // Кнопка "Все параметры"
        Center(
          child: TextButton(
            onPressed: () {},
            child: const Text(
              'Все параметры',
              style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    ),
  );

  Widget _buildParameterRow(String label, String value, {bool hasIcon = false}) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          if (hasIcon) ...[const SizedBox(width: 8), Icon(Icons.help_outline, size: 16, color: Colors.grey[400])],
        ],
      ),
      Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black)),
    ],
  );
}

/// {@template strategy_card}
/// StrategyCard widget.
/// {@endtemplate}
class StrategyCard extends StatelessWidget {
  /// {@macro strategy_card}
  const StrategyCard({
    super.key, // ignore: unused_element
  });

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: const Color.fromARGB(255, 23, 22, 20),
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Прогноз стратегии',
                style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 8),
              Icon(Icons.help_outline, size: 16, color: Colors.grey[400]),
            ],
          ),
          const SizedBox(height: 8),

          // Основная доходность
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('30% в год', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black)),
              TextButton(
                onPressed: () {},
                child: const Text('еще', style: TextStyle(color: Colors.blue, fontSize: 16)),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Описание
          const Text(
            'Доступна для ИИС. Возможен возврат НДФЛ до 88 000 ₽ в год.',
            style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.4),
          ),
        ],
      ),
    ),
  );
}
