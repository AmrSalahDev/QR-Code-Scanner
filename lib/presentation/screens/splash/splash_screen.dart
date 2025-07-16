import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code_sacnner_app/core/color/app_color.dart';
import 'package:qr_code_sacnner_app/core/utils/NavBarColorWrapper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      context.go('/scan');
    });
  }

  @override
  Widget build(BuildContext context) {
    const String assetName = 'assets/images/qr_code_logo.svg';
    final Widget svg = SvgPicture.asset(
      height: 200,
      width: 200,
      assetName,
      semanticsLabel: 'Dart Logo',
      colorFilter: ColorFilter.mode(AppColor.secondaryColor, BlendMode.srcIn),
    );

    return NavBarColorWrapper(
      navBarColor: AppColor.primaryColor,
      iconBrightness: Brightness.light,
      child: Scaffold(
        backgroundColor: AppColor.primaryColor,

        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [svg],
            ),
          ),
        ),
      ),
    );
  }
}
