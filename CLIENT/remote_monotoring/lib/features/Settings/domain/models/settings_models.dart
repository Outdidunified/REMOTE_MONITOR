class FetchUserProfileResponse {
  final bool error;
  final String? message;
  final UserProfileData? data;

  FetchUserProfileResponse({
    required this.error,
    this.message,
    this.data,
  });

  factory FetchUserProfileResponse.fromJson(Map<String, dynamic> json) {
    return FetchUserProfileResponse(
      error: json['error'] as bool? ?? true,
      message: json['message'] as String?,
      data: json['data'] != null ? UserProfileData.fromJson(json['data']) : null,
    );
  }
}

class UserProfileData {
  final String? id;
  final int? userId;
  final String? name;
  final String? email;
  final String? phone;
  final String? password;
  final String? createDate;
  final String? createdBy;
  final int? roleId;
  final String? roleName;
  final bool? status;
  final String? modifiedBy;
  final String? modifiedDate;
  final int? forgetPasswordOtp;
  final String? otpCreatedAt;
  final String? otpExpiry;

  UserProfileData({
    this.id,
    this.userId,
    this.name,
    this.email,
    this.phone,
    this.password,
    this.createDate,
    this.createdBy,
    this.roleId,
    this.roleName,
    this.status,
    this.modifiedBy,
    this.modifiedDate,
    this.forgetPasswordOtp,
    this.otpCreatedAt,
    this.otpExpiry,
  });

  factory UserProfileData.fromJson(Map<String, dynamic> json) {
    return UserProfileData(
      id: json['_id'] as String?,
      userId: json['user_id'] as int?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone']?.toString(), // Handle both String and numeric phone
      password: json['password'] as String?,
      createDate: json['createDate'] as String?,
      createdBy: json['createdBy'] as String?,
      roleId: json['role_id'] as int?,
      roleName: json['role_name'] as String?,
      status: json['status'] as bool?,
      modifiedBy: json['modifiedBy'] as String?,
      modifiedDate: json['modifiedDate'] as String?,
      forgetPasswordOtp: json['forget_password_otp'] as int?,
      otpCreatedAt: json['otp_created_at'] as String?,
      otpExpiry: json['otp_expiry'] as String?,
    );
  }
}

class UpdateUserResponse {
  final bool error;
  final String message;
  final Map<String, dynamic>? data;

  UpdateUserResponse({
    required this.error,
    required this.message,
    this.data,
  });

  factory UpdateUserResponse.fromJson(Map<String, dynamic> json) {
    return UpdateUserResponse(
      error: json['error'] as bool,
      message: json['message'] as String,
      data: json['data'],
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