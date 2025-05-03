// verify_email.dart

import 'dart:convert';
import 'package:customer/data/repository/local_storage_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

// Function to send OTP
Future<bool> getOtp(String email) async {
  try {

    // Load the base URL and endpoint from the .env file
    String sendOtpUrl = dotenv.env['GET_OTP_URL'] ?? '';
    // print(sendOtpUrl);

    if (sendOtpUrl.isEmpty) {
      print("GET_OTP_URL not found in .env file.");
      return false;
    }

    // Prepare the request payload
    Map<String, String> requestBody = {
      'email': email,
    };

    // Send the POST request
    final response = await http.post(
      Uri.parse(sendOtpUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    // Check if the request was successful
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, return true
      return true;
    } else {
      // If the server returns an error response, print and return false
      print('Error: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Error occurred while sending OTP: $e');
    return false;
  }
}

Future<bool> verifyOtp(String email, String otp, String lat, String long) async {
  try {
    // Load the base URL and endpoint from the .env file
    String verifyOtpUrl = dotenv.env['VERIFY_OTP_URL'] ?? '';

    if (verifyOtpUrl.isEmpty) {
      print("VERIFY_OTP_URL not found in .env file.");
      return false;
    }

    // Prepare the request payload
    Map<String, String> requestBody = {
      'email': email,
      'otp': otp,
      'latitude': lat,
      'longitude': long
    };

    // Send the POST request
    final response = await http.post(
      Uri.parse(verifyOtpUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    // Check if the request was successful
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);

      // Extract message and token from response
      String message = responseBody['message'] ?? 'No message';
      String token = responseBody['token'] ?? 'No token';
      bool isProfileNotCreated = responseBody['created_user'];
      String userId = responseBody['user_id'].toString();

      print('Message: $message');
      print('Token: $token');
      
      saveUserEmail(email);
      saveUserToken(token);
      saveIsProfileNotCreated(isProfileNotCreated);
      saveUserId(userId);

      return true;
    } else {
      print('Error: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Error occurred while verifying OTP: $e');
    return false;
  }
}


Future<bool> validateToken(String token) async {
  String apiUrl = dotenv.env['IS_TOKEN_VALID'] ?? '';

  if (apiUrl.isEmpty) {
    print("API URL not set in .env file!");
    return false;
  }

  final url = Uri.parse(apiUrl);
  final headers = {"Content-Type": "application/json"};
  final body = jsonEncode({'token': token});

  try {
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print('Error: $e');
    return false;
  }
}
