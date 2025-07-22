part of 'history_cubit.dart';

abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<HistoryViewData> histories;

  HistoryLoaded(this.histories);
}

class HistoryFailure extends HistoryState {
  final String message;

  HistoryFailure(this.message);
}

class HistoryDeleteSuccess extends HistoryState {
  final String id;

  HistoryDeleteSuccess(this.id);
}

class HistoryDeleteFailure extends HistoryState {
  final String id;
  final String message;

  HistoryDeleteFailure(this.id, this.message);
}
