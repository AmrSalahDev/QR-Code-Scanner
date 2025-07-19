import 'package:qr_code_sacnner_app/core/constant/app_strings.dart';
import 'package:qr_code_sacnner_app/features/contact/domain/entities/contact_entity.dart';

class ValidateContactInputs {
  String? execute(ContactEntity contact) {
    switch (contact) {
      case ContactEntity(firstName: var firstName)
          when firstName.trim().isEmpty:
        return AppStrings.firstNameCannotEmpty;
      case ContactEntity(lastName: var lastName) when lastName.trim().isEmpty:
        return AppStrings.lastNameCannotEmpty;
      case ContactEntity(phone: var phone) when phone.trim().isEmpty:
        return AppStrings.phoneCannotEmpty;
      default:
        return null;
    }
  }
}
