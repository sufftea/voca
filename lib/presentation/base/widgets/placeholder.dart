import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:voca/presentation/base/base_theme.dart';

class PlaceholderCard extends StatelessWidget {
  const PlaceholderCard({
    this.width,
    this.height,
    this.expand = false,
    super.key,
  });

  final double? width, height;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: BaseColors.black10,
      ),
      child: expand ? const Expanded(child: SizedBox()) : null,
    );
  }
}
