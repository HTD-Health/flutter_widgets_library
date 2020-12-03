import 'dart:math';

import 'package:flutter/widgets.dart';

class SpringLoader extends StatefulWidget {
  const SpringLoader({
    Key key,
    @required this.color,
    this.size = 35.0,
    this.duration = const Duration(milliseconds: 1500),
    this.controller,
    this.lineMinWidth = 1.6,
    this.lineMaxWidth = 5.0,
  })  : assert(color != null, 'Color can\'t be null.'),
        assert(lineMinWidth != null, 'lineMinWidth can\'t be null.'),
        assert(lineMaxWidth != null, 'lineMaxWidth can\'t be null.'),
        assert(lineMaxWidth >= lineMinWidth,
            'lineMaxWidth can\'t be thinner than lineMinWidth.'),
        assert(size != null, 'size can\'t be null.'),
        super(key: key);
  final Color color;
  final double size;
  final double lineMinWidth;
  final double lineMaxWidth;
  final Duration duration;
  final AnimationController controller;
  @override
  _SpringLoaderState createState() => _SpringLoaderState();
}

class _SpringLoaderState extends State<SpringLoader>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation1, _animation2;
  final double minProgressPercentage = 0.05;
  double widthSpan;
  @override
  void initState() {
    super.initState();
    widthSpan = widget.lineMaxWidth - widget.lineMinWidth;
    _controller = (widget.controller ??
        AnimationController(vsync: this, duration: widget.duration))
      ..addListener(() => setState(() {}))
      ..repeat(reverse: true);
    _animation1 = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn)));
    _animation2 = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.ease)));
  }

  @override
  Widget build(BuildContext context) {
    final firstAnimationProgressPercent = _animation1.value / 2.0 +
        minProgressPercentage -
        _animation1.value * minProgressPercentage;
    final secondAnimationProgressPercent =
        _animation2.value / 2.0 - _animation2.value * minProgressPercentage;
    final paintWidth = widget.lineMaxWidth -
        widthSpan * (_animation1.value) +
        widthSpan * (_animation2.value);
    final footholdAngle =
        pi + _animation2.value * (pi - pi * 2 * minProgressPercentage);
    return Center(
      child: SizedBox.fromSize(
        size: Size.square(widget.size),
        child: CustomPaint(
          foregroundPainter: SemiRingPainter(
            paintWidth: paintWidth,
            trackColor: widget.color,
            progressPercent:
                firstAnimationProgressPercent - secondAnimationProgressPercent,
            startAngle: footholdAngle,
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

class SemiRingPainter extends CustomPainter {
  SemiRingPainter({
    this.paintWidth,
    this.progressPercent,
    this.startAngle,
    this.trackColor,
  }) : trackPaint = Paint()
          ..color = trackColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = paintWidth
          ..strokeCap = StrokeCap.square;
  final double paintWidth;
  final Paint trackPaint;
  final Color trackColor;
  final double progressPercent;
  final double startAngle;
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 1.5);
    final radius = (min(size.width, size.height * 2) - paintWidth) / 2;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      2 * pi * progressPercent,
      false,
      trackPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
