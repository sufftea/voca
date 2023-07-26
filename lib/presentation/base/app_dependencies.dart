import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';
import 'package:voca/presentation/base/theming/theme_notifier.dart';
import 'package:voca/presentation/base/theming/app_themes.dart';
import 'package:voca/presentation/base/utils/cubit_helpers/global_cubit_provider.dart';

class AppDependencies extends StatefulWidget {
  const AppDependencies({
    required this.builder,
    required this.theme,
    super.key,
  });

  final WidgetBuilder builder;
  final AppTheme theme;

  @override
  State<AppDependencies> createState() => _AppDependenciesState();
}

class _AppDependenciesState extends State<AppDependencies> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ),
      child: GlobalCubitProvider(
        child: ChangeNotifierProvider<ThemeNotifier>(
          create: (context) => ThemeNotifier(widget.theme),
          child: TranslationProvider(
            child: Builder(builder: widget.builder),
          ),
        ),
      ),
    );
  }
}
