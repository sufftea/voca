import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

mixin CubitConsumer<CubitT extends BlocBase<StateT>, StateT> {
  CubitT cubit(BuildContext context) => BlocProvider.of<CubitT>(context);
  Widget builder(Widget Function(BuildContext, StateT) builder) =>
      BlocBuilder<CubitT, StateT>(builder: builder);
}

mixin StatefulCubitConsumer<CubitT extends BlocBase<StateT>, StateT,
    WidgetT extends StatefulWidget> on State<WidgetT> {
  CubitT get cubit => BlocProvider.of(context);
  Widget builder(Widget Function(BuildContext, StateT) builder) =>
      BlocBuilder<CubitT, StateT>(builder: builder);
}
