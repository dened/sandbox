import 'package:flutter/material.dart';

// Generated widget with ChatGPT
class PortfolioWidget extends StatelessWidget {
  const PortfolioWidget({super.key});

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
        // Заголовок
        const Text(
          'Портфель стратегии',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 20),

        // Табы
        Row(
          children: [
            _buildTab('Активы', isSelected: true),
            const SizedBox(width: 12),
            _buildTab('Отрасли', isSelected: false),
            const SizedBox(width: 12),
            _buildTab('Компании', isSelected: false),
          ],
        ),
        const SizedBox(height: 24),

        // Список активов
        _buildAssetRow('ETF', '56,34%', const Color(0xFFBBDEFB)),
        const SizedBox(height: 16),
        _buildAssetRow('Валюта', '0,43%', Colors.grey[100]!),
        const SizedBox(height: 16),
        _buildAssetRow('Акции', '26,94%', const Color(0xFFC8E6C9)),
        const SizedBox(height: 16),
        _buildAssetRow('Облигации', '16,29%', const Color(0xFFFFF9C4)),
      ],
    ),
  );

  Widget _buildTab(String text, {required bool isSelected}) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: isSelected ? Colors.black : Colors.grey[200],
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      text,
      style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
    ),
  );

  Widget _buildAssetRow(String name, String percentage, Color backgroundColor) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(name, style: const TextStyle(fontSize: 16, color: Colors.black)),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(12)),
        child: Text(percentage, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black)),
      ),
    ],
  );
}
