import 'package:flutter/material.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';

class MySearchBar extends StatelessWidget {
  const MySearchBar({
    this.onChanged,
    this.onTap,
    this.initialValue,
    this.focusNode,
    this.elevation = 1.0,
    super.key,
  });

  final VoidCallback? onTap;
  final void Function(String)? onChanged;
  final String? initialValue;
  final FocusNode? focusNode;

  /// Must be from 0.0 to 1.0
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: BaseColors.black25,
            blurRadius: 5 * elevation,
            offset: const Offset(0, 2) * elevation,
          )
        ],
      ),
      child: TextFormField(
        initialValue: initialValue,
        onTap: onTap,
        onChanged: onChanged,
        focusNode: focusNode,
        decoration: InputDecoration(
          hintText: t.search.enterWord,
          contentPadding: const EdgeInsets.all(10),
          filled: true,
          fillColor: BaseColors.concrete,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: BaseColors.curiousBlue)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: BaseColors.curiousBlue),
          ),
          hintStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeights.regular,
            color: BaseColors.neptune,
          ),
          suffixIcon: const Icon(
            Icons.search,
            color: BaseColors.curiousBlue,
            size: 18,
          ),
        ),
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeights.bold,
          color: BaseColors.curiousBlue,
        ),
      ),
    );
  }
}
