import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

typedef IsScrolledWidgetBuilder = Widget Function(
  BuildContext context,
  ScrollController controller,
  IsScrolledState state,
);

class IsScrolledState {
  final bool isScrolled;
  final bool hasMoreToScroll;

  IsScrolledState({
    required this.isScrolled,
    required this.hasMoreToScroll,
  });
}

/// Widget that provides information on whether the scrollable is
/// scrolled more than a given [offset] or has more than
/// [offset] to scroll.
class IsScrolled extends StatefulWidget {
  /// Widget builder
  final IsScrolledWidgetBuilder builder;

  /// The scroll controller on wich the IsScrolled logic is based on.
  ///
  /// If external controller is not provided,
  /// it will be automatically by this widget created.
  ///
  /// This controller needs to be assigned to the scrollable
  /// of our interest.
  ///
  /// If supplied externally (as an argument), it must be removed
  /// by the provider.
  final ScrollController? controller;

  /// The distance the user needs to scroll the scrollable to change the
  /// _isScrolled_ or _hasMoreToScroll_ values.
  final double offset;

  const IsScrolled({
    Key? key,
    required this.builder,
    this.controller,
    this.offset = 1,
  }) : super(key: key);

  @override
  State<IsScrolled> createState() => _IsScrolledState2();
}

class _IsScrolledState2 extends State<IsScrolled> {
  var _state = IsScrolledState(
    hasMoreToScroll: true,
    isScrolled: false,
  );

  ScrollController? _controller;
  ScrollController get controller {
    return widget.controller ?? _controller!;
  }

  @override
  void didUpdateWidget(covariant IsScrolled oldWidget) {
    if (oldWidget.controller != widget.controller) {
      if (widget.controller == null) {
        _createController();
      } else if (oldWidget.controller == null) {
        _disposeController();
      }
    }

    super.didUpdateWidget(oldWidget);
  }

  void _createController() {
    if (_controller != null) {
      throw StateError(
        'Cannot create the controller, '
        'ScrollController is already created.',
      );
    }

    _controller = ScrollController()..addListener(_onControllerUpdate);

    /// Call the update method immediately after assigning a new controller.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _onControllerUpdate();
    });
  }

  void _disposeController() {
    if (_controller == null) {
      throw StateError(
        'Cannot dispose the controller, '
        'ScrollController was not created.',
      );
    }

    _controller!
      ..removeListener(_onControllerUpdate)
      ..dispose();
    _controller = null;
  }

  @override
  void initState() {
    super.initState();

    if (widget.controller == null) {
      _createController();
    }
  }

  void _onControllerUpdate() {
    _onMetricsChanged(controller.position);
  }

  void _onMetricsChanged(ScrollMetrics metrics) {
    final isScrolled = metrics.extentBefore > widget.offset;
    final hasMoreToScroll = metrics.extentAfter > 0;

    final hasChange = hasMoreToScroll != _state.hasMoreToScroll ||
        isScrolled != _state.isScrolled;

    if (hasChange) {
      setState(() {
        _state = IsScrolledState(
          isScrolled: isScrolled,
          hasMoreToScroll: hasMoreToScroll,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, controller, _state);
  }

  @override
  void dispose() {
    if (_controller != null) {
      _disposeController();
    }

    super.dispose();
  }
}
