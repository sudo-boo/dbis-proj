// models/item.dart


class Order {
  int orderId;
  Map<String, String> products;
  bool done;

  Order({
    required this.orderId,
    required this.products,
    required this.done,
  });

  // Factory method to create an Item from a JSON object
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['order_id'],
      products: Map<String, String>.from(json['products']),
      done: json['done'] is bool ? json['done'] : false,
    );
  }

  // Method to convert the Item object into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'products': products,
      'done': done,
    };
  }
}
