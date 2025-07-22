import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// A sliver that fills the overscroll area with a specified color.
class SliverFillOverscroll extends LeafRenderObjectWidget {
  const SliverFillOverscroll({required this.color, super.key});
  final Color color;

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderSliverOverflowFill(color);

  @override
  void updateRenderObject(BuildContext context, covariant RenderObject renderObject) {
    if (renderObject is _RenderSliverOverflowFill) {
      renderObject.color = color;
    }
  }
}

class _RenderSliverOverflowFill extends RenderSliver {
  _RenderSliverOverflowFill(Color color) : _color = color;

  Color _color;
  Color get color => _color;
  set color(Color value) {
    if (_color == value) {
      return;
    }
    _color = value;
    markNeedsPaint();
  }

  @override
  void performLayout() {
    geometry = SliverGeometry(visible: constraints.overlap < 0);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (constraints.overlap < 0) {
      final rect = offset & Size(constraints.crossAxisExtent, constraints.overlap);
      context.canvas.drawRect(rect, Paint()..color = color);
    }
  }
}
