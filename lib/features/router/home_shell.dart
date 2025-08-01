import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code_sacnner_app/core/color/app_color.dart';
import 'package:qr_code_sacnner_app/core/constant/app_strings.dart';
import 'package:qr_code_sacnner_app/core/routes/app_router.dart';

class HomeShell extends StatelessWidget {
  final Widget child;
  const HomeShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: child,
      bottomNavigationBar: ConvexAppBar(
        height: 55,
        style: TabStyle.fixedCircle,
        activeColor: AppColor.secondaryColor,
        initialActiveIndex: 1,
        backgroundColor: AppColor.primaryColor,
        items: const [
          TabItem(icon: Icons.qr_code, title: AppStrings.generate),
          TabItem(icon: Icons.qr_code_scanner, title: AppStrings.scan),
          TabItem(icon: Icons.history, title: AppStrings.history),
        ],
        onTap: (int i) {
          if (i == 0) {
            context.go(AppRouter.generate);
          } else if (i == 1) {
            context.go(AppRouter.scan);
          } else if (i == 2) {
            context.go(AppRouter.history);
          }
        },
      ),
    );
  }
}
