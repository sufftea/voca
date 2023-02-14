import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';
import 'package:voca/presentation/base/routing/router.dart';
import 'package:voca/presentation/base/utils/cubit_helpers/cubit_consumer.dart';
import 'package:voca/presentation/base/widgets/app_bar_card.dart';
import 'package:voca/presentation/nav_bar/cubit/nav_bar_cubit.dart';
import 'package:voca/presentation/nav_bar/cubit/nav_bar_state.dart';

enum NavBarTab { home, settings }

class NavBarShell extends StatelessWidget
    with CubitConsumer<NavBarCubit, NavBarState> {
  const NavBarShell({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: AppBarCard(
        height: 60,
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            Expanded(
              child: builder((context, state) {
                return _NavBarButton(
                  onTap: () {
                    GoRouter.of(context).goNamed(RouteNames.home);
                    cubit(context).setTab(NavBarTab.home);
                  },
                  icon: Icons.home,
                  name: t.navBar.home,
                  active: state.activeTab == NavBarTab.home,
                );
              }),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: builder((context, state) {
                return _NavBarButton(
                  onTap: () {
                    GoRouter.of(context).goNamed(RouteNames.settings);
                    cubit(context).setTab(NavBarTab.settings);
                  },
                  icon: Icons.settings,
                  name: t.navBar.settings,
                  active: state.activeTab == NavBarTab.settings,
                );
              }),
            )
          ],
        ),
      ),
    );
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
