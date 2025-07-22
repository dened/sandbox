import 'package:flutter/cupertino.dart';

class StrategyHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 56;

  @override
  double get maxExtent => 56;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => SizedBox(
    height: minExtent,
    child: ColoredBox(
      color: CupertinoColors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            CupertinoButton.filled(
              color: CupertinoColors.black,

              sizeStyle: CupertinoButtonSize.medium,

              child: const Text(
                'Обзор стратегии',
                style: TextStyle(color: CupertinoColors.white, fontSize: 14, fontWeight: FontWeight.w500),
              ),
              onPressed: () {},
            ),
            const SizedBox(width: 16),

            DecoratedBox(
              decoration: BoxDecoration(
                color: CupertinoColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: CupertinoColors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CupertinoButton.filled(
                color: CupertinoColors.white,

                sizeStyle: CupertinoButtonSize.medium,

                child: const Text(
                  'Новости стратегии',
                  style: TextStyle(color: CupertinoColors.black, fontSize: 14, fontWeight: FontWeight.w500),
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    ),
  );

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}
