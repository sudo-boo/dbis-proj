// models/item.dart

import 'dart:convert';

class Item {
  int productId;
  String name;
  String brand;
  double mrp;
  double discount;
  Map<String, dynamic>? description;
  String? imageUrl;
  double? rating;
  Map<String, dynamic>? highlights;
  int? category;

  Item({
    required this.productId,
    required this.name,
    required this.brand,
    required this.mrp,
    required this.discount,
    this.description,
    this.imageUrl,
    this.rating,
    this.highlights,
    this.category,
  });

  // Factory method to create an Item from a JSON object
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      productId: json['product_id'],
      name: json['name'],
      brand: json['brand'],
      mrp: json['mrp'].toDouble(),
      discount: json['discount'].toDouble(),
      description: json['description'] != null
          ? jsonDecode(json['description'])
          : null,
      imageUrl: json['image_url'],
      rating: json['rating']?.toDouble(),
      highlights: json['highlights'] != null
          ? jsonDecode(json['highlights'])
          : null,
      category: json['category'],
    );
  }

  // Method to convert the Item object into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'name': name,
      'brand': brand,
      'mrp': mrp,
      'discount': discount,
      'description': description != null ? jsonEncode(description) : null,
      'image_url': imageUrl,
      'rating': rating,
      'highlights': highlights != null ? jsonEncode(highlights) : null,
      'category': category,
    };
  }
}
