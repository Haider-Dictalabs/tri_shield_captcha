class Constants {
  static const triShieldBaseUrl = 'https://api.trishield.dictalabs.com';
  static const captchaBaseUrl = 'https://captcha-demo.dictalabs.com';
  static const loginBaseUrl = 'https://login-demo.dictalabs.com/auth/login';

  static const sliderBaseUrl = '$captchaBaseUrl/slider';
  static const altchaChallengeUrl = '$captchaBaseUrl/altcha';
  static const verifyUserKeyUrl = '$triShieldBaseUrl/keys/verifyUserKey';
  static const saveCaptchaLogUrl = '$triShieldBaseUrl/logs/saveLog';
  static const newCaptchaUrl = '$sliderBaseUrl/captcha/new';
  static const verifyCaptchaUrl = '$sliderBaseUrl/captcha/verify';

  static const botDetectionRiskThreshold = 60;
}
