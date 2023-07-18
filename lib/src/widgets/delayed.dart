import 'dart:async';

import 'package:flutter/widgets.dart';

/// Displays the provided widget after the given [duration].
class Delayed extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration animationDuration;
  final Curve curve;

  /// If it is set, the child is laid out in all states,
  /// only the visibility is changed.
  final bool maintainState;

  const Delayed({
    super.key,
    required this.child,
    required this.duration,
    this.maintainState = false,
    this.animationDuration = const Duration(milliseconds: 300),
    this.curve = Curves.linear,
  });

  @override
  State<Delayed> createState() => _DelayedState();
}

class _DelayedState extends State<Delayed> {
  bool _isVisible = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.duration, _show);
  }

  void _show() {
    setState(() {
      _isVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: widget.animationDuration,
      switchInCurve: widget.curve,
      child: widget.maintainState
          ? KeyedSubtree(
              key: ValueKey(_isVisible),
              child: Visibility(
                visible: _isVisible,
                maintainState: true,
                maintainSize: true,
                maintainAnimation: true,
                maintainInteractivity: false,
                maintainSemantics: false,
                child: widget.child,
              ),
            )
          : _isVisible
              ? widget.child
              : null,
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
