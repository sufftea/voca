import 'package:flutter/material.dart';
import 'package:voca/presentation/base/l10n/gen/l10n.dart';
import 'package:voca/presentation/base/router.dart';

void main() async {
  await Intls.load(const Locale('us'));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: router,
    );
  }
}
