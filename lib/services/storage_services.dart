import 'dart:convert';

import 'package:mdw/models/file_type_model.dart';
import 'package:mdw/services/app_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageServices {
  static Future<void> setSignInStatus(bool status) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(AppKeys.signInStatusKey, status);
  }

  static Future<void> setAttendanceStatus(bool status) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(AppKeys.attendanceStatusKey, status);
  }

  static Future<void> setLoginUserDetails(Map<String, dynamic> user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(AppKeys.loginKey, jsonEncode(user));
  }

  static Future<void> setAadharFront(FileTypeModel file, String uname) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(AppKeys.aadharFrontKey + "/" + uname, file.toJsonString());
  }

  static Future<void> setAadharBack(FileTypeModel file, String uname) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(AppKeys.aadharBackKey + "/" + uname, file.toJsonString());
  }

  static Future<void> setPan(FileTypeModel file, String uname) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(AppKeys.panKey + "/" + uname, file.toJsonString());
  }

  static Future<void> setProfilePic(FileTypeModel file) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(AppKeys.profilePicKey, file.toJsonString());
  }

  static Future<FileTypeModel?> getProfilePic() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final data = pref.getString(AppKeys.profilePicKey);
    if (data != null) {
      return FileTypeModel.fromJson(jsonDecode(data));
    } else {
      return null;
    }
  }

  static Future<FileTypeModel?> getPan(String uname) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final data = pref.getString(AppKeys.panKey + "/" + uname);
    if (data != null) {
      return FileTypeModel.fromJson(jsonDecode(data));
    } else {
      return null;
    }
  }

  static Future<FileTypeModel?> getAadharBack(String uname) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final data = pref.getString(AppKeys.aadharBackKey + "/" + uname);
    if (data != null) {
      return FileTypeModel.fromJson(jsonDecode(data));
    } else {
      return null;
    }
  }

  static Future<FileTypeModel?> getAadharFront(String uname) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final data = pref.getString(AppKeys.aadharFrontKey + "/" + uname);
    if (data != null) {
      print(jsonDecode(data).runtimeType);

      return FileTypeModel.fromJson(jsonDecode(data));
    } else {
      return null;
    }
  }

  static Future<String?> getLoginUserDetails() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(AppKeys.loginKey);
  }

  static Future<bool> getSignInStatus() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(AppKeys.signInStatusKey) ?? false;
  }

  static Future<bool> getAttendanceStatus() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(AppKeys.attendanceStatusKey) ?? false;
  }
}
