import 'package:flutter/material.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';
import 'package:voca/presentation/base/widgets/base_card.dart';

class InversePracticeBanner extends StatelessWidget {
  const InversePracticeBanner({
    required this.onStartPressed,
    super.key,
  });

  final VoidCallback onStartPressed;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return BaseCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            t.home.invercePracticeBanner.header,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeights.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Text(
            t.home.invercePracticeBanner.description,
            style: const TextStyle(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          FilledButton(
            onPressed: onStartPressed,
            child: Text(t.home.invercePracticeBanner.start),
          ),
        ],
      ),
    );
  }
}
