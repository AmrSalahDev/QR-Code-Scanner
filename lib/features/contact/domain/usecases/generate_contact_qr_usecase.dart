import 'package:qr_code_sacnner_app/features/contact/domain/entities/contact_entity.dart';

class GenerateContactQrUseCase {
  String execute(ContactEntity contact) {
    return '''
BEGIN:VCARD
VERSION:3.0
N:${contact.lastName};${contact.firstName}
FN:${contact.firstName} ${contact.lastName}
ORG:${contact.company}
TITLE:${contact.job}
TEL:${contact.phone}
EMAIL:${contact.email}
URL:${contact.website}
ADR;TYPE=home:;;${contact.address};${contact.city};;${contact.postalCode};${contact.country}
END:VCARD''';
  }
}
