import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';

enum LogLevel { info, warning, error }

class AppLogger {
  static bool enableLogs = kDebugMode;

  static void info(String message) {
    _log(LogLevel.info, message);
  }

  static void warning(String message) {
    _log(LogLevel.warning, message);
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.error, message, error: error, stackTrace: stackTrace);
  }

  static void _log(
    LogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!enableLogs) return;

    final prefix = switch (level) {
      LogLevel.info => 'ℹ️',
      LogLevel.warning => '⚠️',
      LogLevel.error => '❌',
    };

    dev.log(
      '$prefix: $message',
      error: error,
      stackTrace: stackTrace,
      name: 'TriShield-Captcha',
    );
  }
}
