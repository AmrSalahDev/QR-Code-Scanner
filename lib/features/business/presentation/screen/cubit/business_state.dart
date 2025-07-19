part of 'business_cubit.dart';

@immutable
sealed class BusinessState {}

final class BusinessInitial extends BusinessState {}

final class BusinessFormSuccess extends BusinessState {
  final String qrCode;
  BusinessFormSuccess({required this.qrCode});
}

final class BusinessFormError extends BusinessState {
  final String message;
  BusinessFormError({required this.message});
}
