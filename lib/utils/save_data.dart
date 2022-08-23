import 'package:shared_preferences/shared_preferences.dart';

/// Works as a wrapper for shared preferences to hold key value pairs
class SaveData {
  static String token = "token";
  static String email = "email";
  static String name = "name";
  static void saveData(
      String tokenData, String emailData, String nameData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SaveData.token, tokenData);
    await prefs.setString(SaveData.email, emailData);
    await prefs.setString(SaveData.name, nameData);
  }

  static Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SaveData.token) ?? "";
  }

  static Future<String> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SaveData.name) ?? "";
  }

  static Future<String> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SaveData.email) ?? "";
  }
}
