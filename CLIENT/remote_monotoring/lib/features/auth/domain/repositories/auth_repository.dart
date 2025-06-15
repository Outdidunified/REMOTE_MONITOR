
import 'package:remote_monotoring/features/auth/data/api.dart';
import 'package:remote_monotoring/features/auth/domain/models/auth_model.dart';

class AuthRepository {
  final AuthApiCalls _api = AuthApiCalls();

  Future<RegisterResponse> RegisterAccount(String username,String email, String password, String phoneNo ) async {
    try {
      final responseJson = await _api.RegisterAccount(username,email, password, phoneNo);

      return RegisterResponse.fromJson(responseJson); // Parse JSON to model
    } catch (e) {
      rethrow; // Re-throw the error to be handled by the controller
    }
  }

  Future<LoginResponse> LoginAccount(String email, String password) async {
    try {
      final responseJson = await _api.LoginAccount(email, password);

      return LoginResponse.fromJson(responseJson); // Parse JSON to model
    } catch (e) {
      rethrow; // Re-throw the error to be handled by the controller
    }
  }

  Future<GetOtpResponse> Getotp(String email) async {
    try {
      final responseJson = await _api.GetOtp(email);

      return GetOtpResponse.fromJson(responseJson); // Parse JSON to model
    } catch (e) {
      rethrow; // Re-throw the error to be handled by the controller
    }
  }

  Future<VerifyotpResponse> Verifyotp(String email ,int otp) async {
    try {
      final responseJson = await _api.VerifyOTP(email,otp);

      return VerifyotpResponse.fromJson(responseJson); // Parse JSON to model
    } catch (e) {
      rethrow; // Re-throw the error to be handled by the controller
    }
  }

  Future<UpdatePasswordResponse> UpdatePassword(String email ,String password) async {
    try {
      final responseJson = await _api.UpdatePassword(email,password);

      return UpdatePasswordResponse.fromJson(responseJson); // Parse JSON to model
    } catch (e) {
      rethrow; // Re-throw the error to be handled by the controller
    }
  }

}
