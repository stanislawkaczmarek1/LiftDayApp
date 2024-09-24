import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liftday/l10n/l10n.dart';
import 'package:liftday/sevices/bloc/language/language_bloc.dart';
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

        return BlocBuilder<LanguageBloc, LanguageState>(
          builder: (context, languageState) {
            final currentLocale = languageState.locale;
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  ListTile(
                    title: const Text(
                      'Tryb Ciemny',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    trailing: Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: isDarkMode,
                        focusColor: Theme.of(context).colorScheme.secondary,
                        onChanged: (value) {
                          BlocProvider.of<ThemeBloc>(context).add(
                            ThemeEventChange(isDarkMode: value),
                          );
                        },
                      ),
                    ),
                  ),
                  ListTile(
                    title: const Text(
                      'Język',
                      style: TextStyle(fontSize: 16),
                    ),
                    trailing: DropdownButton<Locale>(
                      value: currentLocale,
                      items: L10n.all.map<DropdownMenuItem<Locale>>((locale) {
                        return DropdownMenuItem<Locale>(
                          value: locale,
                          child: Text(_getLanguageName(locale.languageCode)),
                        );
                      }).toList(),
                      onChanged: (Locale? newLocale) {
                        if (newLocale != null) {
                          context
                              .read<LanguageBloc>()
                              .add(ChangeLanguage(newLocale)); // Zmiana języka
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'pl':
        return 'Polski';
      default:
        return 'Unknown';
    }
  }
}
