import 'package:flutter/material.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/l10n/gen/l10n.dart';
import 'package:voca/presentation/base/utils/cubit_helpers/cubit_consumer.dart';
import 'package:voca/presentation/base/utils/loading_state/loading_state.dart';
import 'package:voca/presentation/base/widgets/placeholder.dart';
import 'package:voca/presentation/home/cubit/home_cubit.dart';
import 'package:voca/presentation/home/cubit/home_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with StatefulCubitConsumer<HomeCubit, LoadingState<HomeState>, HomeScreen> {
  @override
  void initState() {
    super.initState();

    cubit.startLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BaseColors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildAppBar(),
          SingleChildScrollView(
            child: Column(
              children: [],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: BaseColors.white,
        boxShadow: [
          BoxShadow(
            color: BaseColors.black10,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildLanguageButton(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget buildLanguageButton() {
    const placeholder = PlaceholderCard(
      height: 50,
      width: 200,
    );

    return builder(
      (context, state) {
        return state.map(
          loading: (a) => placeholder,
          ready: (a) => TextButton(
            onPressed: () {},
            child: Text(
              Intls.current.language(a.data.selectedLanguage),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeights.bold,
                color: BaseColors.mineShaft,
              ),
            ),
          ),
          error: (a) => placeholder,
        );
      },
    );
  }
}
