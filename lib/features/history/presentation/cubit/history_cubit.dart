import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:qr_code_sacnner_app/core/constant/app_constant.dart';
import 'package:qr_code_sacnner_app/core/constant/app_strings.dart';
import 'package:qr_code_sacnner_app/features/history/data/models/history_model.dart';
part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super(HistoryInitial());

  void loadHistories() {
    emit(HistoryLoading());
    Future.delayed(const Duration(seconds: 3));
    final box = Hive.box<HistoryModel>(AppConstant.hiveBoxHistory);
    final histories = box.values.toList();
    emit(HistoryLoaded(histories));
  }

  Future<void> deleteHistory(String id) async {
    emit(HistoryLoading());
    Future.delayed(const Duration(seconds: 3));
    try {
      final box = Hive.box<HistoryModel>(AppConstant.hiveBoxHistory);
      final key = box.keys.firstWhere(
        (key) => box.get(key)?.id == id,
        orElse: () => null,
      );

      if (key != null) {
        await box.delete(key);
        loadHistories(); // Refresh list
      }
    } catch (e) {
      emit(HistoryDeleteFailure(AppStrings.failedDeleteHistory, id));
    }
  }
}
