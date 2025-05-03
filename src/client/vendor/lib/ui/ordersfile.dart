import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vendor/models/order.dart' as model_order;
import 'package:vendor/data/repository/demo_order_loader.dart';
import 'package:vendor/data/repository/demo_data_loader.dart';

class OrderItem {
  final String name;
  final String imageUrl;
  final int quantity;
  final int id;


  OrderItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.quantity,
  });
}

class Order {
  final String id;
  final List<OrderItem> items;
  bool done; // <-- Add this

  Order({
    required this.id,
    required this.items,
    this.done = false, // <-- Default false
  });
}

List<Order>? _allOrders;

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

String _validateImageUrl(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null || !uri.hasAbsolutePath ||
      !(url.startsWith('http://') || url.startsWith('https://'))) {
    throw ArgumentError("Invalid image URL: $url");
  }
  return url;
}

class HistoryPage extends StatelessWidget {
  final List<Order> orders;

  const HistoryPage({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order History')),
      body: orders.isEmpty
          ? Center(child: Text('No completed orders'))
          : ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            color: Colors.grey.shade300, // Greyish look
            margin: EdgeInsets.all(8),
            child: ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text('Order ID: ${order.id}', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${order.items.length} items'),
            ),
          );
        },
      ),
    );
  }
}

class _OrdersPageState extends State<OrdersPage> {
  List<Order>? orders;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      final loader = OrderDataLoader();
      final itemLoader = DataLoader();

      List<model_order.Order> demoOrders = await loader.loadDemoData();

      List<Order> uiOrders = [];
      for (final backendOrder in demoOrders) {
        final itemsFutures = backendOrder.products.entries.map((entry) async {
          final productId = int.tryParse(entry.key) ?? 0;
          final quantity = int.tryParse(entry.value) ?? 1;
          final item = await itemLoader.getSingleItem(productId);

          return OrderItem(
            id: productId,
            name: item!.name,
            imageUrl: (item.imageUrls.isNotEmpty)
                ? _validateImageUrl(item.imageUrls[0])
                : 'https://via.placeholder.com/150',
            quantity: quantity,
          );
        }).toList();

        final items = await Future.wait(itemsFutures);
        uiOrders.add(Order(
          id: backendOrder.orderId.toString(),
          items: items,
          done: backendOrder.done,
        ));
      }

      setState(() {
        orders = uiOrders.where((o) => !o.done).toList();
        _allOrders = uiOrders; // Save all orders to show in history
      });
    } catch (e) {
      print("Error loading orders: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _acceptOrder(BuildContext context, Order order) {
    setState(() {
      order.done = true;
      orders = orders!.where((o) => !o.done).toList();
      _allOrders!.firstWhere((o) => o.id == order.id).done = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order ${order.id} accepted')),
    );
  }


  void _rejectOrder(BuildContext context, Order order) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order ${order.id} rejected')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => HistoryPage(orders: _allOrders?.where((o) => o.done).toList() ?? []),
                ),
              );
            },
          ),
        ],
      ),
      body: orders == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: orders!.length,
        itemBuilder: (context, index) {
          final order = orders![index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 4,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.purple.shade500, // Purple background color
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),  // Circular top-left corner
                        topRight: Radius.circular(20), // Circular top-right corner
                      ),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(8),
                      leading: Icon(Icons.shopping_cart, color: Colors.white), // White icon for contrast
                      title: Text(
                        'Order ID: ${order.id}',
                        style: TextStyle(
                          color: Colors.white,  // White text for contrast
                          fontWeight: FontWeight.bold, // Make the text bold
                          fontSize: 18,  // Slightly larger text for better readability
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed: () => _acceptOrder(context, order),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,  // Text color
                              backgroundColor: Colors.pinkAccent,  // Background color
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20), // Padding for the button
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20), // Rounded corners
                              ),
                            ),
                            child: Text(
                              'Accept',  // Text for the button
                              style: TextStyle(fontWeight: FontWeight.bold), // Bold text for emphasis
                            ),
                          ),
                          SizedBox(width: 10), // Add space between the buttons
                          TextButton(
                            onPressed: () => _rejectOrder(context, order),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,  // Text color
                              backgroundColor: Colors.pinkAccent,  // Background color
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20), // Padding for the button
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20), // Rounded corners
                              ),
                            ),
                            child: Text(
                              'Decline',  // Text for the button
                              style: TextStyle(fontWeight: FontWeight.bold), // Bold text for emphasis
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ExpansionTile(
                    tilePadding: EdgeInsets.symmetric(horizontal: 16),
                    childrenPadding: EdgeInsets.only(bottom: 10),
                    collapsedIconColor: Colors.black,
                    iconColor: Colors.black,
                    title: Text(
                      'Order Details',
                      style: TextStyle(
                        color: Colors.black, // Bright yellow for contrast
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    children: order.items.map((item) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.purple.shade50, // Light purple background
                          border: Border.all(color: Colors.green.shade100, width: 1.2), // Light green border
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purple.shade100.withOpacity(0.2),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item.imageUrl,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple.shade800,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Quantity: ${item.quantity}',
                                    style: TextStyle(color: Colors.grey.shade700),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

