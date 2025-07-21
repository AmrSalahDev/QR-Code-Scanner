part of 'scan_cubit.dart';

sealed class ScanState {}

final class ScanInitial extends ScanState {}

final class ScanSuccess extends ScanState {
  final String scannedData;
  final String type;

  ScanSuccess(this.scannedData, this.type);
}

final class ScanFailure extends ScanState {
  final String error;

  ScanFailure(this.error);
}

final class ScanLoading extends ScanState {}

final class ScanImageSuccess extends ScanState {
  final String scannedData;
  final String type;

  ScanImageSuccess(this.scannedData, this.type);
}

final class ScanImageFailure extends ScanState {
  final String error;

  ScanImageFailure(this.error);
}

final class ScanAlreadyExists extends ScanState {}

final class ScanOutputIsEmpty extends ScanState {}
