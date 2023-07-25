import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// TODO: remove this and use BaseStyles.appBarDecoration instead
class AppBarCard extends StatelessWidget {
  const AppBarCard({
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.height,
    this.width,
    this.safeArea = true,
    this.color,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double? height;
  final double? width;
  final bool safeArea;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      height: height,
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? theme.colorScheme.surfaceVariant,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow,
            blurRadius: 10,
          ),
        ],
      ),
      child: safeArea ? SafeArea(child: child) : child,
    );
  }
}
