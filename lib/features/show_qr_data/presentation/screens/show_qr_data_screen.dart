import 'package:email_validator/email_validator.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_sacnner_app/core/color/app_color.dart';
import 'package:qr_code_sacnner_app/core/constant/app_strings.dart';
import 'package:qr_code_sacnner_app/core/extensions/context_extensions.dart';
import 'package:qr_code_sacnner_app/core/services/native_bridge.dart';
import 'package:qr_code_sacnner_app/core/utils/app_utils.dart';
import 'package:qr_code_sacnner_app/core/utils/screen_utils.dart';
import 'package:qr_code_sacnner_app/features/show_qr_data/data/models/wifi_model.dart';
import 'package:qr_code_sacnner_app/features/show_qr_data/data/vcard_model.dart';
import 'package:qr_code_sacnner_app/features/show_qr_data/presentation/cubit/view_qr_data_cubit.dart';
import 'package:qr_code_sacnner_app/features/widgets/custom_app_bar.dart';
import 'package:qr_code_sacnner_app/features/widgets/custom_icon_button.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ShowQrDataScreen extends StatefulWidget {
  final String data;
  final String type;
  const ShowQrDataScreen({super.key, required this.data, required this.type});

  @override
  State<ShowQrDataScreen> createState() => _ViewQrDataScreenState();
}

class _ViewQrDataScreenState extends State<ShowQrDataScreen> {
  @override
  Widget build(BuildContext context) {
    final vCardModel = VCardModel.fromRaw(widget.data);
    context.read<ViewQrDataCubit>().setType(widget.type);

    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(title: widget.type),
              SizedBox(height: context.screenHeight * 0.06),
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.secondaryColor,
                        blurRadius: 15,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: QrImageView(
                      data: widget.data,
                      version: QrVersions.auto,
                      size: 200.0,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
              ),
              BlocBuilder<ViewQrDataCubit, String>(
                builder: (context, state) {
                  if (state == 'contact') {
                    return ContactSection(
                      contact: vCardModel,
                      data: widget.data,
                    );
                  } else if (state == 'wifi') {
                    return WifiSection(data: widget.data);
                  }
                  return TextSection(
                    data: widget.data,
                    type: widget.type.toLowerCase(),
                  );
                },
              ),
              SizedBox(height: context.screenHeight * 0.06),
            ],
          ),
        ),
      ),
    );
  }
}

class WifiSection extends StatelessWidget {
  WifiSection({super.key, required this.data});
  final String data;
  late WifiModel wifiModel;

  @override
  Widget build(BuildContext context) {
    wifiModel = WifiModel.fromRaw(data);
    final isLandScape = ScreenUtils.isLandscape(context);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.wifi,
                color: AppColor.secondaryColor,
                size: isLandScape
                    ? context.screenHeight * 0.30
                    : context.screenHeight * 0.15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      text: '${AppStrings.networkName}: ',
                      style: TextStyle(color: AppColor.textColor),
                      children: [
                        TextSpan(
                          text: wifiModel.ssid,
                          style: TextStyle(color: AppColor.secondaryColor),
                        ),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      text: '${AppStrings.type}: ',
                      style: TextStyle(color: AppColor.textColor),
                      children: [
                        TextSpan(
                          text: wifiModel.type,
                          style: TextStyle(color: AppColor.secondaryColor),
                        ),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      text: '${AppStrings.password}: ',
                      style: TextStyle(color: AppColor.textColor),
                      children: [
                        TextSpan(
                          text: wifiModel.password,
                          style: TextStyle(color: AppColor.secondaryColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: context.screenHeight * 0.03),
        IconButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(AppColor.secondaryColor),
          ),
          padding: EdgeInsets.all(20),
          onPressed: () => AppUtils.openWifiSettings(),
          icon: Icon(Icons.wifi, color: Colors.white),
        ),
        const SizedBox(height: 10),
        Text(
          AppStrings.connectToWifi,
          style: TextStyle(color: AppColor.textColor),
        ),
        SizedBox(height: context.screenHeight * 0.03),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                IconButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      AppColor.secondaryColor,
                    ),
                  ),
                  padding: EdgeInsets.all(20),
                  onPressed: () =>
                      AppUtils.copyToClipboard(context, wifiModel.password),
                  icon: Icon(Icons.copy, color: Colors.white),
                ),
                const SizedBox(height: 10),
                Text(
                  AppStrings.copyPassword,
                  style: TextStyle(color: AppColor.textColor),
                ),
              ],
            ),

            Column(
              children: [
                IconButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      AppColor.secondaryColor,
                    ),
                  ),
                  padding: EdgeInsets.all(20),
                  onPressed: () =>
                      AppUtils.copyToClipboard(context, wifiModel.ssid),
                  icon: Icon(Icons.copy, color: Colors.white),
                ),
                const SizedBox(height: 10),
                Text(
                  AppStrings.copyWifiName,
                  style: TextStyle(color: AppColor.textColor),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class TextSection extends StatelessWidget {
  final String data;
  final String type;
  const TextSection({super.key, required this.data, required this.type});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: context.screenHeight * 0.03),
          Container(
            padding: const EdgeInsets.all(20),
            child: Text(
              data,
              style: type == 'url'
                  ? TextStyle(
                      decorationColor: AppColor.secondaryColor,
                      decorationThickness: 1.5,
                      color: AppColor.secondaryColor,
                      decoration: TextDecoration.underline,
                      fontSize: context.textScaler.scale(18),
                    )
                  : TextStyle(
                      color: AppColor.secondaryColor,
                      fontSize: context.textScaler.scale(18),
                    ),
            ),
          ),
          SizedBox(height: context.screenHeight * 0.03),
          Row(
            mainAxisAlignment: type == 'url'
                ? MainAxisAlignment.spaceAround
                : MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  IconButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        AppColor.secondaryColor,
                      ),
                    ),
                    padding: EdgeInsets.all(20),
                    onPressed: () => AppUtils.copyToClipboard(context, data),
                    icon: Icon(Icons.copy, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    AppStrings.copy,
                    style: TextStyle(color: AppColor.textColor),
                  ),
                ],
              ),
              type == 'url'
                  ? Column(
                      children: [
                        IconButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              AppColor.secondaryColor,
                            ),
                          ),
                          padding: EdgeInsets.all(20),
                          onPressed: () => AppUtils.openUrl(data),
                          icon: Icon(Icons.open_in_new, color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          AppStrings.open,
                          style: TextStyle(color: AppColor.textColor),
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ],
      ),
    );
  }
}

class ContactSection extends StatelessWidget {
  final VCardModel contact;
  final String data;

  const ContactSection({super.key, required this.contact, required this.data});

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: AppColor.textColor,
      fontSize: context.textScaler.scale(16),
    );
    final subTextStyle = TextStyle(
      color: AppColor.secondaryColor,
      fontSize: context.textScaler.scale(14),
    );

    List<Widget> buildTiles() {
      final fields = <Widget>[];

      void addTile(String title, String? value) {
        if (value != null && value.trim().isNotEmpty) {
          fields.add(
            ListTile(
              title: Text(title, style: textStyle),
              subtitle: Text(value, style: subTextStyle),
              onLongPress: () => AppUtils.copyToClipboard(context, value),
            ),
          );
        }
      }

      void addMultiTile(String title, List<String> values) {
        for (var value in values) {
          if (value.trim().isNotEmpty) {
            fields.add(
              ListTile(
                title: Text(title, style: textStyle),
                subtitle: Text(value, style: subTextStyle),
                onLongPress: () => AppUtils.copyToClipboard(context, value),
              ),
            );
          }
        }
      }

      if (contact.firstName != null && contact.lastName != null) {
        addTile(AppStrings.firstName, contact.firstName);
        addTile(AppStrings.lastName, contact.lastName);
      } else {
        addTile(AppStrings.name, contact.fullName);
      }

      addMultiTile(AppStrings.phone, contact.phones);
      addMultiTile(AppStrings.email, contact.emails);
      addTile(AppStrings.organization, contact.organization);
      addTile(AppStrings.title, contact.title);
      addMultiTile(AppStrings.address, contact.addresses);
      addMultiTile(AppStrings.website, contact.websites);
      addTile(AppStrings.note, contact.note);

      return fields;
    }

    return Column(
      children: [
        SizedBox(height: context.screenHeight * 0.06),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: AppColor.primaryColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 15,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ExpansionTileCard(
            baseColor: AppColor.primaryColor,
            expandedColor: AppColor.primaryColor,
            expandedTextColor: AppColor.textColor,
            animateTrailing: true,
            shadowColor: Colors.transparent,
            elevation: 10,
            trailing: Icon(
              Icons.arrow_drop_down,
              color: AppColor.secondaryColor,
            ),
            leading: Icon(Icons.person, color: AppColor.secondaryColor),
            title: Text(
              AppStrings.viewData,
              style: TextStyle(
                color: Colors.white,
                fontSize: context.textScaler.scale(16),
              ),
            ),
            children: buildTiles(),
          ),
        ),
        const SizedBox(height: 20),
        if (contact.phones.isNotEmpty &&
            contact.phones.any(
              (number) => number.isNotEmpty && AppUtils.isNumeric(number),
            )) ...[
          CustomIconButton(
            onPressed: () async {
              await NativeBridge.insertContactFromVCard(data);
            },
            label: AppStrings.addContact,
            icon: Icons.add_call,
          ),
          SizedBox(height: context.screenHeight * 0.04),
          CustomIconButton(
            onPressed: () async {
              await AppUtils.dialPhoneNumber(contact.phones.first);
            },
            label: '${AppStrings.dial} ${contact.phones.first}',
            icon: Icons.phone,
          ),
        ],
        if (contact.emails.isNotEmpty &&
            contact.emails.any(
              (email) => email.isNotEmpty && EmailValidator.validate(email),
            )) ...[
          SizedBox(height: context.screenHeight * 0.04),
          CustomIconButton(
            onPressed: () {
              AppUtils.openEmail(contact.emails.first);
            },
            label: '${AppStrings.emailTo} ${contact.emails.first}',
            icon: Icons.email,
          ),
        ],
        if (contact.websites.isNotEmpty &&
            contact.websites.any(
              (website) => website.isNotEmpty && AppUtils.isValidUrl(website),
            )) ...[
          SizedBox(height: context.screenHeight * 0.04),
          CustomIconButton(
            onPressed: () {
              AppUtils.openUrl(contact.websites.first);
            },
            label: '${AppStrings.open} ${contact.websites.first}',
            icon: Icons.open_in_browser,
          ),
        ],

        if (contact.addresses.isNotEmpty &&
            contact.addresses.any(
              (address) =>
                  address.isNotEmpty && AppUtils.isValidAddress(address),
            )) ...[
          SizedBox(height: context.screenHeight * 0.04),
          CustomIconButton(
            onPressed: () {
              AppUtils.openMap(contact.addresses.first);
            },
            label: '${AppStrings.viewAddress} ${contact.addresses.first}',
            icon: Icons.location_on,
          ),
        ],
      ],
    );
  }
}
