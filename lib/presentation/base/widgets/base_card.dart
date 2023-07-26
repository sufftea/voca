import 'package:flutter/material.dart';

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
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.zero,
      color: color ?? theme.colorScheme.surfaceVariant,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: borderSide,
      ),
      child: DefaultTextStyle(
        style: TextStyle(
          color: theme.colorScheme.onSurfaceVariant
        ),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
