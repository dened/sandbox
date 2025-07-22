import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Scaffold;
import 'package:sandbox/three_state_app_bar/animation_navigation_bar.dart';
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
    theme: CupertinoTheme.of(context).copyWith(brightness: Brightness.light, primaryColor: CupertinoColors.white),
    home: Scaffold(
      body: SliverPositionProvider(child: CollapsingList()),
    ),
  );
}

class CollapsingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) => CustomScrollView(
    slivers: <Widget>[
      const SliverFillOverscroll(color: Color(0xFF171614)),
      ZeroSizeToolbar(
        height: kNavBarPersistentHeight + MediaQuery.of(context).padding.top,
        child: AnimatedNavBarColor(value: SliverPositionProvider.of(context).getPosition('light') ?? 0),
      ),

      const SliverToBoxAdapter(child: GrowthChart()),

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
}
