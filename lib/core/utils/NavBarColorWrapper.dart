import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_sacnner_app/core/color/app_color.dart';

class NavBarColorWrapper extends StatelessWidget {
  final Widget child;
  final Color? navBarColor;
  final Brightness? iconBrightness;
  final Brightness? statusBarBrightness;
  final Color? statusBarColor;

  const NavBarColorWrapper({
    super.key,
    required this.child,
    this.navBarColor = AppColor.primaryColor,
    this.iconBrightness = Brightness.light,
    this.statusBarBrightness = Brightness.light,
    this.statusBarColor = AppColor.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: navBarColor,
        systemNavigationBarIconBrightness: iconBrightness,
        statusBarBrightness: statusBarBrightness,
        statusBarColor: statusBarColor,
      ),
      child: child,
    );
  }
}
