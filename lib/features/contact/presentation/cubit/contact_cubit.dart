import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_sacnner_app/features/contact/domain/entities/contact_entity.dart';
import 'package:qr_code_sacnner_app/features/contact/domain/usecases/generate_contact_qr_usecase.dart';
import 'package:qr_code_sacnner_app/features/contact/domain/usecases/validate_contact_inputs.dart';

part 'contact_state.dart';

class ContactCubit extends Cubit<ContactState> {
  final GenerateContactQrUseCase generateContactQrUseCase;
  final ValidateContactInputs validateContactInputs;
  ContactCubit(this.generateContactQrUseCase, this.validateContactInputs)
    : super(ContactInitial());

  void submit(ContactEntity contact) {
    final error = validateContactInputs.execute(contact);
    if (error != null) {
      emit(ContactFormError(message: error));
      return;
    }
    final qrCode = generateContactQrUseCase.execute(contact);
    emit(ContactFormSuccess(qrCode: qrCode));
  }
}
