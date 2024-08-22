import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liftday/constants/colors.dart';
import 'package:liftday/sevices/provider/appbar_title_provider.dart';
import 'package:liftday/view/widgets/exercise_table.dart';
import 'package:table_calendar/table_calendar.dart';

class TrainingPage extends StatefulWidget {
  const TrainingPage({super.key});

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime? _selectedDay;
  Timer? _resetTitleTimer;

  Text _getMonthText(DateTime date) {
    String monthName = _getMonthName(date.month);
    String title = "$monthName ${date.year}";
    return Text(
      title,
      style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
    );
  }

  String _getMonthName(int month) {
    const months = [
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
    return months[month - 1];
  }

  final List<String> _customDayNames = [
    'N',
    'P',
    'W',
    'Ś',
    'C',
    'P',
    'S',
  ];

  @override
  void dispose() {
    _resetTitleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime firstDay = DateTime.utc(2024, 1, 1);
    DateTime lastDay = _focusedDay.add(const Duration(days: 365));

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TableCalendar(
            locale: 'pl_PL',
            firstDay: firstDay,
            lastDay: lastDay,
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            startingDayOfWeek: StartingDayOfWeek.monday,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
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
                context.read<AppBarTitleProvider>().updateTitle(
                      _getMonthText(focusedDay),
                    );
                _resetTitleTimer?.cancel();
                _resetTitleTimer = Timer(const Duration(seconds: 1), () {
                  if (mounted) {
                    context.read<AppBarTitleProvider>().setDefaultTitle();
                  }
                });
              });
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
                return _customDayNames[date.weekday % 7];
              },
            ),
            rowHeight: 60.0,
            calendarStyle: const CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: colorAccent,
                shape: BoxShape.circle,
              ),
              selectedTextStyle: TextStyle(
                color: colorMainBackgroud,
              ),
              todayDecoration: BoxDecoration(
                color: colorInactiveButton,
                shape: BoxShape.circle,
              ),
              todayTextStyle: TextStyle(
                color: colorMainBackgroud,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const ExerciseTable(),
        ],
      ),
    );
  }
}
