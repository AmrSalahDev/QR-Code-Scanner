import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';
import 'package:qr_code_sacnner_app/core/color/app_color.dart';
import 'package:qr_code_sacnner_app/core/constant/app_strings.dart';
import 'package:qr_code_sacnner_app/core/routes/app_router.dart';
import 'package:qr_code_sacnner_app/core/utils/custom_dialogs.dart';
import 'package:qr_code_sacnner_app/features/presentation/screens/scan/cubit/scan_cubit.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:vibration/vibration.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => ScanScreenState();
}

class ScanScreenState extends State<ScanScreen> {
  Barcode? result;
  String? resultOfImage;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool _isDialogShowing = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScanCubit, ScanState>(
      bloc: BlocProvider.of<ScanCubit>(context),
      listener: (context, state) {
        if (state is ScanSuccess) {
          Vibration.vibrate(duration: 100); // Vibrate for 100 milliseconds
        } else if (state is ScanImageSuccess) {
          CustomDialogs.showSuccessDialog(
            context: context,
            title: AppStrings.qRCodeScanned,
            desc: AppStrings.qRCodeSuccessfullyScanned,
            btnLabel: AppStrings.view,
            onTap: () => context.go(AppRouter.history),
          );
        } else if (state is ScanFailure) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.warning,
            animType: AnimType.rightSlide,
            title: AppStrings.oops,
            desc: state.error,
            btnOkText: AppStrings.tryAgain,
            btnOkColor: AppColor.secondaryColor,
            btnOkOnPress: () {
              BlocProvider.of<ScanCubit>(context).scanQRCodeFromImage();
            },
          ).show();
        }
      },
      child: Scaffold(
        body: Column(
          children: <Widget>[Expanded(flex: 4, child: _buildQrView(context))],
        ),
        appBar: AppBar(
          leadingWidth: 100,
          actionsPadding: const EdgeInsets.symmetric(horizontal: 25),
          leading: IconButton(
            onPressed: () {
              BlocProvider.of<ScanCubit>(context).scanQRCodeFromImage();
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

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea =
        (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
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
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void startScan() async {
    if (result != null) {
      await controller!.pauseCamera();
      BlocProvider.of<ScanCubit>(context).addToHistory(result!.code!);
      CustomDialogs.showSuccessDialog(
        context: context,
        title: AppStrings.qRCodeScanned,
        desc: AppStrings.qRCodeSuccessfullyScanned,
        btnLabel: AppStrings.view,
        onTap: () => context.go(AppRouter.history),
        onDismissCallback: (type) async {
          await controller!.resumeCamera();
        },
      );
    } else {
      showQrNotDetectedDialog(context);
    }
  }

  void showQrNotDetectedDialog(BuildContext context) {
    if (_isDialogShowing) return;

    _isDialogShowing = true;

    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.rightSlide,
      title: AppStrings.qRCodeNotDetected,
      desc: AppStrings.pointCameraQRCode,
      btnOkText: AppStrings.retry,
      btnOkColor: AppColor.secondaryColor,
      btnOkOnPress: () {
        _isDialogShowing = false;
      },
      onDismissCallback: (DismissType type) async {
        _isDialogShowing = false;
        await controller?.resumeCamera(); // Use null-safe access
      },
    ).show();
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        if (result != null) {
          BlocProvider.of<ScanCubit>(context).onQRDetected(result!.code!);
        }
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('no Permission')));
    }
  }
}
