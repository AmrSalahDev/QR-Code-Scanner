import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'view_qr_data_state.dart';

class ViewQrDataCubit extends Cubit<String> {
  ViewQrDataCubit() : super('Text');

  void setType(String type) {
    emit(type.toLowerCase());
  }
}
