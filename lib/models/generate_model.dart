import 'package:flutter/material.dart';
import 'package:qr_code_sacnner_app/core/constant/app_icons.dart';

class GenerateModel {
  final String label;
  final IconData? icon;
  final String? svgPath;

  GenerateModel({required this.label, this.icon, this.svgPath});
}

List<GenerateModel> generateList = [
  GenerateModel(label: 'Text', icon: Icons.text_format),
  GenerateModel(label: 'Website', icon: Icons.web),
  GenerateModel(label: 'Wifi', icon: Icons.wifi),
  GenerateModel(label: 'Event', icon: Icons.event),
  GenerateModel(label: 'Contact', icon: Icons.contacts),
  GenerateModel(label: 'Business', icon: Icons.business),
  GenerateModel(label: 'Location', icon: Icons.location_on),
  GenerateModel(label: 'Whatsapp', svgPath: AppIcons.whatsapp),
  GenerateModel(label: 'Twitter', svgPath: AppIcons.twitter),
  GenerateModel(label: 'Instagram', svgPath: AppIcons.instagram),
  GenerateModel(label: 'Email', icon: Icons.email),
  GenerateModel(label: 'Phone', icon: Icons.phone),
];
