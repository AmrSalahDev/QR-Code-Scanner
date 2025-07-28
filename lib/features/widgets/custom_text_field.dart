import 'package:flutter/material.dart';
import 'package:qr_code_sacnner_app/core/color/app_color.dart';
import 'package:qr_code_sacnner_app/core/extensions/context_extensions.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final int? maxLines;
  final IconData? suffixIcon;
  final bool supportSuffix;
  final VoidCallback? onSuffixTap;
  final TextEditingController controller;
  final TextInputType? textInputType;
  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    this.supportSuffix = false,
    this.maxLines,
    required this.controller,
    this.onSuffixTap,
    this.suffixIcon,
    this.textInputType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: AppColor.textColor)),
        const SizedBox(height: 10),
        TextField(
          style: TextStyle(color: AppColor.secondaryColor),
          cursorColor: AppColor.secondaryColor,
          keyboardType: textInputType,
          maxLines: maxLines ?? 1,
          controller: controller,
          decoration: InputDecoration(
            suffixIcon: supportSuffix
                ? GestureDetector(
                    onTap: onSuffixTap,
                    child: Icon(suffixIcon, color: AppColor.secondaryColor),
                  )
                : null,

            hintText: hint,
            hintStyle: TextStyle(color: AppColor.hintColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColor.borderColorInactive),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColor.secondaryColor),
            ),
          ),
        ),
        SizedBox(height: context.screenHeight * 0.04),
      ],
    );
  }
}
