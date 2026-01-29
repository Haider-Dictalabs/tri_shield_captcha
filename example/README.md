# TriShield CAPTCHA Examples

This directory contains example applications demonstrating how to use the TriShield CAPTCHA package.

## Running the Examples

1. Navigate to the example directory:
```bash
cd example
```

2. Get dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Examples Included

### 1. Basic Integration
The simplest way to add TriShield CAPTCHA to your app. Shows:
- Minimal widget setup
- Result handling
- Success feedback

### 2. Login Form
A complete login form with CAPTCHA protection. Demonstrates:
- Form validation
- CAPTCHA integration with forms
- Conditional button enabling
- Loading states

### 3. Registration Form
A multi-field registration form. Shows:
- Complex form handling
- Terms and conditions checkbox
- Password confirmation
- CAPTCHA as part of multi-step validation

## Customization

To use these examples with your own API key:

1. Open `lib/main.dart`
2. Replace `YOUR_API_KEY_HERE` with your actual API key
3. Replace `https://yourwebsite.com` with your registered website URL

```dart
TriShieldCaptcha(
  apiKey: 'your-actual-api-key',
  webUrl: 'https://yourwebsite.com',
  onResult: _handleCaptchaResult,
)
```

## Getting an API Key

Visit [TriShield Dashboard](https://dashboard.trishield.com) to:
1. Create an account
2. Register your website/app
3. Generate your API keys
4. Configure security levels

## Support

For help with the examples:
- Check the main [README.md](../README.md)
- Visit [Documentation](https://docs.trishield.com)
- Contact support@trishield.com
