# Publishing Guide for TriShield CAPTCHA

This guide walks you through the process of publishing your package to pub.dev.

## Prerequisites

Before publishing, ensure you have:
- ✅ A pub.dev account (create at https://pub.dev)
- ✅ Git and GitHub account
- ✅ Flutter SDK installed
- ✅ All tests passing
- ✅ Documentation complete
- ✅ Example app working

## Pre-Publication Checklist

### 1. Update Package Information

Edit `pubspec.yaml`:
```yaml
name: tri_shield_captcha
description: A comprehensive Flutter CAPTCHA solution with multi-layer security
version: 1.0.0  # Increment this for each release
homepage: https://github.com/YOUR_USERNAME/tri_shield_captcha
repository: https://github.com/YOUR_USERNAME/tri_shield_captcha
```

### 2. Validate Package Structure

Your package should have this structure:
```
tri_shield_captcha/
├── lib/
│   ├── tri_shield_captcha.dart (main export file)
│   ├── widgets/
│   ├── models/
│   ├── service/
│   └── config/
├── example/
│   └── lib/
│       └── main.dart
├── test/ (optional but recommended)
├── LICENSE
├── README.md
├── CHANGELOG.md
├── pubspec.yaml
└── .gitignore
```

### 3. Test Everything

```bash
# Analyze code
flutter analyze

# Format code
dart format .

# Run tests (if you have them)
flutter test

# Dry run publish to check for issues
dart pub publish --dry-run
```

### 4. Update GitHub Repository

Before publishing:

1. **Create GitHub Repository**
   - Go to https://github.com/new
   - Name it: `tri_shield_captcha`
   - Make it public
   - Don't initialize with README (you already have one)

2. **Push to GitHub**
   ```bash
   cd tri_shield_captcha
   git init
   git add .
   git commit -m "Initial commit: TriShield CAPTCHA v1.0.0"
   git branch -M main
   git remote add origin https://github.com/YOUR_USERNAME/tri_shield_captcha.git
   git push -u origin main
   ```

3. **Create a Release Tag**
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

### 5. Verify Package Quality

Run the package analyzer:
```bash
dart pub publish --dry-run
```

This checks for:
- Valid pubspec.yaml
- Proper LICENSE
- Documentation quality
- Package score (aim for 130+)

Address any warnings or errors before proceeding.

## Publishing to pub.dev

### First-Time Setup

1. **Login to pub.dev**
   ```bash
   dart pub login
   ```
   This will open a browser to authenticate.

2. **Verify Your Account**
   Follow the email verification steps if required.

### Publish the Package

1. **Final Check**
   ```bash
   dart pub publish --dry-run
   ```

2. **Publish**
   ```bash
   dart pub publish
   ```

3. **Confirm**
   - Review the package details shown
   - Type 'y' to confirm
   - Wait for upload to complete

### Verify Publication

1. Visit https://pub.dev/packages/tri_shield_captcha
2. Check that:
   - Package appears correctly
   - README renders properly
   - Example code is visible
   - All links work
   - Score is good (aim for 130+)

## Post-Publication

### 1. Update README Badge

Add this to the top of your README.md:
```markdown
[![pub package](https://img.shields.io/pub/v/tri_shield_captcha.svg)](https://pub.dev/packages/tri_shield_captcha)
[![popularity](https://img.shields.io/pub/popularity/tri_shield_captcha?logo=dart)](https://pub.dev/packages/tri_shield_captcha/score)
[![likes](https://img.shields.io/pub/likes/tri_shield_captcha?logo=dart)](https://pub.dev/packages/tri_shield_captcha/score)
```

### 2. Announce Your Package

Share on:
- Twitter/X with #FlutterDev
- Reddit r/FlutterDev
- LinkedIn
- Your blog or website
- Flutter community Discord

### 3. Monitor Issues

- Watch GitHub for issues and PRs
- Respond to questions on pub.dev
- Keep dependencies updated

## Updating Your Package

When you need to release updates:

### 1. Update Version

In `pubspec.yaml`, increment version following [Semantic Versioning](https://semver.org/):
- **Major** (1.0.0 → 2.0.0): Breaking changes
- **Minor** (1.0.0 → 1.1.0): New features, backward compatible
- **Patch** (1.0.0 → 1.0.1): Bug fixes, backward compatible

### 2. Update CHANGELOG.md

Add new version entry:
```markdown
## [1.0.1] - 2024-02-15

### Fixed
- Bug in slider captcha validation

### Added
- Better error messages
```

### 3. Commit and Tag

```bash
git add .
git commit -m "Release v1.0.1"
git tag v1.0.1
git push origin main
git push origin v1.0.1
```

### 4. Publish Update

```bash
dart pub publish
```

## Improving Package Score

To get a better pub.dev score:

### Documentation (30 points)
- ✅ Comprehensive README
- ✅ API documentation with `///` comments
- ✅ Working example

### Platform Support (20 points)
- ✅ Test on all platforms
- ✅ Declare supported platforms in pubspec.yaml

### Code Quality (50 points)
- ✅ No analyzer warnings
- ✅ Follow Dart style guide
- ✅ Proper error handling

### Maintenance (30 points)
- ✅ Regular updates
- ✅ Respond to issues
- ✅ Keep dependencies updated

## Troubleshooting

### Common Issues

**"Package validation failed"**
- Run `dart pub publish --dry-run`
- Fix all errors and warnings
- Ensure LICENSE file exists

**"Version already exists"**
- You must increment the version in pubspec.yaml
- You cannot overwrite published versions

**"Email not verified"**
- Check your email for verification link
- Verify your pub.dev account

**"Repository not found"**
- Ensure GitHub repository is public
- Update repository URL in pubspec.yaml
- Push code to GitHub before publishing

## Best Practices

1. **Test thoroughly** before each release
2. **Document changes** in CHANGELOG.md
3. **Respond quickly** to issues
4. **Keep dependencies updated**
5. **Follow semantic versioning**
6. **Provide good examples**
7. **Write clear documentation**
8. **Tag releases** in GitHub

## Resources

- [Publishing Packages](https://dart.dev/tools/pub/publishing)
- [Package Layout Conventions](https://dart.dev/tools/pub/package-layout)
- [Semantic Versioning](https://semver.org/)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [pub.dev Help](https://pub.dev/help)

## Support

Need help publishing?
- 📧 Email: support@trishield.com
- 💬 Flutter Discord
- 📖 pub.dev documentation
- 🐛 GitHub issues

Good luck with your publication! 🚀
