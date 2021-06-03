class ServiceQrCode {
  final String qrcodeUrl;

  ServiceQrCode({
    this.qrcodeUrl,
  });

  factory ServiceQrCode.copyFrom(
    String qrcodeUrl,
  ) {
    return ServiceQrCode(
      qrcodeUrl: qrcodeUrl ?? qrcodeUrl,
    );
  }

  factory ServiceQrCode.fromJson(Map<String, dynamic> data) {
    return ServiceQrCode(
      qrcodeUrl: data['qrcode_url'],
    );
  }
}
