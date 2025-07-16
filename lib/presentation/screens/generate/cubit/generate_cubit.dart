import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_sacnner_app/core/constant/app_icons.dart';
import 'package:qr_code_sacnner_app/core/constant/app_strings.dart';
import 'package:qr_code_sacnner_app/core/utils/custom_dialogs.dart';
part 'generate_state.dart';

class GenerateCubit extends Cubit<GenerateState> {
  GenerateCubit() : super(GenerateInitial());

  void showDialog(String label, BuildContext context) {
    switch (label) {
      case AppStrings.text:
        CustomDialogs.showSimpleDialog(
          context: context,
          labelText: AppStrings.enterText,
          icon: Icons.text_fields,
          btnLabel: AppStrings.generateQrCode,
          onTap: (value) => generateQRCode(AppStrings.text, value),
        );
        break;
      case AppStrings.website:
        CustomDialogs.showSimpleDialog(
          context: context,
          labelText: AppStrings.enterUrl,
          icon: Icons.link,
          btnLabel: AppStrings.generateQrCode,
          onTap: (value) => generateQRCode(AppStrings.website, value),
        );
        break;
      case AppStrings.whatsapp:
        CustomDialogs.showSimpleDialog(
          context: context,
          labelText: AppStrings.enterPhoneNumber,
          svgPath: AppIcons.whatsapp,
          btnLabel: AppStrings.generateQrCode,
          onTap: (value) => generateQRCode(AppStrings.whatsapp, value),
        );
        break;
      case AppStrings.email:
        CustomDialogs.showSimpleDialog(
          context: context,
          labelText: AppStrings.enterEmail,
          icon: Icons.email,
          btnLabel: AppStrings.generateQrCode,
          onTap: (value) => generateQRCode(AppStrings.email, value),
        );
        break;

      case AppStrings.instagram:
        CustomDialogs.showSimpleDialog(
          context: context,
          labelText: AppStrings.enterUsername,
          svgPath: AppIcons.instagram,
          btnLabel: AppStrings.generateQrCode,
          onTap: (value) => generateQRCode(AppStrings.instagram, value),
        );
        break;
      case 'Twitter':
        CustomDialogs.showSimpleDialog(
          context: context,
          labelText: 'Enter Username',
          svgPath: AppIcons.twitter,
          btnLabel: 'Generate QR Code',
          onTap: (value) => generateQRCode('Twitter', value),
        );
        break;
      case 'Phone':
        CustomDialogs.showSimpleDialog(
          context: context,
          labelText: 'Enter Phone Number',
          icon: Icons.phone,
          btnLabel: 'Generate QR Code',
          onTap: (value) => generateQRCode('Phone', value),
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
      case 'Phone':
        qrData = 'tel:$input';
        break;
      case 'Event':
        qrData = input;
        break;
      default:
        qrData = input;
    }

    emit(GenerateLoaded(data: qrData, type: label));
  }
}
