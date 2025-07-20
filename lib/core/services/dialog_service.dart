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
import 'package:qr_code_sacnner_app/features/widgets/common_button.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DialogService {
  void showCreateWifiDialog({
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
      dialogType: DialogType.noHeader,
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
              decoration: _buildInputDecoration(AppStrings.wifiHint),
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
              decoration: _buildInputDecoration(AppStrings.passwordHint),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: CommonButton(
                btnLabel: AppStrings.generateQrCode,
                onTap: () {
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

  void showSimpleDialog({
    required BuildContext context,
    required String labelText,
    required String svgPath,
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
            SvgPicture.asset(
              svgPath,
              width: 100,
              height: 100,
              colorFilter: ColorFilter.mode(
                AppColor.secondaryColor,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(height: 30),
            TextField(
              controller: controller,
              cursorColor: AppColor.secondaryColor,
              style: TextStyle(color: AppColor.secondaryColor),
              decoration: _buildInputDecoration(labelText),
            ),
            SizedBox(height: 30),
            CommonButton(
              onTap: () {
                if (controller.text.isEmpty) {
                  showToast(
                    AppStrings.inputCannotBeEmpty,
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
              btnLabel: btnLabel,
            ),
          ],
        ),
      ),
    ).show();
  }

  InputDecoration _buildInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: AppColor.hintColor),
      border: _inputBorder(),
      focusedBorder: _inputBorder(),
      enabledBorder: _inputBorder(),
    );
  }

  OutlineInputBorder _inputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(color: AppColor.secondaryColor),
    );
  }

  void showSuccessDialog({
    required BuildContext context,
    required String title,
    required String desc,
    required String btnLabel,
    String cancelLabel = AppStrings.cancel,
    VoidCallback? onTap,
    VoidCallback? onCancel,
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
      animType: AnimType.bottomSlide,
      title: title,
      desc: desc,
      btnOkText: btnLabel,
      btnOkColor: AppColor.secondaryColor,
      btnOkOnPress: () {
        if (onTap != null) onTap();
      },
      btnCancelText: cancelLabel,
      btnCancelColor: AppColor.secondaryColor,
      btnCancelOnPress: () {
        if (onCancel != null) onCancel();
      },
      onDismissCallback: onDismissCallback,
    ).show();
  }

  void showInfoDialog({
    required BuildContext context,
    required String title,
    required String desc,
    required String btnLabel,
    VoidCallback? onTap,
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
        if (onTap != null) onTap();
      },
      onDismissCallback: onDismissCallback,
    ).show();
  }

  void showErrorDialog({
    required BuildContext context,
    String title = AppStrings.oops,
    required String desc,
    String btnLabel = AppStrings.ok,
    VoidCallback? onTap,
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
        if (onTap != null) onTap();
      },
      btnCancelText: cancelLabel,
      btnCancelColor: AppColor.secondaryColor,
      btnCancelOnPress: onCancel,
      onDismissCallback: onDismissCallback,
    ).show();
  }

  void showWarningDialog({
    required BuildContext context,
    String title = AppStrings.oops,
    required String desc,
    String btnLabel = AppStrings.ok,
    VoidCallback? onTap,
    VoidCallback? onCancel,
    String? cancelLabel,
    dismissOnTouchOutside = true,
    Function(DismissType)? onDismissCallback,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.bottomSlide,
      title: title,
      desc: desc,
      btnOkText: btnLabel,
      dismissOnTouchOutside: dismissOnTouchOutside,
      btnOkColor: AppColor.secondaryColor,
      btnOkOnPress: () {
        if (onTap != null) onTap();
      },
      btnCancelText: cancelLabel,
      btnCancelColor: AppColor.secondaryColor,
      btnCancelOnPress: onCancel,
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

  void showQRcodeDialog(BuildContext context, String qrData, String type) {
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
