import 'package:flutter/material.dart';
import 'package:qr_code_sacnner_app/core/color/app_color.dart';
import 'package:qr_code_sacnner_app/core/extensions/context_extensions.dart';

class CustomTextFieldWithTwoInput extends StatelessWidget {
  final TextEditingController controller1;
  final TextEditingController controller2;
  final String label1;
  final String label2;
  final String hint1;
  final String hint2;
  const CustomTextFieldWithTwoInput({
    super.key,
    required this.controller1,
    required this.controller2,
    required this.label1,
    required this.label2,
    required this.hint1,
    required this.hint2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CustomTextField(controller: controller1, label: label1, hint: hint1),
        SizedBox(width: context.screenWidth * 0.05),
        _CustomTextField(controller: controller2, label: label2, hint: hint2),
      ],
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  const _CustomTextField({
    required this.controller,
    required this.label,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: AppColor.textColor)),
          const SizedBox(height: 10),
          TextField(
            style: TextStyle(color: AppColor.textColor),
            cursorColor: AppColor.secondaryColor,
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: AppColor.hintColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColor.borderColorInactive),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColor.borderColorActive),
              ),
            ),
          ),
          SizedBox(height: context.screenHeight * 0.04),
        ],
      ),
    );
  }
}
