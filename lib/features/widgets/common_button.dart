import 'package:flutter/material.dart';
import 'package:qr_code_sacnner_app/core/color/app_color.dart';

class CommonButton extends StatelessWidget {
  final String btnLabel;
  final VoidCallback onTap;

  const CommonButton({super.key, required this.btnLabel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        backgroundColor: AppColor.secondaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(btnLabel, style: TextStyle(color: Colors.black)),
    );
  }
}
