import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHandler {
  static const String isLogin = "isLogin";

  static saveLogin(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(isLogin, value);
  }

  static getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isLogin);
  }

  static removeLogin() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(isLogin);
  }

  static Future<String?> getName() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString('name');
  }

  static Future<void> saveRole(String role) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString("role", role);
  }

  static Future<String?> getRole() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString("role");
  }
}
