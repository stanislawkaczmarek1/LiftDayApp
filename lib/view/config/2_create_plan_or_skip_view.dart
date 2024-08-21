import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liftday/constants/colors.dart';
import 'package:liftday/sevices/bloc/app_bloc.dart';
import 'package:liftday/sevices/bloc/app_event.dart';
import 'package:liftday/view/widgets/ui_elements.dart';

class CreatePlanOrSkipView extends StatefulWidget {
  const CreatePlanOrSkipView({super.key});

  @override
  State<CreatePlanOrSkipView> createState() => _CreatePlanOrSkipViewState();
}

class _CreatePlanOrSkipViewState extends State<CreatePlanOrSkipView> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          context.read<AppBloc>().add(const AppEventGoBack());
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
              onPressed: () {},
              style: TextButton.styleFrom(foregroundColor: colorAccent),
              child: const Text(
                "Pomiń automatyzacje",
                style: TextStyle(fontSize: 18.0),
              ),
            )
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Wybierz formę\nw jakiej chcesz\ndodawać treningi',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 34.0,
              ),
              normalButton(
                  "Automatyczne przypisanie\ndni treningowych\ndo dni tygodnia",
                  () {
                context
                    .read<AppBloc>()
                    .add(const AppEventConfirmWeekAutomation());
              }),
              const SizedBox(
                height: 24.0,
              ),
              normalButton(
                  "Ręczne wybieranie\ndanego dnia traningowego\nw dany dzień tygodnia",
                  () {}),
              const SizedBox(
                height: 54.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
