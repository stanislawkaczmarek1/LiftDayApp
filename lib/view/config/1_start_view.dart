import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liftday/sevices/bloc/config/config_bloc.dart';
import 'package:liftday/sevices/bloc/config/config_event.dart';
import 'package:liftday/view/widgets/ui_elements.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StartView extends StatefulWidget {
  const StartView({super.key});

  @override
  State<StartView> createState() => _StartViewState();
}

class _StartViewState extends State<StartView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const SizedBox(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppLocalizations.of(context)!.hello,
                style:
                    const TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                normalButton(
                  "Rozpocznij",
                  () {
                    context
                        .read<ConfigBloc>()
                        .add(const ConfigEventStartButton());
                  },
                  Theme.of(context).colorScheme.tertiary,
                  Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(
                  height: 40.0,
                ), /*
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Klikając przycisk "Rozpocznij", akceptujesz nasze Warunki korzystania i Politykę prywatności',
                    textAlign: TextAlign.center,
                  ),
                ),*/
              ],
            ),
          ],
        ),
      ),
    );
  }
}
