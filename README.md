# AUTH-CAPTCHA

A comprehensive Flutter CAPTCHA solution with multi-layer security verification. AUTH-CAPTCHA provides bot detection, device fingerprinting, ALTCHA proof-of-work, and slider CAPTCHA challenges to protect your Flutter applications.

## Features

**Multi-Layer Security**
- Level 1: Device fingerprinting and bot detection
- Level 2: ALTCHA proof-of-work challenge
- Level 3: Interactive slider CAPTCHA

**Device Fingerprinting**
- Platform detection
- Device information collection
- Root/Jailbreak detection
- Development mode detection
- Risk scoring algorithm

**Flexible Configuration**
- Configurable security levels
- Multi-layer failover support
- Customizable API endpoints

**Easy Integration**
- Simple widget-based API
- Callback-based result handling
- Minimal setup required

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  tri_shield_captcha:
#      git:
#        url: https://github.com/Haider-Dictalabs/tri_shield_captcha.git
```

Then run:

```bash
flutter pub get
```

## Quick Start

### Basic Usage

```dart
import 'package:flutter/material.dart';
import 'package:tri_shield_captcha/auth_captcha.dart';

class MyLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AuthCaptcha(
          apiKey: 'your-api-key-here',
          webUrl: 'https://yourwebsite.com',
          onResult: (CaptchaResult result) {
            if (result.isVerified) {
              print('CAPTCHA verified! UUID: ${result.uuid}');
              // Proceed with your login/form submission
            }
          },
        ),
      ),
    );
  }
}
```

### Advanced Usage

```dart
import 'package:flutter/material.dart';
import 'package:tri_shield_captcha/auth_captcha.dart';

class AdvancedLoginPage extends StatefulWidget {
  @override
  State<AdvancedLoginPage> createState() => _AdvancedLoginPageState();
}

class _AdvancedLoginPageState extends State<AdvancedLoginPage> {
  bool _captchaVerified = false;
  String? _verificationUuid;

  void _handleCaptchaResult(CaptchaResult result) {
    setState(() {
      _captchaVerified = result.isVerified;
      _verificationUuid = result.uuid;
    });

    if (result.isVerified) {
      // Proceed with your business logic
      _submitForm();
    }
  }

  Future<void> _submitForm() async {
    // Use _verificationUuid in your API call
    print('Submitting form with UUID: $_verificationUuid');
    // Your API call here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Secure Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 24),
            
            // AuthCAPTCHA
            AuthCaptcha(
              apiKey: 'your-api-key',
              webUrl: 'https://yourwebsite.com',
              includePadding: true,
              onResult: _handleCaptchaResult,
            ),
            
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _captchaVerified ? _submitForm : null,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Configuration

### API Key and Web URL

You need to obtain an API key from TriShield. Contact the TriShield team or visit their dashboard to generate your keys.

```dart
AuthCaptcha(
  apiKey: 'your-api-key-here',  // Required
  webUrl: 'https://yourapp.com', // Required - your website/app URL
  onResult: (result) { /* ... */ },
)
```

### Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `apiKey` | `String` | Yes | - | Your TriShield API key |
| `webUrl` | `String` | Yes | - | Your registered website/app URL |
| `onResult` | `Function(CaptchaResult)` | Yes | - | Callback when verification completes |
| `includePadding` | `bool` | No | `true` | Whether to include vertical padding |

## Security Levels

AUTH-CAPTCHA supports three security levels:

### Level 1: Device Fingerprinting
- Automatic verification using device fingerprinting
- Bot detection using risk scoring
- Fastest user experience
- No user interaction required (if not flagged as bot)

### Level 2: ALTCHA + Device Fingerprinting
- Adds ALTCHA proof-of-work challenge
- Computational challenge to verify humanity
- Balances security and user experience

### Level 3: Full Multi-Layer (Device + ALTCHA + Slider)
- Maximum security
- All three verification methods
- Interactive slider CAPTCHA as final layer
- Best for high-risk operations

The security level is configured server-side through your TriShield dashboard.

## Customization

### Logging

Enable/disable logging:

```dart
import 'package:tri_shield_captcha/auth_captcha.dart';

// The package includes AppLogger for debugging
// Logs are automatically printed in debug mode
```

## Error Handling

The widget handles errors gracefully:

```dart
AuthCaptcha(
  apiKey: 'invalid-key',
  webUrl: 'https://example.com',
  onResult: (result) {
    // This will only be called on successful verification
    // Errors are displayed in the widget itself
  },
)
```

Common error states:
- **Invalid API Key or URL**: Displays "Invalid key or URL" message
- **Bot Detected**: Shows "Automated activity detected" warning
- **Network Issues**: Displays loading indicator and retries

## Platform Support

| Platform | Supported |
|----------|-----------|
| Android | ✅ |
| iOS | ✅ |

## Dependencies

This package uses:
- `http` - HTTP requests
- `altcha_widget` - ALTCHA proof-of-work implementation
- `device_info_plus` - Device information collection
- `safe_device` - Root/Jailbreak detection
- `crypto` - Cryptographic hashing

## Examples

Check out the `/example` folder for complete examples:
- Basic integration
- Form validation with CAPTCHA
- Multi-step authentication flow
- Custom styling

## Troubleshooting

### CAPTCHA not appearing
- Verify your API key is correct
- Check that your webUrl matches the registered URL in TriShield dashboard
- Ensure network connectivity

### Bot detection too strict/lenient
- Contact TriShield support to adjust your risk thresholds
- Risk scoring is configured server-side

### Build issues
```bash
flutter clean
flutter pub get
flutter pub upgrade
```

## License

MIT License - see LICENSE file for details

## Contributing

Contributions are welcome! Please read our contributing guidelines before submitting PRs.

---