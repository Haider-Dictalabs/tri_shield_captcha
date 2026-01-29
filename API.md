# API Documentation

Detailed API reference for TriShield CAPTCHA package.

## Table of Contents

- [Widgets](#widgets)
  - [TriShieldCaptcha](#trishieldcaptcha)
  - [SliderCaptcha](#slidercaptcha)
- [Models](#models)
  - [CaptchaResult](#captcharesult)
  - [DeviceFingerprint](#devicefingerprint)
  - [SecurityVerificationResponse](#securityverificationresponse)
- [Services](#services)
  - [DeviceFingerprintService](#devicefingerprintservice)
- [Configuration](#configuration)
  - [Constants](#constants)
  - [AppLogger](#applogger)

---

## Widgets

### TriShieldCaptcha

The main CAPTCHA widget that provides multi-layer security verification.

#### Constructor

```dart
TriShieldCaptcha({
  Key? key,
  required String apiKey,
  required String webUrl,
  required void Function(CaptchaResult) onResult,
  bool includePadding = true,
})
```

#### Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `apiKey` | `String` | Yes | - | Your TriShield API key |
| `webUrl` | `String` | Yes | - | Your registered website/app URL |
| `onResult` | `Function(CaptchaResult)` | Yes | - | Callback invoked when verification completes |
| `includePadding` | `bool` | No | `true` | Whether to include vertical padding (12px) |

#### Usage Example

```dart
TriShieldCaptcha(
  apiKey: 'your-api-key',
  webUrl: 'https://yourapp.com',
  onResult: (CaptchaResult result) {
    if (result.isVerified) {
      print('Verified! UUID: ${result.uuid}');
    }
  },
  includePadding: true,
)
```

#### Behavior

The widget automatically:
1. Validates API key and web URL
2. Generates device fingerprint
3. Calculates risk score
4. Determines security level from server
5. Displays appropriate CAPTCHA challenges
6. Handles verification and logging

#### States

- **Loading**: Shows `CircularProgressIndicator`
- **Invalid Key**: Displays error message
- **Bot Detected**: Shows warning (if hard-blocked)
- **Level 1**: Auto-verifies (if not bot)
- **Level 2**: Shows ALTCHA widget
- **Level 3**: Shows ALTCHA then Slider

---

### SliderCaptcha

Interactive slider puzzle CAPTCHA widget.

#### Constructor

```dart
SliderCaptcha({
  Key? key,
  required void Function(String uuid) onVerified,
  required void Function(String reason) onFailed,
})
```

#### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `onVerified` | `Function(String)` | Yes | Callback with verification UUID on success |
| `onFailed` | `Function(String)` | Yes | Callback with failure reason |

#### Usage Example

```dart
SliderCaptcha(
  onVerified: (uuid) {
    print('Slider verified: $uuid');
  },
  onFailed: (reason) {
    print('Slider failed: $reason');
  },
)
```

---

## Models

### CaptchaResult

Result object returned when CAPTCHA verification completes.

#### Properties

```dart
class CaptchaResult {
  final bool isVerified;
  final String? uuid;
}
```

| Property | Type | Description |
|----------|------|-------------|
| `isVerified` | `bool` | Whether CAPTCHA was successfully verified |
| `uuid` | `String?` | Unique verification identifier (for server validation) |

#### Usage Example

```dart
void handleResult(CaptchaResult result) {
  if (result.isVerified) {
    // User verified, proceed with action
    submitForm(verificationUuid: result.uuid);
  }
}
```

---

### DeviceFingerprint

Device information collected for fingerprinting.

#### Properties

```dart
class DeviceFingerprint {
  final String platform;
  final String device;
  final String brand;
  final String model;
  final String osVersion;
  final bool isPhysicalDevice;
  final bool isRooted;
  final bool isDevelopmentMode;
  final String hash;
  final String timestamp;
}
```

| Property | Type | Description |
|----------|------|-------------|
| `platform` | `String` | Platform (iOS, Android, Web, etc.) |
| `device` | `String` | Device name |
| `brand` | `String` | Manufacturer/brand |
| `model` | `String` | Device model |
| `osVersion` | `String` | Operating system version |
| `isPhysicalDevice` | `bool` | True if real device (not emulator) |
| `isRooted` | `bool` | True if device is rooted/jailbroken |
| `isDevelopmentMode` | `bool` | True if developer mode enabled |
| `hash` | `String` | Unique device hash (SHA-256) |
| `timestamp` | `String` | ISO 8601 timestamp of generation |

---

### SecurityVerificationResponse

Server response from key verification endpoint.

#### Properties

```dart
class SecurityVerificationResponse {
  final bool valid;
  final int securityLevel;
  final bool multiLayerFailOver;
}
```

| Property | Type | Description |
|----------|------|-------------|
| `valid` | `bool` | Whether API key and URL are valid |
| `securityLevel` | `int` | Security level (1, 2, or 3) |
| `multiLayerFailOver` | `bool` | Whether failover is enabled |

---

## Services

### DeviceFingerprintService

Service for generating and analyzing device fingerprints.

#### Static Methods

##### generate()

Generates a complete device fingerprint.

```dart
static Future<DeviceFingerprint> generate()
```

**Returns**: `Future<DeviceFingerprint>`

**Example**:
```dart
final fingerprint = await DeviceFingerprintService.generate();
print('Device: ${fingerprint.device}');
print('Platform: ${fingerprint.platform}');
```

##### calculateRiskScore()

Calculates a risk score based on device characteristics.

```dart
static int calculateRiskScore(DeviceFingerprint fingerprint)
```

**Parameters**:
- `fingerprint`: Device fingerprint to analyze

**Returns**: `int` (0-100, higher = more risky)

**Risk Factors**:
- Emulator: +40 points
- Rooted/Jailbroken: +30 points
- Development mode: +20 points
- Platform-specific risks: +10 points

**Example**:
```dart
final fingerprint = await DeviceFingerprintService.generate();
final score = DeviceFingerprintService.calculateRiskScore(fingerprint);

if (score >= 60) {
  print('High risk device detected');
}
```

---

## Configuration

### Constants

Static configuration values.

#### Properties

```dart
class Constants {
  static const String triShieldBaseUrl;
  static const String captchaBaseUrl;
  static const String loginBaseUrl;
  static const String sliderBaseUrl;
  static const String altchaChallengeUrl;
  static const String verifyUserKeyUrl;
  static const String saveCaptchaLogUrl;
  static const String newCaptchaUrl;
  static const String verifyCaptchaUrl;
  static const int botDetectionRiskThreshold;
}
```

#### Default Values

| Constant | Value |
|----------|-------|
| `triShieldBaseUrl` | `https://api.trishield.dictalabs.com` |
| `captchaBaseUrl` | `https://captcha-demo.dictalabs.com` |
| `botDetectionRiskThreshold` | `60` |

---

### AppLogger

Logging utility for debugging.

#### Static Methods

##### info()

Logs informational messages.

```dart
static void info(String message)
```

**Example**:
```dart
AppLogger.info('CAPTCHA verification started');
```

##### warning()

Logs warning messages.

```dart
static void warning(String message)
```

**Example**:
```dart
AppLogger.warning('High risk score detected');
```

##### error()

Logs error messages.

```dart
static void error(String message, [Object? error])
```

**Example**:
```dart
try {
  // some operation
} catch (e) {
  AppLogger.error('Operation failed', e);
}
```

---

## Type Definitions

### Callbacks

```dart
typedef CaptchaResultCallback = void Function(CaptchaResult result);
typedef SliderVerifiedCallback = void Function(String uuid);
typedef SliderFailedCallback = void Function(String reason);
```

---

## Error Handling

The package handles errors internally and displays appropriate UI feedback:

- **Network Errors**: Retried automatically
- **Invalid Credentials**: "Invalid key or URL" message
- **Bot Detection**: "Automated activity detected" warning
- **Verification Failures**: Logged and reported through callbacks

---

## Platform-Specific Notes

### iOS
- Requires `device_info_plus` permissions (automatic)
- Jailbreak detection supported

### Android
- Requires basic device permissions (automatic)
- Root detection supported

### Web
- Limited device information available
- Risk scoring adjusted accordingly

### Desktop (macOS, Windows, Linux)
- Full device information available
- Development mode detection varies by platform

---

## Best Practices

1. **Always handle results**: Implement proper success/failure logic in `onResult`
2. **Store UUID**: Save the verification UUID for server-side validation
3. **Error feedback**: Show user-friendly messages for verification failures
4. **Loading states**: Display loading indicators during verification
5. **Security levels**: Configure appropriate levels based on your security needs

---

## Migration Guide

When updating from older versions:

### From Pre-1.0 to 1.0.0

No breaking changes in initial release.

---

## Support

For API questions or issues:
- 📖 [Full Documentation](https://docs.trishield.com)
- 💬 [GitHub Issues](https://github.com/yourusername/tri_shield_captcha/issues)
- 📧 support@trishield.com
