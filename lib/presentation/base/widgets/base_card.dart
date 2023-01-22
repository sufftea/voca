import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:voca/presentation/base/base_theme.dart';

class BaseCard extends StatelessWidget {
  const BaseCard({
    this.padding = EdgeInsets.zero,
    this.child,
    super.key,
  });

  final EdgeInsetsGeometry padding;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: BaseColors.concrete,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
