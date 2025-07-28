import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code_sacnner_app/core/color/app_color.dart';
import 'package:qr_code_sacnner_app/core/constant/app_icons.dart';
import 'package:qr_code_sacnner_app/core/constant/app_strings.dart';
import 'package:qr_code_sacnner_app/core/extensions/context_extensions.dart';
import 'package:qr_code_sacnner_app/core/routes/app_router.dart';
import 'package:qr_code_sacnner_app/core/routes/args/show_qr_code_args.dart';
import 'package:qr_code_sacnner_app/core/services/di/di.dart';
import 'package:qr_code_sacnner_app/core/services/dialog_service.dart';
import 'package:qr_code_sacnner_app/features/business/domain/entities/business_entity.dart';
import 'package:qr_code_sacnner_app/features/business/presentation/screen/cubit/business_cubit.dart';
import 'package:qr_code_sacnner_app/features/widgets/common_button.dart';
import 'package:qr_code_sacnner_app/features/widgets/custom_app_bar.dart';
import 'package:qr_code_sacnner_app/features/widgets/custom_text_field.dart';
import 'package:qr_code_sacnner_app/features/widgets/custom_text_field_with_two_input.dart';

class BusinessScreen extends StatefulWidget {
  const BusinessScreen({super.key});

  @override
  State<BusinessScreen> createState() => _BusinessScreenState();
}

class _BusinessScreenState extends State<BusinessScreen> {
  final company = TextEditingController();

  final industry = TextEditingController();

  final email = TextEditingController();

  final phone = TextEditingController();

  final address = TextEditingController();

  final website = TextEditingController();

  final city = TextEditingController();

  final country = TextEditingController();

  @override
  void dispose() {
    company.dispose();
    industry.dispose();
    email.dispose();
    phone.dispose();
    address.dispose();
    website.dispose();
    city.dispose();
    country.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: SafeArea(
        child: BlocListener<BusinessCubit, BusinessState>(
          listener: (context, state) {
            if (state is BusinessFormSuccess) {
              context.push(
                AppRouter.showQrCode,
                extra: ShowQrCodeArgs(qrData: state.qrCode),
              );
            } else if (state is BusinessFormError) {
              getIt<DialogService>().showErrorDialog(
                context: context,
                desc: state.message,
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomAppBar(title: AppStrings.contact),
                  SizedBox(height: context.screenHeight * 0.04),
                  SvgPicture.asset(
                    height: context.screenHeight * 0.15,
                    width: context.screenWidth * 0.15,
                    AppIcons.business,
                    colorFilter: ColorFilter.mode(
                      AppColor.secondaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(height: context.screenHeight * 0.04),
                  CustomTextField(
                    label: AppStrings.company,
                    hint: AppStrings.companyHint,
                    controller: company,
                  ),

                  CustomTextField(
                    label: AppStrings.industry,
                    hint: AppStrings.industryHint,
                    controller: industry,
                  ),

                  CustomTextFieldWithTwoInput(
                    controller1: email,
                    label1: AppStrings.email,
                    hint1: AppStrings.enterEmail,
                    controller2: phone,
                    label2: AppStrings.phone,
                    hint2: AppStrings.enterPhoneNumber,
                  ),

                  CustomTextField(
                    label: AppStrings.website,
                    hint: AppStrings.enterUrl,
                    controller: website,
                  ),

                  CustomTextField(
                    label: AppStrings.address,
                    hint: AppStrings.addressHint,
                    controller: address,
                  ),

                  CustomTextFieldWithTwoInput(
                    controller1: city,
                    controller2: country,
                    label1: AppStrings.city,
                    label2: AppStrings.country,
                    hint1: AppStrings.cityHint,
                    hint2: AppStrings.countryHint,
                  ),

                  CommonButton(
                    btnLabel: AppStrings.generateQrCode,
                    onTap: () {
                      final business = BusinessEntity(
                        company: company.text,
                        industry: industry.text,
                        email: email.text,
                        phone: phone.text,
                        address: address.text,
                        website: website.text,
                        city: city.text,
                        country: country.text,
                      );
                      context.read<BusinessCubit>().submit(business);
                    },
                  ),
                  SizedBox(height: context.screenHeight * 0.04),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
