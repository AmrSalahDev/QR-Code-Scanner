// features/history/domain/repositories/history_repository.dart
import '../entities/history_entity.dart';

abstract class HistoryRepository {
  Future<List<HistoryEntity>> getAllHistories();
  Future<void> deleteHistory(String id);
  Future<void> addHistory(HistoryEntity entity);
}
