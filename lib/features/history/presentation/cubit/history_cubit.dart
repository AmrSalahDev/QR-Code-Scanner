import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_sacnner_app/core/constant/app_strings.dart';
import 'package:qr_code_sacnner_app/features/history/domain/usecases/delete_history_usecase.dart';
import 'package:qr_code_sacnner_app/features/history/domain/usecases/get_histories_usecase.dart';
import 'package:qr_code_sacnner_app/features/history/presentation/dto/history_view_data.dart';
part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final GetHistoriesUseCase getHistoriesUseCase;
  final DeleteHistoryUseCase deleteHistoryUseCase;
  HistoryCubit(this.getHistoriesUseCase, this.deleteHistoryUseCase)
    : super(HistoryInitial());

  Future<void> loadHistories() async {
    try {
      emit(HistoryLoading());
      final entities = await getHistoriesUseCase();
      final viewData = entities.map(HistoryViewData.fromEntity).toList();
      emit(HistoryLoaded(viewData));
    } catch (e) {
      emit(HistoryFailure(e.toString()));
    }
  }

  Future<void> deleteHistory(String id) async {
    try {
      await deleteHistoryUseCase(id);
      await loadHistories();
      // Optionally: show a small transient success state
      // emit(HistoryDeleteSuccess(id));
    } catch (e) {
      emit(HistoryDeleteFailure(AppStrings.failedDeleteHistory, id));
    }
  }
}
