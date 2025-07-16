import 'package:flutter/material.dart';

class BorderWithLabel extends StatelessWidget {
  final String label;
  final double labelSize;
  final Color labelColor;
  final Color borderColor;
  final double width;
  final double height;
  final Widget child;

  const BorderWithLabel({
    super.key,
    required this.label,
    required this.labelColor,
    required this.borderColor,
    required this.width,
    required this.height,
    required this.child,
    required this.labelSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            // Full box with border
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                border: Border.all(color: borderColor, width: 1.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: child,
            ),

            // Text sitting on top of border
            Positioned(
              top: -10,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: borderColor,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  label,
                  style: TextStyle(color: labelColor, fontSize: labelSize),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
