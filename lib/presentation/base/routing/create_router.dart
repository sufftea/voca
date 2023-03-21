import 'dart:io';

import 'package:go_router/go_router.dart';
import 'package:receive_intent/receive_intent.dart';
import 'package:voca/presentation/base/routing/routers/add_word_router.dart';
import 'package:voca/presentation/base/routing/routers/main_router.dart';

Future<GoRouter> createRouter() async {
  if (Platform.isAndroid) {
    final intent = await ReceiveIntent.getInitialIntent();

    if (intent != null) {
      if (intent.action == 'android.intent.action.PROCESS_TEXT') {
        final word =
            intent.extra?['android.intent.extra.PROCESS_TEXT'] as String?;
        return createAddWordRouter(word ?? 'whoops, this is a bug...');
      }
    }
  }

  return createMainRouter();
}
