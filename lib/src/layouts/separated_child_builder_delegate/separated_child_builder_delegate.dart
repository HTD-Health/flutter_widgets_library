import 'dart:math' as math;

import 'package:flutter/material.dart';

class SeparatedChildBuilderDelegate extends SliverChildBuilderDelegate {
  SeparatedChildBuilderDelegate({
    required IndexedWidgetBuilder itemBuilder,
    required IndexedWidgetBuilder separatorBuilder,
    required int childCount,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    SemanticIndexCallback semanticIndexCallback = _semanticIndexCallback,
    int semanticIndexOffset = 0,
  }) : super(
          _getBuilder(
            itemBuilder: itemBuilder,
            separatorBuilder: separatorBuilder,
          ),
          childCount: _computeSemanticChildCount(childCount),
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
          semanticIndexCallback: semanticIndexCallback,
          semanticIndexOffset: semanticIndexOffset,
        );

  static IndexedWidgetBuilder _getBuilder({
    required IndexedWidgetBuilder itemBuilder,
    required IndexedWidgetBuilder separatorBuilder,
  }) =>
      (BuildContext context, int index) {
        final int itemIndex = index ~/ 2;
        final isSeparator = index.isOdd;
        return isSeparator
            ? separatorBuilder(context, itemIndex)
            : itemBuilder(context, itemIndex);
      };

  static int _computeSemanticChildCount(int childCount) =>
      math.max(0, childCount * 2 - 1);

  static int? _semanticIndexCallback(Widget widget, int localIndex) {
    // do not index separators
    return localIndex.isEven ? localIndex ~/ 2 : null;
  }
}
