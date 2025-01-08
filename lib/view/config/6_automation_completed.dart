import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liftday/sevices/bloc/config/config_bloc.dart';
import 'package:liftday/sevices/bloc/config/config_event.dart';
import 'package:liftday/view/widgets/ui_elements.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AutomationCompletedView extends StatefulWidget {
  const AutomationCompletedView({super.key});

  @override
  State<AutomationCompletedView> createState() => _AutomationCompletedView();
}

class _AutomationCompletedView extends State<AutomationCompletedView> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          context
              .read<ConfigBloc>()
              .add(const ConfigEventUndarstandAutomationTip());
        }
      },
      child: Scaffold(
        appBar: appBarWithButton(context, AppLocalizations.of(context)!.ok, () {
          context
              .read<ConfigBloc>()
              .add(const ConfigEventUndarstandAutomationTip());
        }),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _isLoading
                        ? AppLocalizations.of(context)!.automating_calendar
                        : AppLocalizations.of(context)!.automation_completed,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: _isLoading
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: LinearProgressIndicator(
                            key: const ValueKey(1),
                            backgroundColor:
                                Theme.of(context).colorScheme.onTertiary,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.secondary),
                          ),
                        )
                      : Icon(
                          Icons.check,
                          key: const ValueKey(2),
                          color: Theme.of(context).colorScheme.secondary,
                          size: 60.0,
                        ),
                ),
                const SizedBox(
                  height: 90.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
