import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../config/app_logger.dart';
import '../config/constants.dart';

class SliderCaptcha extends StatefulWidget {
  const SliderCaptcha({
    super.key,
    this.hideFooter = false,
    this.hideLogo = true,
    this.title = 'Slide to Verify',
    this.onVerified,
    this.onFailed,
  });

  final bool hideFooter;
  final bool hideLogo;
  final String title;
  final void Function(String uuid)? onVerified;
  final void Function(String reason)? onFailed;

  @override
  State<SliderCaptcha> createState() => _SliderCaptchaState();
}

class _SliderCaptchaState extends State<SliderCaptcha> {
  Map<String, dynamic>? captchaData;
  Uint8List? bgBytes;
  Uint8List? pieceBytes;

  double sliderValue = 0.0;
  bool isLoading = true;
  bool isVerified = false;

  @override
  void initState() {
    super.initState();
    fetchCaptcha();
  }

  // ─────────────────────────────────────────────────────────────
  // LOG HELPERS
  // ─────────────────────────────────────────────────────────────

  void _logRequest(String method, String url) {
    AppLogger.info('API REQUEST → [$method] $url');
  }

  void _logSuccess(String method, String url, dynamic response) {
    AppLogger.info('RESPONSE → ${json.encode(response)}');
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

  // ─────────────────────────────────────────────────────────────
  // FETCH CAPTCHA
  // ─────────────────────────────────────────────────────────────

  Future<void> fetchCaptcha() async {
    setState(() {
      isLoading = true;
      isVerified = false;
      sliderValue = 0.0;
    });

    _logRequest('GET', Constants.newCaptchaUrl);

    try {
      final response = await http.get(Uri.parse(Constants.newCaptchaUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
        json.decode(response.body) as Map<String, dynamic>;

        _logSuccess('GET', Constants.newCaptchaUrl, data);

        final bgImage = (data['bgBase64'] as String).split(',').last;
        final pieceImage = (data['pieceBase64'] as String).split(',').last;

        setState(() {
          captchaData = data;
          bgBytes = base64Decode(bgImage);
          pieceBytes = base64Decode(pieceImage);
          isLoading = false;
        });
      } else {
        _logError(
          'GET',
          Constants.newCaptchaUrl,
          'Non-200 response',
          statusCode: response.statusCode,
          body: response.body,
        );
        widget.onFailed?.call('Failed to fetch slider image');
        AppLogger.warning('Failed to load captcha');
        setState(() => isLoading = false);
      }
    } catch (e) {
      _logError('GET', Constants.newCaptchaUrl, e);
      widget.onFailed?.call('Failed to fetch slider images');
      AppLogger.error('Error fetching captcha');
      setState(() => isLoading = false);
    }
  }

  // ─────────────────────────────────────────────────────────────
  // VERIFY CAPTCHA
  // ─────────────────────────────────────────────────────────────

  Future<void> verifyCaptcha() async {
    if (captchaData == null || isVerified) return;

    final userX = sliderValue.toInt();
    final token = captchaData!['token'] as String;

    _logRequest('POST', Constants.verifyCaptchaUrl);
    AppLogger.info('REQUEST BODY → token=$token | userX=$userX');

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(Constants.verifyCaptchaUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'token': token, 'userX': userX}),
      );

      final Map<String, dynamic> result =
      json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && result['success'] == true) {
        _logSuccess('POST', Constants.verifyCaptchaUrl, result);

        final uuid = result['uuid'] as String;

        setState(() {
          isVerified = true;
          isLoading = false;
        });

        AppLogger.info('Captcha verification successful');

        widget.onVerified?.call(uuid);
      } else {
        _logError(
          'POST',
          Constants.verifyCaptchaUrl,
          'Verification failed',
          statusCode: response.statusCode,
          body: response.body,
        );
        widget.onFailed?.call('Slider verification failed');
        setState(() => isLoading = false);
        AppLogger.warning('Captcha verification failed, retrying');
        fetchCaptcha();
      }
    } catch (e) {
      _logError('POST', Constants.verifyCaptchaUrl, e);
      widget.onFailed?.call('Slider verification failed');
      setState(() => isLoading = false);
      AppLogger.error('Error during captcha verification');
    }
  }

  // ─────────────────────────────────────────────────────────────
  // UI
  // ─────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outline),
        borderRadius: BorderRadius.circular(8),
        color: colorScheme.surface,
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (!widget.hideLogo)
                const Icon(Icons.shield, size: 22, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 12),

          if (captchaData != null && bgBytes != null && pieceBytes != null)
            Column(
              children: [
                SizedBox(
                  width: (captchaData!['canvasW'] as num).toDouble(),
                  height: (captchaData!['canvasH'] as num).toDouble(),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.memory(
                        bgBytes!,
                        fit: BoxFit.fill,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                      Positioned(
                        left: sliderValue,
                        top: (captchaData!['offsetY'] as num).toDouble(),
                        child: Image.memory(
                          pieceBytes!,
                          width: (captchaData!['pieceW'] as num).toDouble(),
                          height: (captchaData!['pieceH'] as num).toDouble(),
                        ),
                      ),
                      if (isLoading)
                        const Positioned.fill(
                          child: ColoredBox(
                            color: Colors.black26,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        min: 0,
                        max: ((captchaData!['canvasW'] as num) -
                            (captchaData!['pieceW'] as num))
                            .toDouble(),
                        value: sliderValue,
                        onChanged: isVerified || isLoading
                            ? null
                            : (v) => setState(() => sliderValue = v),
                        onChangeEnd: isVerified || isLoading
                            ? null
                            : (_) => verifyCaptcha(),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: isLoading ? null : fetchCaptcha,
                    ),
                  ],
                ),
              ],
            ),

          if (!widget.hideFooter)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Powered by Dictalabs',
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
