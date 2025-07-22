import 'package:qr_code_sacnner_app/features/history/domain/entities/history_entity.dart';
import 'package:qr_code_sacnner_app/features/history/domain/repositories/history_repository.dart';

class AddHistoryUseCase {
  final HistoryRepository repository;
  AddHistoryUseCase(this.repository);
  Future<void> call(HistoryEntity historyEntity) async {
    return await repository.addHistory(historyEntity);
  }
}
