import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:customer/models/item.dart';
import 'package:customer/ui/item_details_page.dart';
import '../apis/cart.dart';

class ItemCard extends StatefulWidget {
  final Item item;
  final double x;

  const ItemCard({super.key, required this.item, required this.x});

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  Timer? _debounce;

  void _debouncedAddToCart(String productId, int quantity, int previousQuantity) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (previousQuantity == 0 && quantity > 0) {
        await addToCart(productId: productId, quantity: quantity);
      } else {
        await updateCart(productId: productId, quantity: quantity);
      }
    });
  }



  void increment() {
    if (widget.item.cartQuantity < widget.item.inStock) {
      final previousQuantity = widget.item.cartQuantity;
      setState(() {
        widget.item.cartQuantity++;
      });
      _debouncedAddToCart(
        widget.item.productId.toString(),
        widget.item.cartQuantity,
        previousQuantity,
      );
    }
  }

  void decrement() {
    if (widget.item.cartQuantity > 0) {
      final previousQuantity = widget.item.cartQuantity;
      setState(() {
        widget.item.cartQuantity--;
      });
      _debouncedAddToCart(
        widget.item.productId.toString(),
        widget.item.cartQuantity,
        previousQuantity,
      );
    }
  }


  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final item = widget.item;
    final x = widget.x;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ItemDetailPage(item: item)),
        );
      },
      child: Container(
        width: screenWidth * x,
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 28),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        children: [
                          AspectRatio(
                            aspectRatio: 1,
                            child: Opacity(
                              opacity: item.inStock != 0 ? 1.0 : 0.5,
                              child: CachedNetworkImage(
                                imageUrl: item.imageUrls[0].trim(),
                                imageBuilder: (context, imageProvider) => Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) => const SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              ),
                            ),
                          ),
                          if (item.inStock == 0)
                            Positioned.fill(
                              child: Container(
                                alignment: Alignment.center,
                                color: Colors.black.withOpacity(0.3),
                                child: const Text(
                                  'SOLD OUT',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: item.inStock != 0 ? Colors.yellow.shade500 : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.black),
                        ),
                        child: Row(
                          children: [
                            Text(
                              "₹ ${item.offerPrice}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "₹ ${item.mrp}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (item.discount.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "${item.discount}% off",
                            style: const TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {},
                    child: SizedBox(
                      width: 80,
                      height: 32,
                      child: item.inStock != 0
                          ? (item.cartQuantity == 0
                          ? ElevatedButton(
                        onPressed: () {
                          final previousQuantity = item.cartQuantity;
                          setState(() {
                            item.cartQuantity = 1;
                          });
                          _debouncedAddToCart(
                            item.productId.toString(),
                            item.cartQuantity,
                            previousQuantity,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.green,
                          side: const BorderSide(color: Colors.green),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.zero,
                          textStyle: const TextStyle(fontSize: 12),
                        ),
                        child: const Text('ADD'),
                      )
                          : Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (item.cartQuantity == 1) {
                                  final previousQuantity = item.cartQuantity;
                                  setState(() {
                                    item.cartQuantity = 0;
                                  });
                                  _debouncedAddToCart(
                                    item.productId.toString(),
                                    item.cartQuantity,
                                    previousQuantity,
                                  );

                                } else {
                                  decrement();
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                child: Icon(Icons.remove, color: Colors.white, size: 14),
                              ),
                            ),
                            Text(
                              '${item.cartQuantity}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (item.cartQuantity < item.inStock) {
                                  increment();
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                child: Icon(Icons.add, color: Colors.white, size: 14),
                              ),
                            ),
                          ],
                        ),
                      ))
                          : ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            item.toNotify = !item.toNotify;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.green,
                          side: const BorderSide(color: Colors.green),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          textStyle: const TextStyle(fontSize: 14),
                        ),
                        icon: Icon(
                          item.toNotify ? Icons.notifications_off : Icons.notifications,
                          size: 16,
                        ),
                        label: Text(item.toNotify ? 'Turn off' : 'Notify'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(item.netQty, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            Text(
              item.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.star, color: Colors.green, size: 14),
                      Text('4.6 (450)', style: TextStyle(fontSize: 10)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
