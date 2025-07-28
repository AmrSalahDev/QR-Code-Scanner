// location_input_state.dart
part of 'location_input_cubit.dart';

class LocationInputState {
  final String latitude;
  final String longitude;
  final bool isValid;
  final bool isEmpty;
  final String? decodedAddress;

  LocationInputState({
    required this.latitude,
    required this.longitude,
    required this.isValid,
    required this.isEmpty,
    this.decodedAddress,
  });

  factory LocationInputState.initial() {
    return LocationInputState(
      latitude: '',
      longitude: '',
      isValid: false,
      isEmpty: true,
      decodedAddress: null,
    );
  }

  LocationInputState copyWith({
    String? latitude,
    String? longitude,
    bool? isValid,
    bool? isEmpty,
    String? decodedAddress,
  }) {
    return LocationInputState(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isValid: isValid ?? this.isValid,
      isEmpty: isEmpty ?? this.isEmpty,
      decodedAddress: decodedAddress,
    );
  }
}
