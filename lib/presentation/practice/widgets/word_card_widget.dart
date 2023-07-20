import 'dart:math';

import 'package:vector_math/vector_math_64.dart';

import 'package:flutter/material.dart';

class WordCardWidget extends StatefulWidget {
  const WordCardWidget({
    required this.front,
    required this.back,
    required this.flipped,
    super.key,
  });

  final Widget front;
  final Widget back;
  final bool flipped;

  @override
  State<WordCardWidget> createState() => _WordCardWidgetState();
}

class _WordCardWidgetState extends State<WordCardWidget>
    with TickerProviderStateMixin {
  late final AnimationController flipCtrl;
  late final flipAnim = CurveTween(curve: Curves.easeOut).animate(flipCtrl);

  @override
  void initState() {
    super.initState();

    flipCtrl = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(WordCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    switch ((oldWidget.flipped, widget.flipped)) {
      case (false, true):
        flipCtrl.forward();
      case (true, false):
        flipCtrl.reverse();
      default:
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, cons) {
      return AnimatedBuilder(
        animation: flipCtrl,
        builder: (context, child) {
          final zrot = Matrix4.identity()..rotateZ(pi / 16 * (1 - flipAnim.value));
          final yrot = Matrix4.identity()
            ..setEntry(3, 2, 0.001) // perspective
            ..rotateY(flipAnim.value * pi);
          final negzrot = Matrix4.identity()
            ..rotateZ(-pi / 16 * (1 - flipAnim.value));

          final rot = zrot * yrot * negzrot;

          return Transform(
            alignment: Alignment.center,
            transform: rot,
            child: switch (flipAnim.value) {
              < 0.5 => widget.front,
              _ => Transform.flip(
                  flipX: true,
                  child: widget.back,
                ),
            },
          );
        },
      );
    });
  }
}
