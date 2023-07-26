import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voca/injectable/injectable_init.dart';
import 'package:voca/presentation/home/cubit/home_cubit.dart';
import 'package:voca/presentation/settings/cubit/settings_cubit.dart';

class GlobalCubitProvider extends StatelessWidget {
  const GlobalCubitProvider({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt.get<HomeCubit>()..onInitialize()),
        BlocProvider(create: (_) => getIt.get<SettingsCubit>()..onInitialize()),
      ],
      child: child,
    );
  }
}
