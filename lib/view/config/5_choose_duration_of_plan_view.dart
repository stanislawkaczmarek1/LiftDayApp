import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liftday/constants/colors.dart';
import 'package:liftday/sevices/bloc/config_bloc.dart';
import 'package:liftday/sevices/bloc/app_event.dart';
import 'package:liftday/dialogs/have_to_choose_plan_duration.dart';

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
        appBar: AppBar(
          title: Image.asset(
            "assets/liftday_logo.png",
            height: 25,
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (_selectedDuration != null) {
                  context
                      .read<ConfigBloc>()
                      .add(ConfigEventConfirmPlanDuration(_selectedDuration!));
                } else {
                  await showHaveToChoosePlanDuration(context);
                }
              },
              style: TextButton.styleFrom(foregroundColor: colorBabyBlue),
              child: const Text(
                "Dalej",
                style: TextStyle(fontSize: 18.0),
              ),
            )
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Wybierz okres na jaki chcesz ustawić plan treningowy',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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

  final Map<String, int> _optionsMap = {
    '1 tydzień': 7,
    '2 tygodnie': 14,
    '4 tygodnie': 28,
    '8 tygodni': 56,
  };

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _selectedOption,
      hint: const Text('Wybierz opcję'),
      icon: const Icon(Icons.arrow_drop_down),
      items: _optionsMap.keys.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedOption = newValue;
          widget.onDurationChanged(_optionsMap[newValue]);
        });
      },
    );
  }
}
