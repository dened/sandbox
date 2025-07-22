import 'package:flutter/widgets.dart';

/// A provider for sliver positions that allows widgets to access and update their position in a sliver context.
class SliverPositionProvider extends StatefulWidget {
  const SliverPositionProvider({required this.child, super.key});

  final Widget child;

  @override
  SliverPositionProviderState createState() => SliverPositionProviderState();

  static SliverPositionProviderState of(BuildContext context, {Object? aspect}) {
    final inherited = InheritedModel.inheritFrom<_SliverPositionInherited>(context, aspect: aspect);
    assert(inherited != null, 'SliverPositionProvider not found in context');
    return inherited!.state;
  }

  static void updateOf(BuildContext context, Object tag, int position) {
    final inherited = context.getInheritedWidgetOfExactType<_SliverPositionInherited>();
    assert(inherited != null, 'SliverPositionProvider not found in context');
    inherited!.state.updatePosition(tag, position);
  }
}

class SliverPositionProviderState extends State<SliverPositionProvider> {
  final Map<Object, int> _positions = {};

  void updatePosition(Object tag, int position) {
    setState(() {
      _positions[tag] = position;
    });
  }

  int? getPosition(Object tag) => _positions[tag];

  Map<Object, int> get positions => Map.unmodifiable(_positions);

  @override
  Widget build(BuildContext context) => _SliverPositionInherited(state: this, child: widget.child);
}

class _SliverPositionInherited extends InheritedModel<Object> {
  const _SliverPositionInherited({required this.state, required super.child,});

  final SliverPositionProviderState state;

  @override
  bool updateShouldNotify(covariant _SliverPositionInherited oldWidget) => oldWidget.state.positions != state.positions;

  @override
  bool updateShouldNotifyDependent(covariant _SliverPositionInherited oldWidget, Set<Object> aspects) {
    for (final aspect in aspects) {
      if (oldWidget.state.positions[aspect] != state.positions[aspect]) {
        return true;
      }
    }
    return false;
  }
}
