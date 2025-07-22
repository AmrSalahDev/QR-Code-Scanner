import 'package:qr_code_sacnner_app/core/constant/app_strings.dart';

class BarcodeUtils {
  static Map<String, String>? _parseWifiBarcode(String data) {
    try {
      final ssid = RegExp(r'S:([^;]*)').firstMatch(data)?.group(1) ?? '';
      final type = RegExp(r'T:([^;]*)').firstMatch(data)?.group(1) ?? '';
      final password = RegExp(r'P:([^;]*)').firstMatch(data)?.group(1) ?? '';
      return {'ssid': ssid, 'type': type, 'password': password};
    } catch (_) {
      return null;
    }
  }

  static String? getWifiSsid(String data) => _parseWifiBarcode(data)?['ssid'];

  static String? getWifiPassword(String data) =>
      _parseWifiBarcode(data)?['password'];

  static String? getWifiType(String data) => _parseWifiBarcode(data)?['type'];

  static String getQrCodeType(String code) {
    final lower = code.toLowerCase();

    if (lower.startsWith('http://') || lower.startsWith('https://')) {
      return 'URL';
    } else if (lower.startsWith('wifi:')) {
      return 'WiFi';
    } else if (lower.startsWith('mailto:')) {
      return 'Email';
    } else if (lower.startsWith('tel:')) {
      return 'Phone';
    } else if (lower.startsWith('sms:')) {
      return 'SMS';
    } else if (lower.startsWith('geo:')) {
      return 'Geo Location';
    } else if (lower.contains('begin:vcard')) {
      return 'Contact';
    } else {
      return 'Text';
    }
  }

  static String generateQRCode(String label, String input) {
    String qrData = '';

    switch (label) {
      case 'Text':
        qrData = input;
        break;
      case 'Website':
        qrData = input.startsWith('http') ? input : 'https://$input';
        break;
      case 'Whatsapp':
        qrData = 'https://wa.me/$input';
        break;
      case 'Email':
        qrData = 'mailto:$input';
        break;
      case 'Instagram':
        qrData = 'https://instagram.com/$input';
        break;
      case 'Twitter':
        qrData = 'https://twitter.com/$input';
        break;
      case 'Location':
        qrData = 'https://www.google.com/maps/search/?api=1&query=$input';
        break;
      case 'Phone':
        qrData = 'tel:$input';
        break;
      case 'Event':
        qrData = input;
        break;
      case AppStrings.wifi:
        qrData = input;
        break;
      default:
        qrData = input;
    }

    return qrData;
  }

  static bool isWifiBarcode(String data) =>
      data.toLowerCase().startsWith('wifi:');

  static bool isUrl(String data) =>
      data.toLowerCase().startsWith('http://') ||
      data.toLowerCase().startsWith('https://');

  static bool isEmail(String data) => data.toLowerCase().startsWith('mailto:');

  static bool isPhone(String data) => data.toLowerCase().startsWith('tel:');

  static bool isSms(String data) => data.toLowerCase().startsWith('sms:');

  static bool isGeo(String data) => data.toLowerCase().startsWith('geo:');

  static bool isVCard(String data) =>
      data.toLowerCase().contains('begin:vcard');

  static bool isText(String data) =>
      !isWifiBarcode(data) &&
      !isUrl(data) &&
      !isEmail(data) &&
      !isPhone(data) &&
      !isSms(data) &&
      !isGeo(data) &&
      !isVCard(data);
}
