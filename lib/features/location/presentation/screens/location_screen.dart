import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:qr_code_sacnner_app/core/color/app_color.dart';
import 'package:qr_code_sacnner_app/core/constant/app_strings.dart';
import 'package:qr_code_sacnner_app/core/routes/app_router.dart';
import 'package:qr_code_sacnner_app/core/services/di/di.dart';
import 'package:qr_code_sacnner_app/core/services/dialog_service.dart';
import 'package:qr_code_sacnner_app/core/utils/barcode_utils.dart';
import 'package:qr_code_sacnner_app/features/widgets/custom_app_bar.dart';

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
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: initialLocation,
              initialZoom: 14,
              interactionOptions: InteractionOptions(
                flags: InteractiveFlag.all, // enable pan, zoom, tap, etc.
              ),
              onTap: (tapPosition, point) {
                setState(() {
                  selectedLocation = point;
                });
              },
              onMapReady: () {
                print("Map is ready!");
              },
            ),
            // api key: 9gJxUjkQfyXkZh4SK64v
            children: [
              TileLayer(
                // for dark mode
                // urlTemplate:
                //     "https://api.maptiler.com/maps/darkmatter/{z}/{x}/{y}.png?key=9gJxUjkQfyXkZh4SK64v",
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
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
      ),
      floatingActionButton: selectedLocation != null
          ? FloatingActionButton(
              backgroundColor: AppColor.secondaryColor,
              foregroundColor: AppColor.primaryColor,
              child: Icon(Icons.check, color: AppColor.primaryColor),
              onPressed: () {
                String location = BarcodeUtils.generateQRCode(
                  AppStrings.location,
                  '${selectedLocation!.latitude},${selectedLocation!.longitude}',
                );

                context.push(AppRouter.showQrCode, extra: {'qrData': location});
                getAddressFromLatLng(selectedLocation!);
              },
            )
          : null,
    );
  }

  Future<void> getAddressFromLatLng(LatLng position) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final address = "${place.street}, ${place.locality}, ${place.country}";
        print("📍 Address: $address");

        // Optional: Show in a Snackbar or Text widget
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(address)));
      }
    } catch (e) {
      print("❌ Failed to get address: $e");
    }
  }
}
