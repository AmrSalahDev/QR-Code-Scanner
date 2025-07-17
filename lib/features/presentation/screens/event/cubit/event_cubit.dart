import 'package:flutter_bloc/flutter_bloc.dart';

part 'event_state.dart';

class EventCubit extends Cubit<EventState> {
  EventCubit() : super(EventInitial());

  void setStartDate(String startDate) {
    emit(EventStartDateFinished(startDate: startDate));
  }

  void setEndDate(String endDate) {
    emit(EventEndDateFinished(endDate: endDate));
  }
}
