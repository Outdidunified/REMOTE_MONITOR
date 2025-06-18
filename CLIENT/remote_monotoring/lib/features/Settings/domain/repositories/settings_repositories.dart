import 'package:flutter/foundation.dart';
import 'package:remote_monotoring/features/Settings/data/api.dart';
import 'package:remote_monotoring/features/Settings/domain/models/settings_models.dart';


class SettingsRepositories {
  final SettingsApiCall _api = SettingsApiCall();

  Future<FetchUserProfileResponse> fetchuserdata(String token, int userid) async {
    try {
      final Map<String, dynamic> responseJson = await _api.FetchUserDetails(token, userid);

      // Add null checks before parsing
      if (responseJson == null) {
        throw Exception('Null response received from API');
      }

      return FetchUserProfileResponse.fromJson(responseJson);
    } catch (e) {
      debugPrint('repo error : $e');
      rethrow;
    }
  }
  Future<UpdateUserResponse> updateuserdata( String token,
      int userid,
      String name,
      int phone,
      String password,
      String modifiedBy,) async {
    try {
      final Map<String, dynamic> responseJson = await _api.updateUserDetails(token, userid,name,phone,password,modifiedBy);

      // Add null checks before parsing
      if (responseJson == null) {
        throw Exception('Null response received from API');
      }

      return UpdateUserResponse.fromJson(responseJson);
    } catch (e) {
      debugPrint('repo error : $e');
      rethrow;
    }
  }
}
