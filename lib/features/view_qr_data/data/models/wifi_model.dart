class WifiModel {
  final String ssid;
  final String password;
  final String type;

  WifiModel({required this.ssid, required this.password, required this.type});

  factory WifiModel.fromRaw(String data) {
    final ssidMatch = RegExp(r'S:([^;]*)').firstMatch(data);
    final typeMatch = RegExp(r'T:([^;]*)').firstMatch(data);
    final passwordMatch = RegExp(r'P:([^;]*)').firstMatch(data);

    final ssid = ssidMatch?.group(1) ?? '';
    final type = typeMatch?.group(1) ?? '';
    final password = passwordMatch?.group(1) ?? '';

    return WifiModel(ssid: ssid, password: password, type: type);
  }
}
