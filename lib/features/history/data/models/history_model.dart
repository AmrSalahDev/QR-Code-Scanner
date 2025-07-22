import 'package:hive/hive.dart';
import 'package:qr_code_sacnner_app/features/history/domain/entities/history_entity.dart';

part 'history_model.g.dart';

@HiveType(typeId: 54)
class HistoryModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String content;

  @HiveField(3)
  final DateTime date;

  HistoryModel({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
  });

  HistoryEntity toEntity() =>
      HistoryEntity(id: id, title: title, content: content, date: date);

  factory HistoryModel.fromEntity(HistoryEntity entity) {
    return HistoryModel(
      id: entity.id,
      title: entity.title,
      content: entity.content,
      date: entity.date,
    );
  }

  @override
  String toString() {
    return 'HistoryModel{id: $id, title: $title, content: $content, date: $date}';
  }
}
