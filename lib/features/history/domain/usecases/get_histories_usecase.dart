import 'package:qr_code_sacnner_app/features/history/domain/entities/history_entity.dart';
import 'package:qr_code_sacnner_app/features/history/domain/repositories/history_repository.dart';

class GetHistoriesUseCase {
  final HistoryRepository repository;

  GetHistoriesUseCase(this.repository);

  Future<List<HistoryEntity>> call() async {
    return await repository.getAllHistories();
  }
}
