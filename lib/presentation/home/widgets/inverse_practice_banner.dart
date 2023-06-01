import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';
import 'package:voca/presentation/base/routing/routers/main/main_router.dart';
import 'package:voca/presentation/base/widgets/base_card.dart';

class InversePracticeBanner extends StatelessWidget {
  const InversePracticeBanner({
    super.key,
  });


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
          OutlinedButton(
            onPressed: () {
              context.router.root.push(const InversePracticeRoute());
            },
            child: Text(t.home.invercePracticeBanner.start),
          ),
        ],
      ),
    );
  }
}
