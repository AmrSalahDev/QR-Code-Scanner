import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';

class LocationUtils {
  static Future<Map<String, String>> getAddressFromLatLng(
    LatLng position,
  ) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final address = {
          'street': place.street ?? '',
          'city': place.locality ?? '',
          'state': place.administrativeArea ?? '',
          'country': place.country ?? '',
          'postalCode': place.postalCode ?? '',
          'subLocality': place.subLocality ?? '',
        };
        return address;
      }
      return {};
    } catch (e) {
      return {};
    }
  }
}
