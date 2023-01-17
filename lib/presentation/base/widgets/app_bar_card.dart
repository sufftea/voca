import 'package:flutter/widgets.dart';
import 'package:voca/presentation/base/base_theme.dart';

class AppBarCard extends StatelessWidget {
  const AppBarCard({
    this.child,
    super.key,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: BaseColors.white,
        boxShadow: [
          BoxShadow(
            color: BaseColors.black10,
            blurRadius: 10,
          ),
        ],
      ),
      child: child,
    );
  }
}
