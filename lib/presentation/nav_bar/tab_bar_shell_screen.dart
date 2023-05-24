import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';
import 'package:voca/presentation/base/routing/routers/main/main_router.dart';

@RoutePage()
class TabBarShellScreen extends StatelessWidget {
  const TabBarShellScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    TransitionsBuilders.fadeIn;
    return AutoTabsRouter(
      routes: const [
        HomeRoute(),
        SettingsRoute(),
      ],
      builder: (context, child) {
        final router = AutoTabsRouter.of(context);

        return Scaffold(
          body: child,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              AutoRouter.of(context).push(WordSearchRoute());
            },
            child: const Icon(
              Icons.add_rounded,
              size: 30,
            ),
          ),
          bottomNavigationBar: DecoratedBox(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: BaseColors.black25,
                blurRadius: 10,
              ),
            ]),
            child: NavigationBar(
              height: 70,
              indicatorColor: BaseColors.neptune,
              surfaceTintColor: BaseColors.white,
              backgroundColor: BaseColors.white,
              elevation: 0,
              indicatorShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              selectedIndex: router.activeIndex,
              onDestinationSelected: (index) {
                debugPrint('onDestinationSelected; $index');
                if (router.activeIndex == index) {
                  final tabRouter =
                      router.childControllers[index] as StackRouter;
                  tabRouter.popUntilRoot();
                  return;
                }

                router.setActiveIndex(index);
              },
              destinations: [
                NavigationDestination(
                  icon: const Icon(Icons.home),
                  label: t.navBar.home,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.settings),
                  label: t.navBar.settings,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
