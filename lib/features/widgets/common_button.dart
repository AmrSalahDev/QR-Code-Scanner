import 'package:flutter/material.dart';
import 'package:qr_code_sacnner_app/core/color/app_color.dart';

class CommonButton extends StatelessWidget {
  final String btnLabel;
  final Color textColor = Colors.black;
  final Color btnColor = AppColor.secondaryColor;
  final VoidCallback onTap;

  CommonButton({super.key, required this.btnLabel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(15),
        backgroundColor: btnColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(btnLabel, style: TextStyle(color: textColor)),
    );
  }
}
