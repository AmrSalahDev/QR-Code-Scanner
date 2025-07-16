part of 'event_cubit.dart';

abstract class EventState {}

final class EventInitial extends EventState {}

final class EventStartDateFinished extends EventState {
  final String startDate;
  EventStartDateFinished({required this.startDate});
}

final class EventEndDateFinished extends EventState {
  final String endDate;
  EventEndDateFinished({required this.endDate});
}
