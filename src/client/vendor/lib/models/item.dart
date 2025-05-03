// models/item.dart


class Item {
  int productId;
  String name;
  String category;
  List<String> imageUrls;
  Map<String, String> productHighlights;
  Map<String, String> productInformation;
  String netQty;
  String mrp;
  int stockQty;

  Item({
    required this.productId,
    required this.name,
    required this.category,
    required this.imageUrls,
    required this.productHighlights,
    required this.productInformation,
    required this.netQty,
    required this.mrp,
    required this.stockQty,
  });

  // Factory method to create an Item from a JSON object
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      productId: json['product_id'],
      name: json['name'],
      category: json['category'],
      imageUrls: List<String>.from(json['image_urls']),
      productHighlights: Map<String, String>.from(json['product_highlights']),
      productInformation: Map<String, String>.from(json['product_information']),
      netQty: json['net_qty'],
      mrp: json['mrp'] ?? '',
      stockQty: json['stock_qty'] ?? 0,
    );
  }

  // Method to convert the Item object into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'name': name,
      'category': category,
      'image_urls': imageUrls,
      'product_highlights': productHighlights,
      'product_information': productInformation,
      'net_qty': netQty,
      'mrp': mrp,
      'stock_qty': stockQty,
    };
  }
}
