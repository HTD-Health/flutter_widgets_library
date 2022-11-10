import 'package:flutter/widgets.dart';

class FadeButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;

  /// Determines opacity level invoked after on press action
  final double pressedOpacity;

  const FadeButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.pressedOpacity = 0.4,
  })  : assert(
          pressedOpacity >= 0.0 && pressedOpacity <= 1.0,
          'Pressed opacity value should be between 0.0 and 1.0',
        ),
        super(key: key);

  @override
  _FadeButtonState createState() => _FadeButtonState();
}

class _FadeButtonState extends State<FadeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  static final _buttonTween = Tween<double>(begin: 1.0);
  static final _buttonCurveTween = CurveTween(curve: Curves.decelerate);
  static const _fadeOutDuration = const Duration(milliseconds: 150);

  @override
  void initState() {
    _controller = AnimationController(vsync: this, value: 1.0)
      ..drive(_buttonTween)
      ..drive(_buttonCurveTween);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant FadeButton oldWidget) {
    if (oldWidget.onPressed != null && widget.onPressed == null) {
      /// a disabled widget should be in a solid state
      _setSolid();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _setTransparent() {
    _controller.value = widget.pressedOpacity;
  }

  void _setSolid() {
    _controller.animateTo(1.0, duration: _fadeOutDuration);
  }

  bool get isEnabled => widget.onPressed != null;

  @override
  Widget build(BuildContext context) {
    Widget result = Semantics(
      button: true,
      child: GestureDetector(
        onTap: widget.onPressed,
        onTapDown: isEnabled ? (_) => _setTransparent() : null,
        onTapUp: isEnabled ? (_) => _setSolid() : null,
        onTapCancel: isEnabled ? _setSolid : null,
        child: AnimatedBuilder(
          animation: _controller,
          child: widget.child,
          builder: (BuildContext context, Widget? child) => Opacity(
            opacity: _controller.value,
            child: child,
          ),
        ),
      ),
    );

    return result;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
