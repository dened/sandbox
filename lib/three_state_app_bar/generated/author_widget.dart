import 'package:flutter/material.dart';

// Generated widget with ChatGPT
class AuthorWidget extends StatelessWidget {
  const AuthorWidget({super.key});

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
        // Топ торгуемых бумаг
        const Text(
          'Топ торгуемых бумаг',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 20),

        _buildStockRow('ВИМ - Ликвидность', '202 сделки', Colors.grey[300]!, 'ВИМ'),
        const SizedBox(height: 16),
        _buildStockRow('ОФЗ 26248', '111 сделок', const Color(0xFF4CAF50), '★'),
        const SizedBox(height: 16),
        _buildStockRow('Т-Технологии', '110 сделок', const Color(0xFFFFEB3B), 'Т'),
        const SizedBox(height: 32),

        // Последние сделки
        const Text(
          'Последние сделки',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            const Expanded(
              child: Text(
                'Покажем, когда вы начнете следовать стратегии',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            Icon(Icons.lock_outline, color: Colors.grey[400], size: 20),
          ],
        ),
        const SizedBox(height: 32),

        // Автор стратегии
        const Text('Автор стратегии', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
        const SizedBox(height: 20),

        Row(
          children: [
            // Аватар
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                image: const DecorationImage(image: NetworkImage('https://i.pravatar.cc/150'), fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 16),

            // Информация об авторе
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Polyakov_invest',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                        child: const Icon(Icons.check, color: Colors.white, size: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '+13,79% за год',
                    style: TextStyle(fontSize: 14, color: Color(0xFF4CAF50), fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),

            // Кнопка подписки
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
              child: const Icon(Icons.add, color: Colors.white, size: 20),
            ),
          ],
        ),
        const SizedBox(height: 16),

        const Text('Инвестирует с 2019 г., квал. инвестор', style: TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    ),
  );

  Widget _buildStockRow(String name, String trades, Color iconColor, String iconText) => Row(
    children: [
      Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: iconColor, borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Text(iconText, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      ),
      const SizedBox(width: 16),
      Expanded(child: Text(name, style: const TextStyle(fontSize: 16, color: Colors.black))),
      Text(trades, style: const TextStyle(fontSize: 14, color: Colors.grey)),
    ],
  );
}
