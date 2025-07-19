import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code_sacnner_app/core/color/app_color.dart';
import 'package:qr_code_sacnner_app/core/constant/app_strings.dart';
import 'package:qr_code_sacnner_app/core/extensions/context_extensions.dart';
import 'package:qr_code_sacnner_app/core/utils/custom_dialogs.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final bool shouldShowAppBar;
  const CustomAppBar({
    super.key,
    required this.title,
    this.shouldShowAppBar = true,
  });

  @override
  Widget build(BuildContext context) {
    return shouldShowAppBar
        ? Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColor.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),

                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: AppColor.secondaryColor,
                  ),
                  onPressed: () => context.pop(),
                ),
              ),
              SizedBox(width: 15),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColor.textColor,
                  fontSize: context.textScaler.scale(20),
                ),
              ),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: AppColor.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(Icons.menu, color: AppColor.secondaryColor),
                  onPressed: () {
                    CustomDialogs.showInfoDialog(
                      context: context,
                      title: AppStrings.info,
                      desc: AppStrings.commingSoon,
                      btnLabel: AppStrings.ok,
                      onTap: () {},
                    );
                  },
                ),
              ),
            ],
          )
        : const SizedBox.shrink();
  }
}
