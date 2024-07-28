import 'package:flutter/foundation.dart';

@immutable
abstract class AppState {
  final bool isLoading;
  final String? loadingText;

  const AppState({
    required this.isLoading,
    this.loadingText = 'Please wait a moment',
  });
}

class AppStateStart extends AppState {
  const AppStateStart({required super.isLoading});
}
