import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

mixin CubitConsumer<CubitT extends BlocBase<StateT>, StateT> {
  CubitT cubit(BuildContext context) => BlocProvider.of<CubitT>(context);

  Widget builder({
    required Widget Function(BuildContext context, StateT state) builder,
    bool Function(StateT prev, StateT curr)? buildWhen,
  }) =>
      BlocBuilder<CubitT, StateT>(
        builder: builder,
        buildWhen: buildWhen,
      );

  Widget listener({
    required BlocWidgetListener<StateT> listener,
    bool Function(StateT prev, StateT curr)? listenWhen,
    required Widget child,
  }) {
    return BlocListener<CubitT, StateT>(
      listenWhen: listenWhen,
      listener: listener,
      child: child,
    );
  }
}

mixin StatefulCubitConsumer<CubitT extends BlocBase<StateT>, StateT,
    WidgetT extends StatefulWidget> on State<WidgetT> {
  CubitT get cubit {
    return BlocProvider.of(context);
  }

  Widget builder({
    required Widget Function(BuildContext context, StateT state) builder,
    bool Function(StateT prev, StateT curr)? buildWhen,
  }) =>
      BlocBuilder<CubitT, StateT>(
        builder: builder,
        buildWhen: buildWhen,
      );

  Widget listener({
    required BlocWidgetListener<StateT> listener,
    bool Function(StateT prev, StateT curr)? listenWhen,
    required Widget child,
  }) {
    return BlocListener<CubitT, StateT>(
      listenWhen: listenWhen,
      listener: listener,
      child: child,
    );
  }
}
