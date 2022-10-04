import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'sliver_fill_viewport_app_bar_delegate.dart';
export 'sliver_fill_viewport_app_bar_delegate.dart';

class FillViewportSliverList extends StatefulWidget {
  final List<Widget> slivers;
  final double minHeight;
  final ScrollController? controller;
  final Widget child;

  static const defaultHeaderHeight = 280.0;

  const FillViewportSliverList({
    Key? key,
    required this.slivers,
    this.controller,
    this.minHeight = defaultHeaderHeight,
    required this.child,
  }) : super(key: key);
  @override
  _FillViewportSliverListState createState() => _FillViewportSliverListState();
}

class _FillViewportSliverListState extends State<FillViewportSliverList> {
  double _maxExtent = 0.0;
  void setMaxExtent(double value) {
    if (value > _maxExtent) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _maxExtent = value;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: widget.controller,
      slivers: <Widget>[
        SliverPersistentHeader(
          pinned: false,
          delegate: SliverFillViewportAppBarDelegate(
            minHeight: widget.minHeight,
            heightDiff: _maxExtent,
            paddingTop: MediaQuery.of(context).padding.top,
            child: widget.child,
          ),
        ),

        ...widget.slivers,

        /// Measure viewport height
        SliverLayoutBuilder(
          builder: (context, constraints) {
            final double remainingSpace = constraints.viewportMainAxisExtent -
                constraints.precedingScrollExtent;

            setMaxExtent(remainingSpace);

            return const SliverIgnorePointer(
              sliver: SliverPadding(
                padding: EdgeInsets.zero,
              ),
            );
          },
        ),
      ],
    );
  }
}
