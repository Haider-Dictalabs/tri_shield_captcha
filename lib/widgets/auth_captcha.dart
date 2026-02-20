import 'dart:convert';

import 'package:altcha_widget/altcha.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../config/app_logger.dart';
import '../config/constants.dart';
import '../models/captcha_result.dart';
import '../models/device_fingerprint_model.dart';
import '../models/security_verification_response.dart';
import '../service/device_fingerprint_service.dart';
import 'slider_captcha.dart';

class AuthCaptcha extends StatefulWidget {

  const AuthCaptcha({
    super.key,
    required this.onResult,
    required this.apiKey,
    required this.webUrl,
    this.includePadding = true,
  });

  final void Function(CaptchaResult result) onResult;
  final String apiKey;
  final String webUrl;
  final bool includePadding;

  @override
  State<AuthCaptcha> createState() => _AuthCaptchaState();
}

class _AuthCaptchaState extends State<AuthCaptcha> {
  DeviceFingerprint? _fingerprint;
  int? _riskScore;
  String? ip;
  int _securityLevel = 0;
  bool _isBot = false;
  bool _isInvalidKey = false;
  bool _loading = false;
  bool _multiLayerFailOver = false;
  bool _altchaVerified = false;
  bool _sliderVerified = false;
  bool _resultEmitted = false;

  @override
  void initState() {
    super.initState();
    _initIp();
    _startVerificationFlow();
  }

  Future<void> _initIp() async {
    final fetchedIp = await _fetchPublicIp();
    setState(() {
      ip = fetchedIp;
    });
  }

  Future<void> _startVerificationFlow() async {
    setState(() => _loading = true);

    try {
      final verification = await _verifyUserKey();
      if (!verification.valid) {
        _invalidKeyOrUrl();
        return;
      }

      await _generateFingerprint();

      setState(() {
        _securityLevel = verification.securityLevel;
        _multiLayerFailOver = verification.multiLayerFailOver;
      });

      AppLogger.info(
        'Security level=$_securityLevel, failover=$_multiLayerFailOver',
      );
      if (_isBot) {
        await _saveCaptchaLog(
          success: false,
          reason: 'Bot detected by BotD',
          failedCaptcha: 'bot',
        );
      }

      if (_securityLevel == 1) {
        if (_shouldHardBlockBot) {
          AppLogger.info('Level 1 blocked by bot detection');
          return;
        }
        AppLogger.info('Level 1 passed');
        await _saveCaptchaLog(success: true);
        _emitResult();
      }
    } catch (e) {
      AppLogger.error('Captcha main flow failed', e);
      _invalidKeyOrUrl();
    } finally {
      setState(() => _loading = false);
    }
  }

  static Future<String> _fetchPublicIp() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.ipify.org?format=json'),
      );
      if (response.statusCode != 200) {
        AppLogger.warning('IP fetch failed with status ${response.statusCode}');
        return 'unknown';
      }
      final data = json.decode(response.body) as Map<String, dynamic>;
      AppLogger.info(data['ip']?.toString() ?? 'unknown');
      return data['ip']?.toString() ?? 'unknown';
    } catch (e) {
      AppLogger.warning('Failed to fetch public IP: $e');
      return 'unknown';
    }
  }

  Future<SecurityVerificationResponse> _verifyUserKey() async {
    final uri = Uri.parse(Constants.verifyUserKeyUrl).replace(
      queryParameters: {'apiKey': widget.apiKey, 'webUrl': widget.webUrl},
    );

    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('verifyUserKey failed');
    }

    return SecurityVerificationResponse.fromJson(
      json.decode(response.body) as Map<String, dynamic>,
    );  }

  Future<void> _generateFingerprint() async {
    final fp = await DeviceFingerprintService.generate();
    final score = DeviceFingerprintService.calculateRiskScore(fp);

    setState(() {
      _fingerprint = fp;
      _riskScore = score;
      _isBot = score >= Constants.botDetectionRiskThreshold;
    });
  }

  void _emitResult({String? uuid}) {
    if (_resultEmitted) return;
    _resultEmitted = true;

    widget.onResult(CaptchaResult(isVerified: true, uuid: uuid));
  }

  bool get _shouldHardBlockBot {
    if (!_isBot) return false;
    if (!_multiLayerFailOver) return true;
    return _securityLevel == 1;
  }

  void _invalidKeyOrUrl() {
    setState(() => _isInvalidKey = true);
  }

  Future<void> _onAltchaVerified() async {
    AppLogger.info('Altcha verified');
    setState(() => _altchaVerified = true);
    if (_securityLevel == 2) {
      await _saveCaptchaLog(success: true);
      _emitResult();
    }
  }

  Future<void> _onSliderVerified(String uuid) async {
    AppLogger.info('Slider verified uuid=$uuid');
    await _saveCaptchaLog(success: true);
    setState(() => _sliderVerified = true);
    _emitResult(uuid: uuid);
  }

  Future<void> _saveCaptchaLog({
    required bool success,
    String reason = '',
    String? failedCaptcha,
  }) async {
    final url = Constants.saveCaptchaLogUrl;
    final payload = {
      'timestamp': DateTime.now().toIso8601String(),
      'siteKey': widget.apiKey,
      'status': success ? 'SUCCESS' : 'FAILED',
      'reason': reason,
      'failedCaptcha': failedCaptcha,
      'ip': ip ?? 'unknown',
    };
    _logRequest('POST', url);
    AppLogger.info('REQUEST BODY → ${json.encode(payload)}');
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );
      if (response.statusCode == 200) {
        AppLogger.info('RESPONSE → ${response.body}');
      }
    } catch (e) {
      _logError('POST', url, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.includePadding
          ? const EdgeInsets.symmetric(vertical: 12)
          : EdgeInsets.zero,
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_isInvalidKey) {
      return Text(
        "Invalid key or URL",
        style: TextStyle(
          color: Colors.red.shade700,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    if (_shouldHardBlockBot) {
      _saveCaptchaLog(success: false, reason: 'Bot detected by BotD');
      return _buildBotStatus();
    }

    final showAltcha = _securityLevel >= 2 && !_altchaVerified;
    final showSlider =
        _securityLevel == 3 && _altchaVerified && !_sliderVerified;

    AppLogger.info(
      'Render decision: showAltcha=$showAltcha, showSlider=$showSlider '
      'level=$_securityLevel bot=$_isBot failover=$_multiLayerFailOver '
      'altcha=$_altchaVerified slider=$_sliderVerified',
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showAltcha) _buildAltchaWidget(),
        if (showSlider)
          SliderCaptcha(
            onVerified: _onSliderVerified,
            onFailed: (reason) {
              _saveCaptchaLog(
                success: false,
                reason: reason,
                failedCaptcha: 'slider',
              );
            },
          ),
      ],
    );
  }

  Widget _buildFingerprintInfo() {
    if (_fingerprint == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Platform: ${_fingerprint!.platform}'),
        Text('Device: ${_fingerprint!.device}'),
        Text('Brand: ${_fingerprint!.brand}'),
        Text('Model: ${_fingerprint!.model}'),
        Text('OS Version: ${_fingerprint!.osVersion}'),
        Text('Physical Device: ${_fingerprint!.isPhysicalDevice}'),
        Text('Rooted/Jail broken: ${_fingerprint!.isRooted}'),
        Text('Development Mode: ${_fingerprint!.isDevelopmentMode}'),
        Text('Hash: ${_fingerprint!.hash}'),
        Text('Timestamp: ${_fingerprint!.timestamp}'),
        Text('Risk Score: $_riskScore'),
      ],
    );
  }

  Widget _buildAltchaWidget() {
    return AltchaWidget(
      challengeUrl: Constants.altchaChallengeUrl,
      hideFooter: true,
      hideLogo: true,
      onVerified: (_) => _onAltchaVerified(),
      onFailed: (_) async {
        AppLogger.warning('Altcha failed');
        await _saveCaptchaLog(
          success: false,
          reason: 'Altcha verification failed',
          failedCaptcha: 'altcha',
        );
        if (_multiLayerFailOver && _securityLevel == 3) {
          setState(() {
            _altchaVerified = true;
          });
          AppLogger.info(
            'Multi-layer failover enabled: proceeding to next layer despite ALTCHA failure',
          );
        }
      },
    );
  }

  Widget _buildBotStatus() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.red.withOpacity(0.1),
        border: Border.all(color: Colors.red),
      ),
      child: const Row(
        children: [
          Icon(Icons.smart_toy_outlined, color: Colors.red),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Automated activity detected',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // LOG HELPERS
  // ─────────────────────────────────────────────────────────────

  void _logRequest(String method, String url) {
    AppLogger.info('API REQUEST → [$method] $url');
  }

  void _logError(
    String method,
    String url,
    Object error, {
    int? statusCode,
    String? body,
  }) {
    AppLogger.error(
      'API ERROR → [$method] $url | status=$statusCode | body=$body',
      error,
    );
  }
}
