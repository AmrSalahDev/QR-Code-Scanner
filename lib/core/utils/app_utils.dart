import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_sacnner_app/core/utils/custom_dialogs.dart';
import 'package:share_plus/share_plus.dart';

class AppUtils {
  static void openWifiSettings() {
    if (Platform.isAndroid) {
      final intent = AndroidIntent(
        action: 'android.settings.WIFI_SETTINGS',
        flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
      );
      intent.launch();
    }
  }

  static Future<String> getAppPackageName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.packageName;
  }

  static Future<void> openAppSettings() async {
    if (Platform.isAndroid) {
      final intent = AndroidIntent(
        action: 'android.settings.APPLICATION_DETAILS_SETTINGS',
        data: 'package:${await getAppPackageName()}',
        flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
      );
      await intent.launch();
    }
  }

  static void requestStoragePermission(BuildContext context) async {
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      print('Permission not granted');
      return;
    }
  }

  static Future<bool> checkStoragePermission() {
    return Permission.storage.isGranted;
  }

  static Future<Uint8List> widgetToImage(GlobalKey globalKey) async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await (image.toByteData(
      format: ui.ImageByteFormat.png,
    ));
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    return pngBytes;
  }

  static Future<void> shareQrCode(GlobalKey globalKey) async {
    try {
      Uint8List pngBytes = await widgetToImage(globalKey);

      // Save image temporarily
      final directory = await getTemporaryDirectory();
      String filePath =
          '${directory.path}/qr_${DateTime.now().millisecondsSinceEpoch}.png';
      File imgFile = File(filePath);
      await imgFile.writeAsBytes(pngBytes);

      // Share using share_plus
      final shareParams = ShareParams(
        files: [XFile(filePath)],
        text: 'Here is my QR code!',
      );
      await SharePlus.instance.share(shareParams);
      //final result = await SharePlus.instance.share(shareParams);

      // if (result.status == ShareResultStatus.dismissed) {
      //   CustomDialogs.showSuccessDialog(
      //     context: globalKey.currentContext!,
      //     title: 'Success',
      //     desc: 'QR code shared successfully!',
      //     btnLabel: 'OK',
      //     onTap: () {},
      //   );
      // } else {
      //   CustomDialogs.showErrorDialog(
      //     context: globalKey.currentContext!,
      //     title: 'Oops!',
      //     desc: 'Failed to share QR code.',
      //     btnLabel: 'OK',
      //     onTap: () {},
      //   );
      // }
    } catch (e) {
      CustomDialogs.showErrorDialog(
        context: globalKey.currentContext!,
        title: 'Error',
        desc: 'Failed to share QR code.',
        btnLabel: 'OK',
        onTap: () {},
      );
    }
  }

  static Future<void> saveQrCode(GlobalKey globalKey) async {
    try {
      requestStoragePermission(globalKey.currentContext!);

      Uint8List byteData = await widgetToImage(globalKey);
      final result = await ImageGallerySaverPlus.saveImage(
        byteData,
        quality: 100,
      );
      if (result['isSuccess'] == true) {
        CustomDialogs.showSuccessDialog(
          context: globalKey.currentContext!,
          title: 'Success',
          desc: 'QR code saved successfully!',
          btnLabel: 'OK',
          onTap: () {},
        );
      } else {
        CustomDialogs.showErrorDialog(
          context: globalKey.currentContext!,
          title: 'Failed to save QR code.',
          desc: 'Please give app permission to save QR code.',
          btnLabel: 'OK',
          onTap: () {
            openAppSettings();
          },
          cancelLabel: 'Cancel',
          onCancel: () {},
        );
      }
    } catch (e) {
      CustomDialogs.showErrorDialog(
        context: globalKey.currentContext!,
        title: 'Oops!',
        desc: 'Failed to save QR code.',
        btnLabel: 'OK',
        onTap: () {},
      );
    }
  }

  static String formatDateTime(DateTime dateTime) {
    final formattedDate = DateFormat.yMMMMd().format(dateTime);
    final formattedTime = DateFormat('jm').format(dateTime);
    return '$formattedDate, $formattedTime';
  }
}
