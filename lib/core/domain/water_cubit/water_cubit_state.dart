import 'package:hydrate/core/data/models/daily_model.dart';
import 'package:hydrate/core/data/models/water_model.dart';

abstract class WaterCubitState {}

class WaterCubitInitial extends WaterCubitState {}

class WaterCubitLoading extends WaterCubitState {}

class WaterCubitLoaded extends WaterCubitState {
  final List<WaterModel> drinks;
  final List<DailyModel> daylis;

  WaterCubitLoaded({
    required this.drinks,
    required this.daylis,
  });
}

class WaterCubitDateLoaded extends WaterCubitState {
  final List<WaterModel> drinks;
  final DateTime date;

  WaterCubitDateLoaded({required this.drinks, required this.date});
}

class WaterCubitError extends WaterCubitState {
  final String error;

  WaterCubitError(this.error);
}
