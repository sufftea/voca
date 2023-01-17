import 'package:flutter/widgets.dart';
import 'package:voca/presentation/base/widgets/placeholder.dart';

class PlaceholderOr extends StatelessWidget {
  const PlaceholderOr({
    required this.real,
    this.placeholder = const PlaceholderCard(),
    super.key,
  });

  final Widget real;
  final Widget placeholder;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: 0,
          child: real,
        ),
        Positioned.fill(child: placeholder),
      ],
    );
  }
}
