import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liftday/constants/database.dart';
import 'package:liftday/l10n/l10n.dart';
import 'package:liftday/sevices/bloc/language/language_bloc.dart';
import 'package:liftday/sevices/bloc/theme/theme_bloc.dart';
import 'package:liftday/sevices/bloc/theme/theme_event.dart';
import 'package:liftday/sevices/bloc/theme/theme_state.dart';
import 'package:liftday/sevices/bloc/weight_unit/weight_unit_bloc.dart';
import 'package:liftday/sevices/crud/exercise_service.dart';
import 'package:liftday/sevices/settings/settings_service.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:sqflite/sqflite.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<bool> _isValidDatabase(File source) async {
    try {
      Database db = await openDatabase(source.path);

      List<Map<String, dynamic>> tables = await db
          .rawQuery("SELECT name FROM sqlite_master WHERE type='table';");

      List<String> requiredTables = [
        datesTable,
        exercisesTable,
        setsTable,
        trainingDaysTable,
        trainingDayExercisesTable,
        exercisesInfoTable,
      ];

      for (String table in requiredTables) {
        if (!tables.any((t) => t['name'] == table)) {
          await db.close();
          return false;
        }
      }

      await db.close();
      return true;
    } catch (e) {
      log('Błąd podczas walidacji bazy danych: $e');
      return false;
    }
  }

  Future<bool> _restoreDb() async {
    final docsPath = await getApplicationDocumentsDirectory();
    final dbPath = join(docsPath.path, dbName);

    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File source = File(result.files.single.path!);
      String fileExtension = source.path.split('.').last;
      if (fileExtension == 'db' || fileExtension == 'sqlite') {
        if (await _isValidDatabase(source)) {
          try {
            await source.copy(dbPath);
            ExerciseService exerciseService = ExerciseService();
            SettingsService settingsService = SettingsService();
            settingsService.setHasPlanFlag(
                await exerciseService.checkIfThereIsPlanInRestoredDB());
            return true;
          } catch (e) {
            log('Błąd podczas przywracania bazy danych: $e');
            return false;
          }
        } else {
          log('Wybrany plik nie spełnia standardów projektu.');
          return false;
        }
      } else {
        log('Wybrano plik o nieprawidłowym rozszerzeniu');
        return false;
      }
    } else {
      // Użytkownik anulował wybór
      return false;
    }
  }

  Future<bool> _shareDb() async {
    final docsPath = await getApplicationDocumentsDirectory();
    final dbPath = join(docsPath.path, dbName);
    File dbFile = File(dbPath);

    if (await dbFile.exists()) {
      try {
        // Sprawdzenie istnienia pliku bazy danych i udostępnienie g
        final result =
            await Share.shareXFiles([XFile(dbPath)], text: 'LiftDay backup');
        if (result.status == ShareResultStatus.success) {
          return true;
        } else {
          return false;
        }
      } catch (e) {
        log('Błąd podczas udostępniania pliku: $e');
        return false;
      }
    } else {
      log("Plik bazy danych nie istnieje: $dbPath");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
          //TODO: Rodo i komunikaty
          ListTile(
            title: const Text(
              'Kopia zapasowa',
              style: TextStyle(fontSize: 16),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final result = await _restoreDb();
                    if (result) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Successfully Restored DB')),
                        );
                      }
                    }
                  },
                  child: const Icon(Icons.upload),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {
                    final result = await _shareDb();
                    if (result) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Successfully Copied DB')),
                        );
                      }
                    }
                  },
                  child: const Icon(Icons.download),
                ),
              ],
            ),
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
