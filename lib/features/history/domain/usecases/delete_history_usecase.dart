import 'package:qr_code_sacnner_app/features/history/domain/repositories/history_repository.dart';

class DeleteHistoryUseCase {
  final HistoryRepository repository;
  DeleteHistoryUseCase(this.repository);
  Future<void> call(String id) async {
    return await repository.deleteHistory(id);
  }
}
