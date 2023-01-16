import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voca/injectable/injectable_init.dart';

Widget cubitProvider<CubitT extends BlocBase<Object?>>(Widget child) {
  return BlocProvider(
    create: (context) => getIt.get<CubitT>(),
    child: child,
  );
}
