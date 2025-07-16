import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code_sacnner_app/core/color/app_color.dart';
import 'package:qr_code_sacnner_app/core/utils/NavBarColorWrapper.dart';
import 'package:qr_code_sacnner_app/core/routes/app_router.dart';

class HomeScreen extends StatelessWidget {
  final Widget child;
  const HomeScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final String currentRoute = GoRouter.of(
      context,
    ).routerDelegate.currentConfiguration.uri.toString();

    return NavBarColorWrapper(
      navBarColor: AppColor.primaryColor,
      iconBrightness: Brightness.light,
      child: Scaffold(
        backgroundColor: AppColor.primaryColor,
        body: child,
        bottomNavigationBar: ConvexAppBar(
          height: 55,
          style: TabStyle.fixedCircle,
          activeColor: AppColor.secondaryColor,
          initialActiveIndex: currentRoute == '/generate'
              ? 0
              : currentRoute == '/scan'
              ? 1
              : 0,
          backgroundColor: AppColor.primaryColor,
          items: const [
            TabItem(icon: Icons.qr_code, title: 'Generate'),
            TabItem(icon: Icons.qr_code_scanner, title: 'Scan'),
            TabItem(icon: Icons.history, title: 'History'),
          ],
          onTap: (int i) {
            if (i == 0) {
              context.go('/generate');
            } else if (i == 1) {
              if (currentRoute != '/scan') {
                context.go('/scan');
              } else {
                scanScreenKey.currentState?.startScan();
              }
            } else if (i == 2) {
              context.go('/history');
            }
          },
        ),
      ),
    );
  }
}
