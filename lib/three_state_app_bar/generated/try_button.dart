import 'package:flutter/material.dart';

// Generated with ChatGPT
class TryButton extends StatelessWidget {
  const TryButton({super.key, this.text = 'Попробовать от 65 000 ₽', this.onPressed});
  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.all(16),
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE6D73A),
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
    ),
  );
}
