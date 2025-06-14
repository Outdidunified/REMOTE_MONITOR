// GET OTP Response Model {handleGetOTP()}
class RegisterResponse {
  final bool error; // Updated to match the response structure
  final String message; // Message field

  RegisterResponse({
    required this.error,
    required this.message,
  });

  // Factory constructor for creating an instance from JSON
  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      error: json['error'] as bool, // Parse 'error' field
      message: json['message'] as String, // Parse 'message' field
    );
  }

  // Method to convert the instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'message': message,
    };
  }
}

// GET OTP Response Model {handleGetOTP()}
class LoginResponse {
  final bool error;
  final String message;
  final String? token;
  final Map<String, dynamic>? data;

  LoginResponse({
    required this.error,
    required this.message,
    this.token,
    this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      error: json['error'] as bool,
      message: json['message'] as String,
      token: json['token'],
      data: json['user'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'message': message,
      if (token != null) 'token': token,
      if (data != null) 'data': data,
    };
  }
}
