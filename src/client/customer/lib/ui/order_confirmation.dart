import 'package:customer/apis/orders_api.dart';
import 'package:flutter/material.dart';
import 'package:customer/models/order.dart';
import 'package:customer/models/item.dart';
import 'package:customer/commons/orderconfirmationTile.dart';
import 'package:intl/intl.dart';

/// Wrapper to pass both order & items via Navigator
class OrderConfirmationArguments {
  final Order order;
  final List<Item> items;
  OrderConfirmationArguments({required this.order, required this.items});
}

class OrderConfirmationPage extends StatelessWidget {
  static const routeName = '/orderConfirmation';
  final Order order;
  final List<Item> items;

  const OrderConfirmationPage({
    super.key,
    required this.order,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    // Pricing calculations
    double subTotal = items.fold(0, (sum, item) {
      final price = double.tryParse(
          item.offerPrice.replaceAll('₹', '').trim()) ??
          0;
      return sum + price * item.cartQuantity;
    });
    const double deliveryFee = 20;
    final double total = subTotal + deliveryFee;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Order'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Items list
            Expanded(
              child: ListView(
                children: [
                  const Text(
                    'Items Ordered',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...items.map((it) => ReadOnlyCartItemTile(
                    item: it,
                    quantity: it.cartQuantity,
                  )),
                  const Divider(height: 32),

                  // Payment summary
                  const Text(
                    'Payment Summary',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSummaryRow('Subtotal', '₹${subTotal.toStringAsFixed(0)}'),
                  _buildSummaryRow('Delivery Fee', '₹${deliveryFee.toStringAsFixed(0)}'),
                  _buildSummaryRow(
                    'Total',
                    '₹${total.toStringAsFixed(0)}',
                    isBold: true,
                  ),
                  const SizedBox(height: 12),

                  // Cash on delivery message
                  const Text(
                    'You have Cash on Delivery',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // just pop the top route
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.green),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Continue Shopping',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _confirmOrder(context, total),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Confirm Order',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a row for summary
  Widget _buildSummaryRow(String label, String value,
      {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                fontSize: 16,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  /// Shows confirmation dialog then returns home
  void _confirmOrder(BuildContext context, double total) {
    final now = DateTime.now();
    final formatted = DateFormat('dd MMM yyyy, hh:mm a').format(now);
    placeOrder(context);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Order Placed!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID: ${order.orderId}'),
            const SizedBox(height: 6),
            Text('Date: $formatted'),
            const SizedBox(height: 6),
            Text('Total Paid: ₹${total.toStringAsFixed(0)}'),
            const SizedBox(height: 6),
            // Cash on delivery message in dialog
            const Text(
              'Cash on Delivery',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              // pop all the routes then push home
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/',
                    (route) => false,
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
