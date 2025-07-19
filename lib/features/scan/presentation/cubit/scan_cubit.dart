import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_sacnner_app/core/constant/app_constant.dart';
import 'package:qr_code_sacnner_app/core/constant/app_strings.dart';
import 'package:qr_code_sacnner_app/core/utils/barcode_utils.dart';
import 'package:qr_code_sacnner_app/features/history/data/models/history_model.dart';
import 'package:uuid/uuid.dart';

part 'scan_state.dart';

class ScanCubit extends Cubit<ScanState> {
  ScanCubit() : super(ScanInitial());

  void addToHistory(String scannedData) {
    final box = Hive.box<HistoryModel>(AppConstant.hiveBoxHistory);

    final historyItem = HistoryModel(
      id: const Uuid().v4(),
      title: BarcodeUtils.isWifiBarcode(scannedData)
          ? BarcodeUtils.getWifiSsid(scannedData)!
          : scannedData,
      date: DateTime.now(),
      content: scannedData,
    );
    box.add(historyItem);
    emit(ScanSuccess(scannedData));
  }

  void onQRDetected(String scannedData) async {
    emit(ScanSuccess(scannedData));
  }

  Future<void> scanQRCodeFromImage() async {
    try {
      emit(ScanLoading());

      // Use ImagePicker to select an image from the gallery
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage == null) return;

      // Create an InputImage from the selected image
      final inputImage = InputImage.fromFile(File(pickedImage.path));
      final barcodeScanner = BarcodeScanner();
      final barcodes = await barcodeScanner.processImage(inputImage);
      barcodeScanner.close();

      if (barcodes.isEmpty || barcodes.first.rawValue == null) {
        emit(ScanFailure(AppStrings.noQRFoundInImage));
      } else {
        final code = barcodes.first.rawValue!;
        addToHistory(code);
        emit(ScanImageSuccess(code));
      }
    } catch (e) {
      emit(ScanFailure(AppStrings.failedToScanQRCodeFromImage));
    }
  }
}
