import 'package:flutter/material.dart';

class SliverFillViewportAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverFillViewportAppBarDelegate({
    @required this.child,
    @required this.paddingTop,
    @required this.heightDiff,
    @required this.minHeight,
  });

  final double paddingTop;
  final double heightDiff;
  final double minHeight;
  final Widget child;

  @override
  double get minExtent => (minHeight + paddingTop).toDouble();

  @override
  double get maxExtent => (minExtent + heightDiff).toDouble();

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return LayoutBuilder(builder: (context, constraint) {
      return Container(
        alignment: Alignment.topCenter,
        constraints: const BoxConstraints.expand(),
        child: Padding(
          padding: EdgeInsets.only(top: paddingTop),
          child: child,
        ),
      );
    });
  }

  @override
  bool shouldRebuild(SliverFillViewportAppBarDelegate oldDelegate) {
    return true;
  }
}
