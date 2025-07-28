import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:qr_code_sacnner_app/core/color/app_color.dart';
import 'package:qr_code_sacnner_app/core/constant/app_strings.dart';
import 'package:qr_code_sacnner_app/core/extensions/context_extensions.dart';
import 'package:qr_code_sacnner_app/core/routes/app_router.dart';
import 'package:qr_code_sacnner_app/core/routes/args/show_qr_code_args.dart';
import 'package:qr_code_sacnner_app/core/utils/location_utils.dart';
import 'package:qr_code_sacnner_app/core/utils/qr_code_utils.dart';
import 'package:qr_code_sacnner_app/features/location/presentation/cubit/location_input_cubit.dart';
import 'package:qr_code_sacnner_app/features/widgets/common_button.dart';
import 'package:qr_code_sacnner_app/features/widgets/custom_text_field.dart';
import 'package:qr_code_sacnner_app/global/cubits/connection_cubit.dart';
import 'package:qr_code_sacnner_app/features/widgets/custom_app_bar.dart';
import 'package:qr_code_sacnner_app/features/widgets/network_aware_widget.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  LatLng? selectedLocation;

  final mapController = MapController();
  final initialLocation = LatLng(30.033333, 31.233334); // Cairo

  @override
  Widget build(BuildContext context) {
    return NetworkAwareWidget(
      onOffline: () => context.read<ConnectionCubit>().setDisconnected(),
      onOnline: () => context.read<ConnectionCubit>().setConnected(),
      child: Scaffold(
        backgroundColor: AppColor.primaryColor,
        body: BlocBuilder<ConnectionCubit, ConnectionStatus>(
          builder: (context, state) {
            final isOnline = state == ConnectionStatus.connected;
            return isOnline
                ? Stack(
                    children: [
                      FlutterMap(
                        mapController: mapController,
                        options: MapOptions(
                          initialCenter: initialLocation,
                          initialZoom: 14,
                          interactionOptions: InteractionOptions(
                            flags: InteractiveFlag
                                .all, // enable pan, zoom, tap, etc.
                          ),
                          onTap: (tapPosition, point) {
                            setState(() {
                              selectedLocation = point;
                            });
                          },
                        ),
                        // api key: 9gJxUjkQfyXkZh4SK64v
                        children: [
                          TileLayer(
                            // for dark mode
                            // urlTemplate:
                            //     "https://api.maptiler.com/maps/darkmatter/{z}/{x}/{y}.png?key=9gJxUjkQfyXkZh4SK64v",
                            //urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                            urlTemplate:
                                "https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}.png?key=9gJxUjkQfyXkZh4SK64v",
                            userAgentPackageName:
                                'com.blackcode.qrapp', // Avoid using Future here!
                          ),
                          if (selectedLocation != null)
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: selectedLocation!,
                                  width: 40,
                                  height: 40,
                                  child: Icon(
                                    Icons.location_pin,
                                    color: Colors.red,
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                      SafeArea(
                        child: CustomAppBar(
                          title: AppStrings.pickLocation,
                          marginVertical: 12,
                        ),
                      ),
                    ],
                  )
                : BlocProvider(
                    create: (context) => LocationInputCubit(),
                    child: ShowWriteLocationSection(
                      selectedLocation: selectedLocation ?? initialLocation,
                    ),
                  );
          },
        ),
        floatingActionButton: selectedLocation != null
            ? FloatingActionButton(
                backgroundColor: AppColor.secondaryColor,
                foregroundColor: AppColor.primaryColor,
                child: Icon(Icons.check, color: AppColor.primaryColor),
                onPressed: () => _generateQrCode(selectedLocation, context),
              )
            : null,
      ),
    );
  }
}

void _generateQrCode(LatLng? selectedLocation, BuildContext context) {
  String location = BarcodeUtils.generateQRCode(
    AppStrings.location,
    '${selectedLocation!.latitude},${selectedLocation!.longitude}',
  );

  context.push(
    AppRouter.showQrCode,
    extra: ShowQrCodeArgs(
      qrData: location,
      qrType: AppStrings.location,
      qrDataBeforeFormatting: selectedLocation,
    ),
  );
}

class ShowWriteLocationSection extends StatefulWidget {
  final LatLng selectedLocation;
  const ShowWriteLocationSection({super.key, required this.selectedLocation});

  @override
  State<ShowWriteLocationSection> createState() =>
      _ShowWriteLocationSectionState();
}

class _ShowWriteLocationSectionState extends State<ShowWriteLocationSection> {
  late final TextEditingController latitudeController;
  late final TextEditingController longitudeController;

  @override
  void initState() {
    latitudeController = TextEditingController();
    longitudeController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    latitudeController.dispose();
    longitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LocationInputCubit>();

    latitudeController.addListener(() {
      cubit.updateLatitude(latitudeController.text);
    });

    longitudeController.addListener(() {
      cubit.updateLongitude(longitudeController.text);
    });

    return SafeArea(
      child: BlocBuilder<LocationInputCubit, LocationInputState>(
        builder: (context, state) {
          return Column(
            children: [
              CustomAppBar(title: AppStrings.setLocation, marginVertical: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (!state.isEmpty) ...[
                          SizedBox(
                            height: context.isLandscape
                                ? 0
                                : context.screenHeight * 0.05,
                          ),
                          Text(
                            state.decodedAddress ?? AppStrings.invalidLocation,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColor.secondaryColor,
                              fontSize: context.textScaler.scale(23),
                            ),
                          ),
                        ],
                        SizedBox(
                          height: context.isLandscape
                              ? 0
                              : context.screenHeight * 0.06,
                        ),
                        CustomTextField(
                          label: AppStrings.latitude,
                          hint: AppStrings.latitudeHint,
                          controller: latitudeController,
                          textInputType: TextInputType.number,
                        ),
                        CustomTextField(
                          label: AppStrings.longitude,
                          hint: AppStrings.longitudeHint,
                          controller: longitudeController,
                          textInputType: TextInputType.number,
                        ),
                        SizedBox(height: context.screenHeight * 0.04),
                        CommonButton(
                          btnLabel: AppStrings.generateQrCode,
                          onTap: () =>
                              _generateQrCode(widget.selectedLocation, context),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
