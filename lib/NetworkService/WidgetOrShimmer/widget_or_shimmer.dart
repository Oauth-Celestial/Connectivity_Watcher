import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class WidgetOrShimmer extends StatelessWidget {
  final bool showShimmer;
  Color? shimmerBaseColor;
  Color? shimmerHighlightColor;
  final Widget child;
  WidgetOrShimmer(
      {required this.showShimmer,
      required this.child,
      this.shimmerBaseColor,
      this.shimmerHighlightColor});

  @override
  Widget build(BuildContext context) {
    return showShimmer
        ? Shimmer.fromColors(
            baseColor: shimmerBaseColor ?? Colors.red,
            highlightColor: shimmerHighlightColor ?? Colors.yellow,
            child: child)
        : child;
  }
}
