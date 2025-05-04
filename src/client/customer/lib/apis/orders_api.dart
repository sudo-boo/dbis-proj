
import 'dart:convert';
import 'package:customer/data/repository/local_storage_manager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> placeOrder(context) async {
  String? token = await getUserToken();
  String? userId = await getUserId();
  bool? isProfileNotCompleted = await getIsProfileNotCreated();

  if (isProfileNotCompleted != null && isProfileNotCompleted) {
    // If profile is not completed, navigate to the profile page
    Navigator.pushNamed(context, '/profile');
    return;  // Exit early so that order is not placed if profile is incomplete
  }

  final url = Uri.parse(dotenv.env['PLACE_ORDER']!); // Safely read API URL

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  final body = jsonEncode({
    'user_id': userId,
  });

  try {
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Order placed successfully!');
      final data = jsonDecode(response.body);
      print(data);
    } else {
      print('Failed to place order: ${response.statusCode}');
      print(response.body);
    }
  } catch (e) {
    print('Error: $e');
  }
}