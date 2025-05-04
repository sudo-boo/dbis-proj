import 'package:flutter/material.dart';
import 'package:customer/models/item.dart';

class ReadOnlyCartItemTile extends StatelessWidget {
  final Item item;
  final int quantity;

  const ReadOnlyCartItemTile({
    super.key,
    required this.item,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    double price = double.tryParse(item.offerPrice.replaceAll('₹', '').trim()) ?? 0;
    double totalPrice = price * quantity;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [BoxShadow(blurRadius: 0)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              item.imageUrls.isNotEmpty ? item.imageUrls[0].trim() : '',
              width: 50.0,
              height: 50.0,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 8.0),

          // Product Name and Net Qty
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4.0),
                Text(
                  item.netQty,
                  style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8.0),

          // Quantity Display (read-only)
          Container(
            width: 40,
            alignment: Alignment.center,
            child: Text(
              'x$quantity',
              style: const TextStyle(fontSize: 16.0),
            ),
          ),

          // Price
          Container(
            width: 60,
            alignment: Alignment.centerRight,
            child: Text(
              '₹${totalPrice.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
