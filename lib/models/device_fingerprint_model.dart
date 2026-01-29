class DeviceFingerprint {
  final String platform;
  final String device;
  final String? brand;
  final String? model;
  final String osVersion;
  final bool isPhysicalDevice;
  final bool isRooted;
  final bool isDevelopmentMode;
  final double? sensorVariance;
  final int? batteryLevel;
  final String? batteryState;
  final String? networkType;
  final String hash;
  final int timestamp;

  const DeviceFingerprint({
    required this.platform,
    required this.device,
    this.brand,
    this.model,
    required this.osVersion,
    required this.isPhysicalDevice,
    required this.isRooted,
    required this.isDevelopmentMode,
    this.sensorVariance,
    this.batteryLevel,
    this.batteryState,
    this.networkType,
    required this.hash,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'platform': platform,
      'device': device,
      'brand': brand,
      'model': model,
      'osVersion': osVersion,
      'isPhysicalDevice': isPhysicalDevice,
      'isRooted': isRooted,
      'isDevelopmentMode': isDevelopmentMode,
      'sensorVariance': sensorVariance,
      'batteryLevel': batteryLevel,
      'batteryState': batteryState,
      'networkType': networkType,
      'hash': hash,
      'timestamp': timestamp,
    };
  }

  factory DeviceFingerprint.fromJson(Map<String, dynamic> json) {
    return DeviceFingerprint(
      platform: json['platform'] as String,
      device: json['device'] as String,
      brand: json['brand'] as String,
      model: json['model'] as String,
      osVersion: json['osVersion'] as String,
      isPhysicalDevice: json['isPhysicalDevice'] as bool,
      isRooted: json['isRooted'] as bool,
      isDevelopmentMode: json['isDevelopmentMode'] as bool,
      sensorVariance: (json['sensorVariance'] as num?)?.toDouble(),
      batteryLevel: json['batteryLevel'] as int,
      batteryState: json['batteryState'] as String,
      networkType: json['networkType'] as String,
      hash: json['hash'] as String,
      timestamp: json['timestamp'] as int,
    );
  }
}
