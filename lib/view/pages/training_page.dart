import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  void _onDaySelected(DateTime selectedDay) {
    setState(() {
      _selectedDay = selectedDay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCalendar(),
        _buildExerciseTable(),
      ],
    );
  }

  Widget _buildCalendar() {
    return Container(
      color: Theme.of(context).colorScheme.onPrimary,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0),
          ),
        ),
        child: AppCalendar(
          onDaySelected: _onDaySelected,
        ),
      ),
    );
  }

  Widget _buildExerciseTable() {
    return Expanded(
      child: Container(
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
      ),
    );
  }
}
