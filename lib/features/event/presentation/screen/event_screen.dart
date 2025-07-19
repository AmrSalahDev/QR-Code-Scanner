import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:qr_code_sacnner_app/core/color/app_color.dart';
import 'package:qr_code_sacnner_app/core/constant/app_strings.dart';
import 'package:qr_code_sacnner_app/core/utils/app_utils.dart';
import 'package:qr_code_sacnner_app/core/utils/custom_dialogs.dart';
import 'package:qr_code_sacnner_app/features/event/presentation/cubit/event_cubit.dart';
import 'package:qr_code_sacnner_app/features/widgets/common_button.dart';
import 'package:qr_code_sacnner_app/features/widgets/custom_app_bar.dart';
import 'package:qr_code_sacnner_app/features/widgets/custom_text_field.dart';

class EventScreen extends StatelessWidget {
  EventScreen({super.key});
  final nameController = TextEditingController();
  final startController = TextEditingController();
  final endController = TextEditingController();
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              CustomAppBar(title: AppStrings.event),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.event,
                          color: AppColor.secondaryColor,
                          size: 100,
                        ),
                      ),
                      CustomTextField(
                        controller: nameController,
                        label: AppStrings.eventName,
                        hint: AppStrings.eventNameHint,
                      ),
                      EventStartDatePart(startController: startController),
                      EventEndDateAndTimePart(endController: endController),
                      CustomTextField(
                        controller: locationController,
                        label: AppStrings.eventLocation,
                        hint: AppStrings.eventLocationHint,
                      ),
                      CustomTextField(
                        controller: descriptionController,
                        maxLines: 3,
                        label: AppStrings.eventDescription,
                        hint: AppStrings.eventDescriptionHint,
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.center,
                        child: CommonButton(
                          btnLabel: AppStrings.generateQrCode,
                          onTap: () => _onGenerateQrCodeClicked(context),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onGenerateQrCodeClicked(BuildContext context) {
    if (nameController.text.trim().isEmpty ||
        startController.text.trim().isEmpty ||
        endController.text.trim().isEmpty ||
        locationController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty) {
      CustomDialogs.showWarningDialog(
        context: context,
        title: AppStrings.warning,
        desc: AppStrings.pleaseFillAllTheFields,
        btnLabel: AppStrings.ok,
        onTap: () {},
      );
      return;
    }
    final eventData = {
      'Name': nameController.text.trim(),
      'Start': startController.text.trim(),
      'End': endController.text.trim(),
      'Location': locationController.text.trim(),
      'Description': descriptionController.text.trim(),
    };
    CustomDialogs.showQRcodeDialog(
      context,
      jsonEncode(eventData),
      AppStrings.event,
    );
  }
}

class EventStartDatePart extends StatelessWidget {
  final TextEditingController startController;
  const EventStartDatePart({super.key, required this.startController});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventCubit, EventState>(
      builder: (context, state) {
        if (state is EventStartDateFinished) {
          startController.text = state.startDate;
        }
        return CustomTextField(
          controller: startController,
          supportSuffix: true,
          suffixIcon: Icons.date_range,
          label: AppStrings.eventStartDate,
          hint: AppStrings.eventStartDateHint,
          onSuffixTap: () async {
            DateTime? dateTime = await showOmniDateTimePicker(
              theme: ThemeData(
                colorScheme: ColorScheme.dark(
                  primary: AppColor.secondaryColor,
                  surface: AppColor.primaryColor,
                  onSurface: AppColor.textColor,
                ),
              ),
              context: context,
            );
            if (dateTime != null && context.mounted) {
              BlocProvider.of<EventCubit>(
                context,
              ).setStartDate(AppUtils.formatDateTime(dateTime));
            }
          },
        );
      },
    );
  }
}

class EventEndDateAndTimePart extends StatelessWidget {
  final TextEditingController endController;
  const EventEndDateAndTimePart({super.key, required this.endController});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventCubit, EventState>(
      builder: (context, state) {
        if (state is EventEndDateFinished) {
          endController.text = state.endDate;
        }
        return CustomTextField(
          controller: endController,
          supportSuffix: true,
          suffixIcon: Icons.date_range,
          onSuffixTap: () async {
            DateTime? dateTime = await showOmniDateTimePicker(
              theme: ThemeData(
                colorScheme: ColorScheme.dark(
                  primary: AppColor.secondaryColor,
                  surface: AppColor.primaryColor,
                  onSurface: AppColor.textColor,
                ),
              ),
              context: context,
            );
            if (dateTime != null && context.mounted) {
              BlocProvider.of<EventCubit>(
                context,
              ).setEndDate(AppUtils.formatDateTime(dateTime));
            }
          },
          label: AppStrings.eventEndDate,
          hint: AppStrings.eventEndDateHint,
        );
      },
    );
  }
}
