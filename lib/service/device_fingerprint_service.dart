import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:jailbreak_root_detection/jailbreak_root_detection.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../config/app_logger.dart';
import '../models/device_fingerprint_model.dart';

class DeviceFingerprintService {
  // Singleton instance
  DeviceFingerprintService._();
  static final DeviceFingerprintService instance = DeviceFingerprintService._();

  // Now it's an instance member ✅
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  Future<DeviceFingerprint> generate() async {
    try {
      AppLogger.info('Generating device fingerprint...');

      bool isRooted = false;
      bool isDevelopmentMode = false;

      try {
        isRooted = await JailbreakRootDetection().isJailBroken;
        isDevelopmentMode = await JailbreakRootDetection().isDebugged;
      } on Exception catch (e) {
        AppLogger.warning('Root/dev detection failed: $e');
      }

      if (Platform.isAndroid) {
        return await _generateAndroidFingerprint(isRooted, isDevelopmentMode);
      } else if (Platform.isIOS) {
        return await _generateIOSFingerprint(isRooted, isDevelopmentMode);
      } else {
        throw UnsupportedError('Platform not supported');
      }
    } on Exception catch (e, stackTrace) {
      AppLogger.error('Fingerprint generation failed', e, stackTrace);
      rethrow;
    }
  }

  Future<DeviceFingerprint> _generateAndroidFingerprint(
      bool isRooted,
      bool isDevelopmentMode,
      ) async {
    final androidInfo = await _deviceInfo.androidInfo;

    final sensorVariance = await _collectAccelerometerVariance();
    final batteryInfo = await _collectBatteryInfo();
    final networkType = await _collectNetworkType();
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final fingerprintData = {
      'platform': 'android',
      'device': androidInfo.model,
      'brand': androidInfo.brand,
      'manufacturer': androidInfo.manufacturer,
      'osVersion': androidInfo.version.release,
      'sdkInt': androidInfo.version.sdkInt,
      'isPhysicalDevice': androidInfo.isPhysicalDevice,
      'isRooted': isRooted,
      'isDevelopmentMode': isDevelopmentMode,
      'sensorVariance': sensorVariance,
      'batteryLevel': batteryInfo['batteryLevel'],
      'batteryState': batteryInfo['batteryState'],
      'networkType': networkType,
      'timestamp': timestamp,
    };

    return DeviceFingerprint(
      platform: 'android',
      device: androidInfo.model,
      brand: androidInfo.brand,
      model: androidInfo.model,
      osVersion: androidInfo.version.release,
      isPhysicalDevice: androidInfo.isPhysicalDevice,
      isRooted: isRooted,
      isDevelopmentMode: isDevelopmentMode,
      sensorVariance: sensorVariance,
      batteryLevel: int.tryParse(batteryInfo['batteryLevel'].toString()),
      batteryState: batteryInfo['batteryState'].toString(),
      networkType: networkType,
      hash: _generateHash(fingerprintData),
      timestamp: timestamp,
    );
  }

  Future<DeviceFingerprint> _generateIOSFingerprint(
      bool isRooted,
      bool isDevelopmentMode,
      ) async {
    final iosInfo = await _deviceInfo.iosInfo;

    final sensorVariance = await _collectAccelerometerVariance();
    final batteryInfo = await _collectBatteryInfo();
    final networkType = await _collectNetworkType();
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final fingerprintData = {
      'platform': 'ios',
      'device': iosInfo.model,
      'name': iosInfo.name,
      'osVersion': iosInfo.systemVersion,
      'isPhysicalDevice': iosInfo.isPhysicalDevice,
      'isRooted': isRooted,
      'isDevelopmentMode': isDevelopmentMode,
      'sensorVariance': sensorVariance,
      'batteryLevel': batteryInfo['batteryLevel'],
      'batteryState': batteryInfo['batteryState'],
      'networkType': networkType,
      'timestamp': timestamp,
    };

    return DeviceFingerprint(
      platform: 'ios',
      device: iosInfo.model?? 'Model not available',
      brand: 'Apple',
      model: iosInfo.model,
      osVersion: iosInfo.systemVersion?? '10',
      isPhysicalDevice: iosInfo.isPhysicalDevice,
      isRooted: isRooted,
      isDevelopmentMode: isDevelopmentMode,
      sensorVariance: sensorVariance,
      batteryLevel: int.tryParse(batteryInfo['batteryLevel'].toString()),
      batteryState: batteryInfo['batteryState'].toString(),
      networkType: networkType,
      hash: _generateHash(fingerprintData),
      timestamp: timestamp,
    );
  }

  Future<double> _collectAccelerometerVariance() async {
    final samples = <double>[];
    final completer = Completer<double>();

    late StreamSubscription<AccelerometerEvent> sub;
    sub = accelerometerEventStream().listen((event) {
      final magnitude =
          event.x * event.x + event.y * event.y + event.z * event.z;
      samples.add(magnitude);

      if (samples.length >= 20) {
        sub.cancel();
        final mean = samples.reduce((a, b) => a + b) / samples.length;
        final variance =
            samples
                .map((v) => (v - mean) * (v - mean))
                .reduce((a, b) => a + b) /
                samples.length;
        completer.complete(variance);
      }
    });

    return completer.future.timeout(
      const Duration(seconds: 2),
      onTimeout: () => 0.0,
    );
  }

  Future<Map<String, dynamic>> _collectBatteryInfo() async {
    try {
      final battery = Battery();
      return {
        'batteryLevel': await battery.batteryLevel,
        'batteryState': (await battery.batteryState).toString(),
      };
    } on Exception catch (_) {
      return {'batteryLevel': -1, 'batteryState': 'unknown'};
    }
  }

  Future<String> _collectNetworkType() async {
    final connectivity = Connectivity();
    return (await connectivity.checkConnectivity()).toString();
  }

  String _generateHash(Map<String, dynamic> data) {
    return sha256.convert(utf8.encode(json.encode(data))).toString();
  }

  int calculateRiskScore(DeviceFingerprint f) {
    int score = 0;

    if (f.isRooted) {
      score += 50;
    }
    if (f.isDevelopmentMode) {
      score += 30;
    }
    if (!f.isPhysicalDevice) {
      score += 40;
    }

    if (f.sensorVariance != null && f.sensorVariance! < 0.05) {
      score += 25;
      AppLogger.warning('Low sensor variance detected');
    }

    if (f.batteryLevel == -1 || f.batteryState == 'unknown') {
      score += 15;
    }

    if (f.networkType!.contains('none')) {
      score += 10;
    }

    AppLogger.info('Calculated risk score: $score');
    return score.clamp(0, 100);
  }
}