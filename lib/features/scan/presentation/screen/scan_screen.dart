import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:qr_code_sacnner_app/core/color/app_color.dart';
import 'package:qr_code_sacnner_app/core/constant/app_strings.dart';
import 'package:qr_code_sacnner_app/core/services/di/di.dart';
import 'package:qr_code_sacnner_app/core/services/dialog_service.dart';
import 'package:qr_code_sacnner_app/core/utils/app_utils.dart';
import 'package:qr_code_sacnner_app/features/scan/presentation/cubit/scan_cubit.dart';
import 'package:qr_code_sacnner_app/features/scan/presentation/screen/scan_ui_actions.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => ScanScreenState();
}

class ScanScreenState extends State<ScanScreen> with WidgetsBindingObserver {
  QRViewController? controller;
  bool _dialogShown = false;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  /// This method is called when the app is reassembled, which is the case
  /// when the app is running in a physical device or emulator and the
  /// Flutter framework is restarted, such as when the user presses the
  /// "Hot reload" button in an IDE or runs the command
  /// `flutter run` again from the command line. It is used to pause and
  /// resume the camera to avoid camera-related issues that may arise
  /// from the framework restart. The pause and resume operations are
  /// only performed on Android, as the issue is Android-specific.
  ///
  void reassemble() async {
    super.reassemble();
    assert(() {
      if (Platform.isAndroid) {
        controller?.pauseCamera();
      }
      controller?.resumeCamera();
      return true;
    }());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  /// This method is called when the app's lifecycle state changes, such as when
  /// the app is resumed or paused. It is used to check the camera permission
  /// status and request it if necessary. The permission request is delayed by
  /// 500 milliseconds to avoid race conditions or false results due to the
  /// system not having finished updating the permission status immediately
  /// after the app is resumed. The delay also helps avoid immediate UI dialog
  /// flashes or flickers.
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Why delay?
      // Because the OS might not have finished updating the permission status immediately when the app resumes.
      // A short delay ensures the system is ready and avoids race conditions or false results (e.g., .status still says permanentlyDenied even after user allowed it in settings).
      // It also helps avoid immediate UI dialog flashes or flickers.
      Future.delayed(const Duration(milliseconds: 500), () {
        checkCameraPermission();
      });
    }
  }

  /// Checks the current camera permission status and requests it if necessary.
  ///
  /// When the permission is granted, the [_dialogShown] flag is reset to false.
  ///
  /// If the permission is permanently denied and the [_dialogShown] flag is
  /// false, a warning dialog is shown to the user with the option to open the
  /// app settings to enable the permission. The flag is then set to true until
  /// the user enables the permission or dismisses the dialog.
  ///
  /// Optionally, the method can delay and recheck the permission status again
  /// after a short delay (2 seconds by default) to avoid immediate UI dialog
  /// flashes or flickers.
  ///
  Future<void> checkCameraPermission() async {
    final status = await Permission.camera.status;

    if (status.isGranted) {
      _dialogShown = false; // ✅ Reset flag when permission is now granted
      return;
    }

    if (status.isPermanentlyDenied && !_dialogShown) {
      _dialogShown = true;

      if (!mounted) return;

      getIt<DialogService>().showWarningDialog(
        context: context,
        dismissOnTouchOutside: false,
        title: AppStrings.cameraNeedPermission,
        desc: AppStrings.cameraPermissionMessage,
        btnLabel: AppStrings.allow,
        onTap: () async {
          _dialogShown = true; // 👈 Still blocked until user enables permission
          await AppUtils.openAppSettings();

          // Optionally: delay and recheck again later
          Future.delayed(Duration(seconds: 2), () {
            _dialogShown = false; // ✅ Allow checking again after delay
          });
        },
        cancelLabel: AppStrings.deny,
        onCancel: () {
          _dialogShown = true; // Block dialog unless user does action
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScanCubit, ScanState>(
      listener: (context, state) {
        if (state is ScanSuccess) {
          ScanUiActions.onScanSuccess(context, controller);
        } else if (state is ScanImageSuccess) {
          ScanUiActions.onScanImageSuccess(context);
        } else if (state is ScanAlreadyExists) {
          ScanUiActions.onScanAlreadyExists(context, controller);
        } else if (state is ScanOutputIsEmpty) {
          ScanUiActions.onScanEmpty(context, controller);
        } else if (state is ScanImageFailure) {
          ScanUiActions.onScanImageFailure(context, state);
        }
      },
      child: Scaffold(
        body: Column(
          children: [Expanded(flex: 4, child: _buildQrView(context))],
        ),
        appBar: AppBar(
          leadingWidth: 100,
          actionsPadding: const EdgeInsets.symmetric(horizontal: 25),
          leading: IconButton(
            onPressed: () {
              context.read<ScanCubit>().scanQRCodeFromImage();
            },
            icon: const Icon(Icons.image, color: Colors.white),
          ),
          centerTitle: true,
          title: IconButton(
            onPressed: () async {
              if (controller != null) {
                await controller!.toggleFlash();
              }
            },
            icon: const Icon(Icons.flash_on, color: Colors.white),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                if (controller != null) {
                  await controller!.flipCamera();
                }
              },
              icon: const Icon(Icons.cameraswitch, color: Colors.white),
            ),
          ],
          backgroundColor: AppColor.primaryColor,
        ),
      ),
    );
  }

  /// Builds the QR view widget for scanning QR codes.
  ///
  /// The widget adjusts the scan area based on the device's screen size.
  /// If the width or height of the screen is less than 400, the scan
  /// area is set to 200.0, otherwise it is set to 300.0.
  ///
  /// The QR view widget includes a customizable overlay with a border
  /// and a cut-out area for scanning. The overlay's border color,
  /// radius, length, and width can be customized. The QR view is
  /// initialized with a callback function `_onQRViewCreated` which
  /// handles the QR code scanning process.

  Widget _buildQrView(BuildContext context) {
    var scanArea =
        (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: AppColor.secondaryColor,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
    );
  }

  /// Handles the QR code scanning process when the QR view is created.
  ///
  /// The `_onQRViewCreated` function is a callback that is invoked when the
  /// QR view widget is created. It is passed a `QRViewController` object, which
  /// is used to listen for scanned data. When the `QRViewController` object
  /// detects a QR code, it emits a `scanData` object containing the QR code's
  /// data. The `_onQRViewCreated` function extracts the QR code's data from the
  /// `scanData` object and passes it to the `onQRDetected` function of the
  /// `ScanCubit` class.
  ///
  /// The `onQRDetected` function is responsible for handling the QR code
  /// scanning process. It checks if the QR code is valid, and if so, adds it
  /// to the history of scanned QR codes. If the QR code is invalid, it shows
  /// a warning dialog with an error message.
  ///
  /// The `mounted` property is checked to ensure that the widget is still
  /// mounted before calling the `onQRDetected` function. This is necessary
  /// because the `onQRDetected` function performs a navigation action, which
  /// would fail if the widget is not mounted.
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.scannedDataStream.listen((scanData) {
      final code = scanData.code;
      if (code != null) {
        if (!mounted) return;
        context.read<ScanCubit>().onQRDetected(code);
      }
    });
  }
}
