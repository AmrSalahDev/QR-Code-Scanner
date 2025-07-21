import 'package:email_validator/email_validator.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_sacnner_app/core/color/app_color.dart';
import 'package:qr_code_sacnner_app/core/constant/app_strings.dart';
import 'package:qr_code_sacnner_app/core/extensions/context_extensions.dart';
import 'package:qr_code_sacnner_app/core/services/native_bridge.dart';
import 'package:qr_code_sacnner_app/core/utils/app_utils.dart';
import 'package:qr_code_sacnner_app/features/view_qr_data/data/vcard_model.dart';
import 'package:qr_code_sacnner_app/features/widgets/custom_app_bar.dart';
import 'package:qr_code_sacnner_app/features/widgets/custom_icon_button.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewQrDataScreen extends StatefulWidget {
  final String data;
  final String type;
  const ViewQrDataScreen({super.key, required this.data, required this.type});

  @override
  State<ViewQrDataScreen> createState() => _ViewQrDataScreenState();
}

class _ViewQrDataScreenState extends State<ViewQrDataScreen> {
  @override
  Widget build(BuildContext context) {
    final parsed = VCardModel.fromRaw(widget.data);

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
              SizedBox(height: context.screenHeight * 0.06),

              ContactSection(contact: parsed, data: widget.data),

              SizedBox(height: context.screenHeight * 0.06),
            ],
          ),
        ),
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
    final textStyle = TextStyle(color: AppColor.textColor);
    final subTextStyle = TextStyle(color: AppColor.secondaryColor);

    List<Widget> buildTiles() {
      final fields = <Widget>[];

      void addTile(String title, String? value) {
        if (value != null && value.trim().isNotEmpty) {
          fields.add(
            ListTile(
              title: Text(title, style: textStyle),
              subtitle: Text(value, style: subTextStyle),
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
              ),
            );
          }
        }
      }

      if (contact.firstName != null && contact.lastName != null) {
        addTile('First Name', contact.firstName);
        addTile('Last Name', contact.lastName);
      } else {
        addTile('Name', contact.fullName);
      }

      addMultiTile('Phone', contact.phones);
      addMultiTile('Email', contact.emails);
      addTile('Organization', contact.organization);
      addTile('Title', contact.title);
      addMultiTile('Address', contact.addresses);
      addMultiTile('Website', contact.websites);
      addTile('Note', contact.note);

      return fields;
    }

    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: AppColor.primaryColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
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
            title: Text('View data', style: textStyle),
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
            onPressed: () {},
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
            onPressed: () {},
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
            label: 'View Address ${contact.addresses.first}',
            icon: Icons.location_on,
          ),
        ],
      ],
    );
  }
}
