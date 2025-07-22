import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_sacnner_app/core/constant/app_icons.dart';
import 'package:qr_code_sacnner_app/core/constant/app_strings.dart';
import 'package:qr_code_sacnner_app/core/services/di/di.dart';
import 'package:qr_code_sacnner_app/core/services/dialog_service.dart';
part 'generate_state.dart';

class GenerateCubit extends Cubit<GenerateState> {
  GenerateCubit() : super(GenerateInitial());

  void showDialog(String label, BuildContext context) {
    switch (label) {
      case AppStrings.text:
        getIt<DialogService>().showSimpleDialog(
          context: context,
          labelText: AppStrings.enterText,
          svgPath: AppIcons.text,
          btnLabel: AppStrings.generateQrCode,
          onTap: (value) => generateQRCode(AppStrings.text, value),
        );
        break;
      case AppStrings.website:
        getIt<DialogService>().showSimpleDialog(
          context: context,
          labelText: AppStrings.enterUrl,
          svgPath: AppIcons.website,
          btnLabel: AppStrings.generateQrCode,
          onTap: (value) => generateQRCode(AppStrings.website, value),
        );
        break;
      case AppStrings.whatsapp:
        getIt<DialogService>().showSimpleDialog(
          context: context,
          labelText: AppStrings.enterPhoneNumber,
          svgPath: AppIcons.whatsapp,
          btnLabel: AppStrings.generateQrCode,
          onTap: (value) => generateQRCode(AppStrings.whatsapp, value),
        );
        break;
      case AppStrings.email:
        getIt<DialogService>().showSimpleDialog(
          context: context,
          labelText: AppStrings.enterEmail,
          svgPath: AppIcons.email,
          btnLabel: AppStrings.generateQrCode,
          onTap: (value) => generateQRCode(AppStrings.email, value),
        );
        break;

      case AppStrings.instagram:
        getIt<DialogService>().showSimpleDialog(
          context: context,
          labelText: AppStrings.enterUsername,
          svgPath: AppIcons.instagram,
          btnLabel: AppStrings.generateQrCode,
          onTap: (value) => generateQRCode(AppStrings.instagram, value),
        );
        break;
      case AppStrings.twitter:
        getIt<DialogService>().showSimpleDialog(
          context: context,
          labelText: AppStrings.enterUsername,
          svgPath: AppIcons.twitter,
          btnLabel: AppStrings.generateQrCode,
          onTap: (value) => generateQRCode(AppStrings.twitter, value),
        );
        break;
      case AppStrings.phone:
        getIt<DialogService>().showSimpleDialog(
          context: context,
          labelText: AppStrings.enterPhoneNumber,
          svgPath: AppIcons.phone,
          btnLabel: AppStrings.generateQrCode,
          onTap: (value) => generateQRCode(AppStrings.phone, value),
        );
        break;
    }
  }

  void generateQRCode(String label, String input) {
    String qrData = '';

    switch (label) {
      case 'Text':
        qrData = input;
        break;
      case 'Website':
        qrData = input.startsWith('http') ? input : 'https://$input';
        break;
      case 'Whatsapp':
        qrData = 'https://wa.me/$input';
        break;
      case 'Email':
        qrData = 'mailto:$input';
        break;
      case 'Instagram':
        qrData = 'https://instagram.com/$input';
        break;
      case 'Twitter':
        qrData = 'https://twitter.com/$input';
        break;
      case 'Location':
        qrData = 'https://www.google.com/maps/search/?api=1&query=$input';
        break;
      case 'Phone':
        qrData = 'tel:$input';
        break;
      case 'Event':
        qrData = input;
        break;
      case AppStrings.wifi:
        qrData = input;
        break;
      default:
        qrData = input;
    }

    emit(GenerateLoaded(data: qrData, type: label));
  }
}
