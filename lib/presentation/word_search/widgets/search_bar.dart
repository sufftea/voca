import 'package:flutter/material.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    this.onChanged,
    this.onTap,
    this.autofocus = false,
    super.key,
  });

  final VoidCallback? onTap;
  final void Function(String)? onChanged;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return TextField(
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
        hintText: t.search.lookUpWord,
        hintStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeights.bold,
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
    );
  }
}
