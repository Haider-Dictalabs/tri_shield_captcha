# Quick Start Guide

Get up and running with TriShield CAPTCHA in 5 minutes!

## Step 1: Install the Package

Add to your `pubspec.yaml`:

```yaml
dependencies:
  tri_shield_captcha: ^1.0.0
```

Then run:
```bash
flutter pub get
```

## Step 2: Get Your API Key

1. Visit [TriShield Dashboard](https://dashboard.trishield.com)
2. Sign up or log in
3. Create a new project
4. Register your website/app URL
5. Copy your API key

## Step 3: Import the Package

```dart
import 'package:tri_shield_captcha/tri_shield_captcha.dart';
```

## Step 4: Add the Widget

```dart
class MyLoginPage extends StatefulWidget {
  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  bool _isVerified = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Your form fields here
          TextField(/* ... */),
          
          // Add TriShield CAPTCHA
          TriShieldCaptcha(
            apiKey: 'YOUR_API_KEY',
            webUrl: 'https://yourwebsite.com',
            onResult: (result) {
              setState(() {
                _isVerified = result.isVerified;
              });
            },
          ),
          
          // Submit button
          ElevatedButton(
            onPressed: _isVerified ? _submitForm : null,
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
  
  void _submitForm() {
    // Your submission logic
  }
}
```

## Step 5: Test It!

Run your app:
```bash
flutter run
```

That's it! You now have CAPTCHA protection. 🎉

## What's Next?

- 📖 Read the [Full Documentation](README.md)
- 🔍 Check out [API Reference](API.md)
- 💡 Browse [Examples](example/)
- 🚀 Learn about [Publishing](PUBLISHING.md)

## Common Configurations

### Disable Padding

```dart
TriShieldCaptcha(
  apiKey: 'YOUR_API_KEY',
  webUrl: 'https://yourwebsite.com',
  includePadding: false,  // No vertical padding
  onResult: (result) { /* ... */ },
)
```

### Handle Verification with UUID

```dart
TriShieldCaptcha(
  apiKey: 'YOUR_API_KEY',
  webUrl: 'https://yourwebsite.com',
  onResult: (result) {
    if (result.isVerified) {
      // Send UUID to your backend for validation
      submitToBackend(verificationUuid: result.uuid);
    }
  },
)
```

### Show Custom Feedback

```dart
TriShieldCaptcha(
  apiKey: 'YOUR_API_KEY',
  webUrl: 'https://yourwebsite.com',
  onResult: (result) {
    if (result.isVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✓ Verification successful!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  },
)
```

## Troubleshooting

### CAPTCHA Not Appearing?
- ✅ Check your API key is correct
- ✅ Verify webUrl matches registered URL
- ✅ Ensure internet connection

### Invalid Key Error?
- ✅ Confirm API key in dashboard
- ✅ Check URL is exactly as registered (including https://)
- ✅ Verify account is active

### Build Errors?
```bash
flutter clean
flutter pub get
flutter run
```

## Support

Need help?
- 📧 support@trishield.com
- 💬 [GitHub Issues](https://github.com/yourusername/tri_shield_captcha/issues)
- 📖 [Documentation](https://docs.trishield.com)

Happy coding! 🚀
