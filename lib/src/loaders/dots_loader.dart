import "dart:math" as math;

import 'package:flutter/widgets.dart';

class DotsLoader extends StatefulWidget {
  /// Defines loading dots color.
  ///
  /// Defaults to `accent` color.
  final Color color;

  /// Loading dots scale.
  ///
  /// Default to `1.0`.
  final double scale;

  const DotsLoader({
    this.color,
    this.scale = 1.0,
  });

  @override
  _DotsLoaderState createState() => _DotsLoaderState();
}

class _DotsLoaderState extends State<DotsLoader>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  static const _basicIndicatorSize = 8.0;
  static const _basicSpaceBetweenDots = 5.0;
  static const _basicDotsOffsets = 3.75;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();

    super.initState();
  }

  static final _dotsCurve = CurveTween(curve: Curves.easeInOut);

  static final _dotsRotationTween =
      Tween(begin: 0.0, end: math.pi).chain(_dotsCurve);

  @override
  Widget build(BuildContext context) {
    final indicatorDotSize = _basicIndicatorSize * widget.scale;
    final spaceBetweenDots = _basicSpaceBetweenDots * widget.scale;
    final dotsOffset = _basicDotsOffsets * widget.scale;
    final widgetHeight = 2 * indicatorDotSize + spaceBetweenDots;

    return AnimatedBuilder(
      animation: _controller,
      child: Container(
        height: indicatorDotSize,
        width: indicatorDotSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.color,
        ),
      ),
      builder: (BuildContext context, Widget child) {
        double value1 = (_controller.value * 2).clamp(0.0, 1.0);
        bool isDot1Visible = value1 < 1.0;

        double value2 = ((_controller.value - 0.5) * 2.0).clamp(0.0, 1.0);
        bool isDot2Visible = value1 == 1.0;

        return SizedBox(
          height: widgetHeight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Transform.translate(
                offset: Offset(dotsOffset, 0.0),
                child: Transform.rotate(
                  angle: _dotsRotationTween.transform(value1),
                  child: Row(
                    children: [
                      Opacity(
                        child: child,
                        opacity: isDot1Visible ? 1.0 : 0.0,
                      ),
                      SizedBox(width: spaceBetweenDots),
                      child,
                    ],
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(-dotsOffset, 0.0),
                child: Transform.rotate(
                  angle: _dotsRotationTween.transform(value2),
                  child: Row(
                    children: [
                      Opacity(
                        child: child,
                        opacity: isDot2Visible ? 1.0 : 0.0,
                      ),
                      SizedBox(width: spaceBetweenDots),
                      child,
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
