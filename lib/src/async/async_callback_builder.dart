import 'package:flutter/widgets.dart';

/// Asynchronous variant of [ValueGetter<T>].
typedef AsyncFutureRunner<T> = Future<T> Function();

/// Builder that passes three parameters:
/// 1. Current [BuildContext]
/// 2. [bool] indicating whether the runner Future is in progress or not.
/// 3. [VoidCallback] for starting the future from inside the builder.
typedef AsyncCallbackBuilderBuilder<T> = Widget Function(BuildContext, bool, VoidCallback);

typedef AsyncErrorHandler = void Function(dynamic, StackTrace);

/// A widget that encapsulates asynchronously running procedures with automatic state updates.
class AsyncCallbackBuilder<T> extends StatefulWidget {
  const AsyncCallbackBuilder({
    Key key,
    @required this.runner,
    @required this.builder,
    this.onError,
  }) : super(key: key);

  /// Asynchronous function to be passed to [builder] as callback. It will be available
  /// from [builder] as a third positional parameter.
  final AsyncFutureRunner<T> runner;

  /// A builder function for rendering some part of UI that needs to change depending on
  /// future state.
  final AsyncCallbackBuilderBuilder<T> builder;

  /// Optional error handler.
  final AsyncErrorHandler onError;

  @override
  _AsyncCallbackBuilderState createState() => _AsyncCallbackBuilderState<T>();
}

class _AsyncCallbackBuilderState<T> extends State<AsyncCallbackBuilder<T>> {
  bool _inProgress = false;

  void _runCallback() async {
    setState(() {
      _inProgress = true;
    });
    try {
      await widget.runner();
    } catch (exception, stack) {
      widget.onError?.call(exception, stack);
    }
    setState(() {
      _inProgress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _inProgress, _runCallback);
  }
}
