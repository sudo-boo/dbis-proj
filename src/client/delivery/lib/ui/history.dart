import 'package:flutter/material.dart';
import 'package:delivery/models/order.dart' as model_order;

/// Page showing history of completed deliveries
class HistoryPage extends StatelessWidget {
  final List<model_order.Order> ordersDelivered;

  const HistoryPage({super.key, required this.ordersDelivered});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery History'),
      ),
      body: ordersDelivered.isEmpty
          ? const Center(
        child: Text(
          'No completed deliveries',
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: ordersDelivered.length,
        itemBuilder: (context, index) {
          final order = ordersDelivered[index];
          return Card(
            color: Colors.grey.shade200,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.check_circle_outline, color: Colors.green),
                      const SizedBox(width: 8),
                      Text(
                        'Order ${order.orderId}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('Expected Delivery: ${order.expecteddeliveryTime}'),
                  Text('Delivered at: ${order.timeOfDelivery}'),
                  const SizedBox(height: 8),
                  Text('From: ${order.vendorAddress}'),
                  Text('To: ${order.customerAddress}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
