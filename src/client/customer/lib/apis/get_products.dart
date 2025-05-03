import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<void> getCategories({required String token}) async {
  final String? endpoint = dotenv.env['GET_CATEGORIES_URL'];

  if (endpoint == null || endpoint.isEmpty) {
    print('Error: GET_CATEGORIES_URL is not set in the .env file.');
    return;
  }

  final Uri uri = Uri.parse(endpoint);

  try {
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Categories JSON: $data');
    } else {
      print('Error ${response.statusCode}: ${response.body}');
    }
  } catch (e) {
    print('Exception occurred: $e');
  }
}

Future<void> getProductsByCategory({
  required String token,
  required String categoryId,
  required String requestQuantity,
  required String batchNo,
  required String userId,
}) async {
  final String? endpoint = dotenv.env['GET_PRODUCTS_BY_CATEGORY'];

  if (endpoint == null || endpoint.isEmpty) {
    print('Error: API endpoint is not set in .env file.');
    return;
  }

  // Prepare request body as JSON
  final Map<String, dynamic> requestBody = {
    'category_id': categoryId,
    'request_quantity': requestQuantity,
    'batch_no': batchNo,
    'user_id': userId,
  };

  print('Request Body: $requestBody');

  try {
    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Response JSON: $data');
    } else {
      print('Error ${response.statusCode}: ${response.body}');
    }
  } catch (e) {
    print('Exception occurred: $e');
  }
}
