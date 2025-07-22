import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show ThemeData;

const kNavBarPersistentHeight = 44.0;


class AnimatedNavBarColor extends StatefulWidget {
  
  const AnimatedNavBarColor({required this.value, super.key});
  final int value;

  @override
  State<AnimatedNavBarColor> createState() => _AnimatedNavBarColorState();
}

class _AnimatedNavBarColorState extends State<AnimatedNavBarColor> {
  Color _prevColor = CupertinoColors.transparent;

  Color _getColor(int value) {
    if (value > 480) return CupertinoColors.transparent;
    if (value > 70) return const Color.fromARGB(255, 74, 70, 9);

    return CupertinoColors.white;
  }

  @override
  void didUpdateWidget(covariant AnimatedNavBarColor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _prevColor = _getColor(oldWidget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final targetColor = _getColor(widget.value);
    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(begin: _prevColor, end: targetColor),
      duration: const Duration(milliseconds: 300),
      builder: (context, color, _) {
        final isDark = ThemeData.estimateBrightnessForColor(targetColor) == Brightness.dark;
        final theme = CupertinoTheme.of(context);
        final primaryColor = isDark ? CupertinoColors.white : CupertinoColors.black;

        return CupertinoTheme(
          data: theme.copyWith(
            primaryColor: primaryColor,
            textTheme: theme.textTheme.copyWith(
              navTitleTextStyle: theme.textTheme.navTitleTextStyle.copyWith(color: primaryColor.withAlpha(200)),
            ),
          ),
          child: CupertinoNavigationBar(
            leading: const Icon(CupertinoIcons.back),
            middle: targetColor == CupertinoColors.transparent ? null : const Text('Стратегия роста RUB'),
            trailing: const Icon(CupertinoIcons.share),
            enableBackgroundFilterBlur: false,
            backgroundColor: color,
          ),
        );
      },
    );
  }
}
