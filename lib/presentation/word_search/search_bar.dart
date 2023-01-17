import 'package:flutter/material.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/l10n/gen/l10n.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({
    this.onChanged,
    this.onTap,
    super.key,
  });

  /// For the Hero transition
  static final globalKey = GlobalKey();

  final VoidCallback? onTap;
  final void Function(String)? onChanged;

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10),
        filled: true,
        fillColor: BaseColors.concrete,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide.none,
        ),
        hintText: Intls.current.lookUpWord,
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
