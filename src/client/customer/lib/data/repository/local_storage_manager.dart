import 'package:shared_preferences/shared_preferences.dart';

// Save user ID
Future<void> saveUserId(String userId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("user_id", userId);
}

// Save user email
Future<void> saveUserEmail(String email) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("user_email", email);
}

// Save user token
Future<void> saveUserToken(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("user_token", token);
}

// Save isProfileNotCreated flag
Future<void> saveIsProfileNotCreated(bool isNotCreated) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool("is_profile_not_created", isNotCreated);
}

// Save all user data
Future<void> saveUserData(String email, String userId, String token, bool isProfileNotCreated) async {
  await saveUserEmail(email);
  await saveUserId(userId);
  await saveUserToken(token);
  await saveIsProfileNotCreated(isProfileNotCreated);
}

// Retrieve user email
Future<String?> getUserEmail() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("user_email");
}

// Retrieve user ID
Future<String?> getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("user_id");
}

// Retrieve user token
Future<String?> getUserToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("user_token");
}

// Retrieve isProfileNotCreated flag
Future<bool?> getIsProfileNotCreated() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool("is_profile_not_created");
}

// Erase all user data
Future<void> eraseUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove("user_email");
  await prefs.remove("user_id");
  await prefs.remove("user_token");
  await prefs.remove("is_profile_not_created");
}
