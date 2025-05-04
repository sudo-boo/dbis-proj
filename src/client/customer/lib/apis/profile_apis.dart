import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../data/repository/local_storage_manager.dart';
import '../models/user.dart';  // Assuming you have this UserProfile class

// Fetch profile information
Future<UserProfile?> getProfile() async {
  // Fetch the token and email from local storage
  String? token = await getUserToken();
  String? email = await getUserEmail();

  if (token == null) {
    print('Token not available');
    return null;  // If token is not available, return null
  }

  // Construct the URL from the environment variable
  final url = Uri.parse(dotenv.env['GET_PROFILE_URL']!);

  // Set up headers with the token
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',  // Add Bearer token to header
  };

  // Prepare the body with the email
  final body = jsonEncode({
    'email': email,  // Include email in the body
  });

  try {
    // Send the POST request to the API
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      // Decode the response body
      final data = jsonDecode(response.body);
      print('Profile Response:');

      // Check if the response is a Map
      if (data is Map<String, dynamic>) {
        // Print each key-value pair in the response
        data.forEach((key, value) {
          print('$key: $value');
        });

        // Create a UserProfile from the response data
        return UserProfile.fromJson(data);
      } else {
        print('Response is not in expected format: $data');
        return null;
      }
    } else {
      // If the status code is not 200, print error information
      print('Failed to fetch profile: ${response.statusCode}');
      print(response.body);
      return null;
    }
  } catch (e) {
    print('Error fetching profile: $e');
    return null;
  }
}

// API call to update user profile
Future<void> updateUserProfile(
    String email, String name, String phone, String address
    ) async {
  // Fetch the token from local storage
  String? token = await getUserToken();

  if (token == null) {
    print('Token not available');
    return;
  }

  // Prepare the URL and headers
  final url = Uri.parse(dotenv.env['UPDATE_PROFILE_URL']!); // Load URL from .env

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',  // Bearer token in the header
  };

  // Prepare the body with updated values
  final body = jsonEncode({
    'email': email,
    'name': name,
    'phone': phone,
    'address': address,
  });

  try {
    // Send the POST request to update profile
    final response = await http.post(url, headers: headers, body: body);

    // Handle the response
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Profile update response: $data');
    } else {
      print('Failed to update profile: ${response.statusCode}');
      print(response.body);
    }
  } catch (e) {
    print('Error updating profile: $e');
  }
}
