import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHandler {
  static const String isLogin = "isLogin";

  //Save data login pada saat login
  static saveLogin(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(isLogin, value);
  }

  //Ambil data login pada saat mau login / ke dashboard
  static getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isLogin);
  }

  //Hapus data login pada saat logout
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
