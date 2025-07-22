import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code_sacnner_app/core/color/app_color.dart';
import 'package:qr_code_sacnner_app/core/constant/app_strings.dart';
import 'package:qr_code_sacnner_app/core/extensions/context_extensions.dart';
import 'package:qr_code_sacnner_app/core/services/di/di.dart';
import 'package:qr_code_sacnner_app/core/services/dialog_service.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final bool shouldShowAppBar;
  final bool shouldShowMenu;
  final bool shouldShowBackButton;
  final double marginVertical;
  const CustomAppBar({
    super.key,
    required this.title,
    this.shouldShowAppBar = true,
    this.shouldShowMenu = true,
    this.shouldShowBackButton = true,
    this.marginVertical = 20,
  });

  @override
  Widget build(BuildContext context) {
    return shouldShowAppBar
        ? Container(
            color: AppColor.primaryColor,
            child: Row(
              children: [
                shouldShowBackButton
                    ? Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: marginVertical,
                        ),
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
                      )
                    : const SizedBox.shrink(),
                shouldShowBackButton
                    ? const SizedBox.shrink()
                    : SizedBox(width: context.screenWidth * 0.05),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColor.textColor,
                    fontSize: context.textScaler.scale(20),
                  ),
                ),
                Spacer(),
                shouldShowMenu
                    ? Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: marginVertical,
                        ),
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
                            Icons.menu,
                            color: AppColor.secondaryColor,
                          ),
                          onPressed: () {
                            getIt<DialogService>().showInfoDialog(
                              context: context,
                              title: AppStrings.info,
                              desc: AppStrings.commingSoon,
                              btnLabel: AppStrings.ok,
                              onTap: () {},
                            );
                          },
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}
