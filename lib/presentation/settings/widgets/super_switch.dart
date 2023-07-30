// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class SuperSwitch extends StatefulWidget {
  const SuperSwitch({
    required this.onTap,
    required this.value,
    super.key,
  });

  final bool value;
  final VoidCallback onTap;

  final width = 60.0;
  final height = 28.0;
  final padding = 6.0;
  final shadowSize = 2.0;

  @override
  State<SuperSwitch> createState() => _SuperSwitchState();
}

class _SuperSwitchState extends State<SuperSwitch>
    with SingleTickerProviderStateMixin {
  late final animCtrl = AnimationController(
    vsync: this,
    duration: const Duration(
      milliseconds: 700,
    ),
  );

  late Animation<double> mainCurve;

  Animation<double> createMainCurve(bool value) {
    return animCtrl.drive(
      Tween(begin: value ? 1.0 : 0.0, end: value ? 0.0 : 1.0).chain(
        CurveTween(curve: Curves.elasticOut),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    mainCurve = createMainCurve(widget.value);
  }

  @override
  void didUpdateWidget(covariant SuperSwitch old) {
    super.didUpdateWidget(old);

    if (old.value != widget.value) {
      mainCurve = createMainCurve(!widget.value);

      animCtrl.reset();
      animCtrl.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          shape: const StadiumBorder(side: BorderSide.none),
          shadows: [
            BoxShadow(
              color: Colors.white,
              blurRadius: widget.shadowSize,
              blurStyle: BlurStyle.normal,
              offset: Offset(0, widget.shadowSize),
            ),
            BoxShadow(
              color: Colors.black,
              blurRadius: widget.shadowSize,
              blurStyle: BlurStyle.normal,
              offset: Offset(0, -widget.shadowSize),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            buildBackground(),
            buildCelestial(),
          ],
        ),
      ),
    );
  }

  Widget buildBackground() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: mainCurve,
        builder: (context, child) {
          return CustomPaint(
            foregroundPainter: BgPainter(mainCurve.value),
          );
        },
      ),
    );
  }

  Widget buildCelestial() {
    const glowColor = Colors.white10;
    final size = widget.height - widget.padding * 2;
    final glowExtent = size * 0.35;

    final slideAnim = mainCurve.drive(Tween(
      begin: widget.padding,
      end: widget.width - widget.padding - size,
    ));

    return AnimatedBuilder(
      animation: mainCurve,
      builder: (context, child) {
        return Positioned(
          left: slideAnim.value,
          top: widget.padding,
          height: size,
          width: size,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              shape: StadiumBorder(),
              shadows: [
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(
                    widget.shadowSize * 2,
                    widget.shadowSize * 2,
                  ),
                  blurRadius: widget.shadowSize * 2,
                ),
                BoxShadow(
                  color: glowColor,
                  blurStyle: BlurStyle.solid,
                  spreadRadius: glowExtent,
                ),
                BoxShadow(
                  color: glowColor,
                  blurStyle: BlurStyle.solid,
                  spreadRadius: glowExtent * 2,
                ),
                BoxShadow(
                  color: glowColor,
                  blurStyle: BlurStyle.solid,
                  spreadRadius: glowExtent * 3,
                ),
              ],
            ),
            child: CustomPaint(
              isComplex: true,
              painter: CelestialPainter(
                animValue: mainCurve.value,
                shadowSize: widget.shadowSize,
              ),
            ),
          ),
        );
      },
    );
  }
}

class BgPainter extends CustomPainter {
  BgPainter(this.animValue);

  final double animValue;

  final skyColorTween = ColorTween(
    begin: Colors.blue,
    end: Colors.grey.shade900,
  );

  final starkColorTween = ColorTween(
    begin: Colors.blue,
    end: Colors.white,
  );

  @override
  bool shouldRepaint(BgPainter oldDelegate) {
    return animValue != oldDelegate.animValue;
  }

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final skyPaint = Paint()..color = skyColorTween.transform(animValue)!;

    canvas.drawRect(
      Rect.largest,
      skyPaint,
    );

    _drawClouds(canvas, size);

    _drawStars(canvas, size);
  }

  void _drawClouds(Canvas canvas, ui.Size size) {
    final w = size.width;
    final h = size.height;
    final slideOffset = Offset(0, h * animValue);

    final lightCloudsPath = Path()
      ..addOval(Rect.fromCircle(
        center: Offset(0.3 * w, 1.1 * h) + slideOffset,
        radius: 0.3 * h,
      ))
      ..addOval(Rect.fromCircle(
        center: Offset(0.5 * w, 1.15 * h) + slideOffset,
        radius: 0.5 * h,
      ))
      ..addOval(Rect.fromCircle(
        center: Offset(0.65 * w, 1 * h) + slideOffset,
        radius: 0.45 * h,
      ))
      ..addOval(Rect.fromCircle(
        center: Offset(0.80 * w, 1 * h) + slideOffset,
        radius: 0.5 * h,
      ))
      ..addOval(Rect.fromCircle(
        center: Offset(0.9 * w, 0.4 * h) + slideOffset,
        radius: 0.3 * h,
      ))
      ..addOval(Rect.fromCircle(
        center: Offset(0.8 * w, 0.5 * h) + slideOffset,
        radius: 0.2 * h,
      ));

    final lightCloudPaint = Paint()..color = Colors.white30;
    canvas.drawPath(lightCloudsPath, lightCloudPaint);

    final cloudsPath = Path()
      ..addOval(Rect.fromCircle(
        center: Offset(0.35 * w, 1.1 * h) + slideOffset,
        radius: 0.2 * h,
      ))
      ..addOval(Rect.fromCircle(
        center: Offset(0.5 * w, 1.3 * h) + slideOffset,
        radius: 0.5 * h,
      ))
      ..addOval(Rect.fromCircle(
        center: Offset(0.70 * w, 1.2 * h) + slideOffset,
        radius: 0.45 * h,
      ))
      ..addOval(Rect.fromCircle(
        center: Offset(1 * w, 1.05 * h) + slideOffset,
        radius: 0.7 * h,
      ));

    final cloudsPaint = Paint()..color = Colors.white;
    canvas.drawPath(
      cloudsPath,
      cloudsPaint,
    );
  }

  void _drawStars(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final starTreck = Path()
      ..addOval(Rect.fromCircle(
        center: Offset(w * 0.1, h * 0.2),
        radius: w * 0.01,
      ))
      ..addOval(Rect.fromCircle(
        center: Offset(w * 0.4, h * 0.3),
        radius: w * 0.02,
      ))
      ..addOval(Rect.fromCircle(
        center: Offset(w * 0.3, h * 0.6),
        radius: w * 0.015,
      ))
      ..addOval(Rect.fromCircle(
        center: Offset(w * 0.2, h * 0.5),
        radius: w * 0.025,
      ))
      ..addOval(Rect.fromCircle(
        center: Offset(w * 0.15, h * 0.75),
        radius: w * 0.01,
      ))
      ..addOval(Rect.fromCircle(
        center: Offset(w * 0.4, h * 0.8),
        radius: w * 0.01,
      ));

    final starPaint = Paint()
      ..color = starkColorTween.transform(animValue)!
      ..style = PaintingStyle.fill;

    canvas.drawPath(starTreck, starPaint);
  }
}

class CelestialPainter extends CustomPainter {
  const CelestialPainter({
    required this.animValue,
    required this.shadowSize,
  });

  final double animValue;
  final double shadowSize;

  @override
  bool shouldRepaint(CelestialPainter oldDelegate) {
    return animValue != oldDelegate.animValue ||
        shadowSize != oldDelegate.shadowSize;
  }

  @override
  void paint(Canvas canvas, Size size) {
    assert(size.height == size.width);
    final d = size.width;
    final highlightRatio = shadowSize * 4 / d;

    // CLIP CIRCLE
    final circlePath = Path()
      ..addOval(
        Rect.fromCircle(center: Offset(d / 2, d / 2), radius: d / 2),
      );
    canvas.clipPath(circlePath);

    _drawSun(canvas, d);

    _drawMoon(canvas, d);
  }

  void _drawMoon(Canvas canvas, double d) {
    final slideOffset = Offset((1 - animValue) * d, 0);

    final moonPaint = Paint()..color = Colors.blueGrey.shade200;

    canvas.drawCircle(
      Offset(d / 2, d / 2) + slideOffset,
      d / 2,
      moonPaint,
    );

    _drawCrater(
      canvas,
      Offset(d * 0.4, d * 0.6) + slideOffset,
      d * 0.17,
    );
    _drawCrater(
      canvas,
      Offset(d * 0.5, d * 0.3) + slideOffset,
      d * 0.1,
    );
    _drawCrater(
      canvas,
      Offset(d * 0.8, d * 0.5) + slideOffset,
      d * 0.07,
    );

    // CLIP CIRCLE
    final circlePath = Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(d / 2, d / 2) + slideOffset,
          radius: d / 2,
        ),
      );
    canvas.clipPath(circlePath);

    _drawHighlights(
      canvas,
      d,
      Offset(d / 2, d / 2) + slideOffset,
    );
  }

  void _drawCrater(Canvas canvas, Offset center, double radius) {
    final craterPaint = Paint()..color = Colors.blueGrey.shade500;

    canvas.drawCircle(
      center,
      radius,
      craterPaint,
    );
  }

  void _drawSun(ui.Canvas canvas, double d) {
    // DRAW SUN
    final yellowPaint = Paint()..color = Colors.yellow.shade700;

    canvas.drawCircle(
      Offset(d / 2, d / 2),
      d / 2,
      yellowPaint,
    );

    _drawHighlights(canvas, d, Offset(d / 2, d / 2));
  }

  void _drawHighlights(
    Canvas canvas,
    double d,
    Offset center,
  ) {
    // DRAW HIGHLIGHTS
    final highlightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadowSize)
      ..strokeWidth = shadowSize * 2
      ..color = Colors.white;
    final shadowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadowSize)
      ..strokeWidth = shadowSize
      ..color = Colors.black;

    canvas.drawCircle(
      center + Offset(shadowSize, shadowSize),
      d / 2 + shadowSize,
      highlightPaint,
    );
    canvas.drawCircle(
      center + Offset(-shadowSize, -shadowSize),
      d / 2 + shadowSize,
      shadowPaint,
    );
  }
}
