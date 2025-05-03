import 'dart:convert';
import 'package:delivery/models/order.dart';

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
        "done": true,
        "vendor_id": 1,
        "delivery_guy_id": 3,
        "vendor_address": "samsung research institute bangalore",
        "customer_address": "BAPS Swaminarayan Mandir, bangalore",
        "expected_delivery_time": "10",
        "time_of_delivery": "12",
        "order_assigned": false
      },
      {
        "order_id": 182,
        "products": {
          "208": "20",
          "210": "1"
        },
        "done": true,
        "vendor_id": 1,
        "delivery_guy_id": 2,
        "vendor_address": "samsung research institute bangalore",
        "customer_address": "BAPS Swaminarayan Mandir, bangalore",
        "expected_delivery_time": "12",
        "time_of_delivery": ""
        "order_assigned": true
        "order_delivered": true
      },
      {
        "order_id": 14,
        "products": {
          "208": "1"
        },
        "done": false,
        "vendor_id": 1,
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
