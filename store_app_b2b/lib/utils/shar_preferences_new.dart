import 'package:shared_preferences/shared_preferences.dart';

class SharPreferences {
  static const isLogin = "isLogin";

  static const videoWatchedDate = "videoWatchedDate";
  static const videoWatchedCount = "videoWatchedCount";

  static const deviceToken = "deviceToken";
  static const isNotSubscribe = "isNotSubscribe";

  static const loginId = "loginID";
  static const storeCategoryId = "storeCategoryId";
  static const storeName = "storeName";
  static const drugLicenseExpiry = "drugLicenseExpiry";

  static const mobileNumber = "mobileNumber";
  static const ownerName = "ownerName";
  static const addressLine1 = "addressLine1";
  static const latitude = "latitude";
  static const longitude = "longitude";
  static const storeNumber = "storeNumber";
  static const supplierId = "supplierId";
  static const storeCategoryMainId = "storeCategoryId";
  static const ownerNameNew = "ownerNameNew";

  static const accessToken = "accessToken";
  static const token = 'token';
  static const phone = "phone";

  static const versionNumber = "versionNumber";

  static Future<bool?> getBoolean(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  static Future<void> setBoolean(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  static getString(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(accessToken) ?? '';
  }

  static Future<void> setString(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static getInt(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  static setInt(String key, int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  static getListString(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key);
  }

  static setListString(String key, List<String> value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, value);
  }

  static Future<void> clearSharPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
}
