import 'package:qr_code_sacnner_app/features/contact/domain/entities/contact_entity.dart';

class GenerateContactQrUseCase {
  String execute(ContactEntity contact) {
    return 'BEGIN:VCARD\nVERSION:3.0\nN:${contact.lastName};${contact.firstName}\nORG:${contact.company}\nTITLE:${contact.job}\nTEL:${contact.phone}\nEMAIL:${contact.email}\nURL:${contact.website}\nADR:${contact.address};${contact.city};${contact.country}\nEND:VCARD';
  }
}
