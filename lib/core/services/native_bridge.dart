import 'package:flutter/services.dart';

class NativeBridge {
  static const _channel = MethodChannel('vcard_channel');

  static Future<void> insertContactFromVCard(String vCardContent) async {
    try {
      await _channel.invokeMethod('insertContactFromVCard', {
        'vcard': vCardContent,
      });
    } on PlatformException catch (e) {
      print("Failed to open vCard: ${e.message}");
    }
  }
}
