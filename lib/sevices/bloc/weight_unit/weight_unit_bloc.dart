import 'package:bloc/bloc.dart';
import 'package:liftday/sevices/settings/settings_service.dart';

abstract class WeightUnitEvent {}

class ChangeWeightUnit extends WeightUnitEvent {
  final String unit;
  ChangeWeightUnit(this.unit);
}

class WeightUnitState {
  final String unit;
  WeightUnitState(this.unit);
}

class WeightUnitBloc extends Bloc<WeightUnitEvent, WeightUnitState> {
  WeightUnitBloc() : super(WeightUnitState("kg")) {
    _loadThemePreference();

    on<ChangeWeightUnit>((event, emit) {
      SettingsService settingsService = SettingsService();
      if (event.unit == "lbs") {
        settingsService.setWeightUnit('lbs');
      } else {
        settingsService.setWeightUnit('kg');
      }
      emit(WeightUnitState(event.unit));
    });
  }

  void _loadThemePreference() async {
    SettingsService settingsService = SettingsService();
    await settingsService.init();
    final unit = settingsService.weightUnit();
    if (unit == "kg") {
      add(ChangeWeightUnit("kg"));
    } else if (unit == "lbs") {
      add(ChangeWeightUnit("lbs"));
    }
  }
}
