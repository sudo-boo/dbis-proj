// models/item.dart


class Item {
  int productId;
  String name;
  String category;
  List<String> imageUrls;
  Map<String, dynamic> productHighlights;
  Map<String, dynamic> productInformation;
  String offerPrice;
  String discount;
  String netQty;
  String mrp;
  int inStock;
  bool toNotify;
  int cartQuantity;
  double rating;

  Item({
    required this.productId,
    required this.name,
    required this.category,
    required this.imageUrls,
    required this.productHighlights,
    required this.productInformation,
    required this.offerPrice,
    required this.discount,
    required this.netQty,
    required this.mrp,
    required this.inStock,
    required this.cartQuantity,
    required this.toNotify,
    required this.rating
  });

  // Factory method to create an Item from a JSON object
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      productId: json['product_id'],
      name: json['name'],
      category: json['category'],
      imageUrls: List<String>.from(json['image_urls']),
      productHighlights: Map<String, dynamic>.from(json['product_highlights']),
      productInformation: Map<String, dynamic>.from(json['product_information']),
      offerPrice: json['offer_price'],
      discount: json['discount'] ?? '',
      netQty: json['net_qty'],
      mrp: json['mrp'] ?? '',
      inStock: 10,
      cartQuantity: 0,
      toNotify: false,
      rating: 4.3
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
      'offer_price': offerPrice,
      'discount': discount,
      'net_qty': netQty,
      'mrp': mrp,
      'inStock': inStock,
      'cartQuantity': cartQuantity,
      'toNotify': toNotify,
    };
  }
}
