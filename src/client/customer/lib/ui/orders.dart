import 'dart:convert';
import 'package:customer/data/repository/local_storage_manager.dart'; // For getting token and userId
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CustomerOrderHistoryPage extends StatefulWidget {
  const CustomerOrderHistoryPage({super.key});

  @override
  State<CustomerOrderHistoryPage> createState() => _CustomerOrderHistoryPageState();
}

class _CustomerOrderHistoryPageState extends State<CustomerOrderHistoryPage> {
  List<_CustomerOrder>? _orders;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<List<_CustomerOrder>> getActiveOrders() async {
    String? token = await getUserToken();
    String? userId = await getUserId();

    final url = Uri.parse(dotenv.env['GET_ACTIVE_ORDER']!); // Load from .env

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final body = jsonEncode({
      'user_id': userId,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Active Orders Response: $data');

        if (data is Map<String, dynamic> && data.containsKey('orders')) {
          List<dynamic> ordersJson = data['orders'];
          return ordersJson.map<_CustomerOrder>((order) {
            var rawItems = order['items'];
            List<dynamic> itemsJson = rawItems is List ? rawItems : [];

            List<_CustomerOrderItem> items = itemsJson.map<_CustomerOrderItem>((item) {
              return _CustomerOrderItem(
                name: item['name'] ?? "Product ${item['product_id']}",
                quantity: item['quantity'],
                price: (item['price'] as num).toDouble(),
              );
            }).toList();

            return _CustomerOrder(
              id: order['order_id'].toString(),
              date: order['order_date'] ?? "Unknown date",
              time: order['order_time'] ?? "Unknown time",
              eta: order['eta'] ?? "Unknown ETA",
              status: order['status'] ?? "Unknown",
              totalPrice: (order['total_price'] as num).toDouble(),
              items: items,
            );
          }).toList();
        } else {
          print("No 'orders' key found or unexpected response format.");
          return [];
        }
      } else {
        print('Failed to fetch active orders: ${response.statusCode}');
        print(response.body);
        return [];
      }
    } catch (e) {
      print('Error fetching active orders: $e');
      return [];
    }
  }

  Future<void> _loadOrders() async {
    print("Loading orders...");
    List<_CustomerOrder> orders = await getActiveOrders();

    setState(() {
      _orders = orders;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Orders")),
      body: _orders == null
          ? const Center(child: CircularProgressIndicator())
          : _orders!.isEmpty
          ? const Center(child: Text("No past orders found."))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _orders!.length,
        itemBuilder: (context, index) {
          final order = _orders![index];
          return Card(
            color: Colors.grey.shade100,
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Order ID: ${order.id}",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text("Date: ${order.date} | Time: ${order.time}",
                      style: TextStyle(color: Colors.grey.shade600)),
                  const SizedBox(height: 4),
                  Text("ETA: ${order.eta}", style: TextStyle(color: Colors.blue.shade700)),
                  const SizedBox(height: 4),
                  Text("Status: ${order.status}", style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Text("Total: ₹${order.totalPrice.toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 15, color: Colors.green.shade800)),
                  const SizedBox(height: 10),
                  ...order.items.map((item) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item.name, style: const TextStyle(fontSize: 14)),
                          Text("x${item.quantity}", style: TextStyle(color: Colors.grey.shade700)),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CustomerOrderItem {
  final String name;
  final int quantity;
  final double price;

  _CustomerOrderItem({
    required this.name,
    required this.quantity,
    required this.price,
  });
}

class _CustomerOrder {
  final String id;
  final String date;
  final String time;
  final String eta;
  final String status;
  final double totalPrice;
  final List<_CustomerOrderItem> items;

  _CustomerOrder({
    required this.id,
    required this.date,
    required this.time,
    required this.eta,
    required this.status,
    required this.totalPrice,
    required this.items,
  });
}
