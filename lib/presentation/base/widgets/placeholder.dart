import 'package:flutter/material.dart';

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
    final theme = Theme.of(context);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: theme.colorScheme.surfaceVariant,
      ),
      child: expand ? const Expanded(child: SizedBox()) : null,
    );
  }
}
