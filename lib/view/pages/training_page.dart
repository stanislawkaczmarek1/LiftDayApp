import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liftday/sevices/bloc/settings/settings_bloc.dart';
import 'package:liftday/sevices/bloc/tap/tap_bloc.dart';
import 'package:liftday/view/widgets/calendar.dart';
import 'package:liftday/view/widgets/tables/exercise_table.dart';

class TrainingPage extends StatefulWidget {
  const TrainingPage({super.key});

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  DateTime? _selectedDay = DateTime.now();
  String _dateText = "";
  bool _calendarVisibility = true;
  bool _isInitialized = false;

  void _onDaySelected(DateTime selectedDay) {
    setState(() {
      _selectedDay = selectedDay;
    });
  }

  void _setDateText(DateTime date) {
    String dateDay = "";
    if (date.day < 10) {
      dateDay = "${0}${date.day}";
    } else {
      dateDay = "${date.day}";
    }

    String dateMonth = "";
    if (date.month < 10) {
      dateMonth = "${0}${date.month}";
    } else {
      dateMonth = "${date.month}";
    }

    _dateText = "$dateDay.$dateMonth";
  }

  @override
  void initState() {
    _setDateText(DateTime.now());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _calendarVisibility = context.read<SettingsBloc>().state.showCalendar;
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCalendarSection(),
        Expanded(child: _buildExerciseTable()),
      ],
    );
  }

  Widget _buildCalendarSection() {
    return StatefulBuilder(
      builder: (context, StateSetter setCalState) {
        return Container(
          color: Theme.of(context).colorScheme.onPrimary,
          child: _calendarVisibility
              ? _buildCalendar(setCalState)
              : _buildCollapsedCalendar(setCalState),
        );
      },
    );
  }

  Widget _buildCalendar(StateSetter setCalState) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        ),
      ),
      child: AppCalendar(
        onDaySelected: _onDaySelected,
        callback: (visible, date) {
          setCalState(() {
            _calendarVisibility = visible;
            _setDateText(date);
          });
        },
        currentDay: _selectedDay,
      ),
    );
  }

  Widget _buildCollapsedCalendar(StateSetter setCalState) {
    return Container(
      width: double.infinity,
      height: 30,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 1,
            bottom: 1,
            child: GestureDetector(
              onTap: () {
                setCalState(() {
                  _calendarVisibility = true;
                });
              },
              child: SizedBox(
                height: 30,
                width: 30,
                child: Icon(
                  Icons.keyboard_arrow_down,
                  size: 25,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ),
          Positioned(
            right: 1,
            bottom: 5,
            left: 1,
            child: Center(
              child: Text(
                _dateText,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseTable() {
    return Container(
      color: Theme.of(context).colorScheme.onPrimary,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            if (_selectedDay != null)
              GestureDetector(
                onTap: () {
                  context.read<TapBloc>().add(const Tap());
                },
                child: ExerciseTable(
                  key: ValueKey(_selectedDay),
                  selectedDate: _selectedDay!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
