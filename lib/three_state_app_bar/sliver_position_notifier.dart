import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:sandbox/three_state_app_bar/sliver_position_provider.dart';

/// A widget that notifies its position in a sliver context.
class SliverPositionNotifier extends StatefulWidget {
  const SliverPositionNotifier({required this.tag, required this.child, super.key});

  final Object tag;

  final Widget child;

  @override
  State<SliverPositionNotifier> createState() => _SliverPositionNotifierState();
}

class _SliverPositionNotifierState extends State<SliverPositionNotifier> with SingleTickerProviderStateMixin {
  var _lastPostion = 0;
  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();

    _ticker = createTicker(_onTick);
  }

  @override
  void dispose() {
    _ticker
      ..stop(canceled: true)
      ..dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      _SliverPosition(onPositionChanged: _onPositionChanged, child: widget.child);

  void _onPositionChanged(int newPosition) {
    if (newPosition != _lastPostion) {
      _lastPostion = newPosition;

      if (!_ticker.isActive) {
        _ticker.start();
      }
    } else {
      _ticker.stop();
    }
  }

  void _onTick(Duration _) {
    SliverPositionProvider.updateOf(context, widget.tag, _lastPostion);
    _ticker.stop();
  }
}

class _SliverPosition extends SingleChildRenderObjectWidget {
  const _SliverPosition({required this.onPositionChanged, required super.child});

  final OnPositionChanged onPositionChanged;

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderSliverPosition(onProgressChanged: onPositionChanged);

  @override
  void updateRenderObject(BuildContext context, _RenderSliverPosition renderObject) {
    renderObject.onPositionChanged = onPositionChanged;
  }
}

typedef OnPositionChanged = void Function(int newPosition);

class _RenderSliverPosition extends RenderSliverToBoxAdapter {
  _RenderSliverPosition({required OnPositionChanged onProgressChanged}) : _onProgressChanged = onProgressChanged;

  int? _currentMainAxisPosition;

  OnPositionChanged _onProgressChanged;

  OnPositionChanged get onPositionChanged => _onProgressChanged;
  set onPositionChanged(OnPositionChanged value) {
    if (_onProgressChanged == value) {
      return;
    }
    _onProgressChanged = value;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    super.performLayout();
    _updatePosition();
  }

  void _updatePosition() {
    final newPos =
        (constraints.viewportMainAxisExtent - constraints.remainingPaintExtent - constraints.scrollOffset).truncate();
    if (_currentMainAxisPosition != newPos) {
      _currentMainAxisPosition = newPos;
      onPositionChanged(newPos);
    }
  }
}
