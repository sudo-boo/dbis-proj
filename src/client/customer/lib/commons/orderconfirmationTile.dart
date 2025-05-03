import 'package:flutter/material.dart';
import 'package:customer/models/item.dart';

class OrderConfirmationTile extends StatelessWidget {
  final Item item;
  final int quantity;

  const OrderConfirmationTile({
    super.key,
    required this.item,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    double price = double.tryParse(item.offerPrice.replaceAll('₹', '').trim()) ?? 0;
    double totalPrice = price * quantity;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        border: Border.all(color: Colors.green.shade100, width: 1.2),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.shade100.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Image thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.imageUrls.isNotEmpty ? item.imageUrls[0] : '',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),

          // Product details and quantity
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
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Quantity: $quantity',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ],
            ),
          ),

          // Total price
          Text(
            '₹${totalPrice.toStringAsFixed(0)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
