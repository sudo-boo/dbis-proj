import 'package:flutter/material.dart';
import 'package:customer/models/item.dart';

class CartItemTile extends StatefulWidget {
  final Item item;

  const CartItemTile({super.key, required this.item});

  @override
  State<CartItemTile> createState() => _CartItemTileState();
}

class _CartItemTileState extends State<CartItemTile> {
  int quantity = 1; // Initial quantity set to 1

  @override
  Widget build(BuildContext context) {
    // Calculate the total price based on the quantity
    double price = double.tryParse(widget.item.offerPrice.replaceAll('₹', '').trim()) ?? 0;
    double totalPrice = price * quantity;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [
          BoxShadow(
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          // Image on the left
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              widget.item.imageUrls.isNotEmpty ? widget.item.imageUrls[0] : '',
              width: 50.0,
              height: 50.0,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 8.0),

          // Name of the product with two lines and net quantity below
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.item.name,
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2, // Allow two lines for the name
                  overflow: TextOverflow.ellipsis, // Ellipsis for overflow
                ),
                const SizedBox(height: 4.0), // Space between the name and net qty
                Text(
                  widget.item.netQty,
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // Quantity setter (- and + buttons)
          Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, size: 20),
                  onPressed: quantity > 1
                      ? () {
                    setState(() {
                      quantity--;
                    });
                  }
                      : null, // Disable the button if quantity is 1
                ),
                Text(
                  '$quantity',
                  style: const TextStyle(fontSize: 16.0),
                ),
                IconButton(
                  icon: const Icon(Icons.add, size: 20),
                  onPressed: () {
                    setState(() {
                      quantity++;
                    });
                  },
                ),
              ],
            ),
          ),

          // Price at the end
          Expanded(
            flex: 2,
            child: Text(
              '₹${totalPrice.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
              textAlign: TextAlign.end,
            ),
          ),
          // const SizedBox(width: 10.0)
        ],
      ),
    );
  }
}
