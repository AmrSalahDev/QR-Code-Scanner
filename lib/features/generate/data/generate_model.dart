import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_sacnner_app/core/constant/app_icons.dart';
import 'package:qr_code_sacnner_app/core/constant/app_strings.dart';
import 'package:qr_code_sacnner_app/core/services/dialog_service.dart';
import 'package:qr_code_sacnner_app/features/generate/presentation/cubit/wifi_create_dialog_cubit.dart';
import 'package:qr_code_sacnner_app/features/generate/presentation/cubit/generate_cubit.dart';
import 'package:qr_code_sacnner_app/features/generate/generate_ui_actions.dart';

class GenerateModel {
  final String label;
  final String svgPath;
  final void Function(BuildContext context) onTap;

  GenerateModel({
    required this.label,
    required this.svgPath,
    required this.onTap,
  });
}

final List<GenerateModel> generateList = [
  GenerateModel(
    label: AppStrings.text,
    svgPath: AppIcons.text,
    onTap: (context) => GenerateUIActions.handleTextTap(context),
  ),
  GenerateModel(
    label: AppStrings.website,
    svgPath: AppIcons.website,
    onTap: (context) => GenerateUIActions.handleWebsiteTap(context),
  ),
  GenerateModel(
    label: AppStrings.wifi,
    svgPath: AppIcons.wifi,
    onTap: (context) {
      context.read<WifiCreateDialogCubit>().openDialog(
        context: context,
        onTap: (data) {
          context.read<GenerateCubit>().generateQRCode(AppStrings.wifi, data);
        },
      );
    },
  ),
  GenerateModel(
    label: AppStrings.event,
    svgPath: AppIcons.event,
    onTap: (context) => GenerateUIActions.handleEventTap(context),
  ),
  GenerateModel(
    label: AppStrings.contact,
    svgPath: AppIcons.contact,
    onTap: (context) => GenerateUIActions.handleContactTap(context),
  ),
  GenerateModel(
    label: AppStrings.business,
    svgPath: AppIcons.business,
    onTap: (context) => GenerateUIActions.handleBusinessTap(context),
  ),
  GenerateModel(
    label: AppStrings.location,
    svgPath: AppIcons.location,
    onTap: (context) => GenerateUIActions.handleLocationTap(context),
  ),
  GenerateModel(
    label: AppStrings.whatsapp,
    svgPath: AppIcons.whatsapp,
    onTap: (context) => GenerateUIActions.handleWhatsappTap(context),
  ),
  GenerateModel(
    label: AppStrings.twitter,
    svgPath: AppIcons.twitter,
    onTap: (context) => GenerateUIActions.handleTwitterTap(context),
  ),
  GenerateModel(
    label: AppStrings.instagram,
    svgPath: AppIcons.instagram,
    onTap: (context) => GenerateUIActions.handleInstagramTap(context),
  ),
  GenerateModel(
    label: AppStrings.email,
    svgPath: AppIcons.email,
    onTap: (context) => GenerateUIActions.handleEmailTap(context),
  ),
  GenerateModel(
    label: AppStrings.phone,
    svgPath: AppIcons.phone,
    onTap: (context) {
      GenerateUIActions.handlePhoneTap(context);
    },
  ),
];
