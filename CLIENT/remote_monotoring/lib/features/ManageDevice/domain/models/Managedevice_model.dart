class ManageDeviceResponse {
  final bool error;
  final bool status;
  final String? message;
  final List<DeviceData> data;

  ManageDeviceResponse({
    required this.error,
    required this.status,
    this.message,
    required this.data,
  });

  factory ManageDeviceResponse.fromJson(Map<String, dynamic> json) {
    List<dynamic> deviceList = json['data'] as List<dynamic>? ?? [];
    List<DeviceData> devices =
        deviceList.map((device) => DeviceData.fromJson(device)).toList();

    return ManageDeviceResponse(
      error: json['error'] as bool? ?? false,
      status: json['status'] as bool? ?? false,
      message: json['message'] as String?,
      data: devices,
    );
  }
}

class DeviceData {
  final String id;
  final int userId;
  final String deviceId;
  final String createBy;
  final String createDate;
  final bool status;
  final String? modifiedBy;
  final String? modifiedDate;

  DeviceData({
    required this.id,
    required this.userId,
    required this.deviceId,
    required this.createBy,
    required this.createDate,
    required this.status,
    this.modifiedBy,
    this.modifiedDate,
  });

  factory DeviceData.fromJson(Map<String, dynamic> json) {
    return DeviceData(
      id: json['_id'] as String? ?? '',
      userId: json['user_id'] as int? ?? 0,
      deviceId: json['device_id'] as String? ?? '',
      createBy: json['createBy'] as String? ?? '',
      createDate: json['createDate'] as String? ?? '',
      status: json['status'] as bool? ?? false,
      modifiedBy: json['modifiedBy'] as String?,
      modifiedDate: json['modifiedDate'] as String?,
    );
  }
}

class AddDeviceResponse {
  final bool error;
  final String message;
  final Map<String, dynamic>? data;

  AddDeviceResponse({
    required this.error,
    required this.message,
    this.data,
  });

  factory AddDeviceResponse.fromJson(Map<String, dynamic> json) {
    return AddDeviceResponse(
      error: json['error'] as bool,
      message: json['message'] as String,
      data: json['user'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'message': message,
      if (data != null) 'data': data,
    };
  }
}

class UpdateStatusResponse {
  final bool error;
  final String message;
  final Map<String, dynamic>? data;

  UpdateStatusResponse({
    required this.error,
    required this.message,
    this.data,
  });

  factory UpdateStatusResponse.fromJson(Map<String, dynamic> json) {
    return UpdateStatusResponse(
      error: json['error'] as bool,
      message: json['message'] as String,
      data: json['user'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'message': message,
      if (data != null) 'data': data,
    };
  }
}