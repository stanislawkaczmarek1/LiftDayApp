import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liftday/sevices/bloc/theme/theme_bloc.dart';
import 'package:liftday/sevices/bloc/theme/theme_event.dart';
import 'package:liftday/sevices/bloc/theme/theme_state.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        final isDarkMode = themeState.themeMode == ThemeMode.dark;

        return ListTile(
          title: const Text(
            'Dark Mode',
            style: TextStyle(fontSize: 16),
          ),
          trailing: Switch(
            value: isDarkMode,
            focusColor: Theme.of(context).colorScheme.secondary,
            onChanged: (value) {
              BlocProvider.of<ThemeBloc>(context).add(
                ThemeEventChange(isDarkMode: value),
              );
            },
          ),
        );
      },
    );
  }
}
