// get_update_profile.dart

import 'dart:convert';
import 'package:customer/data/repository/local_storage_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

// Function to get user profile data by email
Future<Map<String, dynamic>?> getUserProfile() async {
  try {
    String getProfileUrl = dotenv.env['GET_PROFILE_URL'] ?? '';
    String? email = await getUserEmail();
    
    if (getProfileUrl.isEmpty) {
      print("GET_PROFILE_URL not found in .env file.");
      return null;
    }

    final response = await http.get(
      Uri.parse('$getProfileUrl?email=$email'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'username': data['username'],
        'mobile': data['mobile'],
        'email': data['email'],
        'address': data['address'],
      };
    } else {
      print('Error getting profile: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Exception while getting user profile: $e');
    return null;
  }
}

// Function to update user profile
Future<bool> updateUserProfile(
    String email,
    String username,
    String mobile,
    String address,
    ) async {
  try {
    String updateProfileUrl = dotenv.env['UPDATE_PROFILE_URL'] ?? '';

    if (updateProfileUrl.isEmpty) {
      print("UPDATE_PROFILE_URL not found in .env file.");
      return false;
    }

    final requestBody = {
      'email': email,
      'username': username,
      'mobile': mobile,
      'address': address,
    };

    final response = await http.post(
      Uri.parse(updateProfileUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Error updating profile: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Exception while updating user profile: $e');
    return false;
  }
}
