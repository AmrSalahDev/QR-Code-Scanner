import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_sacnner_app/core/color/app_color.dart';
import 'package:qr_code_sacnner_app/core/constant/app_strings.dart';

class NetworkAwareWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback? onOffline;
  final VoidCallback? onOnline;

  const NetworkAwareWidget({
    super.key,
    required this.child,
    this.onOffline,
    this.onOnline,
  });

  @override
  State<NetworkAwareWidget> createState() => _NetworkAwareWidgetState();
}

class _NetworkAwareWidgetState extends State<NetworkAwareWidget> {
  late StreamSubscription _subscription;
  bool _wasConnected = true;

  @override
  void initState() {
    super.initState();
    _subscription = Connectivity().onConnectivityChanged.listen((result) async {
      bool isConnected = await _checkInternet();
      if (!isConnected && _wasConnected) {
        _showSnackBar(AppStrings.noInternetConnection);
        widget.onOffline?.call(); // 🔴 Trigger offline action
      } else if (isConnected && !_wasConnected) {
        _showSnackBar(AppStrings.backOnline);
        widget.onOnline?.call(); // 🟢 Trigger online action
      }
      _wasConnected = isConnected;
    });
  }

  Future<bool> _checkInternet() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, textAlign: TextAlign.center),
        backgroundColor: AppColor.primaryColor,
      ),
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
