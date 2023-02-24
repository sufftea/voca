import 'package:flutter/widgets.dart';
import 'package:voca/presentation/base/base_theme.dart';

class AppBarCard extends StatelessWidget {
  const AppBarCard({
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.height,
    this.width,
    this.safeArea = true,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double? height;
  final double? width;
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: BaseColors.white,
        boxShadow: [
          BoxShadow(
            color: BaseColors.black10,
            blurRadius: 10,
          ),
        ],
      ),
      child: safeArea ? SafeArea(child: child) : child,
    );
  }
}
