import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class _FlexibleSliverPersistentHeaderLeaf
    extends SingleChildRenderObjectWidget {
  const _FlexibleSliverPersistentHeaderLeaf({
    required super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderFlexibleSliverPersistentHeaderLeaf(
        showOnScreenConfiguration:
            const PersistentHeaderShowOnScreenConfiguration(),
      );
}

class _RenderFlexibleSliverPersistentHeaderLeaf
    extends RenderSliverFloatingPersistentHeader {
  _RenderFlexibleSliverPersistentHeaderLeaf(
      {required super.showOnScreenConfiguration});

  @override
  double get maxExtent =>
      child!.getMaxIntrinsicHeight(constraints.crossAxisExtent);
  @override
  double get minExtent => 0;
}

class FlexibleSliverPersistentHeader extends StatelessWidget {
  const FlexibleSliverPersistentHeader({
    super.key,
    required this.child,
    this.backgroudColor,
    this.padding,
  });

  final Widget child;
  final Color? backgroudColor;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return _FlexibleSliverPersistentHeaderLeaf(
      child: Container(
        decoration: BoxDecoration(
          color: backgroudColor,
        ),
        padding: padding,
        clipBehavior: Clip.hardEdge,
        child: OverflowBox(
          maxHeight: double.infinity,
          alignment: Alignment.bottomCenter,
          child: child,
        ),
      ),
    );
  }
}
