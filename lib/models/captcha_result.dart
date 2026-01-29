class CaptchaResult {
  final bool isVerified;
  final String? uuid;

  const CaptchaResult({
    required this.isVerified,
    this.uuid,
  });
}
