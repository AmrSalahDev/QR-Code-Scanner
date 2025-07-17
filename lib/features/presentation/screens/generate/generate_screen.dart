import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code_sacnner_app/core/color/app_color.dart';
import 'package:qr_code_sacnner_app/core/utils/custom_dialogs.dart';
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
        appBar: CustomAppBar(isShowAppBar: isShowAppBar),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [Expanded(child: GenerateQRGridView())]),
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
    return GridView.builder(
      padding: const EdgeInsets.only(top: 16),
      itemCount: generateList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 30,
      ),
      itemBuilder: (context, index) {
        final String label = generateList[index].label;
        return GestureDetector(
          onTap: () {
            if (label == 'Event') {
              GoRouter.of(context).push('/event');
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

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.isShowAppBar});

  final bool isShowAppBar;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: isShowAppBar ? 80 : 0,
      actionsPadding: EdgeInsets.only(right: 16),
      backgroundColor: AppColor.primaryColor,
      title: Text('Generate QR', style: TextStyle(color: AppColor.textColor)),
      actions: [
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
              // Add your delete action here
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(isShowAppBar ? 80 : 0);
}

class GenerateQRItem extends StatelessWidget {
  final int index;
  const GenerateQRItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return BorderWithLabel(
      label: generateList[index].label,
      labelColor: Colors.black,
      borderColor: AppColor.secondaryColor,
      labelSize: 12,
      width: 95,
      height: 85,
      child: generateList[index].svgPath != null
          ? Padding(
              padding: const EdgeInsets.all(25),
              child: SvgPicture.asset(
                generateList[index].svgPath!,
                colorFilter: ColorFilter.mode(
                  AppColor.secondaryColor,
                  BlendMode.srcIn,
                ),
              ),
            )
          : Icon(
              generateList[index].icon,
              color: AppColor.secondaryColor,
              size: 35,
            ),
    );
  }
}
