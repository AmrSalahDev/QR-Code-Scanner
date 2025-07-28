// location_input_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:qr_code_sacnner_app/core/utils/location_utils.dart';

part 'location_input_state.dart';

class LocationInputCubit extends Cubit<LocationInputState> {
  LocationInputCubit() : super(LocationInputState.initial());

  void updateLatitude(String value) {
    emit(state.copyWith(latitude: value));
    _validateInputs();
  }

  void updateLongitude(String value) {
    emit(state.copyWith(longitude: value));
    _validateInputs();
  }

  void _validateInputs() {
    final lat = double.tryParse(state.latitude.trim());
    final lng = double.tryParse(state.longitude.trim());

    final isValid =
        lat != null && lng != null && lat.abs() <= 90 && lng.abs() <= 180;
    final isEmpty =
        state.latitude.trim().isEmpty && state.longitude.trim().isEmpty;

    if (isValid) {
      _decodeAddress(lat!, lng!);
    } else {
      emit(
        state.copyWith(isValid: false, isEmpty: isEmpty, decodedAddress: null),
      );
    }
  }

  Future<void> _decodeAddress(double lat, double lng) async {
    final address = await LocationUtils.getAddressFromLatLng(LatLng(lat, lng));
    final formatted =
        '${address['street']}, ${address['city']}, ${address['country']}';

    emit(
      state.copyWith(isValid: true, isEmpty: false, decodedAddress: formatted),
    );
  }
}
