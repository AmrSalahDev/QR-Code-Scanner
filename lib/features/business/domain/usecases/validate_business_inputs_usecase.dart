import 'package:qr_code_sacnner_app/core/constant/app_strings.dart';
import 'package:qr_code_sacnner_app/features/business/domain/entities/business_entity.dart';

class ValidateBusinessInputsUsecase {
  String? execute(BusinessEntity business) {
    switch (business) {
      case BusinessEntity(company: var company) when company.trim().isEmpty:
        return AppStrings.companyCannotEmpty;
      case BusinessEntity(email: var email) when email.trim().isEmpty:
        return AppStrings.emailCannotEmpty;
      case BusinessEntity(phone: var phone) when phone.trim().isEmpty:
        return AppStrings.phoneCannotEmpty;
      case BusinessEntity(website: var website) when website.trim().isEmpty:
        return AppStrings.websiteCannotEmpty;
      case BusinessEntity(address: var address) when address.trim().isEmpty:
        return AppStrings.addressCannotEmpty;
      default:
        return null;
    }
  }
}
