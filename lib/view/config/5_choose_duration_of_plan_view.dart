import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liftday/dialogs/have_to_choose_plan_duration.dart';
import 'package:liftday/sevices/bloc/config/config_bloc.dart';
import 'package:liftday/sevices/bloc/config/config_event.dart';
import 'package:liftday/view/widgets/ui_elements.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PlanDurationView extends StatefulWidget {
  const PlanDurationView({super.key});

  @override
  State<PlanDurationView> createState() => _PlanDurationViewState();
}

class _PlanDurationViewState extends State<PlanDurationView> {
  int? _selectedDuration;

  void _onDurationChanged(int? duration) {
    setState(() {
      _selectedDuration = duration;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          context.read<ConfigBloc>().add(const ConfigEventGoBack());
        }
      },
      child: Scaffold(
        appBar: appBarWithButton(context, AppLocalizations.of(context)!.next,
            () async {
          if (_selectedDuration != null) {
            context
                .read<ConfigBloc>()
                .add(ConfigEventConfirmPlanDuration(_selectedDuration!));
          } else {
            await showHaveToChoosePlanDurationDialog(context);
          }
        }),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                AppLocalizations.of(context)!.choose_plan_duration,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            Dropdown(onDurationChanged: _onDurationChanged),
            const SizedBox(
              height: 60.0,
            ),
          ],
        ),
      ),
    );
  }
}

class Dropdown extends StatefulWidget {
  final ValueChanged<int?> onDurationChanged;

  const Dropdown({required this.onDurationChanged, super.key});

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  String? _selectedOption;

  @override
  Widget build(BuildContext context) {
    final Map<String, int> optionsMap = {
      AppLocalizations.of(context)!.week_1: 7,
      AppLocalizations.of(context)!.weeks_2: 14,
      AppLocalizations.of(context)!.weeks_4: 28,
      AppLocalizations.of(context)!.weeks_8: 56,
    };

    return DropdownButton<String>(
      value: _selectedOption,
      hint: Text(AppLocalizations.of(context)!.choose_option),
      icon: const Icon(Icons.arrow_drop_down),
      items: optionsMap.keys.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedOption = newValue;
          widget.onDurationChanged(optionsMap[newValue]);
        });
      },
    );
  }
}
