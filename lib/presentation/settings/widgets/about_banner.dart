import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';
import 'package:voca/presentation/base/widgets/base_card.dart';

final _wordNetUrl = Uri.parse('https://wordnet.princeton.edu/');

class AboutBanner extends StatelessWidget {
  const AboutBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return BaseCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            t.settings.about.header,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeights.bold,
            ),
          ),
          bulidWordNetCitation(),
        ],
      ),
    );
  }

  Wrap bulidWordNetCitation() {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final word in (t.settings.about.dictionaryFrom).split(' '))
          Text(
            '$word ',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeights.regular,
            ),
          ),
        TextButton.icon(
          onPressed: () async {
            await launchUrl(
              _wordNetUrl,
              mode: LaunchMode.externalApplication,
            );
          },
          style: const ButtonStyle(
            padding: MaterialStatePropertyAll(
              EdgeInsets.symmetric(vertical: 1, horizontal: 1),
            ),
            minimumSize: MaterialStatePropertyAll(Size.zero),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            textStyle: MaterialStatePropertyAll(TextStyle(
              fontSize: 15,
              fontWeight: FontWeights.regular,
            )),
            foregroundColor: MaterialStatePropertyAll(BaseColors.curiousBlue),
          ),
          icon: const Icon(Icons.link),
          label: Text(t.settings.about.wordNet),
        ),
      ],
    );
  }
}
