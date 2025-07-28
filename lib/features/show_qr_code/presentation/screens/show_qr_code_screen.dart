import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:qr_code_sacnner_app/core/color/app_color.dart';
import 'package:qr_code_sacnner_app/core/constant/app_strings.dart';
import 'package:qr_code_sacnner_app/core/extensions/context_extensions.dart';
import 'package:qr_code_sacnner_app/core/utils/app_utils.dart';
import 'package:qr_code_sacnner_app/core/utils/location_utils.dart';
import 'package:qr_code_sacnner_app/features/widgets/custom_app_bar.dart';
import 'package:qr_code_sacnner_app/features/widgets/custom_circle_button.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:translator/translator.dart';

class ShowQrCodeScreen extends StatelessWidget {
  final String qrData;
  final String? qrType;
  final Object? qrCodeBeforeFormatting;
  const ShowQrCodeScreen({
    super.key,
    required this.qrData,
    this.qrType,
    this.qrCodeBeforeFormatting,
  });

  @override
  Widget build(BuildContext context) {
    final GlobalKey qrKey = GlobalKey();

    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomAppBar(title: AppStrings.qrCode),
              SizedBox(height: context.screenHeight * 0.06),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.secondaryColor,
                      blurRadius: 15,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: RepaintBoundary(
                  key: qrKey,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: QrImageView(
                      data: qrData,
                      version: QrVersions.auto,
                      size: 200.0,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: context.screenHeight * 0.08),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomCircleButton(
                    onPressed: () => AppUtils.shareQrCode(qrKey),
                    icon: Icons.share_rounded,
                    title: AppStrings.share,
                  ),
                  CustomCircleButton(
                    onPressed: () => AppUtils.saveQrCode(qrKey),
                    icon: Icons.save_rounded,
                    title: AppStrings.save,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GetAddressFormLatLng extends StatelessWidget {
  const _GetAddressFormLatLng({required this.qrCodeBeforeFormatting});

  final Object? qrCodeBeforeFormatting;

  Future<String> _getAddress(LatLng latLng) async {
    final address = await LocationUtils.getAddressFromLatLng(latLng);
    return '${address['street']}, ${address['city']}, ${address['country']}';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getAddress(qrCodeBeforeFormatting as LatLng),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(color: AppColor.secondaryColor);
        } else if (snapshot.hasError) {
          return Text('');
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onLongPress: () =>
                  AppUtils.copyToClipboard(context, snapshot.data ?? ''),
              child: Text(
                snapshot.data ?? '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: context.textScaler.scale(16),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
