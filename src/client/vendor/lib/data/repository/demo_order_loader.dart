import 'dart:convert';
import 'package:vendor/models/order.dart';

class OrderDataLoader {
  // A function to load demo data from a JSON string (or a local file)
  Future<List<Order>> loadDemoData() async {
    // Hardcoded JSON data as a string (for testing purposes)
    String jsonData = '''[
      {
        "order_id": 142,
        "products": {
          "208": "2",
          "209": "3",
          "210": "10"
        }
      },
      {
        "order_id": 182,
        "products": {
          "208": "20",
          "210": "1"
        },
        "done": true
      },
      {
        "order_id": 14,
        "products": {
          "208": "1"
        }
      }
    ]''';

    // Parse the JSON data
    List<dynamic> dataList = jsonDecode(jsonData);

    // Convert each map to an Order object and return as a list
    return dataList.map<Order>((json) => Order.fromJson(json)).toList();
  }

  // Function to get a single order based on order_id
  Future<Order?> getOrder(int orderId) async {
    List<Order> allOrders = await loadDemoData();
    return allOrders.firstWhere((order) => order.orderId == orderId);
  }
}
