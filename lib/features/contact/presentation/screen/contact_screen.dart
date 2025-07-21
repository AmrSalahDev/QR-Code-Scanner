import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qr_code_sacnner_app/core/color/app_color.dart';
import 'package:qr_code_sacnner_app/core/constant/app_icons.dart';
import 'package:qr_code_sacnner_app/core/constant/app_strings.dart';
import 'package:qr_code_sacnner_app/core/extensions/context_extensions.dart';
import 'package:qr_code_sacnner_app/core/services/di/di.dart';
import 'package:qr_code_sacnner_app/core/services/dialog_service.dart';
import 'package:qr_code_sacnner_app/features/contact/domain/entities/contact_entity.dart';
import 'package:qr_code_sacnner_app/features/contact/presentation/cubit/contact_cubit.dart';
import 'package:qr_code_sacnner_app/features/widgets/common_button.dart';
import 'package:qr_code_sacnner_app/features/widgets/custom_app_bar.dart';
import 'package:qr_code_sacnner_app/features/widgets/custom_text_field.dart';
import 'package:qr_code_sacnner_app/features/widgets/custom_text_field_with_two_input.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final firstNameController = TextEditingController();

  final lastNameController = TextEditingController();

  final company = TextEditingController();

  final job = TextEditingController();

  final email = TextEditingController();

  final phone = TextEditingController();

  final address = TextEditingController();

  final website = TextEditingController();

  final city = TextEditingController();

  final country = TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    company.dispose();
    job.dispose();
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
        child: BlocListener<ContactCubit, ContactState>(
          listener: (context, state) {
            if (state is ContactFormSuccess) {
              // CustomDialogs.showQRcodeDialog(
              //   context,
              //   state.qrCode,
              //   AppStrings.contact,
              // );
              getIt<DialogService>().showQRcodeDialog(
                context,
                state.qrCode,
                AppStrings.contact,
              );
            } else if (state is ContactFormError) {
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
                    AppIcons.contact,
                    colorFilter: ColorFilter.mode(
                      AppColor.secondaryColor,
                      BlendMode.srcIn,
                    ),
                  ),

                  SizedBox(height: context.screenHeight * 0.04),

                  CustomTextFieldWithTwoInput(
                    controller1: firstNameController,
                    label1: AppStrings.firstName,
                    hint1: AppStrings.firstNameHint,
                    controller2: lastNameController,
                    label2: AppStrings.lastName,
                    hint2: AppStrings.lastNameHint,
                  ),

                  CustomTextFieldWithTwoInput(
                    controller1: company,
                    label1: AppStrings.company,
                    hint1: AppStrings.companyHint,
                    controller2: job,
                    label2: AppStrings.job,
                    hint2: AppStrings.jobHint,
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
                      final contact = ContactEntity(
                        firstName: firstNameController.text,
                        lastName: lastNameController.text,
                        company: company.text,
                        job: job.text,
                        email: email.text,
                        phone: phone.text,
                        address: address.text,
                        website: website.text,
                        city: city.text,
                        country: country.text,
                        postalCode: '',
                      );
                      context.read<ContactCubit>().submit(contact);
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
