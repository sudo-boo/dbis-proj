import 'dart:convert';
import 'package:customer/data/repository/local_storage_manager.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:math';
import '../models/item.dart';

Future<List<Item>> getCart() async {
  String? userId = await getUserId();
  String? token = await getUserToken();

  // Get current location
  Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );

  final url = Uri.parse(dotenv.env['GET_CART']!);
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  final body = jsonEncode({
    'user_id': userId,
    'latitude': position.latitude,
    'longitude': position.longitude,
  });

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    if (data['items'] is List) {
      List<Item> items = [];

      for (var cartItem in data['items']) {
        var itemData = cartItem['item'];
        int productId = itemData['product_id'] ?? 0;
        String name = itemData['name'] ?? 'No Name';
        String netQty = itemData['quantity']?.toString() ?? '1';
        String discount = (5 + Random().nextInt(16)).toString(); // Random 5–20%
        String mrp = itemData['mrp']?.toString() ?? '0';
        String offerPrice = (double.parse(mrp) * (1 - double.parse(discount) / 100)).toStringAsFixed(2);

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

        int inStock = itemData['stock_available'] ?? 0;
        double rating = double.parse((4.1 + Random().nextDouble() * 0.9).toStringAsFixed(1));

        int cartQuantity = cartItem['quantity'] ?? 0;

        Item item = Item(
          productId: productId,
          name: name,
          category: itemData['category'] ?? 'Default', // Optional fallback
          imageUrls: imageUrls,
          productHighlights: productHighlights,
          productInformation: productInformation,
          offerPrice: offerPrice,
          discount: discount,
          netQty: netQty,
          mrp: mrp,
          inStock: inStock,
          cartQuantity: cartQuantity,
          toNotify: false,
          rating: rating,
        );

        items.add(item);
      }

      return items;
    } else {
      throw Exception('Unexpected response format: items list not found.');
    }
  } else {
    throw Exception('Failed to fetch cart: ${response.statusCode}, ${response.body}');
  }
}


Future<void> addToCart({
  required String productId,
  required int quantity,
}) async {
  // 1. Retrieve userId and token
  String? userId = await getUserId();
  String? token = await getUserToken();

  // 2. Load ADD_TO_CART URL from .env
  final url = Uri.parse(dotenv.env['ADD_TO_CART']!);

  // 3. Set headers
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  // 4. Prepare request body
  final body = jsonEncode({
    'user_id': userId,
    'product_id': productId,
    'quantity': quantity,
  });

  // 5. Send POST request
  final response = await http.post(
    url,
    headers: headers,
    body: body,
  );

  // 6. Handle response
  if (response.statusCode == 200) {
    print('Product added to cart: ${response.body}');
  } else {
    print('Failed to add to cart: ${response.statusCode}, ${response.body}');
  }
}

Future<void> updateCart({
  required String productId,
  required int quantity,
}) async {
  // 1. Retrieve userId and token
  String? userId = await getUserId();
  String? token = await getUserToken();

  // 2. Load UPDATE_CART URL from .env
  final String? urlString = dotenv.env['UPDATE_CART'];
  if (urlString == null || urlString.isEmpty) {
    throw Exception('UPDATE_CART is not set in the .env file.');
  }
  final Uri url = Uri.parse(urlString);

  // 3. Set headers
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  // 4. Prepare request body
  final body = jsonEncode({
    'user_id': userId,
    'product_id': productId,
    'quantity': quantity,
  });

  // 5. Send POST request
  final response = await http.post(
    url,
    headers: headers,
    body: body,
  );

  // 6. Handle response
  if (response.statusCode == 200) {
    print('Cart updated successfully: ${response.body}');
  } else {
    print('Failed to update cart: ${response.statusCode}, ${response.body}');
  }
}


