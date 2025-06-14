

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



}
