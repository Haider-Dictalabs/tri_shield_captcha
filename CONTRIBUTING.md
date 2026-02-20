# Contributing to TriShield CAPTCHA

Thank you for your interest in contributing to AuthShield CAPTCHA! This document provides guidelines for contributing to the project.

## Code of Conduct

Please be respectful and constructive in all interactions with the community.

## How to Contribute

### Reporting Bugs

If you find a bug, please create an issue with:
- Clear description of the problem
- Steps to reproduce
- Expected vs actual behavior
- Flutter/Dart version
- Platform (iOS, Android, Web, etc.)
- Code samples if applicable

### Suggesting Features

Feature requests are welcome! Please:
- Check if the feature already exists
- Clearly describe the use case
- Explain why it would be useful to most users

### Pull Requests

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/my-new-feature
   ```

3. **Make your changes**
   - Write clean, well-documented code
   - Follow the existing code style
   - Add tests if applicable
   - Update documentation

4. **Test your changes**
   ```bash
   flutter test
   flutter analyze
   ```

5. **Commit your changes**
   ```bash
   git commit -m "Add: Brief description of changes"
   ```
   Use conventional commits:
   - `Add:` for new features
   - `Fix:` for bug fixes
   - `Update:` for updates to existing features
   - `Docs:` for documentation changes
   - `Refactor:` for code refactoring

6. **Push to your fork**
   ```bash
   git push origin feature/my-new-feature
   ```

7. **Create a Pull Request**
   - Provide a clear description
   - Reference any related issues
   - Include screenshots/videos if relevant

## Development Setup

1. Clone the repository:
```bash
git clone https://github.com/yourusername/tri_shield_captcha.git
cd tri_shield_captcha
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run tests:
```bash
flutter test
```

4. Run the example app:
```bash
cd example
flutter run
```

## Code Style

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart)
- Use `flutter analyze` to check for issues
- Format code with `dart format .`
- Keep lines under 80 characters when reasonable
- Write meaningful comments for complex logic

## Testing

- Add tests for new features
- Ensure existing tests pass
- Test on multiple platforms if possible
- Include edge cases

## Documentation

- Update README.md for new features
- Add inline documentation for public APIs
- Update CHANGELOG.md
- Add examples for complex features

## Questions?

Feel free to:
- Open an issue for questions
- Email: support@authshield.com
- Check existing issues and discussions

Thank you for contributing! 🎉
