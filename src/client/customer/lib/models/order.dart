// models/item.dart


class Order {
  int orderId;
  int vendorId;
  int deliveryGuyId;
  String vendorAddress;
  String customerAddress;
  Map<String, String> products;
  bool done;
  String expecteddeliveryTime;
  bool orderAssigned;
  bool orderDelivered;
  String timeOfDelivery;
  // Constructor

  Order({
    required this.orderId,
    required this.products,
    required this.vendorId,
    required this.deliveryGuyId,
    required this.vendorAddress,
    required this.customerAddress,
    required this.done,
    required this.timeOfDelivery,
    required this.expecteddeliveryTime,
    required this.orderAssigned,
    required this.orderDelivered,
  });

  // Factory method to create an Item from a JSON object
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['order_id'],
      products: Map<String, String>.from(json['products']),
      done: json['done'] is bool ? json['done'] : false,
      vendorId: json['vendor_id'],
      deliveryGuyId: json['delivery_guy_id'],
      vendorAddress: json['vendor_address'],
      customerAddress: json['customer_address'],
      expecteddeliveryTime: json['expected_delivery_time'] ?? '',
      timeOfDelivery: json['time_of_delivery'] ?? '',
      orderAssigned: json['order_assigned'] is bool ? json['order_assigned'] : false,
      orderDelivered: json['order_delivered'] is bool ? json['order_delivered'] : false,
    );
  }

  // Method to convert the Item object into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'products': products,
      'done': done,
      'vendor_id': vendorId,
      'delivery_guy_id': deliveryGuyId,
      'vendor_address': vendorAddress,
      'customer_address': customerAddress,
      'expected_delivery_time': expecteddeliveryTime,
      'time_of_delivery': timeOfDelivery,
      'order_assigned': orderAssigned,
      'order_delivered': orderDelivered,
    };
  }
}