import 'dart:async';
import 'package:flutter/material.dart';
import 'package:customer/models/item.dart';
import 'package:customer/apis/cart.dart'; // Make sure this contains updateCart()

class CartItemTile extends StatefulWidget {
  final Item item;

  const CartItemTile({super.key, required this.item});

  @override
  State<CartItemTile> createState() => _CartItemTileState();
}

class _CartItemTileState extends State<CartItemTile> {
  int quantity = 1;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    quantity = widget.item.cartQuantity > 0 ? widget.item.cartQuantity : 1;
  }

  void _onQuantityChanged(int newQty) {
    setState(() {
      quantity = newQty;
    });

    // Cancel any existing timer
    _debounce?.cancel();

    // Set a new timer to debounce API call
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      try {
        await updateCart(
          productId: widget.item.productId.toString(),
          quantity: quantity,
        );
      } catch (e) {
        print('Failed to update cart: $e');
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double price = double.tryParse(widget.item.offerPrice.replaceAll('₹', '').trim()) ?? 0;
    double totalPrice = price * quantity;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [BoxShadow(blurRadius: 0)],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  widget.item.imageUrls.isNotEmpty ? widget.item.imageUrls[0].trim() : '',
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
                      widget.item.name,
                      style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      widget.item.netQty,
                      style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8.0),

              // Quantity Controller
              Container(
                width: 120.00,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, size: 20),
                      onPressed: quantity > 1
                          ? () => _onQuantityChanged(quantity - 1)
                          : null,
                    ),
                    Text('$quantity', style: const TextStyle(fontSize: 16.0)),
                    IconButton(
                      icon: const Icon(Icons.add, size: 20),
                      onPressed: () => _onQuantityChanged(quantity + 1),
                    ),
                  ],
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
          );
        },
      ),
    );
  }
}
