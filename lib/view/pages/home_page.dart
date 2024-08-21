import 'package:flutter/material.dart';
import 'package:liftday/constants/colors.dart';
import 'package:liftday/view/widgets/exercise_table.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime? _selectedDay;
  bool _isScrolling = false;

  @override
  Widget build(BuildContext context) {
    DateTime firstDay = DateTime.utc(2024, 1, 1);
    DateTime lastDay = _focusedDay.add(const Duration(days: 365));
    return Scaffold(
      appBar: AppBar(
        title: _isScrolling
            ? Text(
                "${_focusedDay.month} ${_focusedDay.year}",
                style: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.bold),
              )
            : Image.asset('assets/liftday_logo.png', height: 25.0),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
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
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
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
                  fontSize: 0.0, // Ustaw rozmiar czcionki na 0, aby ukryć tytuł
                ),
              ),
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle: TextStyle(fontSize: 12.0),
                weekendStyle: TextStyle(fontSize: 12.0),
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
      ),
    );
  }
}
