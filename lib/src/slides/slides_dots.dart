import 'package:flutter/material.dart';

class SlidesDots extends StatelessWidget {
  static const _slideDotSpace = 18.0;
  static const _heightShrinkFactor = 0.35;

  final double dotWidth;
  final double dotHeight;
  final int count;
  final double cardWidth;
  final PageController controller;
  final Color color;

  const SlidesDots({
    @required @required this.count,
    @required this.controller,
    @required this.cardWidth,
    this.dotWidth = 16.0,
    this.dotHeight = 8.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final dotsColor = color ?? Colors.blue;

    return Center(
      child: Stack(
        fit: StackFit.loose,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              for (int i = 0; i < count; i++)
                SlideDot(
                  height: dotHeight,
                  width: dotWidth,
                  color: dotsColor,
                )
            ],
          ),
          AnimatedBuilder(
            animation: controller,
            builder: (BuildContext context, _) {
              double width = dotWidth;
              double height = dotHeight;
              double left = 0.0;
              double top = 0.0;
              if (controller.offset != null) {
                final progress = (controller.offset / cardWidth)
                    .clamp(0.0, (count - 1).toDouble());

                /// width
                final currentSlide = progress.round();
                final diff = ((progress - currentSlide) * 2.0).abs();
                width = dotWidth + (diff * _slideDotSpace);

                /// left
                left = progress * (_slideDotSpace + dotWidth / 2);

                /// top
                final heightDiff = diff * _heightShrinkFactor;
                final halfDotHeight = dotHeight * 0.5;
                top = halfDotHeight * heightDiff;

                /// height
                final invertedDiff = 1.0 - heightDiff;
                height = dotHeight * invertedDiff;
              }

              return Positioned(
                left: left,
                top: top,
                child: SlideDot(
                  color: dotsColor,
                  width: width,
                  height: height,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class SlideDot extends StatelessWidget {
  final Color color;
  final double width;
  final double height;

  const SlideDot({
    @required this.color,
    this.height = 8,
    this.width = 8,
  }) : assert(color != null, 'color can not be null');

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(height)),
        color: color,
      ),
    );
  }
}
