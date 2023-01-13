import 'package:go_router/go_router.dart';
import 'package:voca/presentation/home/home_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: "home",
      builder: (context, state) {
        return const HomeScreen();
      }
    ),
  ],
);
