import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liftday/sevices/bloc/config/config_bloc.dart';
import 'package:liftday/sevices/bloc/config/config_event.dart';
import 'package:liftday/view/widgets/ui_elements.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RoutinesTipView extends StatefulWidget {
  const RoutinesTipView({super.key});

  @override
  State<RoutinesTipView> createState() => _RoutinesTipView();
}

class _RoutinesTipView extends State<RoutinesTipView> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          context
              .read<ConfigBloc>()
              .add(const ConfigEventUndarstandRoutinesAdditionTip());
        }
      },
      child: Scaffold(
        appBar: appBarWithButton(context, AppLocalizations.of(context)!.ok, () {
          context
              .read<ConfigBloc>()
              .add(const ConfigEventUndarstandRoutinesAdditionTip());
        }),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.days_added_to_routines,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Text(
                    AppLocalizations.of(context)!.load_routine_during_training,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.normal),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.click_here,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.normal),
                          textAlign: TextAlign.center,
                        ),
                        Icon(
                          Icons.more_vert,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.next_to_button,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.normal),
                          textAlign: TextAlign.center,
                        ),
                        Container(
                          margin: const EdgeInsets.all(6),
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onTertiary,
                              borderRadius: BorderRadius.circular(9.0),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.onPrimary,
                              )),
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.add_exercise2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                        const Text(
                          ")",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.normal),
                          textAlign: TextAlign.center,
                        ),
                      ],
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
      ),
    );
  }
}
