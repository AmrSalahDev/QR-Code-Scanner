class ShowQrCodeArgs {
  final String qrData;
  final Object? qrDataBeforeFormatting;
  final String? qrType;
  ShowQrCodeArgs({
    required this.qrData,
    this.qrType,
    this.qrDataBeforeFormatting,
  });
}
