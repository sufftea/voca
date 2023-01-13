import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:voca/presentation/base/utils/cubit_helpers/cubit_provider.dart';
import 'package:voca/presentation/home/cubit/home_cubit.dart';
import 'package:voca/presentation/home/home_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: "home",
      builder: (context, state) {
        return cubitProvider<HomeCubit>(const HomeScreen());
      }
    ),
  ],
);
