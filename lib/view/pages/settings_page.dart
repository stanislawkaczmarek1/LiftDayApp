import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liftday/l10n/l10n.dart';
import 'package:liftday/sevices/bloc/language/language_bloc.dart';
import 'package:liftday/sevices/bloc/theme/theme_bloc.dart';
import 'package:liftday/sevices/bloc/theme/theme_event.dart';
import 'package:liftday/sevices/bloc/theme/theme_state.dart';
import 'package:liftday/sevices/bloc/weight_unit/weight_unit_bloc.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              final isDarkMode = themeState.themeMode == ThemeMode.dark;
              return ListTile(
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
              );
            },
          ),
          BlocBuilder<LanguageBloc, LanguageState>(
            builder: (context, languageState) {
              final currentLocale = languageState.locale;
              return ListTile(
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
              );
            },
          ),
          BlocBuilder<WeightUnitBloc, WeightUnitState>(
            builder: (context, unitState) {
              final currentUnit = unitState.unit;
              return ListTile(
                title: const Text(
                  'Jednostka',
                  style: TextStyle(fontSize: 16),
                ),
                trailing: DropdownButton<String>(
                  value: currentUnit,
                  items: const [
                    DropdownMenuItem<String>(
                      value: 'kg',
                      child: Text('Kg'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'lbs',
                      child: Text('Lbs'),
                    ),
                  ],
                  onChanged: (String? newUnit) {
                    if (newUnit != null) {
                      context
                          .read<WeightUnitBloc>()
                          .add(ChangeWeightUnit(newUnit));
                    }
                  },
                ),
              );
            },
          ),
        ],
      ),
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
