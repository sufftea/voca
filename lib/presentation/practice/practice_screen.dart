import 'package:flutter/material.dart';
import 'package:voca/presentation/base/utils/cubit_helpers/cubit_consumer.dart';
import 'package:voca/presentation/practice/cubit/practice_cubit.dart';
import 'package:voca/presentation/practice/cubit/practice_state.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen>
    with StatefulCubitConsumer<PracticeCubit, PracticeState, PracticeScreen> {
  @override
  void initState() {
    super.initState();

    cubit.onScreenOpened();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
