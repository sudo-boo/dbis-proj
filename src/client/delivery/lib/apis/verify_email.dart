// verify_email.dart

import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

// Function to send OTP
Future<bool> sendOtp(String email) async {
  try {

    return true; // return true for now
    // Load the base URL and endpoint from the .env file
    String sendOtpUrl = dotenv.env['SEND_OTP_URL'] ?? '';
    // print(sendOtpUrl);

    if (sendOtpUrl.isEmpty) {
      print("SEND_OTP_URL not found in .env file.");
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
