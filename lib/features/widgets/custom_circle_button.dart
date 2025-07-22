import 'package:flutter/material.dart';
import 'package:qr_code_sacnner_app/core/color/app_color.dart';
import 'package:qr_code_sacnner_app/core/extensions/context_extensions.dart';

class CustomCircleButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String title;
  const CustomCircleButton({
    super.key,
    this.onPressed,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon, color: Colors.white),
          style: ButtonStyle(
            padding: WidgetStatePropertyAll(const EdgeInsets.all(20)),
            backgroundColor: WidgetStatePropertyAll(AppColor.secondaryColor),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: context.textScaler.scale(16),
          ),
        ),
      ],
    );
  }
}
