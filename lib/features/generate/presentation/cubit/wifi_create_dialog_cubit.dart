import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_sacnner_app/core/services/dialog_service.dart';
import '../../../domain/usecases/validate_wifi_input_usecase.dart';

class WifiCreateDialogCubit extends Cubit<void> {
  final ValidateWifiInputUseCase _validate;
  final DialogService _dialogService;

  WifiCreateDialogCubit(this._validate, this._dialogService) : super(null);

  void openDialog({
    required BuildContext context,
    required void Function(String data) onTap,
  }) {
    _dialogService.showCreateWifiDialog(
      context: context,
      onTap: (wifi) {
        final result = _validate(
          ssid: wifi['ssid']!,
          password: wifi['password']!,
        );
        if (result != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(result)));
          return;
        }
        final qrData = 'WIFI:T:WPA;S:${wifi['ssid']};P:${wifi['password']};""';
        onTap(qrData);
      },
    );
  }
}
