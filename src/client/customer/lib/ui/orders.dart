import 'package:flutter/material.dart';
import 'package:customer/models/order.dart' as model_order;
import 'package:customer/data/repository/demo_order_loader.dart';
import 'package:customer/data/repository/demo_data_loader.dart';

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

  Future<void> _loadOrders() async {
    print("Loading orders...");

    final loader = OrderDataLoader();
    final itemLoader = DataLoader();

    List<model_order.Order> demoOrders = await loader.loadDemoData();
    print("Demo orders loaded: ${demoOrders.length}");
    print("Type of demoOrders: ${demoOrders.runtimeType}");

    List<_CustomerOrder> uiOrders = [];
    for (final backendOrder in demoOrders) {
      print("Processing order: ${backendOrder.orderId}");
      print("Type of backendOrder: ${backendOrder.runtimeType}");

      final itemsFutures = backendOrder.products.entries.map((entry) async {
        final productId = int.tryParse(entry.key) ?? 0;
        final quantity = int.tryParse(entry.value) ?? 1;
        final item = await itemLoader.getSingleItem(productId);
        print("Processing item: ${item?.name ?? 'Unknown'}");

        return _CustomerOrderItem(
          name: item!.name,
          quantity: quantity,
          price: item.offerPrice.isNotEmpty
              ? double.tryParse(item.offerPrice.replaceAll('₹', '').trim()) ?? 0.0
              : 0.0,
        );
      }).toList();

      final items = await Future.wait(itemsFutures);
      final totalPrice = items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));

      print("Order ID: ${backendOrder.orderId}, Total price: $totalPrice");

      uiOrders.add(_CustomerOrder(
        id: backendOrder.orderId.toString(),
        date: backendOrder.timeOfDelivery,
        totalPrice: totalPrice,
        items: items,
      ));
    }

    print("Orders processed: ${uiOrders.length}");
    print("Type of uiOrders: ${uiOrders.runtimeType}");

    setState(() {
      _orders = uiOrders;
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
                  Text(
                    "Order ID: ${order.id}",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text("Date: ${order.date}", style: TextStyle(color: Colors.grey.shade600)),
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
  final double totalPrice;
  final List<_CustomerOrderItem> items;

  _CustomerOrder({
    required this.id,
    required this.date,
    required this.totalPrice,
    required this.items,
  });
}
