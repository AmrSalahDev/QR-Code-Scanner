import 'package:hive/hive.dart';
import 'package:qr_code_sacnner_app/core/constant/app_constant.dart';
import 'package:qr_code_sacnner_app/features/history/domain/entities/history_entity.dart';
import 'package:qr_code_sacnner_app/features/history/domain/repositories/history_repository.dart';
import 'package:qr_code_sacnner_app/features/history/data/models/history_model.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final Box<HistoryModel> _historyBox = Hive.box<HistoryModel>(
    AppConstant.hiveBoxHistory,
  );

  @override
  Future<List<HistoryEntity>> getAllHistories() async {
    final models = _historyBox.values.toList();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> deleteHistory(String id) async {
    try {
      final box = Hive.box<HistoryModel>(AppConstant.hiveBoxHistory);
      final key = box.keys.firstWhere(
        (key) => box.get(key)?.id == id,
        orElse: () => null,
      );

      if (key != null) {
        await box.delete(key);
      }
    } catch (e) {
      throw Exception('Failed to delete history: $e');
    }
  }

  @override
  Future<void> addHistory(HistoryEntity entity) async {
    final newModel = HistoryModel.fromEntity(entity);
    await _historyBox.add(newModel);
  }
}
