import 'package:qr_code_sacnner_app/core/constant/app_icons.dart';
import 'package:qr_code_sacnner_app/core/constant/app_strings.dart';

class GenerateModel {
  final String label;
  final String? svgPath;

  GenerateModel({required this.label, this.svgPath});
}

List<GenerateModel> generateList = [
  GenerateModel(label: AppStrings.text, svgPath: AppIcons.text),
  GenerateModel(label: AppStrings.website, svgPath: AppIcons.website),
  GenerateModel(label: AppStrings.wifi, svgPath: AppIcons.wifi),
  GenerateModel(label: AppStrings.event, svgPath: AppIcons.event),
  GenerateModel(label: AppStrings.contact, svgPath: AppIcons.contact),
  GenerateModel(label: AppStrings.business, svgPath: AppIcons.business),
  GenerateModel(label: AppStrings.location, svgPath: AppIcons.location),
  GenerateModel(label: AppStrings.whatsapp, svgPath: AppIcons.whatsapp),
  GenerateModel(label: AppStrings.twitter, svgPath: AppIcons.twitter),
  GenerateModel(label: AppStrings.instagram, svgPath: AppIcons.instagram),
  GenerateModel(label: AppStrings.email, svgPath: AppIcons.email),
  GenerateModel(label: AppStrings.phone, svgPath: AppIcons.phone),
];
