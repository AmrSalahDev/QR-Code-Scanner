import 'package:flutter/material.dart';
import 'package:qr_code_sacnner_app/core/color/app_color.dart';
import 'package:qr_code_sacnner_app/core/extensions/context_extensions.dart';

class CustomIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final IconData icon;
  const CustomIconButton({
    super.key,
    required this.onPressed,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColor.primaryColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColor.secondaryColor),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: context.textScaler.scale(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
