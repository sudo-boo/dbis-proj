import 'dart:math';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:delivery/models/order.dart' as model_order;
import 'package:delivery/data/repository/demo_order_loader.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  // All orders loaded from backend or fallback
  List<model_order.Order> _allOrders = [];
  // Orders to display (active or fallback)
  List<model_order.Order> _activeOrders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final loader = OrderDataLoader();
    List<model_order.Order> demoOrders;
    try {
      demoOrders = await loader.loadDemoData();
    } catch (e) {
      demoOrders = [];
    }

    // If loader returned no data, use hardcoded fallback dummy orders
    if (demoOrders.isEmpty) {
      demoOrders = [
        model_order.Order(
          orderId: 142,
          products: {'208': '2', '209': '3', '210': '10'},
          vendorId: 1,
          deliveryGuyId: 0,
          vendorAddress: 'Demo Vendor Address',
          customerAddress: 'Demo Customer Address',
          done: false,
          timeOfDelivery: '',
          expecteddeliveryTime: '15 mins',
          orderAssigned: false,
          orderDelivered: false,
        ),
        model_order.Order(
          orderId: 182,
          products: {'208': '1', '210': '2'},
          vendorId: 1,
          deliveryGuyId: 0,
          vendorAddress: 'Demo Vendor Address',
          customerAddress: 'Demo Customer Address',
          done: false,
          timeOfDelivery: '',
          expecteddeliveryTime: '20 mins',
          orderAssigned: false,
          orderDelivered: false,
        ),
      ];
    }

    setState(() {
      _allOrders = demoOrders;
      // Display all fetched or fallback orders
      _activeOrders = List.from(_allOrders);
    });
  }

  void _acceptOrder(model_order.Order order) {
    setState(() {
      order.orderAssigned = true;
      // Continue showing all for demo
      _activeOrders = List.from(_allOrders);
    });
    // TODO: call API to mark order assigned
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order ${order.orderId} accepted')),
    );
  }

  void _rejectOrder(model_order.Order order) {
    setState(() {
      _allOrders.removeWhere((o) => o.orderId == order.orderId);
      _activeOrders = List.from(_allOrders);
    });
    // TODO: call API to reject and remove order
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order ${order.orderId} rejected')),
    );
  }

  Future<void> _openDirections(model_order.Order order) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&origin=${Uri.encodeComponent(order.vendorAddress)}'
          '&destination=${Uri.encodeComponent(order.customerAddress)}',
    );
    try {
      // Directly attempt to launch maps without canLaunch check
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open maps: $e')),
      );
    }
  }

  void _completeDelivery(model_order.Order order) async {
    final otpController = TextEditingController();
    final otp = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Enter OTP'),
        content: TextField(
          controller: otpController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: 'OTP'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, null), child: Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, otpController.text), child: Text('Submit')),
        ],
      ),
    );
    if (otp != null) {
      // TODO: verify OTP with backend using otp
      setState(() {
        order.orderDelivered = true;
        order.timeOfDelivery = DateTime.now().toIso8601String();
        _activeOrders = List.from(_allOrders);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Delivery for order ${order.orderId} completed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Delivery Orders')),
      body: _activeOrders.isEmpty
          ? Center(child: Text('No current orders', style: TextStyle(fontSize: 18)))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _activeOrders.length,
        itemBuilder: (context, index) => _buildOrderCard(_activeOrders[index]),
      ),
    );
  }

  Widget _buildOrderCard(model_order.Order order) {
    final distanceKm = (5 + Random().nextDouble() * 10).toStringAsFixed(1);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.purple.shade500,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: ListTile(
                leading: Icon(Icons.delivery_dining, color: Colors.white),
                title: Text(
                  'Order ${order.orderId}',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () => _acceptOrder(order),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.greenAccent.shade700,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: Text('Accept'),
                    ),
                    SizedBox(width: 8),
                    TextButton(
                      onPressed: () => _rejectOrder(order),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: Text('Reject'),
                    ),
                  ],
                ),
              ),
            ),
            ExpansionTile(
              title: Text('Order Details', style: TextStyle(fontWeight: FontWeight.bold)),
              childrenPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                _buildDetailRow(Icons.schedule, 'Expected: ${order.expecteddeliveryTime}'),
                _buildDetailRow(Icons.store, order.vendorAddress),
                _buildDetailRow(Icons.home, order.customerAddress),
                _buildDetailRow(Icons.map, 'Distance: $distanceKm km'),
                SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () => _openDirections(order),
                  icon: Icon(Icons.directions, color: Colors.white),
                  label: Text('Directions', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                SizedBox(height: 12),
                if (order.orderAssigned && !order.orderDelivered) ...[
                  ElevatedButton(
                    onPressed: () => _completeDelivery(order),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Complete Delivery'),
                  ),
                  SizedBox(height: 12),
                ] else if (order.orderDelivered) ...[
                  _buildDetailRow(Icons.check, 'Delivered at: ${order.timeOfDelivery}'),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurpleAccent),
          SizedBox(width: 12),
          Expanded(child: Text(text, style: TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}

