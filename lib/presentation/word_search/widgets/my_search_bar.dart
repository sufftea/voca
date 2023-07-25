import 'package:flutter/material.dart';
import 'package:voca/presentation/base/theming/base_theme.dart';
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
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow,
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
          fillColor: theme.colorScheme.secondaryContainer,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
                color: theme.colorScheme.onSecondaryContainer.withOpacity(0.1)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
                color: theme.colorScheme.onSecondaryContainer.withOpacity(0.2)),
          ),
          hintStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeights.regular,
            color: theme.colorScheme.onSecondaryContainer.withOpacity(0.5),
          ),
          suffixIcon: Icon(
            Icons.search,
            color: theme.colorScheme.onSecondaryContainer.withOpacity(0.5),
            size: 18,
          ),
        ),
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeights.bold,
          color: theme.colorScheme.onSecondaryContainer,
        ),
      ),
    );
  }
}
