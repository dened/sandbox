import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sandbox/three_state_app_bar/generated/author_widget.dart';
import 'package:sandbox/three_state_app_bar/generated/growth_chart.dart';
import 'package:sandbox/three_state_app_bar/generated/portfolio_widget.dart';
import 'package:sandbox/three_state_app_bar/generated/risk_level_widget.dart';
import 'package:sandbox/three_state_app_bar/generated/strategy_card.dart';
import 'package:sandbox/three_state_app_bar/generated/try_button.dart';
import 'package:sandbox/three_state_app_bar/sliver_fill_overscroll.dart';
import 'package:sandbox/three_state_app_bar/sliver_position_notifier.dart';
import 'package:sandbox/three_state_app_bar/sliver_position_provider.dart';
import 'package:sandbox/three_state_app_bar/strategy_header_delegate.dart';
import 'package:sandbox/three_state_app_bar/zero_size_toolbar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => CupertinoApp(
    theme: CupertinoTheme.of(context).copyWith(brightness: Brightness.light, primaryColor: Colors.white),
    home: Scaffold(body: SliverPositionProvider(child: CollapsingList())),
  );
}

class AnimatedNavBarColor extends StatefulWidget {
  const AnimatedNavBarColor({required this.value, super.key});
  final int value;

  @override
  State<AnimatedNavBarColor> createState() => _AnimatedNavBarColorState();
}

class _AnimatedNavBarColorState extends State<AnimatedNavBarColor> {
  Color _prevColor = Colors.transparent;

  Color _getColor(int value) {
    if (value > 480) return Colors.transparent;
    if (value > 70) return const Color.fromARGB(255, 74, 70, 9);

    return Colors.white;
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
        final primaryColor = isDark ? Colors.white : Colors.black;

        return CupertinoTheme(
          data: theme.copyWith(
            primaryColor: primaryColor,
            textTheme: theme.textTheme.copyWith(
              navTitleTextStyle: theme.textTheme.navTitleTextStyle.copyWith(color: primaryColor.withAlpha(200)),
            ),
          ),
          child: CupertinoNavigationBar(
            leading: const Icon(CupertinoIcons.back),
            middle: targetColor == Colors.transparent ? null : const Text('Стратегия роста RUB'),
            trailing: const Icon(CupertinoIcons.share),
            enableBackgroundFilterBlur: false,
            backgroundColor: color,
          ),
        );
      },
    );
  }
}

class CollapsingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) => CustomScrollView(
    slivers: <Widget>[
      const SliverFillOverscroll(color: Color.fromARGB(255, 23, 22, 20)),
      ZeroSizeToolbar(
        height: kToolbarHeight + MediaQuery.of(context).padding.top,
        child: AnimatedNavBarColor(value: SliverPositionProvider.of(context).getPosition('light') ?? 0),
      ),

      const SliverPositionNotifier(tag: 'dark', child: GrowthChart()),

      const SliverPositionNotifier(tag: 'light', child: StrategyCard()),

      SliverPersistentHeader(pinned: true, delegate: StrategyHeaderDelegate()),
      SliverList.list(
        children: [
          const StrategyParameterCard(),
          const AuthorWidget(),
          const PortfolioWidget(),
          const RiskLevelWidget(),
          TryButton(onPressed: () {}),
        ],
      ),
    ],
  );

  List<Widget> generateColoredBoxList({required int count, double height = 300}) => List.generate(
    count,
    (index) => SliverToBoxAdapter(
      child: Container(
        height: height,
        color: Colors.primaries[index % Colors.primaries.length],
        alignment: Alignment.center,
        // child: Text('index: $index'),
      ),
    ),
  );
}
