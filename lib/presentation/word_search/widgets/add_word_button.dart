import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:voca/presentation/base/base_theme.dart';

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

  @override
  Widget build(BuildContext context) {
    late final Widget? child;

    if (widget.isAdded) {
      child = null;
    } else if (isLoading) {
      child = const SizedBox(
        height: 20,
        width: 20,
        child:  CircularProgressIndicator(
          color: BaseColors.curiousBlue,
          
        ),
      );
    } else {
      child = IconButton(
        onPressed: onPressed,
        style: const ButtonStyle(
          foregroundColor: MaterialStatePropertyAll(BaseColors.curiousBlue),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          iconSize: MaterialStatePropertyAll(30),
          maximumSize: MaterialStatePropertyAll(Size.square(50)),
        ),
        icon: const Icon(Icons.add_rounded),
      );
    }

    return SizedBox(
      width: 60,
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
