

import 'package:flutter/foundation.dart';
import 'package:remote_monotoring/core/services/base_api_service.dart';
import 'package:remote_monotoring/features/auth/data/url.dart';

class AuthApiCalls extends BaseApiService {
  Future<Map<String, dynamic>> RegisterAccount(String username,String email, String password, String phoneNo) async {
    debugPrint('🛰️ Hitting URL: ${AuthUrl.registeraccount.url}');
    final result = await makeRequest<Map<String, dynamic>>(
      url: AuthUrl.registeraccount.url,
      method: AuthUrl.registeraccount.method,
      body: {
        "name":username,
        "email":email,
        "phone":phoneNo,
        "password":password
      },
      responseParser: (data) => data as Map<String, dynamic>,
    );
    debugPrint('🔽 Final Parsed Response => $result');
    return result;
  }
  Future<Map<String, dynamic>> LoginAccount(String email, String password) async {
    debugPrint('🛰️ Hitting URL: ${AuthUrl.loginaccount.url}');
    final result = await makeRequest<Map<String, dynamic>>(
      url: AuthUrl.loginaccount.url,
      method: AuthUrl.loginaccount.method,
      body: {
        "email":email,
        "password":password
      },
      responseParser: (data) => data as Map<String, dynamic>,
    );
    debugPrint('🔽 Final Parsed Response => $result');
    return result;
  }
  Future<Map<String, dynamic>> GetOtp(String email) async {
    debugPrint('🛰️ Hitting URL: ${AuthUrl.getotp.url}');
    final result = await makeRequest<Map<String, dynamic>>(
      url: AuthUrl.getotp.url,
      method: AuthUrl.getotp.method,
      body: {
        "email":email,
      },
      responseParser: (data) => data as Map<String, dynamic>,
    );
    debugPrint('🔽 Final Parsed Response => $result');
    return result;
  }
  Future<Map<String, dynamic>> VerifyOTP(String email,int forget_password_otp) async {
    debugPrint('🛰️ Hitting URL: ${AuthUrl.verifyotp.url}');
    final result = await makeRequest<Map<String, dynamic>>(
      url: AuthUrl.verifyotp.url,
      method: AuthUrl.verifyotp.method,
      body: {
        "email":email,
        "forget_password_otp":forget_password_otp
      },
      responseParser: (data) => data as Map<String, dynamic>,
    );
    debugPrint('🔽 Final Parsed Response => $result');
    return result;
  }
  Future<Map<String, dynamic>> UpdatePassword(String email,String password) async {
    debugPrint('🛰️ Hitting URL: ${AuthUrl.Updatepassword.url}');
    final result = await makeRequest<Map<String, dynamic>>(
      url: AuthUrl.Updatepassword.url,
      method: AuthUrl.Updatepassword.method,
      body: {
        "email":email,
        "password":password
      },
      responseParser: (data) => data as Map<String, dynamic>,
    );
    debugPrint('🔽 Final Parsed Response => $result');
    return result;
  }



}
