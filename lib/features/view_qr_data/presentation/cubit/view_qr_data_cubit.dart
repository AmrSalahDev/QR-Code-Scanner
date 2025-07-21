import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'view_qr_data_state.dart';

class ViewQrDataCubit extends Cubit<ViewQrDataState> {
  ViewQrDataCubit() : super(ViewQrDataInitial());
}
