import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code_sacnner_app/core/constant/app_strings.dart';
import 'package:qr_code_sacnner_app/core/routes/app_router.dart';
import 'package:qr_code_sacnner_app/core/routes/args/show_qr_data_args.dart';
import 'package:qr_code_sacnner_app/core/services/di/di.dart';
import 'package:qr_code_sacnner_app/core/services/dialog_service.dart';
import 'package:qr_code_sacnner_app/features/scan/presentation/cubit/scan_cubit.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:vibration/vibration.dart';

class ScanUiActions {
  static void onScanSuccess(
    BuildContext context,
    QRViewController? controller,
    String data,
    String type,
  ) async {
    await controller?.pauseCamera();
    if (!context.mounted) return;
    Vibration.vibrate(duration: 100);
    getIt<DialogService>().showSuccessDialog(
      context: context,
      title: AppStrings.qRCodeScanned,
      desc: AppStrings.qRCodeSuccessfullyScanned,
      btnLabel: AppStrings.view,
      onTap: () => context.push(
        AppRouter.showQrData,
        extra: ShowQrDataArgs(qrData: data, qrType: type),
      ),
      onDismissCallback: (dismiss) async {
        await controller?.resumeCamera();
      },
      cancelLabel: AppStrings.ok,
      onCancel: () => {},
    );
  }

  static void onScanImageSuccess(
    BuildContext context,
    String data,
    String type,
  ) {
    getIt<DialogService>().showSuccessDialog(
      context: context,
      title: AppStrings.qRCodeScanned,
      desc: AppStrings.qRCodeSuccessfullyScanned,
      btnLabel: AppStrings.view,
      onTap: () => context.push(
        AppRouter.showQrData,
        extra: ShowQrDataArgs(qrData: data, qrType: type),
      ),
      cancelLabel: AppStrings.ok,
      onCancel: () => {},
    );
  }

  static void onScanAlreadyExists(
    BuildContext context,
    QRViewController? controller,
  ) async {
    await controller?.pauseCamera();
    if (!context.mounted) return;
    getIt<DialogService>().showWarningDialog(
      context: context,
      title: AppStrings.alreadyExists,
      desc: AppStrings.qRCodeAlreadyExistsInHistory,
      btnLabel: AppStrings.view,
      onDismissCallback: (dismiss) async => await controller?.resumeCamera(),
      cancelLabel: AppStrings.ok,
      onCancel: () => {},
    );
  }

  static void onScanEmpty(
    BuildContext context,
    QRViewController? controller,
  ) async {
    await controller?.pauseCamera();
    if (!context.mounted) return;
    getIt<DialogService>().showWarningDialog(
      context: context,
      title: AppStrings.emptyQrCode,
      desc: AppStrings.qRCodeScannedEmpty,
      btnLabel: AppStrings.view,
      onDismissCallback: (dismiss) async => await controller?.resumeCamera(),
      cancelLabel: AppStrings.ok,
      onCancel: () => {},
    );
  }

  static void onScanImageFailure(BuildContext context, ScanImageFailure state) {
    getIt<DialogService>().showWarningDialog(
      context: context,
      desc: state.error,
      btnLabel: AppStrings.tryAgain,
      onTap: () => context.read<ScanCubit>().scanQRCodeFromImage(),
    );
  }
}
