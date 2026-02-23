class CaptchaResult {

  const CaptchaResult({
    required this.isVerified,
    this.uuid,
  });
  final bool isVerified;
  final String? uuid;
}
