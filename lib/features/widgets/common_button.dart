import 'package:flutter/material.dart';
import 'package:qr_code_sacnner_app/core/color/app_color.dart';

class CommonButton extends StatelessWidget {
  final String btnLabel;
  final VoidCallback onTap;
  Color? textColor;
  Color? btnColor;
  IconData? icon;
  Color? iconColor;
  double? elevation;

  CommonButton({
    super.key,
    required this.btnLabel,
    required this.onTap,
    this.btnColor,
    this.textColor,
    this.icon,
    this.iconColor,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: btnColor ?? AppColor.secondaryColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor),
          ElevatedButton(
            onPressed: onTap,

            style: ElevatedButton.styleFrom(
              backgroundColor: btnColor ?? AppColor.secondaryColor,
              elevation: 0,
              overlayColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              btnLabel,
              style: TextStyle(color: textColor ?? Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
