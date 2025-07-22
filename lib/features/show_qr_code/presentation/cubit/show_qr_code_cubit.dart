import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'show_qr_code_state.dart';

class ShowQrCodeCubit extends Cubit<ShowQrCodeState> {
  ShowQrCodeCubit() : super(ShowQrCodeInitial());
}
