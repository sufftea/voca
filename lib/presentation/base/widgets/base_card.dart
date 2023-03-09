import 'package:flutter/material.dart';
import 'package:voca/presentation/base/base_theme.dart';

class BaseCard extends StatelessWidget {
  const BaseCard({
    this.padding = EdgeInsets.zero,
    this.borderSide = BorderSide.none,
    this.color,
    this.child,
    super.key,
  });

  final EdgeInsetsGeometry padding;
  final Widget? child;
  final BorderSide borderSide;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.zero,
      color: color ?? BaseColors.concrete,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: borderSide,
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
