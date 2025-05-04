// local_storage_manager.dart

import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveUserId(String userId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("user_id", userId);
}

Future<void> saveUserEmail(String email) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("user_email", email);
}

Future<void> saveUserData(String email, String userId) async {
  saveUserEmail(email);
  saveUserId(userId);
}

// Retrieve the user_email from SharedPreferences
Future<String?> getUserEmail() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("user_email");
}

// Retrieve the user_id from SharedPreferences
Future<String?> getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("user_id");
}

// Erase user_email and user_id from SharedPreferences
Future<void> eraseUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove("user_email");
  await prefs.remove("user_id");
}
