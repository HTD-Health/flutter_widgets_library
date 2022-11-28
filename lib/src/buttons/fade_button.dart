import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class FadeButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final HitTestBehavior behavior;
  final Widget child;

  /// Determines opacity level invoked after on press action
  final double pressedOpacity;

  /// Determines opacity level during focus action
  final double focusedOpacity;

  final FocusNode? focusNode;

  const FadeButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.behavior = HitTestBehavior.opaque,
    this.pressedOpacity = 0.2,
    this.focusedOpacity = 0.6,
    this.focusNode,
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
  late bool _isFocused;
  bool _isHovered = false;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, value: 1.0)
      ..drive(_buttonTween)
      ..drive(_buttonCurveTween);
    _isFocused = widget.focusNode?.hasPrimaryFocus ?? false;
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

  final Map<Type, Action<Intent>>? _actions = {
    VoidCallbackIntent: CallbackAction<VoidCallbackIntent>(
      onInvoke: (intent) => intent.callback(),
    ),
  };

  late final Map<ShortcutActivator, Intent>? _shortcuts = {
    SingleActivator(LogicalKeyboardKey.enter): VoidCallbackIntent(() {
      widget.onPressed?.call();
    }),
  };

  @override
  Widget build(BuildContext context) {
    Widget result = Semantics(
      container: true,
      button: true,
      child: FocusableActionDetector(
        actions: _actions,
        shortcuts: _shortcuts,
        onShowFocusHighlight: (value) {
          setState(() {
            _isFocused = value;
          });
        },
        onShowHoverHighlight: (value) {
          setState(() {
            _isHovered = value;
          });
        },
        focusNode: widget.focusNode,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            behavior: widget.behavior,
            onTap: widget.onPressed,
            onTapDown: isEnabled ? (_) => _setTransparent() : null,
            onTapUp: isEnabled ? (_) => _setSolid() : null,
            onTapCancel: isEnabled ? _setSolid : null,
            child: AnimatedBuilder(
              animation: _controller,
              child: widget.child,
              builder: (BuildContext context, Widget? child) => Opacity(
                opacity: _isFocused || _isHovered
                    ? widget.focusedOpacity
                    : _controller.value,
                child: child,
              ),
            ),
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
