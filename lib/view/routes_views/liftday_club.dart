import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liftday/sevices/bloc/settings/settings_bloc.dart';
import 'package:liftday/sevices/bloc/settings/settings_state.dart';

class LiftDayClub extends StatefulWidget {
  const LiftDayClub({super.key});

  @override
  State<LiftDayClub> createState() => _LiftDayClubState();
}

class _LiftDayClubState extends State<LiftDayClub> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BlocBuilder<SettingsBloc, SettingsState>(
              builder: (context, state) {
                final isDarkMode = state.themeMode == ThemeMode.dark;
                return Container(
                  height: 80,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: isDarkMode
                          ? const AssetImage('assets/liftday_club_dm.png')
                          : const AssetImage('assets/liftday_club_lm.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              },
            ),
            const Padding(
              padding: EdgeInsets.all(48.0),
              child: Column(
                children: [
                  Text(
                    "Dołącz aby:",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    "wesprzeć twórcę LiftDay",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    "odblokować dodatkowe opcje w aplikacji:",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    "- statystyki z dłuższego okresu\n(obecny limit 7 dni)\n- nielimitowana ilość rutyn\n(obecny limit 4)",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 1,
                    child: _roundedRectangleWithButton(
                      text: "Subskrybcja\nmiesięczna\n7.99 zł",
                      buttonText: "Dołącz",
                      backgroundColor: Theme.of(context).colorScheme.tertiary,
                      textColor: Theme.of(context).colorScheme.primary,
                      buttonColor: Theme.of(context).colorScheme.primary,
                      buttonTextColor: Theme.of(context).colorScheme.onPrimary,
                      onPressed: () {},
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: _roundedRectangleWithButton(
                      text: "Płatność\njednorazowa\n199.99 zł",
                      buttonText: "Dołącz",
                      backgroundColor: Theme.of(context).colorScheme.tertiary,
                      textColor: Theme.of(context).colorScheme.primary,
                      buttonColor: Theme.of(context).colorScheme.primary,
                      buttonTextColor: Theme.of(context).colorScheme.onPrimary,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _roundedRectangleWithButton({
    required String text,
    required String buttonText,
    required Color backgroundColor,
    required Color textColor,
    required Color buttonColor,
    required Color buttonTextColor,
    required VoidCallback onPressed,
    bool useGradient = false, // Dodano parametr gradientu
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: useGradient
              ? null
              : backgroundColor, // Ustaw tło, jeśli nie gradient
          gradient: useGradient
              ? LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.secondary,
                    Theme.of(context).colorScheme.tertiary
                  ], // Gradient
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: TextStyle(fontSize: 14.0, color: textColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    backgroundColor: buttonColor),
                child: Text(
                  buttonText,
                  style: TextStyle(
                      fontSize: 14.0,
                      color: buttonTextColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
