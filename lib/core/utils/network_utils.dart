import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

class NetWorkUtils {
  static Future<bool> isConnectedToInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      return false; // Not connected to any network
    }

    try {
      // Try to ping a reliable host
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true; // Connected to internet
      }
    } on SocketException catch (_) {
      return false; // Connected to a network but no internet
    }

    return false;
  }

  Future<String> getConnectionStatus() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      return 'Not connected'; // Not connected to any network
    }

    try {
      // Try to ping a reliable host
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return 'Connected'; // Connected to internet
      }
    } on SocketException catch (_) {
      return 'No internet'; // Connected to a network but no internet
    }

    return 'Unknown';
  }
}
