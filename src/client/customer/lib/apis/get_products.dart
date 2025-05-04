import 'dart:convert';
import 'dart:math';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/item.dart';

Future<List<Category>> getCategories({required String token}) async {
  final String? endpoint = dotenv.env['GET_CATEGORIES_URL'];

  if (endpoint == null || endpoint.isEmpty) {
    throw Exception('GET_CATEGORIES_URL is not set in the .env file.');
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

      // Assuming data is a List of category maps
      if (data is List) {
        return data.map((item) => Category.fromJson(item)).toList();
      } else {
        throw Exception('Unexpected data format. Expected a list.');
      }
    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  } catch (e) {
    throw Exception('Exception occurred: $e');
  }
}


Future<List<Item>> getProductsByCategory({
  required String token,
  required String categoryId,
  required String categoryName,
  required String requestQuantity,
  required String batchNo,
  required String userId,
}) async {
  final String? endpoint = dotenv.env['GET_PRODUCTS_BY_CATEGORY'];

  if (endpoint == null || endpoint.isEmpty) {
    throw Exception('GET_PRODUCTS_BY_CATEGORY is not set in the .env file.');
  }

  final Map<String, dynamic> requestBody = {
    'category_id': categoryId,
    'request_quantity': requestQuantity,
    'batch_no': batchNo,
    'user_id': userId,
  };

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

      // print(data);

      // Check if the response contains the 'items' key
      if (data['items'] is List) {
        List<Item> items = [];

        // // Loop through the items and print the keys and values of each item
        // for (var item in data['items']) {
        //   print('Item Keys and Values:');
        //   for (var key in item.keys) {
        //     print('$key: ${item[key]}');  // Print each key and its value
        //   }
        // }


        // Loop through each item in the 'items' list
        for (var itemData in data['items']) {
          // Parse and extract the necessary data from each item
          int productId = itemData['product_id'] ?? 0;
          String name = itemData['name'] ?? 'No Name';
          String category = categoryName;

          String netQty = itemData['quantity']?.toString() ?? '1';
          String discount = (5 + Random().nextInt(16)).toString(); // Random int from 5 to 20

          String mrp = (double.parse(itemData['mrp']!.toString()) * (1 + double.parse(discount) / 100)).toStringAsFixed(2);
          String offerPrice = itemData['mrp']?.toString() ?? '0';

          List<String> imageUrls = List<String>.from(itemData['image_url'] ?? []);
          Map<String, dynamic> productHighlights = itemData['highlights'] ?? {};
          Map<String, dynamic> productInformation = {};
          if (itemData['description'] is String) {
            try {
              productInformation = jsonDecode(itemData['description']);
            } catch (e) {
              print("Failed to parse description: $e");
            }
          } else if (itemData['description'] is Map<String, dynamic>) {
            productInformation = itemData['description'];
          }

          bool toNotify = false;
          int inStock = itemData['stock_available'];
          double rating = double.parse((4.1 + Random().nextDouble() * 0.9).toStringAsFixed(1));
          int cartQuantity = itemData['quantity'] ?? 0;

          // Create an Item object from the extracted data
          Item item = Item(
            productId: productId,
            name: name,
            category: category,
            imageUrls: imageUrls,
            productHighlights: productHighlights,
            productInformation: productInformation,
            offerPrice: offerPrice,
            discount: discount,
            netQty: netQty,
            mrp: mrp,
            inStock: inStock,
            cartQuantity: cartQuantity,
            toNotify: toNotify,
            rating: rating
          );

          items.add(item); // Add the item to the list
        }

        return items; // Return the list of items
      } else {
        throw Exception('Unexpected response format: Expected "items" list');
      }
    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  } catch (e) {
    throw Exception('Exception occurred: $e');
  }
}
