part of 'history_cubit.dart';

abstract class HistoryState {}

final class HistoryInitial extends HistoryState {}

final class HistoryLoading extends HistoryState {}

final class HistoryLoaded extends HistoryState {
  final List<HistoryModel> histories;
  HistoryLoaded(this.histories);
}

final class HistoryFailure extends HistoryState {
  final String message;
  HistoryFailure(this.message);
}

final class HistoryDeleteSuccess extends HistoryState {}

final class HistoryDeleteFailure extends HistoryState {
  final String message;
  final String id;
  HistoryDeleteFailure(this.message, this.id);
}

final class HistoryDeleteLoading extends HistoryState {}
