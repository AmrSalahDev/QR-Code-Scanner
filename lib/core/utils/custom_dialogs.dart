import 'dart:convert';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code_sacnner_app/core/color/app_color.dart';
import 'package:qr_code_sacnner_app/core/constant/app_icons.dart';
import 'package:qr_code_sacnner_app/core/constant/app_strings.dart';
import 'package:qr_code_sacnner_app/core/utils/app_utils.dart';
import 'package:qr_code_sacnner_app/features/presentation/widgets/common_button.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CustomDialogs {
  static void showSuccessDialog({
    required BuildContext context,
    required String title,
    required String desc,
    required String btnLabel,
    required VoidCallback onTap,
    Function(DismissType)? onDismissCallback,
  }) {
    AwesomeDialog(
      context: context,
      customHeader: Icon(
        Icons.check_circle,
        color: AppColor.secondaryColor,
        size: 110,
      ),
      dialogType: DialogType.success,
      animType: AnimType.scale,
      title: title,
      desc: desc,
      btnOkText: btnLabel,
      btnOkColor: AppColor.secondaryColor,
      btnOkOnPress: () {
        onTap();
      },
      onDismissCallback: onDismissCallback,
    ).show();
  }

  static void showInfoDialog({
    required BuildContext context,
    required String title,
    required String desc,
    required String btnLabel,
    required VoidCallback onTap,
    double? width,
    Function(DismissType)? onDismissCallback,
  }) {
    AwesomeDialog(
      context: context,
      customHeader: Icon(Icons.info, color: AppColor.secondaryColor, size: 110),
      dialogType: DialogType.noHeader,
      animType: AnimType.scale,
      title: title,
      width: width,
      desc: desc,
      btnOkText: btnLabel,
      btnOkColor: AppColor.secondaryColor,
      btnOkOnPress: () {
        onTap();
      },
      onDismissCallback: onDismissCallback,
    ).show();
  }

  static void showErrorDialog({
    required BuildContext context,
    required String title,
    required String desc,
    required String btnLabel,
    required VoidCallback onTap,
    VoidCallback? onCancel,
    String? cancelLabel,
    Function(DismissType)? onDismissCallback,
  }) {
    AwesomeDialog(
      context: context,
      customHeader: Icon(
        Icons.error,
        color: AppColor.secondaryColor,
        size: 110,
      ),
      dialogType: DialogType.error,
      animType: AnimType.scale,
      title: title,
      desc: desc,
      btnOkText: btnLabel,
      btnOkColor: AppColor.secondaryColor,
      btnOkOnPress: () {
        onTap();
      },
      btnCancelText: cancelLabel,
      btnCancelColor: AppColor.secondaryColor,
      btnCancelOnPress: onCancel,
      onDismissCallback: onDismissCallback,
    ).show();
  }

  static void showWarningDialog({
    required BuildContext context,
    required String title,
    required String desc,
    required String btnLabel,
    required VoidCallback onTap,
    Function(DismissType)? onDismissCallback,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.scale,
      title: title,
      desc: desc,
      btnOkText: btnLabel,
      btnOkColor: AppColor.secondaryColor,
      btnOkOnPress: () {
        onTap();
      },
      onDismissCallback: onDismissCallback,
    ).show();
  }

  static void showWifiDialog({
    required BuildContext context,
    required String ssid,
    required String password,
    required VoidCallback onOkTap,
    required VoidCallback onCancelTap,
    Function(DismissType)? onDismissCallback,
  }) {
    AwesomeDialog(
      context: context,
      customHeader: SvgPicture.asset(
        height: 100,
        width: 100,
        AppIcons.wifi_signal,
        colorFilter: ColorFilter.mode(AppColor.secondaryColor, BlendMode.srcIn),
      ),
      dialogType: DialogType.warning,
      animType: AnimType.rightSlide,
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            GestureDetector(
              child: RichText(
                text: TextSpan(
                  text: 'Name: ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: ssid,
                      style: TextStyle(
                        color: AppColor.primaryColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: ssid));
                showToast(
                  "Wifi Name copied!",
                  context: context,
                  animation: StyledToastAnimation.scale,
                  reverseAnimation: StyledToastAnimation.fade,
                  position: StyledToastPosition.bottom,
                  animDuration: Duration(seconds: 1),
                  duration: Duration(seconds: 4),
                  curve: Curves.elasticOut,
                  reverseCurve: Curves.linear,
                  backgroundColor: AppColor.secondaryColor,
                );
              },
            ),
            SizedBox(height: 10),
            GestureDetector(
              child: RichText(
                text: TextSpan(
                  text: 'Password: ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: password,
                      style: TextStyle(
                        color: AppColor.primaryColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: password));
                showToast(
                  "Wifi Password copied!",
                  context: context,
                  animation: StyledToastAnimation.scale,
                  reverseAnimation: StyledToastAnimation.fade,
                  position: StyledToastPosition.bottom,
                  animDuration: Duration(seconds: 1),
                  duration: Duration(seconds: 4),
                  curve: Curves.elasticOut,
                  reverseCurve: Curves.linear,
                  backgroundColor: AppColor.secondaryColor,
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.secondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('View code', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: onCancelTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.secondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Cancel', style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: onOkTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.secondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Connect', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      onDismissCallback: onDismissCallback,
    ).show();
  }

  static void showCreateWifiDialog({
    required BuildContext context,
    required Function(Map<String, String> wifi) onTap,
  }) {
    final wifiNameController = TextEditingController();
    final wifiPasswordController = TextEditingController();
    AwesomeDialog(
      context: context,
      dialogBackgroundColor: AppColor.primaryColor,
      customHeader: SvgPicture.asset(
        height: 100,
        width: 100,
        AppIcons.wifi_signal,
        colorFilter: ColorFilter.mode(AppColor.secondaryColor, BlendMode.srcIn),
      ),
      dialogType: DialogType.warning,
      animType: AnimType.scale,
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              AppStrings.networkName,
              style: TextStyle(color: AppColor.textColor),
            ),
            SizedBox(height: 10),
            TextField(
              controller: wifiNameController,
              cursorColor: AppColor.secondaryColor,
              style: TextStyle(color: AppColor.secondaryColor),
              decoration: InputDecoration(
                hintText: AppStrings.wifiHint,
                hintStyle: TextStyle(color: AppColor.hintColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: AppColor.secondaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: AppColor.secondaryColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: AppColor.secondaryColor),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              AppStrings.password,
              style: TextStyle(color: AppColor.textColor),
            ),
            SizedBox(height: 10),
            TextField(
              controller: wifiPasswordController,
              cursorColor: AppColor.secondaryColor,
              style: TextStyle(color: AppColor.secondaryColor),
              decoration: InputDecoration(
                hintText: AppStrings.passwordHint,
                hintStyle: TextStyle(color: AppColor.hintColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: AppColor.secondaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: AppColor.secondaryColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: AppColor.secondaryColor),
                ),
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: CommonButton(
                btnLabel: AppStrings.generateQrCode,
                onTap: () {
                  if (wifiNameController.text.isEmpty) {
                    showToast(
                      AppStrings.wifiNameCannotBeEmpty,
                      context: context,
                      animation: StyledToastAnimation.scale,
                      reverseAnimation: StyledToastAnimation.fade,
                      position: StyledToastPosition.bottom,
                      animDuration: Duration(seconds: 1),
                      duration: Duration(seconds: 4),
                      curve: Curves.elasticOut,
                      reverseCurve: Curves.linear,
                      backgroundColor: AppColor.secondaryColor,
                    );
                    return;
                  } else if (wifiPasswordController.text.isEmpty) {
                    showToast(
                      AppStrings.passwordCannotBeEmpty,
                      context: context,
                      animation: StyledToastAnimation.scale,
                      reverseAnimation: StyledToastAnimation.fade,
                      position: StyledToastPosition.bottom,
                      animDuration: Duration(seconds: 1),
                      duration: Duration(seconds: 4),
                      curve: Curves.elasticOut,
                      reverseCurve: Curves.linear,
                      backgroundColor: AppColor.secondaryColor,
                    );
                    return;
                  }
                  onTap({
                    "ssid": wifiNameController.text,
                    "password": wifiPasswordController.text,
                  });
                },
              ),
            ),
          ],
        ),
      ),
    ).show();
  }

  static void showSimpleDialog({
    required BuildContext context,
    required String labelText,
    IconData? icon,
    String? svgPath,
    required String btnLabel,
    required Function(String value) onTap,
  }) {
    final controller = TextEditingController();
    AwesomeDialog(
      dialogBackgroundColor: AppColor.primaryColor,
      dialogType: DialogType.noHeader,
      context: context,
      body: Padding(
        padding: EdgeInsets.all(25),
        child: Column(
          children: [
            svgPath != null
                ? SvgPicture.asset(
                    svgPath,
                    width: 100,
                    height: 100,
                    colorFilter: ColorFilter.mode(
                      AppColor.secondaryColor,
                      BlendMode.srcIn,
                    ),
                  )
                : Icon(icon, size: 100, color: AppColor.secondaryColor),
            SizedBox(height: 30),
            TextField(
              controller: controller,
              cursorColor: AppColor.secondaryColor,
              style: TextStyle(color: AppColor.secondaryColor),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: AppColor.secondaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: AppColor.secondaryColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: AppColor.secondaryColor),
                ),
                labelText: labelText,
                labelStyle: TextStyle(color: AppColor.textColor),
                floatingLabelStyle: TextStyle(color: AppColor.secondaryColor),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isEmpty) {
                  showToast(
                    "Please enter a value",
                    context: context,
                    animation: StyledToastAnimation.scale,
                    reverseAnimation: StyledToastAnimation.fade,
                    position: StyledToastPosition.bottom,
                    animDuration: Duration(seconds: 1),
                    duration: Duration(seconds: 4),
                    curve: Curves.elasticOut,
                    reverseCurve: Curves.linear,
                    backgroundColor: AppColor.secondaryColor,
                  );
                  return;
                }
                onTap(controller.text);
                context.pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.secondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              ),
              child: Text(btnLabel, style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    ).show();
  }

  static void showQRcodeDialog(
    BuildContext context,
    String qrData,
    String type,
  ) {
    final GlobalKey qrKey = GlobalKey();
    AwesomeDialog(
      dialogBackgroundColor: AppColor.primaryColor,
      dialogType: DialogType.noHeader,
      borderSide: BorderSide(color: AppColor.secondaryColor),
      context: context,
      body: Padding(
        padding: EdgeInsets.all(25),
        child: Column(
          children: [
            RepaintBoundary(
              key: qrKey,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 200.0,
                  backgroundColor: AppColor.secondaryColor,
                ),
              ),
            ),

            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColor.secondaryColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {
                      AppUtils.shareQrCode(qrKey);
                    },
                    icon: Icon(Icons.share, color: AppColor.primaryColor),
                  ),
                ),
                SizedBox(width: 20),
                Container(
                  decoration: BoxDecoration(
                    color: AppColor.secondaryColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {
                      AppUtils.saveQrCode(qrKey);
                    },
                    icon: Icon(Icons.save, color: AppColor.primaryColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).show();
  }
}
