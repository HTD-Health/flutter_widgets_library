import 'dart:core';
import 'dart:math';

import 'package:flutter/material.dart';

class CheckLoader extends StatefulWidget {
  final double size;
  final VoidCallback onCompleteAnimation;
  final double strokeWidth;
  final Color backgroundColor;

  final Color lineColor;

  /// By default 1s
  final Duration duration;

  /// Update [isCompleted] to true to show check animation
  /// otherwise it will be in in loading state
  final bool isCompleted;

  const CheckLoader({
    this.size = 48,
    this.onCompleteAnimation,
    this.isCompleted = false,
    this.strokeWidth = 3,
    this.backgroundColor = Colors.transparent,
    this.lineColor = Colors.green,
    this.duration,
  });

  @override
  _CheckLoaderState createState() => _CheckLoaderState();
}

class _CheckLoaderState extends State<CheckLoader> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _curve;
  bool isLoading = false;
  
  bool get isAnimationCompleted => _controller.status == AnimationStatus.completed;
  bool get isLoadingAnimationCompleted => !widget.isCompleted;
  bool get isCheckAnimationCompleted => widget.onCompleteAnimation != null;
  bool get isAnimationModeChanged => isLoading != !widget.isCompleted;

  @override
  void initState() {
    super.initState();
    updateIsLoadingState();
    _controller = AnimationController(duration: widget.duration ?? const Duration(seconds: 1), vsync: this);
    _curve = CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine);

    _controller.addListener(() {
      setState(() {});
      if (isAnimationCompleted) {
        onCompletedAnimation();
      }
    });

    _controller.forward();
  }

  void updateIsLoadingState() {
    isLoading = !widget.isCompleted;
  }

  void onCompletedAnimation() {
    if (isAnimationModeChanged) {
      updateIsLoadingState();
      restartAnimation();
    }
    if (isLoadingAnimationCompleted) {
      onLoadingAnimationCompleted();
    } else if (isCheckAnimationCompleted) {
      onCheckAnimationCompleted();
    }
  }

  void onCheckAnimationCompleted() {
    widget.onCompleteAnimation();
  }

  void onLoadingAnimationCompleted() {
    restartAnimation();
  }

  void restartAnimation() {
    _controller.reset();
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant CheckLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isCompleted != widget.isCompleted) {
      if (isAnimationCompleted) {
        updateIsLoadingState();
        restartAnimation();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.size,
      width: widget.size,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(360),
      ),
      child: CustomPaint(
        painter: CheckPainter(
          value: _curve.value,
          strokeWidth: widget.strokeWidth,
          lineColor: widget.lineColor,
          backgroundColor: widget.backgroundColor,
          loading: isLoading,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class CheckPainter extends CustomPainter {
  Paint _paint;
  double value;
  bool loading;

  double _length;
  double _offset;
  double _startingAngle;

  Color lineColor;
  Color backgroundColor;

  CheckPainter({
    @required this.value,
    double strokeWidth = 12.0,
    double length = 60,
    this.backgroundColor,
    @required this.lineColor,
    this.loading = true,
  }) {
    _paint = Paint()
      ..color = backgroundColor ?? const Color(0xFF2DCBCB)
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    _offset = 0;
    _length = length;
    _startingAngle = 205;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Background canvas
    final rect = const Offset(0, 0) & size;
    _paint.color = backgroundColor ?? const Color(0xFF2DCBCB);

    final double line1x1 = size.width / 2 + size.width * cos(Angle.degrees(_startingAngle).radians) * .5;
    final double line1y1 = size.height / 2 + size.height * sin(Angle.degrees(_startingAngle).radians) * .5;

    final double line1x2 = size.width * .45;
    final double line1y2 = size.height * .65;

    final double line2x1 = size.width / 2 + size.width * cos(const Angle.degrees(320).radians) * .35;
    final double line2y1 = size.height / 2 + size.height * sin(const Angle.degrees(320).radians) * .35;

    // animation painter

    double circleValue, checkValue;
    if (value < .5) {
      checkValue = 0;
      circleValue = value / .5;
    } else {
      checkValue = (value - .5) / .5;
      circleValue = 1;
    }

    _paint.color = lineColor;
    final double firstAngle = _startingAngle + 360 * circleValue;
    setOffset(firstAngle, _length, _startingAngle + 360);
    if (loading) {
      canvas.drawArc(
          rect, Angle.degrees(360 * value + _startingAngle).radians, const Angle.degrees(80).radians, false, _paint);
    } else {
      canvas.drawArc(
        rect,
        Angle.degrees(_startingAngle).radians,
        Angle.degrees(firstAngle + value * 120 - _startingAngle).radians,
        false,
        _paint,
      );

      double line1Value = 0, line2Value = 0, line1x2Value = 0;
      if (circleValue >= 1) {
        if (checkValue < .5) {
          line2Value = 0;
          line1x2Value = getMin(checkValue * 7, 1);
          line1Value = checkValue / .5;
        } else {
          line2Value = (checkValue - .5) / .5;
          line1x2Value = 1;
          line1Value = 1;
        }
      }
      double auxLine1x1 = (line1x2 - line1x1) * getMin(line1Value, .75);
      double auxLine1y1 = ((auxLine1x1 - line1x1) / (line1x2 - line1x1)) * (line1y2 - line1y1) + line1y1;

      if (_offset < _length || auxLine1x1 < line1x1 || auxLine1y1 < line1y1) {
        auxLine1x1 = line1x1;
        auxLine1y1 = line1y1;
      }

      //SECOND
      double auxLine1x2 = auxLine1x1 + size.width / 2;
      double auxLine1y2 =
          (((auxLine1x1 + size.width / 2) - line1x1) / (line1x2 - line1x1)) * (line1y2 - line1y1) + line1y1;

      if (checkIfPointHasCrossedLine(
          Offset(line1x2, line1y2), Offset(line2x1, line2y1), Offset(auxLine1x2, auxLine1y2))) {
        auxLine1x2 = (line1x2) * getMax(line1x2Value, 0.1);
        auxLine1y2 = ((auxLine1x2 - line1x2) / (line1x2 - line1x1)) * (line1y2 - line1y1) + line1y2;
      }
      if (_offset > 0) {
        canvas.drawLine(Offset(auxLine1x1, auxLine1y1), Offset(auxLine1x2, auxLine1y2), _paint);
      }

      // SECOND LINE

      double auxLine2x1 = (line2x1 - line1x2) * line2Value;
      double auxLine2y1 =
          ((((line2x1 - line1x2) * line2Value) - line1x2) / (line2x1 - line1x2)) * (line2y1 - line1y2) + line1y2;

      if (checkIfPointHasCrossedLine(
          Offset(line1x1, line1y1), Offset(line1x2, line1y2), Offset(auxLine2x1, auxLine2y1))) {
        auxLine2x1 = line1x2;
        auxLine2y1 = line1y2;
      }

      if (line2Value > 0.3) {
        canvas.drawLine(
            Offset(auxLine2x1, auxLine2y1),
            Offset(
                (line2x1 - line1x2) * line2Value + size.width * .35,
                ((((line2x1 - line1x2) * line2Value + size.width * .35) - line1x2) / (line2x1 - line1x2)) *
                        (line2y1 - line1y2) +
                    line1y2),
            _paint);
      }
    }
  }

  double getMax(double x, double y) {
    return (x > y) ? x : y;
  }

  double getMin(double x, double y) {
    return (x > y) ? y : x;
  }

  bool checkIfPointHasCrossedLine(Offset a, Offset b, Offset point) {
    return ((b.dx - a.dx) * (point.dy - a.dy) - (b.dy - a.dy) * (point.dx - a.dx)) > 0;
  }

  void setOffset(double angle, double plus, double max) {
    if (angle + plus > max) {
      _offset = angle + plus - max;
    } else {
      _offset = 0;
    }
  }

  @override
  bool shouldRepaint(CheckPainter old) {
    return old.value != value;
  }
}

class Angle {
  final double _storage;

  /// Create an angle defined by degrees.
  /// One full turn equals 360 degrees.
  const Angle.degrees(final double degrees) : _storage = degrees / 180.0 * pi;

  double get radians => _storage;
}
