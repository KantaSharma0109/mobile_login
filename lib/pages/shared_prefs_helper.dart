import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static const String _userIdKey = 'user_id';

  // Function to get user ID from SharedPreferences
  static Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  // Function to save user ID to SharedPreferences (if needed elsewhere)
  static Future<void> saveUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
  }

  // Function to clear user ID from SharedPreferences (if needed for logout)
  static Future<void> clearUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
  }
}
