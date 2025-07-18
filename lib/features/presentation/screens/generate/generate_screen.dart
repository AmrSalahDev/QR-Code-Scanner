import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code_sacnner_app/core/color/app_color.dart';
import 'package:qr_code_sacnner_app/core/constant/app_strings.dart';
import 'package:qr_code_sacnner_app/core/extensions/context_extensions.dart';
import 'package:qr_code_sacnner_app/core/routes/app_router.dart';
import 'package:qr_code_sacnner_app/core/utils/custom_dialogs.dart';
import 'package:qr_code_sacnner_app/core/utils/screen_utils.dart';
import 'package:qr_code_sacnner_app/features/data/models/generate_model.dart';
import 'package:qr_code_sacnner_app/features/presentation/screens/generate/cubit/generate_cubit.dart';
import 'package:qr_code_sacnner_app/features/presentation/widgets/border_with_label.dart';

// ignore: must_be_immutable
class GenerateScreen extends StatelessWidget {
  bool isShowAppBar;
  GenerateScreen({super.key, this.isShowAppBar = true});

  @override
  Widget build(BuildContext context) {
    return BlocListener<GenerateCubit, GenerateState>(
      listener: (context, state) {
        if (state is GenerateLoaded) {
          CustomDialogs.showQRcodeDialog(context, state.data, state.type);
        }
      },
      child: Scaffold(
        backgroundColor: AppColor.primaryColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Column(
              children: [
                if (isShowAppBar) ...[
                  CustomAppBar(isShowAppBar: isShowAppBar),
                  SizedBox(height: context.screenHeight * 0.05),
                ],
                Expanded(child: GenerateQRGridView()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GenerateQRGridView extends StatelessWidget {
  const GenerateQRGridView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isLandscape = ScreenUtils.isLandscape(context);

    return GridView.builder(
      padding: const EdgeInsets.only(top: 16),
      itemCount: generateList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isLandscape ? 4 : 3,
        crossAxisSpacing: context.screenWidth * 0.04,
        mainAxisSpacing: isLandscape
            ? context.screenWidth * 0.05
            : context.screenWidth * 0.08,
      ),
      itemBuilder: (context, index) {
        final String label = generateList[index].label;
        return GestureDetector(
          onTap: () {
            if (label == AppStrings.event) {
              GoRouter.of(context).push(AppRouter.event);
              return;
            } else {
              BlocProvider.of<GenerateCubit>(
                context,
              ).showDialog(label, context);
            }
          },
          child: GenerateQRItem(index: index),
        );
      },
    );
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key, required this.isShowAppBar});

  final bool isShowAppBar;

  @override
  Widget build(BuildContext context) {
    return isShowAppBar
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.generateQr,
                style: TextStyle(
                  color: AppColor.textColor,
                  fontSize: context.textTheme.headlineSmall!.fontSize,
                ),
              ),
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
                      title: AppStrings.commingSoon,
                      desc: AppStrings.commingSoon,
                      btnLabel: AppStrings.ok,
                      onTap: () {},
                    );
                  },
                ),
              ),
            ],
          )
        : Container();
  }
}

class GenerateQRItem extends StatelessWidget {
  final int index;
  const GenerateQRItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => BorderWithLabel(
        label: generateList[index].label,
        labelColor: Colors.black,
        borderColor: AppColor.secondaryColor,
        labelSize: context.textScaler.scale(
          context.textTheme.bodySmall!.fontSize!,
        ),
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: constraints.maxWidth * 0.3,
            vertical: constraints.maxHeight * 0.3,
          ),
          child: SvgPicture.asset(
            generateList[index].svgPath!,
            colorFilter: ColorFilter.mode(
              AppColor.secondaryColor,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
