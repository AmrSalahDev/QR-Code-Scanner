import 'package:qr_code_sacnner_app/core/constant/app_strings.dart';

class ValidateWifiInputUseCase {
  String? call({required String ssid, required String password}) {
    if (ssid.isEmpty) return AppStrings.wifiNameCannotBeEmpty;
    if (password.isEmpty) return AppStrings.passwordCannotBeEmpty;
    return null;
  }
}
