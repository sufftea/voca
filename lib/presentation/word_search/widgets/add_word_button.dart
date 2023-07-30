import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AddWordButton extends StatefulWidget {
  const AddWordButton({
    required this.onAddWord,
    required this.isAdded,
    super.key,
  });

  final bool isAdded;
  final AsyncCallback onAddWord;

  @override
  State<AddWordButton> createState() => _AddWordButtonState();
}

class _AddWordButtonState extends State<AddWordButton> {
  bool isLoading = false;
  late ThemeData theme = Theme.of(context);

  @override
  Widget build(BuildContext context) {
    late final Widget? child;

    if (widget.isAdded) {
      child = null;
    } else if (isLoading) {
      child = SizedBox(
        height: 32,
        width: 32,
        child: CircularProgressIndicator(
          color: theme.colorScheme.secondary,
        ),
      );
    } else {
      child = IconButton(
        onPressed: onPressed,
        style: ButtonStyle(
          foregroundColor:
              MaterialStatePropertyAll(theme.colorScheme.secondary),
          padding: const MaterialStatePropertyAll(EdgeInsets.all(0)),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          iconSize: const MaterialStatePropertyAll(32),
          fixedSize: const MaterialStatePropertyAll(Size.square(48)),
          // visualDensity: const VisualDensity(horizontal: 0, vertical: 0),
        ),
        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        icon: const Icon(
          Icons.add_rounded,
          // size: 20,
        ),
      );
    }

    return SizedBox(
      width: 64,
      child: Center(child: child),
    );
  }

  void onPressed() async {
    setState(() {
      isLoading = true;
    });

    await widget.onAddWord();

    setState(() {
      isLoading = false;
    });
  }
}
