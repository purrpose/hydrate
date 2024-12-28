import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrate/core/data/models/daily_model.dart';
import 'package:hydrate/core/data/models/water_model.dart';
import 'package:hydrate/core/data/repository/water_repository.dart';
import 'package:hydrate/core/domain/water_cubit/water_cubit_state.dart';
import 'package:rxdart/rxdart.dart';

class WaterCubit extends Cubit<WaterCubitState> {
  final WaterRepository _repository;

  WaterCubit(this._repository) : super(WaterCubitInitial());

  Future<String?> getUid() => _repository.getUid();

  void loadDrinksAndDailys() {
    emit(WaterCubitLoading());

    // Загрузка данных из обеих коллекций
    final drinksStream = _repository.getDrinks();
    final dailysStream = _repository.getDailys();

    Rx.combineLatest2<List<WaterModel>, List<DailyModel>, WaterCubitLoaded>(
      drinksStream,
      dailysStream,
      (drinks, daylis) => WaterCubitLoaded(drinks: drinks, daylis: daylis),
    ).listen(
      (loadedState) {
        emit(loadedState);
      },
      onError: (error) {
        emit(WaterCubitError(error.toString()));
      },
    );
  }

  Future<void> loadDrinksForDate(DateTime date) async {
    try {
      emit(WaterCubitLoading());
      final drinks = await _repository.getDrinksForDate(date);
      emit(WaterCubitDateLoaded(drinks: drinks, date: date));
    } catch (e) {
      emit(WaterCubitError(e.toString()));
    }
  }

  Future<void> addDrink(int amountTaken, DateTime date, String uid) async {
    try {
      await _repository.addDrink(amountTaken, date, uid);
    } catch (e) {
      emit(WaterCubitError(e.toString()));
    }
  }

  Future<void> updateDailyAmount(int dailyAmount, String id) async {
    try {
      await _repository.addDailyAmount(dailyAmount, id);
    } catch (e) {
      emit(WaterCubitError(e.toString()));
    }
  }

  Future<void> deleteDailyAmount(String id) async {
    try {
      await _repository.deleteDailyAmount(id);
    } catch (e) {
      emit(WaterCubitError(e.toString()));
    }
  }

  Future<void> deleteDrink(String drinkId) async {
    try {
      await _repository.deleteDrink(drinkId);
    } catch (e) {
      emit(WaterCubitError(e.toString()));
    }
  }

  void reset() {
    emit(WaterCubitInitial());
  }
}
