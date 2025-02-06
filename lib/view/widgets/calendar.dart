import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liftday/constants/themes.dart';
import 'package:liftday/sevices/bloc/app_bar/app_bar_bloc.dart';
import 'package:liftday/sevices/bloc/app_bar/app_bar_event.dart';
import 'package:liftday/sevices/bloc/settings/settings_bloc.dart';
import 'package:liftday/sevices/bloc/settings/settings_state.dart';
import 'package:liftday/sevices/conversion/conversion_service.dart';
import 'package:liftday/sevices/crud/exercise_service.dart';
import 'package:liftday/sevices/settings/settings_service.dart';
import 'package:table_calendar/table_calendar.dart';

typedef CalendarVisibilityCallback = void Function(bool visable, DateTime date);

class AppCalendar extends StatefulWidget {
  final Function(DateTime) onDaySelected;
  final CalendarVisibilityCallback callback;
  final DateTime? currentDay;

  const AppCalendar({
    super.key,
    required this.callback,
    required this.onDaySelected,
    this.currentDay,
  });

  @override
  State<AppCalendar> createState() => _AppCalendarState();
}

class _AppCalendarState extends State<AppCalendar> {
  late DateTime _focusedDay;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime? _selectedDay;
  Timer? _resetTitleTimer;
  Map<DateTime, List<String>> _events = {};

  void _loadEventsForRange(DateTime start, DateTime end) async {
    ExerciseService exerciseService = ExerciseService();
    Map<String, Set<DateTime>> categorizedDates =
        await exerciseService.getDatesByTypeAndRange(start, end);

    if (mounted) {
      setState(() {
        for (var date in categorizedDates['green']!) {
          _events[date] = ['green'];
        }
        for (var date in categorizedDates['gray']!) {
          _events[date] = ['gray'];
        }
      });
    }
  }

  Text _getMonthText(DateTime date) {
    String monthName = _getMonthName(date.month);
    String title = "$monthName ${date.year}";
    return Text(
      title,
      style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
    );
  }

  String _getMonthName(int month) {
    final List<String> months;
    SettingsService settingsService = SettingsService();
    if (settingsService.language() == "pl") {
      months = [
        'Styczeń',
        'Luty',
        'Marzec',
        'Kwiecień',
        'Maj',
        'Czerwiec',
        'Lipiec',
        'Sierpień',
        'Wrzesień',
        'Październik',
        'Listopad',
        'Grudzień'
      ];
    } else {
      months = [
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December"
      ];
    }
    return months[month - 1];
  }

  @override
  void initState() {
    _focusedDay = widget.currentDay ?? DateTime.now();
    //_exerciseService = ExerciseService();
    _selectedDay ??= _focusedDay;
    DateTime start = _focusedDay.subtract(const Duration(days: 31));
    DateTime end = _focusedDay.add(const Duration(days: 31));
    _loadEventsForRange(start, end);
    super.initState();
  }

  @override
  void dispose() {
    _resetTitleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime firstDay = DateTime.utc(2024, 1, 1);
    DateTime lastDay = _focusedDay.add(const Duration(days: 365));
    return Stack(children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: TableCalendar(
          locale: 'pl_PL',
          firstDay: firstDay,
          lastDay: lastDay,
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          startingDayOfWeek: StartingDayOfWeek.monday,
          eventLoader: (day) {
            DateTime normalizedDay = DateTime(day.year, day.month, day.day);
            return _events[normalizedDay] ?? [];
          },
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, day, events) {
              if (events.isNotEmpty) {
                Color dotColor;
                if (events.contains('green')) {
                  dotColor = colorLightGreen; // Zielona kropka
                } else if (events.contains('gray')) {
                  dotColor = Colors.grey; // Szara kropka
                } else {
                  dotColor = Colors.transparent; // Brak kropki
                }

                return Positioned(
                  bottom: 5,
                  child: Container(
                    width: 7.0,
                    height: 7.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: dotColor,
                    ),
                  ),
                );
              }
              return null;
            },
          ),
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            if (!isSameDay(_selectedDay, selectedDay)) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              widget.onDaySelected(selectedDay);
            }
          },
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          onPageChanged: (focusedDay) async {
            setState(() {
              _focusedDay = focusedDay;
              context
                  .read<AppBarBloc>()
                  .add(AppBarEventUpdateTitle(_getMonthText(focusedDay)));
              _resetTitleTimer?.cancel();
              _resetTitleTimer = Timer(const Duration(seconds: 1), () {
                if (mounted) {
                  context.read<AppBarBloc>().add(AppBarEventSetDefaultTitle(
                      Theme.of(context).brightness == Brightness.dark));
                }
              });
            });
            DateTime start = focusedDay.subtract(const Duration(days: 20));
            DateTime end = focusedDay.add(const Duration(days: 20));
            _loadEventsForRange(start, end);
          },
          availableCalendarFormats: const {
            CalendarFormat.month: 'Miesiąc',
            CalendarFormat.week: 'Tydzień',
          },
          headerStyle: const HeaderStyle(
            titleCentered: true,
            formatButtonVisible: false,
            leftChevronVisible: false,
            rightChevronVisible: false,
            headerPadding: EdgeInsets.zero,
            titleTextStyle: TextStyle(
              fontSize: 0.0, // Ukrycie domyślnego tytułu
            ),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: const TextStyle(fontSize: 12.0),
            weekendStyle: const TextStyle(fontSize: 12.0),
            dowTextFormatter: (date, locale) {
              return ConversionService.getDayOfWeekOneLetter("${date.weekday}");
            },
          ),
          rowHeight: 60.0,
          calendarStyle: CalendarStyle(
            selectedDecoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              shape: BoxShape.circle,
            ),
            selectedTextStyle: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            todayDecoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
            todayTextStyle: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
      ),
      Positioned(
        right: 1,
        bottom: 1,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _calendarFormat = _calendarFormat == CalendarFormat.month
                  ? CalendarFormat.week
                  : CalendarFormat.month;
            });
          },
          child: SizedBox(
            height: 30,
            width: 30,
            child: Container(
              color: Colors.transparent,
              child: Icon(
                _calendarFormat == CalendarFormat.month
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                size: 25,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ), // Użycie ikony kalendarza
          ),
        ),
      ),
      BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return !state.showCalendar
              ? Positioned(
                  right: 45,
                  bottom: 1,
                  child: GestureDetector(
                    onTap: () {
                      if (_calendarFormat == CalendarFormat.week) {
                        setState(() {
                          widget.callback(false, _focusedDay);
                        });
                      }
                    },
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: Container(
                        color: Colors.transparent,
                        child: Icon(
                          _calendarFormat == CalendarFormat.week
                              ? Icons.keyboard_arrow_up
                              : null,
                          size: 25,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ), // Użycie ikony kalendarza
                    ),
                  ),
                )
              : const Positioned(
                  child: SizedBox(
                  height: 0,
                ));
        },
      ),
    ]);
  }
}
