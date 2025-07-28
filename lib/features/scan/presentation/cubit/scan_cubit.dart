import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_sacnner_app/core/constant/app_constant.dart';
import 'package:qr_code_sacnner_app/core/constant/app_strings.dart';
import 'package:qr_code_sacnner_app/core/utils/qr_code_utils.dart';
import 'package:qr_code_sacnner_app/features/history/data/models/history_model.dart';
import 'package:uuid/uuid.dart';

part 'scan_state.dart';

class ScanCubit extends Cubit<ScanState> {
  ScanCubit() : super(ScanInitial());

  final box = Hive.box<HistoryModel>(AppConstant.hiveBoxHistory);

  bool isCodeExists(String code) {
    final isExists = box.values.any((history) => history.content == code);
    if (isExists) {
      return true;
    }
    return box.values.any((element) => element.content == code);
  }

  void addToHistory(String scannedData) {
    final historyItem = HistoryModel(
      id: const Uuid().v4(),
      title: BarcodeUtils.isWifiBarcode(scannedData)
          ? BarcodeUtils.getWifiSsid(scannedData)!
          : scannedData,
      date: DateTime.now(),
      content: scannedData,
    );
    box.add(historyItem);
  }

  void onQRDetected(String scannedData) async {
    if (scannedData.trim().isEmpty) {
      emit(ScanOutputIsEmpty());
      return;
    } else if (isCodeExists(scannedData)) {
      emit(ScanAlreadyExists());
      return;
    } else {
      emit(ScanSuccess(scannedData, BarcodeUtils.getQrCodeType(scannedData)));
      addToHistory(scannedData);
    }
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
      final List<BarcodeFormat> formats = [BarcodeFormat.all];
      final barcodeScanner = BarcodeScanner(formats: formats);
      final barcodes = await barcodeScanner.processImage(inputImage);

      barcodeScanner.close();

      if (barcodes.isEmpty) {
        emit(ScanOutputIsEmpty());
      } else {
        final code = barcodes.first.rawValue!;
        addToHistory(code);
        emit(ScanImageSuccess(code, BarcodeUtils.getQrCodeType(code)));
      }
    } catch (e) {
      emit(ScanImageFailure(AppStrings.failedToScanQRCodeFromImage));
    }
  }
}
