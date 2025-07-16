class HistoryModel {
  final String id;
  final String title;
  final String content;
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
