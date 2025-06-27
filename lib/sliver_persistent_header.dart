import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SliverTop extends StatelessWidget {
  const SliverTop({required Widget child, required double minExtent, required double maxExtent, super.key})
    : _child = child,
      _minExtent = minExtent,
      _maxExtent = maxExtent;

  final Widget _child;
  final double _minExtent;
  final double _maxExtent;

  @override
  Widget build(BuildContext context) => _SliverTop(minExtent: _minExtent, maxExtent: _maxExtent, child: _child);
}

class _SliverTop extends SingleChildRenderObjectWidget {
  const _SliverTop({required super.child, required double minExtent, required double maxExtent})
    : _minExtent = minExtent,
      _maxExtent = maxExtent;

  final double _minExtent;
  final double _maxExtent;

  @override
  _RenderSliverTop createRenderObject(BuildContext context) =>
      _RenderSliverTop(minExtent: _minExtent, maxExtent: _maxExtent);

  @override
  void updateRenderObject(BuildContext context, covariant _RenderSliverTop renderObject) {
    renderObject
      .._minExtent = _minExtent
      .._maxExtent = _maxExtent;
  }
}

class _RenderSliverTop extends RenderSliverSingleBoxAdapter {
  _RenderSliverTop({required double minExtent, required double maxExtent})
    : _minExtent = minExtent,
      _maxExtent = maxExtent;

  double _minExtent;
  double _maxExtent;

  @override
  void paint(PaintingContext context, Offset offset) {
    final height = geometry!.paintExtent;
    final rect = offset & Size(constraints.crossAxisExtent, height);
    context.canvas.drawRect(rect, Paint()..color = Colors.redAccent.shade100);

    final textPainter = TextPainter(
      text: TextSpan(
        text: 'offset: $offset \n\n $geometry \n\n  ${constraints.toString()} ',
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 15,
    )..layout(maxWidth: rect.width);

    textPainter.paint(context.canvas, const Offset(0, 600));

    if (child != null && geometry!.visible) {
      context.paintChild(child!, offset);
    }
  }

  @override
  void performLayout() {
    if (child == null) {
      geometry = SliverGeometry.zero;
      return;
    }

    final constraints = this.constraints;
    final maxExtent = _maxExtent;

    child!.layout(constraints.asBoxConstraints(maxExtent: _maxExtent), parentUsesSize: true);

    final childExtent = _maxExtent;

    final double effectiveRemainingPaintExtent = math.max(0, constraints.remainingPaintExtent - constraints.overlap);
    final paintExtent = math.min(childExtent, effectiveRemainingPaintExtent);

    geometry = SliverGeometry(
      scrollExtent: maxExtent,

      paintOrigin: constraints.overlap,
      paintExtent: paintExtent,

      // layoutExtent: math.min(10, paintExtent),
      maxPaintExtent: maxExtent,

      // cacheExtent: layoutExtent > 0.0 ? -constraints.cacheOrigin + layoutExtent : layoutExtent,
      // hasVisualOverflow: true,
    );
    // print(' paintExtent: math.min(childExtent, effectiveRemainingPaintExtent),');
    // print('geometry: $geometry');

    setChildParentData(child!, constraints, geometry!);
  }
}
