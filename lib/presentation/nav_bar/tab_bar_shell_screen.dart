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

    return AutoTabsRouter(
      routes: const [
        HomeRoute(),
        SettingsRoute(),
      ],
      builder: (context, child) {
        final router = AutoTabsRouter.of(context);

        return Scaffold(
          body: child,
          bottomNavigationBar: NavigationBar(
            selectedIndex: router.activeIndex,
            onDestinationSelected: (index) {
              router.setActiveIndex(index);
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home),
                label: 'home',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings),
                label: 'settings',
              ),
            ],
          ),
        );
      },
    );

    // return AutoTabsScaffold(
    //   homeIndex: 0,
    //   routes: const [
    //     HomeRoute(),
    //     SettingsRoute(),
    //   ],
    //   bottomNavigationBuilder: (context, tabsRouter) {
    //     final router = AutoTabsRouter.of(context);

    //     return Row(
    //       children: [
    //         Expanded(
    //           child: _NavBarButton(
    //             onTap: () {
    //               router.setActiveIndex(0);
    //             },
    //             icon: Icons.home,
    //             name: t.navBar.home,
    //             active: tabsRouter.activeIndex == 0,
    //           ),
    //         ),
    //         const SizedBox(width: 5),
    //         Expanded(
    //           child: _NavBarButton(
    //             onTap: () {
    //               router.setActiveIndex(1);
    //             },
    //             icon: Icons.settings,
    //             name: t.navBar.settings,
    //             active: tabsRouter.activeIndex == 1,
    //           ),
    //         )
    //       ],
    //     );
    //   },
    // );

    // return AutoTabsRouter.builder(
    //   routes: routes,
    //   builder: builder,
    // );

    // return Scaffold(
    //   bottomNavigationBar: AppBarCard(
    //     height: 60,
    //     padding: const EdgeInsets.all(5),
    //     child: Row(
    //       children: [
    //         Expanded(
    //           child: builder(
    //             buildWhen: (prev, curr) => prev.activeTab != curr.activeTab,
    //             builder: (context, state) {
    //               return _NavBarButton(
    //                 onTap: () {
    //                   GoRouter.of(context).goNamed(RouteNames.home);
    //                   cubit(context).setTab(NavBarTab.home);
    //                 },
    //                 icon: Icons.home,
    //                 name: t.navBar.home,
    //                 active: state.activeTab == NavBarTab.home,
    //               );
    //             },
    //           ),
    //         ),
    //         const SizedBox(width: 5),
    //         Expanded(
    //           child: builder(
    //             buildWhen: (prev, curr) => prev.activeTab != curr.activeTab,
    //             builder: (context, state) {
    //               return _NavBarButton(
    //                 onTap: () {
    //                   GoRouter.of(context).goNamed(RouteNames.settings);
    //                   cubit(context).setTab(NavBarTab.settings);
    //                 },
    //                 icon: Icons.settings,
    //                 name: t.navBar.settings,
    //                 active: state.activeTab == NavBarTab.settings,
    //               );
    //             },
    //           ),
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }
}

class _NavBarButton extends StatelessWidget {
  const _NavBarButton({
    required this.icon,
    required this.name,
    required this.active,
    required this.onTap,
  });

  final VoidCallback onTap;
  final IconData icon;
  final String name;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onTap,
      style: ButtonStyle(
        padding: const MaterialStatePropertyAll(EdgeInsets.all(0)),
        backgroundColor: MaterialStatePropertyAll(
          active ? BaseColors.mercury : BaseColors.white,
        ),
        foregroundColor: const MaterialStatePropertyAll(BaseColors.mineShaft),
        overlayColor: MaterialStatePropertyAll(BaseColors.mineShaft10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24,
          ),
          Text(
            name,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeights.bold,
            ),
          ),
        ],
      ),
    );
  }
}
