class FetchdevicehistoryResponse {
  final bool error;
  final String? message;
  final List<DeviceHistory> data;

  FetchdevicehistoryResponse({
    required this.error,
    this.message,
    required this.data,
  });

  factory FetchdevicehistoryResponse.fromJson(Map<String, dynamic> json) {
    return FetchdevicehistoryResponse(
      error: json['error'] as bool? ?? true,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => DeviceHistory.fromJson(item))
          .toList() ?? [],
    );
  }
}

class DeviceHistory {
  final String? id;
  final String? deviceId;
  final bool? status;
  final String? notification;
  final String? phone;
  final String? iot;
  final double? temperature;
  final double? humidity;

  DeviceHistory({
    this.id,
    this.deviceId,
    this.status,
    this.notification,
    this.phone,
    this.iot,
    this.temperature,
    this.humidity,
  });

  factory DeviceHistory.fromJson(Map<String, dynamic> json) {
    return DeviceHistory(
      id: json['_id'] as String?,
      deviceId: json['device_id'] as String?,
      status: json['status'] as bool?,
      notification: json['Notification'] as String?,
      phone: json['phone']?.toString(), // Handle both String and numeric phone
      iot: json['iot'] as String?,
      temperature: (json['temperature'] as num?)?.toDouble(),
      humidity: (json['humidity'] as num?)?.toDouble(),
    );
  }
}