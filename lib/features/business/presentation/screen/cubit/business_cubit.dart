import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:qr_code_sacnner_app/features/business/domain/entities/business_entity.dart';
import 'package:qr_code_sacnner_app/features/business/domain/usecases/generate_business_qr_usecase.dart';
import 'package:qr_code_sacnner_app/features/business/domain/usecases/validate_business_inputs_usecase.dart';

part 'business_state.dart';

class BusinessCubit extends Cubit<BusinessState> {
  final GenerateBusinessQrUseCase generateBusinessQrUseCase;
  final ValidateBusinessInputsUsecase validateBusinessInputsUsecase;
  BusinessCubit(
    this.generateBusinessQrUseCase,
    this.validateBusinessInputsUsecase,
  ) : super(BusinessInitial());

  void submit(BusinessEntity business) {
    final error = validateBusinessInputsUsecase.execute(business);
    if (error != null) {
      emit(BusinessFormError(message: error));
      return;
    }
    final qrCode = generateBusinessQrUseCase.execute(business);
    emit(BusinessFormSuccess(qrCode: qrCode));
  }
}
