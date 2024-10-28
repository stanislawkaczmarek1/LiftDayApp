import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liftday/constants/database.dart';
import 'package:liftday/dialogs/create_backup.dart';
import 'package:liftday/dialogs/restore_backup.dart';
import 'package:liftday/l10n/l10n.dart';
import 'package:liftday/sevices/bloc/settings/settings_bloc.dart';
import 'package:liftday/sevices/bloc/settings/settings_event.dart';
import 'package:liftday/sevices/bloc/settings/settings_state.dart';
import 'package:liftday/sevices/crud/exercise_service.dart';
import 'package:liftday/sevices/settings/settings_service.dart';
//import 'package:liftday/view/routes_views/liftday_club.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

    try {
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
        // Użytkownik nie zezwolil
        return false;
      }
    } catch (e) {
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
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          final isDarkMode = state.themeMode == ThemeMode.dark;
          final currentLocale = state.locale;
          final currentUnit = state.unit;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    AppLocalizations.of(context)!.settings,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  AppLocalizations.of(context)!.dark_mode,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                trailing: Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: isDarkMode,
                    focusColor: Theme.of(context).colorScheme.secondary,
                    onChanged: (value) {
                      BlocProvider.of<SettingsBloc>(context).add(
                        SettingsEventChangeTheme(isDarkMode: value),
                      );
                    },
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  AppLocalizations.of(context)!.language,
                  style: const TextStyle(fontSize: 16),
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
                      context.read<SettingsBloc>().add(
                          SettingsEventChangeLanguage(
                              newLocale)); // Zmiana języka
                    }
                  },
                ),
              ),
              ListTile(
                title: Text(
                  AppLocalizations.of(context)!.unit,
                  style: const TextStyle(fontSize: 16),
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
                          .read<SettingsBloc>()
                          .add(SettingsEventChangeWeightUnit(newUnit));
                    }
                  },
                ),
              ),
              ListTile(
                title: Text(
                  AppLocalizations.of(context)!.send_backup,
                  style: const TextStyle(fontSize: 16),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final dialogResult =
                            await showCreateBackupDialog(context);
                        if (dialogResult) {
                          final result = await _shareDb();
                          if (result) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(AppLocalizations.of(context)!
                                        .copied_backup)),
                              );
                            }
                          }
                        }
                      },
                      child: const Icon(Icons.cloud_queue_outlined),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Text(
                  AppLocalizations.of(context)!.restore_backup,
                  style: const TextStyle(fontSize: 16),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final dialogResult =
                            await showRestoreBackupDialog(context);
                        if (dialogResult) {
                          final result = await _restoreDb();
                          if (result) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(AppLocalizations.of(context)!
                                        .restored_backup)),
                              );
                            }
                          }
                        }
                      },
                      child: const Icon(Icons.upload_file_outlined),
                    ),
                  ],
                ),
              ),
              /*const SizedBox(
                height: 48,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Odkryj",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const LiftDayClub(),
                    ),
                  );
                },
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    image: DecorationImage(
                      image: isDarkMode
                          ? const AssetImage('assets/liftday_club_dm.png')
                          : const AssetImage('assets/liftday_club_lm.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              )*/
            ],
          );
        },
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
