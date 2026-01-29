class SecurityVerificationResponse {
  final bool valid;
  final int securityLevel;
  final bool multiLayerFailOver;

  SecurityVerificationResponse({
    required this.valid,
    required this.securityLevel,
    required this.multiLayerFailOver,
  });

  factory SecurityVerificationResponse.fromJson(Map<String, dynamic> json) {
    return SecurityVerificationResponse(
      valid: json['valid'] as bool,
      securityLevel: json['securityLevel'] as int,
      multiLayerFailOver: json['multi_layer_failover'] as bool,
    );
  }
}
