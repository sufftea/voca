import 'package:flutter/material.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';

class MySearchBar extends StatelessWidget {
  const MySearchBar({
    this.onChanged,
    this.onTap,
    this.initialValue,
    this.autofocus = false,
    this.shadow = true,
    super.key,
  });

  final VoidCallback? onTap;
  final void Function(String)? onChanged;
  final bool autofocus;
  final String? initialValue;
  final bool shadow;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [
          if (shadow)
            BoxShadow(
              color: BaseColors.black25,
              blurRadius: 5,
              offset: const Offset(0, 3),
            )
        ],
      ),
      child: TextFormField(
        initialValue: initialValue,
        onTap: onTap,
        onChanged: onChanged,
        autofocus: autofocus,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          filled: true,
          fillColor: BaseColors.concrete,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide.none,
          ),
          hintText: t.search.enterWord,
          hintStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeights.medium,
            color: BaseColors.neptune,
          ),
          suffixIcon: const Icon(
            Icons.search,
            color: BaseColors.neptune,
            size: 18,
          ),
        ),
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeights.bold,
          color: BaseColors.neptune,
        ),
      ),
    );
  }
}
