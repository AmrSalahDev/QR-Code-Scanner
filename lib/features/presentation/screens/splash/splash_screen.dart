import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code_sacnner_app/core/color/app_color.dart';
import 'package:qr_code_sacnner_app/core/constant/app_icons.dart';
import 'package:qr_code_sacnner_app/core/extensions/context_extensions.dart';
import 'package:qr_code_sacnner_app/core/routes/app_router.dart';
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
      context.go(AppRouter.scan);
    });
  }

  @override
  Widget build(BuildContext context) {
    return NavBarColorWrapper(
      navBarColor: AppColor.primaryColor,
      iconBrightness: Brightness.light,
      statusBarColor: AppColor.primaryColor,
      statusBarBrightness: Brightness.light,
      child: Scaffold(
        backgroundColor: AppColor.primaryColor,

        body: Center(
          child: SvgPicture.asset(
            height: context.screenHeight * 0.3,
            width: context.screenWidth * 0.3,
            AppIcons.qrCodeLogo,
            colorFilter: ColorFilter.mode(
              AppColor.secondaryColor,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
