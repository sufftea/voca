import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:voca/presentation/base/theming/app_themes.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';
import 'package:voca/presentation/base/widgets/base_card.dart';

final _wordNetUrl = Uri.parse('https://wordnet.princeton.edu/');

class AboutBanner extends StatelessWidget {
  const AboutBanner({super.key});

  Future<void> onWordNetTap() async {
    await launchUrl(
      _wordNetUrl,
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return BaseCard(
      padding: const EdgeInsets.all(16),
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
          const SizedBox(height: 12),
          bulidWordNetCitation(context),
        ],
      ),
    );
  }

  Widget bulidWordNetCitation(BuildContext context) {
    final theme = Theme.of(context);

    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style.merge(TextStyle(
              fontSize: 15,
              fontWeight: FontWeights.regular,
              color: theme.colorScheme.onSurfaceVariant,
            )),
        children: [
          TextSpan(
            text: t.settings.about.dictionaryFrom,
          ),
          TextSpan(
            text: t.settings.about.wordNet,
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontWeight: FontWeights.medium,
            ),
            recognizer: TapGestureRecognizer()..onTap = onWordNetTap,
          ),
        ],
      ),
    );
  }
}
