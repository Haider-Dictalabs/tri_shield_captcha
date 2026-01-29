# ✅ Package Setup & Publishing Checklist

Use this checklist to ensure your package is ready for publication.

## Pre-Publication Setup

### 1. Update Package Information
- [ ] Open `pubspec.yaml`
- [ ] Update `name` (if needed)
- [ ] Update `description` 
- [ ] Set correct `version` (1.0.0 for initial release)
- [ ] Update `homepage` URL to your GitHub repo
- [ ] Update `repository` URL to your GitHub repo
- [ ] Update `issue_tracker` URL
- [ ] Verify all dependencies and version constraints

### 2. Configure GitHub Repository
- [ ] Create new repository on GitHub
- [ ] Name it: `tri_shield_captcha` (or your package name)
- [ ] Make it public
- [ ] Don't initialize with README (you have one)
- [ ] Copy the git commands provided by GitHub

### 3. Update Documentation URLs
- [ ] Search all `.md` files for `yourusername`
- [ ] Replace with your actual GitHub username
- [ ] Update email addresses (support@trishield.com → your email)
- [ ] Update any company-specific references

### 4. Test Package Locally
```bash
# From package root directory
cd tri_shield_captcha

# Run analyzer
flutter analyze

# Format code
dart format .

# Dry run publish
dart pub publish --dry-run
```
- [ ] All checks pass
- [ ] No errors or warnings
- [ ] Score estimate is good (aim for 130+)

### 5. Test Example App
```bash
cd example
flutter pub get
flutter run
```
- [ ] App runs successfully
- [ ] All examples work
- [ ] No console errors
- [ ] UI looks correct

## Git & GitHub Setup

### 6. Initialize Git Repository
```bash
cd tri_shield_captcha
git init
git add .
git commit -m "Initial commit: TriShield CAPTCHA v1.0.0"
```
- [ ] Repository initialized
- [ ] All files committed

### 7. Push to GitHub
```bash
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/tri_shield_captcha.git
git push -u origin main
```
- [ ] Code pushed to GitHub
- [ ] Repository is public
- [ ] All files visible on GitHub

### 8. Create Release Tag
```bash
git tag v1.0.0
git push origin v1.0.0
```
- [ ] Tag created
- [ ] Tag pushed to GitHub

## Publication

### 9. Setup pub.dev Account
- [ ] Visit https://pub.dev
- [ ] Sign in with Google
- [ ] Verify email if required
- [ ] Agree to terms of service

### 10. Authenticate with pub.dev
```bash
dart pub login
```
- [ ] Browser opened
- [ ] Successfully authenticated
- [ ] Credentials saved locally

### 11. Final Validation
```bash
dart pub publish --dry-run
```
- [ ] No errors
- [ ] No warnings
- [ ] Package details look correct
- [ ] Dependencies are valid

### 12. Publish Package
```bash
dart pub publish
```
- [ ] Command executed
- [ ] Confirmed publication (press 'y')
- [ ] Upload completed successfully
- [ ] Package available on pub.dev

### 13. Verify Publication
- [ ] Visit https://pub.dev/packages/tri_shield_captcha
- [ ] Package appears correctly
- [ ] README renders properly
- [ ] Example code is visible
- [ ] All links work
- [ ] Dependencies listed correctly
- [ ] Score is calculated (wait a few minutes)

## Post-Publication

### 14. Update README Badges
Add to top of README.md:
```markdown
[![pub package](https://img.shields.io/pub/v/tri_shield_captcha.svg)](https://pub.dev/packages/tri_shield_captcha)
[![popularity](https://img.shields.io/pub/popularity/tri_shield_captcha?logo=dart)](https://pub.dev/packages/tri_shield_captcha/score)
[![likes](https://img.shields.io/pub/likes/tri_shield_captcha?logo=dart)](https://pub.dev/packages/tri_shield_captcha/score)
```
- [ ] Badges added
- [ ] Committed and pushed

### 15. Announce Package
- [ ] Post on Twitter/X with #FlutterDev
- [ ] Share on Reddit r/FlutterDev
- [ ] Post on LinkedIn
- [ ] Share in Flutter Discord
- [ ] Update personal website/portfolio

### 16. Setup Monitoring
- [ ] Watch GitHub repository for issues
- [ ] Enable email notifications for pub.dev
- [ ] Set up Dependabot for dependency updates
- [ ] Create project board for feature tracking

## Maintenance Plan

### 17. Response Strategy
- [ ] Respond to issues within 24-48 hours
- [ ] Review pull requests weekly
- [ ] Update dependencies monthly
- [ ] Plan quarterly feature releases

### 18. Documentation Maintenance
- [ ] Keep README up to date
- [ ] Update CHANGELOG for each release
- [ ] Add new examples as needed
- [ ] Improve API docs based on feedback

## Version Updates (Future)

When publishing updates:
- [ ] Update version in pubspec.yaml
- [ ] Add entry to CHANGELOG.md
- [ ] Commit changes
- [ ] Create and push new tag (e.g., v1.0.1)
- [ ] Run `dart pub publish`

### Versioning Rules
- **Patch** (1.0.0 → 1.0.1): Bug fixes only
- **Minor** (1.0.0 → 1.1.0): New features, backward compatible
- **Major** (1.0.0 → 2.0.0): Breaking changes

## Troubleshooting

### Common Issues

**"Package validation failed"**
→ Run `dart pub publish --dry-run` and fix all errors

**"Version already exists"**
→ Increment version number in pubspec.yaml

**"Repository not found"**
→ Ensure GitHub repo is public and URL is correct

**"Email not verified"**
→ Check email and verify your pub.dev account

**Low package score**
→ Add tests, improve documentation, follow best practices

## Resources

- 📖 [Publishing Packages](https://dart.dev/tools/pub/publishing)
- 📦 [Package Layout](https://dart.dev/tools/pub/package-layout)
- 🎯 [Semantic Versioning](https://semver.org/)
- ✨ [Effective Dart](https://dart.dev/guides/language/effective-dart)
- 💯 [Package Scoring](https://pub.dev/help/scoring)

## Support

Need help?
- 📧 Email: support@trishield.com
- 💬 GitHub Issues
- 📖 [Publishing Guide](PUBLISHING.md)

---

**Last Updated**: January 29, 2024
**Package Version**: 1.0.0

Good luck with your publication! 🚀
