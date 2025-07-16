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
      return 'vCard (Contact)';
    } else {
      return 'Text';
    }
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
