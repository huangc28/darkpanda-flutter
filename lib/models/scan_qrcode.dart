class ScanQrCode {
  final String qrCodeSecret;
  final String qrCodeUuid;

  ScanQrCode({
    this.qrCodeSecret,
    this.qrCodeUuid,
  });

  factory ScanQrCode.copyFrom(
    String qrCodeSecret,
    String qrCodeUuid,
  ) {
    return ScanQrCode(
      qrCodeSecret: qrCodeSecret ?? qrCodeSecret,
      qrCodeUuid: qrCodeUuid ?? qrCodeUuid,
    );
  }

  factory ScanQrCode.fromJson(Map<String, dynamic> data) {
    return ScanQrCode(
      qrCodeSecret: data['qrcode_secret'],
      qrCodeUuid: data['qrcode_uuid'],
    );
  }
}
