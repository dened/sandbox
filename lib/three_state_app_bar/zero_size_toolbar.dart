import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// A sliver that provides a zero size toolbar, useful for creating a pinned header with no visible height.
class ZeroSizeToolbar extends SingleChildRenderObjectWidget {
  const ZeroSizeToolbar({required this.height, super.key, super.child});

  final double height;

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderSliverZeroSizePinnedPersistentHeader(height);

  @override
  void updateRenderObject(BuildContext context, covariant RenderObject renderObject) {
    if (renderObject is _RenderSliverZeroSizePinnedPersistentHeader) {
      renderObject.height = height;
    }
  }
}

class _RenderSliverZeroSizePinnedPersistentHeader extends RenderSliverPinnedPersistentHeader {
  _RenderSliverZeroSizePinnedPersistentHeader(double height) : _height = height;

  double _height;
  double get height => _height;
  set height(double value) {
    if (_height == value) {
      return;
    }
    _height = value;
    markNeedsLayout();
  }

  @override
  double get maxExtent => _height;

  @override
  double get minExtent => _height;

  @override
  void performLayout() {
    super.performLayout();
    geometry = geometry?.copyWith(layoutExtent: 0, scrollExtent: 0);
  }
}
