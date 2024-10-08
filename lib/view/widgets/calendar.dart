import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liftday/sevices/bloc/app_bar/app_bar_bloc.dart';
import 'package:liftday/sevices/bloc/app_bar/app_bar_event.dart';
import 'package:table_calendar/table_calendar.dart';

class AppCalendar extends StatefulWidget {
  final Function(DateTime) onDaySelected;

  const AppCalendar({
    super.key,
    required this.onDaySelected,
  });

  @override
  State<AppCalendar> createState() => _AppCalendarState();
}

class _AppCalendarState extends State<AppCalendar> {
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
  void initState() {
    //_exerciseService = ExerciseService();
    _selectedDay ??= _focusedDay;
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

    return TableCalendar(
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
              context
                  .read<AppBarBloc>()
                  .add(const AppBarEventSetDefaultTitle());
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
    );
  }
}
