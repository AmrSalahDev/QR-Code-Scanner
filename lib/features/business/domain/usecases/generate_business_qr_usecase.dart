import 'package:qr_code_sacnner_app/features/business/domain/entities/business_entity.dart';

class GenerateBusinessQrUseCase {
  String execute(BusinessEntity business) {
    return 'BUSINESS CARD\nCompany: ${business.company}\nIndustry: ${business.industry}\nEmail: ${business.email}\nPhone: ${business.phone}\nWebsite: ${business.website}\nAddress: ${business.address}\nCity: ${business.city}\nCountry: ${business.country}';
  }
}
