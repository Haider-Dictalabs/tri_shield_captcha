# 📋 Quick Reference Card

## Package Information
- **Name**: tri_shield_captcha
- **Version**: 1.0.0
- **License**: MIT
- **Flutter**: >=3.0.0
- **Dart**: >=3.0.0

## Installation
```yaml
dependencies:
  tri_shield_captcha: ^1.0.0
```

## Basic Usage
```dart
import 'package:tri_shield_captcha/tri_shield_captcha.dart';

TriShieldCaptcha(
  apiKey: 'your-api-key',
  webUrl: 'https://yourapp.com',
  onResult: (result) {
    if (result.isVerified) {
      print('Verified! UUID: ${result.uuid}');
    }
  },
)
```

## Publishing Commands
```bash
# Validate
dart pub publish --dry-run

# Publish
dart pub publish

# Login
dart pub login
```

## Git Commands
```bash
# Initialize
git init
git add .
git commit -m "Initial commit"

# Push to GitHub
git remote add origin https://github.com/USER/REPO.git
git push -u origin main

# Tag release
git tag v1.0.0
git push origin v1.0.0
```

## Testing Commands
```bash
# Analyze
flutter analyze

# Format
dart format .

# Run example
cd example && flutter run
```

## Key Files
- `lib/tri_shield_captcha.dart` - Main export
- `pubspec.yaml` - Package config
- `README.md` - Documentation
- `CHANGELOG.md` - Version history
- `example/` - Example app

## Widget Parameters
| Parameter | Type | Required |
|-----------|------|----------|
| apiKey | String | Yes |
| webUrl | String | Yes |
| onResult | Function | Yes |
| includePadding | bool | No |

## Security Levels
- **Level 1**: Device fingerprint only
- **Level 2**: Device + ALTCHA
- **Level 3**: Device + ALTCHA + Slider

## Common URLs
- pub.dev: https://pub.dev
- GitHub: https://github.com
- Docs: See README.md

## File Structure
```
tri_shield_captcha/
├── lib/
│   ├── tri_shield_captcha.dart
│   ├── widgets/
│   ├── models/
│   ├── service/
│   └── config/
├── example/
├── pubspec.yaml
└── README.md
```

## Support
- 📧 support@trishield.com
- 🐛 GitHub Issues
- 📖 README.md

## Version Updates
- Patch: 1.0.0 → 1.0.1 (bug fixes)
- Minor: 1.0.0 → 1.1.0 (features)
- Major: 1.0.0 → 2.0.0 (breaking)
