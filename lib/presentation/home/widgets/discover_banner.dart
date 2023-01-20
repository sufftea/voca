import 'package:flutter/material.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/l10n/gen/l10n.dart';
import 'package:voca/presentation/base/widgets/base_card.dart';
import 'package:voca/presentation/base/widgets/placeholder_or.dart';

class DiscoverBanner extends StatelessWidget {
  const DiscoverBanner({super.key});

  static const placeholder = PlaceholderOr(real: DiscoverBanner());

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            Intls.current.discoverBannerTitle,textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeights.bold,
              color: BaseColors.mineShaft,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: const ButtonStyle(
              padding: MaterialStatePropertyAll(EdgeInsets.all(10)),
            ),
            child: Text(Intls.current.discoverNew),
          ),
        ],
      ),
    );
  }
}
