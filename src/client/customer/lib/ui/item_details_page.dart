import 'package:flutter/material.dart';
import 'package:customer/models/item.dart';


class ItemDetailPage extends StatelessWidget {
  final Item item;
  const ItemDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset(item.imageUrls[0]),
            const SizedBox(height: 20),
            Text(item.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(item.netQty),
            Text('₹${item.offerPrice} (₹${item.mrp})'),
            Text('₹${item.discount} OFF'),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.green),
                Text('${4.6} (${450} ratings)'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
