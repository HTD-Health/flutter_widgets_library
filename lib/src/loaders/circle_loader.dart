import 'dart:math';

import 'package:flutter/material.dart';

class CircleLoader extends StatefulWidget {
  final Color color;
  final double size;
  final double lineMinWidth;
  final double lineMaxWidth;
  final Duration duration;
  final AnimationController? controller;

  const CircleLoader({
    Key? key,
    this.color = Colors.white,
    this.size = 25.0,
    this.duration = const Duration(milliseconds: 1500),
    this.controller,
    this.lineMinWidth = 2.0,
    this.lineMaxWidth = 4.0,
  })  : assert(lineMinWidth > 0,
            'lineMinWidth cannot be less than or equal to 0.'),
        assert(lineMaxWidth >= lineMinWidth,
            'lineMaxWidth can\'t be thinner than lineMinWidth.'),
        super(key: key);

  @override
  _CircleLoaderState createState() => _CircleLoaderState();
}

class _CircleLoaderState extends State<CircleLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotatingAnimation,
      _circlePhaseAnimation,
      _circleProgressAnimation,
      _widthThicAnimation,
      _widthSkinnyAnimation;
  late double _lineWidthDifference;
  final phaseSwift = pi * 0.2;

  @override
  void initState() {
    super.initState();
    _lineWidthDifference = widget.lineMaxWidth - widget.lineMinWidth;
    _controller = (widget.controller ??
        AnimationController(vsync: this, duration: widget.duration))
      ..addListener(() => setState(() {}))
      ..repeat();
    _rotatingAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.decelerate)));
    _circlePhaseAnimation = Tween(begin: -2 / 3, end: 2 / 4).animate(
        CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.5, 1.0, curve: Curves.linear)));
    _circleProgressAnimation = Tween(begin: 0.05, end: 4 / 7).animate(
        CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 1.0, curve: SpinRingCurve())));
    _widthThicAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 0.8, curve: Curves.linear)));
    _widthSkinnyAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.8, 1.0, curve: Curves.linear)));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform(
        transform: Matrix4.identity()
          ..rotateZ((_rotatingAnimation.value) * 5 * pi / 6),
        alignment: FractionalOffset.center,
        child: SizedBox.fromSize(
          size: Size.square(widget.size),
          child: CustomPaint(
            foregroundPainter: CirclePainter(
              paintWidth: _widthThicAnimation.value * _lineWidthDifference -
                  _widthSkinnyAnimation.value * _lineWidthDifference +
                  widget.lineMinWidth,
              trackColor: widget.color,
              progressPercent: _circleProgressAnimation.value,
              startAngle: pi * _circlePhaseAnimation.value + phaseSwift,
            ),
          ),
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

class SpinRingCurve extends Curve {
  const SpinRingCurve();

  @override
  double transform(double t) => (t <= 0.5) ? 2 * t : 2 * (1 - t);
}

class CirclePainter extends CustomPainter {
  final double paintWidth;
  final Paint trackPaint;
  final Color trackColor;
  final double? progressPercent;
  final double? startAngle;

  CirclePainter({
    required this.paintWidth,
    this.progressPercent,
    this.startAngle,
    required this.trackColor,
  }) : trackPaint = Paint()
          ..color = trackColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = paintWidth
          ..strokeCap = StrokeCap.square;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (min(size.width, size.height) - paintWidth) / 2;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle!,
      2 * pi * progressPercent!,
      false,
      trackPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
