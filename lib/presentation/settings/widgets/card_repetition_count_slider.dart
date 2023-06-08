import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:voca/domain/domain_constants.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/utils/cubit_helpers/cubit_consumer.dart';
import 'package:voca/presentation/settings/cubit/settings_cubit.dart';
import 'package:voca/presentation/settings/cubit/settings_state.dart';

class CardRepetitionCountSlider extends StatefulWidget {
  const CardRepetitionCountSlider({super.key});

  @override
  State<CardRepetitionCountSlider> createState() =>
      _CardRepetitionCountSliderState();
}

class _CardRepetitionCountSliderState extends State<CardRepetitionCountSlider>
    with
        StatefulCubitConsumer<SettingsCubit, SettingsState,
            CardRepetitionCountSlider> {
  final _repetitions = ValueNotifier<double?>(null);

  @override
  Widget build(BuildContext context) {
    final f = NumberFormat('00');

    return listener(
      listenWhen: (prev, curr) =>
          prev.maxRepetitionCount != curr.maxRepetitionCount,
      listener: (context, state) {
        _repetitions.value = state.maxRepetitionCount?.toDouble();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Card repetitions:',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeights.regular,
            ),
          ),
          Row(
            children: [
              buildSlider(),
              ValueListenableBuilder(
                valueListenable: _repetitions,
                builder: (context, value, child) {
                  return Text(
                    f.format(value ?? 0),
                    style: TextStyle(
                      fontSize: 15,
                      color: value == null
                          ? BaseColors.grey
                          : BaseColors.curiousBlue,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSlider() {
    return Expanded(
      child: ValueListenableBuilder(
        valueListenable: _repetitions,
        builder: (context, value, __) {
          value = switch (value) {
            null => null,
            < DomainConstants.minCardRepetitionsSetting =>
              DomainConstants.minCardRepetitionsSetting.toDouble(),
            > DomainConstants.maxCardRepetitionsSetting =>
              DomainConstants.maxCardRepetitionsSetting.toDouble(),
            double value => value,
          };

          return SliderTheme(
            data: SliderThemeData(
              overlappingShapeStrokeColor: Colors.purple,
              overlayShape: SliderComponentShape.noThumb,
            ),
            child: Slider(
              value: value ?? 0.0,
              max: DomainConstants.maxCardRepetitionsSetting.toDouble(),
              min: 0,
              divisions: DomainConstants.maxCardRepetitionsSetting,
              inactiveColor: BaseColors.botticelly,
              activeColor: BaseColors.curiousBlue,
              thumbColor: BaseColors.curiousBlue,
              label: value?.toInt().toString(),
              onChangeEnd: (_) {
                // NOT using the value provided by the callback is deliberate
                if (_repetitions.value case final value?) {
                  cubit.onSetMaxRepetitionCount(value.toInt());
                }
              },
              onChanged: switch (value) {
                null => null,
                _ => (value) {
                    if (DomainConstants.cardRepetitionSettingWithinRange(
                        value.toInt())) {
                      _repetitions.value = value;
                    }
                  },
              },
            ),
          );
        },
      ),
    );
  }
}
