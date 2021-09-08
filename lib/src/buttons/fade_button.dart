import 'package:flutter/widgets.dart';

class FadeButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;

  const FadeButton({
    Key? key,
    required this.child,
    required this.onPressed,
  }) : super(key: key);

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

  void setTextTransparent() {
    _controller.value = 0.6;
  }

  void setTextSolid() {
    _controller.animateTo(1.0, duration: _fadeOutDuration);
  }

  @override
  Widget build(BuildContext context) {
    Widget result = Semantics(
      button: true,
      child: GestureDetector(
        onTap: widget.onPressed,
        onTapDown: ((_) => setTextTransparent()),
        onTapUp: ((_) => setTextSolid()),
        onTapCancel: setTextSolid,
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
