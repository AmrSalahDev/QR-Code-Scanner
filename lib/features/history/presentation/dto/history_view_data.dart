// presentation/dtos/history_view_data.dart
import 'package:qr_code_sacnner_app/core/utils/app_utils.dart';
import 'package:qr_code_sacnner_app/core/utils/qr_code_utils.dart';
import 'package:qr_code_sacnner_app/features/history/domain/entities/history_entity.dart';

class HistoryViewData {
  final String id;
  final String title;
  final String content;
  final String formattedDate;
  final String type;

  const HistoryViewData({
    required this.id,
    required this.title,
    required this.content,
    required this.formattedDate,
    required this.type,
  });

  static HistoryViewData fromEntity(HistoryEntity entity) => HistoryViewData(
    id: entity.id,
    title: entity.title,
    content: entity.content,
    formattedDate: AppUtils.formatDateTime(entity.date),
    type: BarcodeUtils.getQrCodeType(entity.content),
  );
}
