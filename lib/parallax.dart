import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(home: Scaffold(body: CollapsingList()));
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({required this.minHeight, required this.maxHeight, required this.child});
  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => SizedBox.expand(child: child);

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) =>
      maxHeight != oldDelegate.maxHeight || minHeight != oldDelegate.minHeight || child != oldDelegate.child;
}

class CollapsingList extends StatelessWidget {
  // SliverPersistentHeader makeHeader(String headerText) => MySliverPersistentHeader(
  //   pinned: true,
  //   delegate: _SliverAppBarDelegate(
  //     minHeight: 60,
  //     maxHeight: 200,
  //     child: Container(color: Colors.lightBlue, child: Center(child: Text(headerText))),
  //   ),
  // );

  @override
  Widget build(BuildContext context) => ScrollConfiguration(
    behavior: ScrollConfiguration.of(context).copyWith(platform: TargetPlatform.iOS),
    child: ColoredBox(
      color: Colors.tealAccent,
      child: CustomScrollView(
        cacheExtent: 0,
        slivers: <Widget>[
          // SliverAppBar(
          //   backgroundColor: Colors.white12,

          //   expandedHeight: 150,
          //   flexibleSpace: const FlexibleSpaceBar(title: Text('Available seats')),
          //   actions: <Widget>[
          //     IconButton(
          //       icon: const Icon(Icons.add_circle),
          //       tooltip: 'Add new entry',
          //       onPressed: () {
          //         /* ... */
          //       },
          //     ),
          //   ],
          //   pinned: true,
          //   // floating: true,
          // ),
          ...List.generate(
            5,
            (index) => MySliverToBoxAdapter(
              child: Container(
                height: 250,
                color: Colors.primaries[index % Colors.primaries.length],
                alignment: Alignment.center,
                child: Text('index: $index'),
              ),
            ),
          ),
          // const StretchingSliverHeader(
          //   minExtent: 50,
          //   maxExtent: 250,
          //   child: Center(child: Text('StretchingSliverHeader')),
          // ),
          // makeHeader('Header Section 1'),
          // // SliverGrid.count(
          // //   crossAxisCount: 3,
          // //   children: [
          // //     Container(color: Colors.red, height: 150),
          // //     Container(color: Colors.purple, height: 150),
          // //     Container(color: Colors.green, height: 150),
          // //     Container(color: Colors.orange, height: 150),
          // //     Container(color: Colors.yellow, height: 150),
          // //     Container(color: Colors.pink, height: 150),
          // //     Container(color: Colors.cyan, height: 150),
          // //     Container(color: Colors.indigo, height: 150),
          // //     Container(color: Colors.blue, height: 150),
          // //   ],
          // // ),
          // SliverList(
          //   delegate: SliverChildListDelegate([
          //     Container(color: Colors.pink, height: 150),
          //     Container(color: Colors.cyan, height: 150),
          //     Container(color: Colors.indigo, height: 150),
          //     Container(color: Colors.blue, height: 150),
          //   ]),
          // ),
          // makeHeader('Header Section 2'),
          // // SliverFixedExtentList(
          // //   itemExtent: 150,
          // //   delegate: SliverChildListDelegate([
          // //     Container(color: Colors.red),
          // //     Container(color: Colors.purple),
          // //     Container(color: Colors.green),
          // //     Container(color: Colors.orange),
          // //     Container(color: Colors.yellow),
          // //   ]),
          // // ),
          // SliverList(
          //   delegate: SliverChildListDelegate([
          //     Container(color: Colors.pink, height: 150),
          //     Container(color: Colors.cyan, height: 150),
          //     Container(color: Colors.indigo, height: 150),
          //     Container(color: Colors.blue, height: 150),
          //   ]),
          // ),
          // makeHeader('Header Section 3'),
          // // SliverGrid(
          // //   gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          // //     maxCrossAxisExtent: 200,
          // //     mainAxisSpacing: 10,
          // //     crossAxisSpacing: 10,
          // //     childAspectRatio: 4,
          // //   ),
          // //   delegate: SliverChildBuilderDelegate(
          // //     (context, index) => Container(
          // //       alignment: Alignment.center,
          // //       color: Colors.teal[100 * (index % 9)],
          // //       child: Text('grid item $index'),
          // //     ),
          // //     childCount: 20,
          // //   ),
          // // ),
          // SliverList(
          //   delegate: SliverChildListDelegate([
          //     Container(color: Colors.pink, height: 150),
          //     Container(color: Colors.cyan, height: 150),
          //     Container(color: Colors.indigo, height: 150),
          //     Container(color: Colors.blue, height: 150),
          //   ]),
          // ),
          // makeHeader('Header Section 4'),
          // // Yes, this could also be a SliverFixedExtentList. Writing
          // // this way just for an example of SliverList construction.
          // SliverList(
          //   delegate: SliverChildListDelegate([
          //     Container(color: Colors.pink, height: 150),
          //     Container(color: Colors.cyan, height: 150),
          //     Container(color: Colors.indigo, height: 150),
          //     Container(color: Colors.blue, height: 150),
          //   ]),
          // ),
          // SliverColoredBox(color: Colors.red),
          // SliverColoredBox(color: Colors.green),
          // SliverColoredBox(color: Colors.blue),
          // SliverColoredBox(color: Colors.orange),
          // SliverColoredBox(color: Colors.purple),
          // SliverColoredBox(color: Colors.blue),
          // SliverColoredBox(color: Colors.orange),
          // SliverColoredBox(color: Colors.purple),
          // SliverZoomingBox(minHeight: 150, maxHeight: 300, color: Colors.red),
          // SliverZoomingBox(minHeight: 150, maxHeight: 300, color: Colors.green),
          // SliverZoomingBox(minHeight: 150, maxHeight: 300, color: Colors.blue),
          // SliverZoomingBox(minHeight: 150, maxHeight: 300, color: Colors.orange),
          // SliverZoomingBox(minHeight: 150, maxHeight: 300, color: Colors.purple),
          // SliverZoomingBox(minHeight: 150, maxHeight: 300, color: Colors.blue),
          // SliverZoomingBox(minHeight: 150, maxHeight: 300, color: Colors.orange),
          // SliverZoomingBox(minHeight: 150, maxHeight: 300, color: Colors.purple),
          ...List.generate(
            5,
            (index) => SliverToBoxAdapter(
              child: Container(
                height: 150,
                color: Colors.primaries[index % Colors.primaries.length],
                alignment: Alignment.center,
                child: Text('index: $index'),
              ),
            ),
          ),
          const StretchingSliverHeader(
            minExtent: 50,
            maxExtent: 100,
            child: Center(child: Text('StretchingSliverHeader')),
          ),

          // sl.SliverPersistentHeader(
          //   minExtent: 50,
          //   maxExtent: 100,
          //   child: Container(color: Colors.purpleAccent, alignment: Alignment.center, child: const Text('center')),
          // ),
          // ...List.generate(
          //   50,
          //   (index) =>
          //   // SliverZoomingBox(color: Colors.primaries[index % Colors.primaries.length], minHeight: 80, maxHeight: 160),
          //   SliverToBoxAdapter(
          //     child: Container(
          //       height: 100,
          //       color: Colors.primaries[index % Colors.primaries.length],
          //       alignment: Alignment.center,
          //     ),
          //   ),
          // ),
          // sl.SliverTop(
          //   minExtent: 50,
          //   maxExtent: 100,
          //   child: Container(color: Colors.purpleAccent, alignment: Alignment.center, child: const Text('center')),
          // ),
          // ...List.generate(
          //   5,
          //   (index) =>
          //       SliverZoomingBox(color: Colors.primaries[index % Colors.primaries.length], minHeight: 80, maxHeight: 160),
          // ),
          // const StretchingSliverHeader(
          //   minExtent: 150,
          //   maxExtent: 250,
          //   child: Center(child: Text('StretchingSliverHeader')),
          // ),

          // //: 150, maxExtent: 250),
          // ...List.generate(
          //   5,
          //   (index) =>
          //       SliverZoomingBox(color: Colors.primaries[index % Colors.primaries.length], minHeight: 80, maxHeight: 160),
          // ),

          // sl.SliverTop(
          //   minExtent: 50,
          //   maxExtent: 100,
          //   child: Container(color: Colors.purpleAccent, alignment: Alignment.center, child: const Text('center')),
          // ),
          // ...List.generate(
          //   15,
          //   (index) =>
          //       SliverZoomingBox(color: Colors.primaries[index % Colors.primaries.length], minHeight: 80, maxHeight: 160),
          // ),
          // const ExpandSliverWidget(),
        ],
      ),
    ),
  );
}

class MySliverToBoxAdapter extends SingleChildRenderObjectWidget {
  /// Creates a sliver that contains a single box widget.
  const MySliverToBoxAdapter({super.key, super.child});

  @override
  MyRenderSliverToBoxAdapter createRenderObject(BuildContext context) => MyRenderSliverToBoxAdapter();
}

class MyRenderSliverToBoxAdapter extends RenderSliverSingleBoxAdapter {
  /// Creates a [RenderSliver] that wraps a [RenderBox].
  MyRenderSliverToBoxAdapter({super.child});
  final maxExtent = 150.0;
  final minExtent = 50.0;

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    final childParentData = child!.parentData! as SliverPhysicalParentData;
    final textPainter = TextPainter(
      text: TextSpan(
        text: '$offset\n\n${childParentData.paintOffset}\n\n$constraints',
        style: const TextStyle(color: Colors.black, backgroundColor: Colors.white54, fontSize: 12),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 15,
      ellipsis: '...',
    )..layout(maxWidth: constraints.crossAxisExtent);

    textPainter.paint(context.canvas, offset + childParentData.paintOffset);
  }

  @override
  void performLayout() {
    if (child == null) {
      geometry = SliverGeometry.zero;
      return;
    }
    final constraints = this.constraints;
    child!.layout(constraints.asBoxConstraints(maxExtent: maxExtent), parentUsesSize: true);
    final childExtent = switch (constraints.axis) {
      Axis.horizontal => child!.size.width,
      Axis.vertical => child!.size.height,
    };
    final paintedChildSize = calculatePaintOffset(constraints, from: 0, to: childExtent);
    final cacheExtent = calculateCacheOffset(constraints, from: 0, to: childExtent);

    assert(paintedChildSize.isFinite);
    assert(paintedChildSize >= 0.0);
    geometry = SliverGeometry(
      scrollExtent: childExtent,
      paintExtent: paintedChildSize,
      cacheExtent: cacheExtent,
      maxPaintExtent: childExtent,
      hitTestExtent: paintedChildSize,
      hasVisualOverflow: childExtent > constraints.remainingPaintExtent || constraints.scrollOffset > 0.0,
    );
    setChildParentData(child!, constraints, geometry!);
  }
}

/// Start StretchingSliverHeader
///

class StretchingSliverHeader extends SingleChildRenderObjectWidget {
  const StretchingSliverHeader({required super.child, required double minExtent, required double maxExtent, super.key})
    : _minExtent = minExtent,
      _maxExtent = maxExtent;

  final double _minExtent;
  final double _maxExtent;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      RenderStretchingSliverHeader(minExtent: _minExtent, maxExtent: _maxExtent);

  @override
  void updateRenderObject(BuildContext context, covariant RenderStretchingSliverHeader renderObject) {
    renderObject
      .._minExtent = _minExtent
      .._maxExtent = _maxExtent;
  }
}

class RenderStretchingSliverHeader extends RenderSliverSingleBoxAdapter {
  RenderStretchingSliverHeader({required double minExtent, required double maxExtent})
    : _minExtent = minExtent,
      _maxExtent = maxExtent;

  double _minExtent;
  double _maxExtent;

  @override
  void attach(PipelineOwner owner) {
    // TODO: implement attach
    super.attach(owner);
    print('RenderStretchingSliverHeader is attached');
  }

  @override
  void detach() {
    // TODO: implement detach
    super.detach();
    print('RenderStretchingSliverHeader is detached');
  }

  @override
  void performLayout() {
    if (child != null) {
      final scrollOffset = constraints.scrollOffset;

      final childExtent = _maxExtent;

      final double effectiveRemainingPaintExtent = math.max(0, constraints.remainingPaintExtent - constraints.overlap);
      final paintExtent = math.min(_maxExtent, effectiveRemainingPaintExtent);

      child!.layout(constraints.asBoxConstraints(maxExtent: _maxExtent), parentUsesSize: true);
      final layoutExtent =
          (_maxExtent - constraints.scrollOffset).clamp(0, constraints.remainingPaintExtent).toDouble();
      if (paintExtent < layoutExtent) {
        print('paintExtent < layoutExtent: $paintExtent < $layoutExtent');
        print('constraints.overlap: ${constraints.overlap}');
        print('constraints.remainingPaintExtent: ${constraints.remainingPaintExtent}');
      }

      geometry = SliverGeometry(
        scrollExtent: 10000,
        paintOrigin: constraints.overlap,
        paintExtent: paintExtent,
        layoutExtent: layoutExtent,
        // maxPaintExtent: _maxExtent,
        maxPaintExtent: 500,
        hasVisualOverflow: false,
      );

      if (geometry!.paintOrigin + geometry!.paintExtent > constraints.remainingPaintExtent) {
        print('geometry!.paintOrigin + geometry!.paintExtent > constraints.remainingPaintExtent');
        print('${geometry!.paintOrigin} + ${geometry!.paintExtent} > ${constraints.remainingPaintExtent}');
      }

      setChildParentData(child!, constraints, geometry!);
    } else {
      geometry = SliverGeometry.zero;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final rect = offset & Size(constraints.crossAxisExtent, geometry!.paintExtent);

    context.canvas.drawRect(rect, Paint()..color = Colors.limeAccent);

    if (child != null && geometry!.visible) {
      context.paintChild(child!, offset);
    }

    final textPainter = TextPainter(
      text: TextSpan(
        text: '$offset\n\n${geometry?.toInfoString()}\n\n$constraints',
        style: const TextStyle(color: Colors.black, backgroundColor: Colors.white54, fontSize: 12),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 15,
      ellipsis: '...',
    )..layout(maxWidth: rect.width);

    textPainter.paint(context.canvas, const Offset(0, 400));
  }
}

extension on SliverGeometry {
  String toInfoString() =>
      'SliverGeometry(scrollExtent: $scrollExtent,paintExtent: $paintExtent,paintOrigin: $paintOrigin,layoutExtent: $layoutExtent,maxPaintExtent: $maxPaintExtent,maxScrollObstructionExtent: $maxScrollObstructionExtent,crossAxisExtent: $crossAxisExtent,hitTestExtent: $hitTestExtent,visible: $visible,hasVisualOverflow: $hasVisualOverflow,cacheExtent: $cacheExtent,)';
}

///
/// End StretchingSliverHeader
///

class ExpandSliverWidget extends LeafRenderObjectWidget {
  const ExpandSliverWidget({super.key});

  @override
  RenderObject createRenderObject(BuildContext context) => ExpandSliver();
}

class ExpandSliver extends RenderSliver {
  @override
  void performLayout() {
    final remainingPaintExtent = constraints.remainingPaintExtent;
    final viewportMainAxisExtent = constraints.viewportMainAxisExtent;
    final paintExtent = calculatePaintOffset(constraints, from: 0, to: viewportMainAxisExtent);
    geometry = SliverGeometry(
      scrollExtent: viewportMainAxisExtent,
      paintExtent: paintExtent,
      maxPaintExtent: viewportMainAxisExtent,
      hasVisualOverflow: true,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final rect = offset & Size(constraints.crossAxisExtent, geometry?.paintExtent ?? 0);
    context.canvas.drawRect(rect, Paint()..color = Colors.red);

    //     // Для отладки — отрисуем высоту
    // final textPainter = TextPainter(
    //   text: TextSpan(
    //     text: 'h: ${height.toStringAsFixed(0)}, offset: $offset, ${constraints.toString()} ',
    //     style: const TextStyle(color: Colors.black, fontSize: 12),
    //   ),
    //   textDirection: TextDirection.ltr,
    //   maxLines: 8,
    // )..layout(maxWidth: rect.width);

    // textPainter.paint(context.canvas, rect.center - Offset(textPainter.width / 2, textPainter.height / 2));

    final textPainter = TextPainter(
      text: TextSpan(
        text: 'h: ${rect.height}, offset: $offset, ${constraints.toString()} ',
        style: const TextStyle(color: Colors.black, fontSize: 12),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 3,
    )..layout(maxWidth: rect.width);
    textPainter.paint(context.canvas, rect.center - Offset(textPainter.width / 2, textPainter.height / 2));
  }
}

class SliverZoomingBox extends LeafRenderObjectWidget {
  const SliverZoomingBox({required this.minHeight, required this.maxHeight, required this.color, super.key});

  final double minHeight;
  final double maxHeight;
  final Color color;

  @override
  RenderSliverZoomingBox createRenderObject(BuildContext context) =>
      RenderSliverZoomingBox(minHeight: minHeight, maxHeight: maxHeight, color: color);

  @override
  void updateRenderObject(BuildContext context, covariant RenderSliverZoomingBox renderObject) {
    renderObject
      ..minHeight = minHeight
      ..maxHeight = maxHeight
      ..color = color;
  }
}

class RenderSliverZoomingBox extends RenderSliver {
  RenderSliverZoomingBox({required double minHeight, required double maxHeight, required Color color})
    : _minHeight = minHeight,
      _maxHeight = maxHeight,
      _color = color;

  double _minHeight;
  set minHeight(double value) {
    if (_minHeight == value) return;
    _minHeight = value;
    markNeedsLayout();
  }

  double _maxHeight;
  set maxHeight(double value) {
    if (_maxHeight == value) return;
    _maxHeight = value;
    markNeedsLayout();
  }

  Color _color;
  set color(Color value) {
    if (_color == value) return;
    _color = value;
    markNeedsPaint();
  }

  @override
  void performLayout() {
    // final double itemOffset = constraints.precedingScrollExtent;
    // final double scrollOffset = constraints.scrollOffset;
    // final double viewportExtent = constraints.viewportMainAxisExtent;

    // final double relativeOffset = itemOffset - scrollOffset;
    // final double center = viewportExtent / 2;

    // double distanceFromCenter = (relativeOffset - center).abs();
    // double t = 1.0 - (distanceFromCenter / center);
    // t = t.clamp(0.0, 1.0);

    // final double height = lerpDouble(_minHeight, _maxHeight, t)!;

    // final double paintExtent = calculatePaintOffset(constraints, from: 0.0, to: height);

    // geometry = SliverGeometry(
    //   scrollExtent: height,
    //   paintExtent: paintExtent,
    //   maxPaintExtent: _maxHeight,
    //   hasVisualOverflow: paintExtent < height,
    // );

    final itemOffset = constraints.remainingPaintExtent - _maxHeight / 2;
    final scrollOffset = constraints.scrollOffset;
    final viewportExtent = constraints.viewportMainAxisExtent;

    // Где находится верх элемента относительно видимой области
    final relativeOffset = itemOffset - scrollOffset;

    // Центр вьюпорта
    final center = viewportExtent / 2;

    // t = близость к центру
    final t = (1.0 - ((relativeOffset - center).abs() / center)).clamp(0.0, 1.0);

    final height = lerpDouble(_maxHeight, _maxHeight, t)!;

    final paintExtent = calculatePaintOffset(constraints, from: 0, to: height);
    final cacheExtent = calculateCacheOffset(constraints, from: 0, to: height);

    // 👇 Вот тут теперь scrollExtent зависит от того, насколько мы близки к центру
    geometry = SliverGeometry(
      scrollExtent: height,
      paintExtent: paintExtent,
      cacheExtent: cacheExtent,
      maxPaintExtent: _maxHeight,
      hasVisualOverflow: paintExtent < height,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final height = geometry!.paintExtent;

    final paint = Paint()..color = _color;
    final rect = offset & Size(constraints.crossAxisExtent, height);
    context.canvas.drawRect(rect, paint);

    // Для отладки — отрисуем высоту
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'h: ${height.toStringAsFixed(0)}, offset: $offset, ${constraints.toString()} ',
        style: const TextStyle(color: Colors.black, fontSize: 12),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 8,
    )..layout(maxWidth: rect.width);

    // textPainter.paint(context.canvas, rect.center - Offset(textPainter.width / 2, textPainter.height / 2));
  }
}
//
//
//
//
//
//
//
//
//
//
//
//
//
//

//
//
//
class ParallaxScene extends StatefulWidget {
  const ParallaxScene({super.key});

  @override
  State<ParallaxScene> createState() => _ParallaxSceneState();
}

class _ParallaxSceneState extends State<ParallaxScene> {
  final ScrollController _scrollController = ScrollController();
  double scrollOffset = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: CustomScrollView(
      // scrollDirection: Axis.horizontal,
      slivers: [
        const SliverAppBar.large(title: Text('Parallax Scroll')),
        SliverFixedExtentList.builder(
          itemBuilder: (context, index) => ColoredBox(color: _randomColor()),
          itemExtent: 150,
        ),
      ],
    ),
  );

  final _random = math.Random();
  Color _randomColor() => Color.fromARGB(255, _random.nextInt(256), _random.nextInt(256), _random.nextInt(256));
}

class ParallaxLayer extends StatelessWidget {
  const ParallaxLayer({
    required this.scrollOffset,
    required this.depth,
    required this.color,
    required this.label,
    super.key,
  });
  final double scrollOffset;
  final double depth;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) => Positioned.fill(
    child: Transform.translate(
      offset: Offset(-scrollOffset * depth, 0),
      child: Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.symmetric(vertical: 16 * (1 - depth)),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [color.withOpacity(0.7), color],
          ),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10 * depth, offset: Offset(0, 5 * depth))],
        ),
        child: Stack(
          children: [
            // Декоративные элементы в зависимости от слоя
            if (label == 'Горы') ...[
              _buildMountains(),
            ] else if (label == 'Деревья') ...[
              _buildTrees(),
            ] else if (label == 'Цветы') ...[
              _buildFlowers(),
            ],
            // Текстовая метка
            Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 48,
                  color: Colors.white,
                  shadows: [Shadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2))],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _buildMountains() => Positioned.fill(child: CustomPaint(painter: _MountainPainter(color: color)));

  Widget _buildTrees() => Positioned.fill(child: CustomPaint(painter: _TreesPainter(color: color)));

  Widget _buildFlowers() => Positioned.fill(child: CustomPaint(painter: _FlowersPainter(color: color)));
}
// ...existing code...

class _MountainPainter extends CustomPainter {
  _MountainPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color.withOpacity(0.7);
    final path =
        Path()
          ..moveTo(0, size.height)
          ..lineTo(size.width * 0.2, size.height * 0.6)
          ..lineTo(size.width * 0.4, size.height * 0.8)
          ..lineTo(size.width * 0.6, size.height * 0.5)
          ..lineTo(size.width * 0.8, size.height * 0.7)
          ..lineTo(size.width, size.height * 0.4)
          ..lineTo(size.width, size.height)
          ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _MountainPainter oldDelegate) => oldDelegate.color != color;
}

class _TreesPainter extends CustomPainter {
  _TreesPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final trunkPaint = Paint()..color = Colors.brown.shade700;
    final leavesPaint = Paint()..color = color.withOpacity(0.8);

    for (var x = size.width * 0.1; x < size.width; x += size.width * 0.2) {
      // Draw trunk
      canvas.drawRect(Rect.fromLTWH(x, size.height * 0.7, size.width * 0.03, size.height * 0.15), trunkPaint);
      // Draw leaves
      canvas.drawCircle(Offset(x + size.width * 0.015, size.height * 0.7), size.width * 0.05, leavesPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _TreesPainter oldDelegate) => oldDelegate.color != color;
}

class _FlowersPainter extends CustomPainter {
  _FlowersPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final stemPaint =
        Paint()
          ..color = Colors.green.shade700
          ..strokeWidth = 2;
    final flowerPaint = Paint()..color = color.withOpacity(0.9);

    for (var x = size.width * 0.1; x < size.width; x += size.width * 0.15) {
      // Draw stem
      canvas.drawLine(Offset(x, size.height * 0.95), Offset(x, size.height * 0.85), stemPaint);
      // Draw flower
      canvas.drawCircle(Offset(x, size.height * 0.84), size.width * 0.015, flowerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _FlowersPainter oldDelegate) => oldDelegate.color != color;
}
