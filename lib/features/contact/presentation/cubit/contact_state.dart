part of 'contact_cubit.dart';

sealed class ContactState {}

final class ContactInitial extends ContactState {}

final class ContactFormSuccess extends ContactState {
  final String qrCode;
  ContactFormSuccess({required this.qrCode});
}

final class ContactFormError extends ContactState {
  final String message;
  ContactFormError({required this.message});
}
