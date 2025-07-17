import 'package:hive/hive.dart';

part 'history_model.g.dart';

@HiveType(typeId: 0) // Give each model a unique typeId
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

  @override
  String toString() {
    return 'HistoryModel{id: $id, title: $title, content: $content, date: $date}';
  }
}
