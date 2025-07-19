import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code_sacnner_app/core/constant/app_icons.dart';
import 'package:qr_code_sacnner_app/core/constant/app_strings.dart';
import 'package:qr_code_sacnner_app/core/routes/app_router.dart';
import 'package:qr_code_sacnner_app/core/services/di/di.dart';
import 'package:qr_code_sacnner_app/core/services/dialog_service.dart';
import 'package:qr_code_sacnner_app/features/generate/presentation/cubit/generate_cubit.dart';

class GenerateUIActions {
  static void handlePhoneTap(BuildContext context) {
    getIt<DialogService>().showSimpleDialog(
      context: context,
      labelText: AppStrings.enterPhoneNumber,
      svgPath: AppIcons.phone,
      btnLabel: AppStrings.generateQrCode,
      onTap: (value) =>
          context.read<GenerateCubit>().generateQRCode(AppStrings.phone, value),
    );
  }

  static void handleWhatsappTap(BuildContext context) {
    getIt<DialogService>().showSimpleDialog(
      context: context,
      labelText: AppStrings.enterPhoneNumber,
      svgPath: AppIcons.whatsapp,
      btnLabel: AppStrings.generateQrCode,
      onTap: (value) => context.read<GenerateCubit>().generateQRCode(
        AppStrings.whatsapp,
        value,
      ),
    );
  }

  static void handleInstagramTap(BuildContext context) {
    getIt<DialogService>().showSimpleDialog(
      context: context,
      labelText: AppStrings.enterUsername,
      svgPath: AppIcons.instagram,
      btnLabel: AppStrings.generateQrCode,
      onTap: (value) => context.read<GenerateCubit>().generateQRCode(
        AppStrings.instagram,
        value,
      ),
    );
  }

  static void handleTwitterTap(BuildContext context) {
    getIt<DialogService>().showSimpleDialog(
      context: context,
      labelText: AppStrings.enterUsername,
      svgPath: AppIcons.twitter,
      btnLabel: AppStrings.generateQrCode,
      onTap: (value) => context.read<GenerateCubit>().generateQRCode(
        AppStrings.twitter,
        value,
      ),
    );
  }

  static void handleBusinessTap(BuildContext context) {
    context.push(AppRouter.business);
  }

  static void handleContactTap(BuildContext context) {
    context.push(AppRouter.contact);
  }

  static void handleEmailTap(BuildContext context) {
    getIt<DialogService>().showSimpleDialog(
      context: context,
      labelText: AppStrings.enterEmail,
      svgPath: AppIcons.email,
      btnLabel: AppStrings.generateQrCode,
      onTap: (value) =>
          context.read<GenerateCubit>().generateQRCode(AppStrings.email, value),
    );
  }

  static void handleTextTap(BuildContext context) {
    getIt<DialogService>().showSimpleDialog(
      context: context,
      labelText: AppStrings.enterText,
      svgPath: AppIcons.text,
      btnLabel: AppStrings.generateQrCode,
      onTap: (value) =>
          context.read<GenerateCubit>().generateQRCode(AppStrings.text, value),
    );
  }

  static void handleWebsiteTap(BuildContext context) {
    getIt<DialogService>().showSimpleDialog(
      context: context,
      labelText: AppStrings.enterUrl,
      svgPath: AppIcons.website,
      btnLabel: AppStrings.generateQrCode,
      onTap: (value) => context.read<GenerateCubit>().generateQRCode(
        AppStrings.website,
        value,
      ),
    );
  }

  static void handleLocationTap(BuildContext context) {
    getIt<DialogService>().showSimpleDialog(
      context: context,
      svgPath: AppIcons.location,
      labelText: AppStrings.location,
      btnLabel: AppStrings.generateQrCode,
      onTap: (value) => context.read<GenerateCubit>().generateQRCode(
        AppStrings.location,
        value,
      ),
    );
  }

  static void handleEventTap(BuildContext context) {
    context.push(AppRouter.event);
  }
}
