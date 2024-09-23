import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liftday/sevices/bloc/app_bar/app_bar_bloc.dart';
import 'package:liftday/sevices/bloc/app_bar/app_bar_state.dart';

typedef OnPressedFunction = void Function();

TextButton normalButton(
  BuildContext context,
  String text,
  OnPressedFunction onPressed,
) {
  return TextButton(
    onPressed: onPressed,
    style: TextButton.styleFrom(
      elevation: 3.0,
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      foregroundColor: Theme.of(context).colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
      ),
    ),
  );
}

AppBar appBar(BuildContext context) {
  return AppBar(
    title: BlocBuilder<AppBarBloc, AppBarState>(
      builder: (context, state) {
        return state.title;
      },
    ),
    backgroundColor: Theme.of(context).colorScheme.onPrimary,
    elevation: 0,
    scrolledUnderElevation: 0.0,
  );
}

AppBar appBarWithButton(
  BuildContext context,
  String text,
  void Function() onPressed,
) {
  return AppBar(
    title: BlocBuilder<AppBarBloc, AppBarState>(
      builder: (context, state) {
        return state.title;
      },
    ),
    backgroundColor: Theme.of(context).colorScheme.onPrimary,
    elevation: 0,
    scrolledUnderElevation: 0.0,
    actions: [
      TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.secondary),
        child: Text(
          text,
          style: const TextStyle(fontSize: 18.0),
        ),
      )
    ],
  );
}
