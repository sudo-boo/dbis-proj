import 'package:flutter/material.dart';
import 'package:customer/data/repository/demo_data_loader.dart';
import 'package:customer/models/item.dart';
import 'package:customer/ui/item_details_page.dart';

class ItemCard extends StatefulWidget {
  final Item item;
  final double x;
  const ItemCard({super.key, required this.item, required this.x});

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  int quantity = 0;
  bool notifyOn = false;

  void increment() {
    if (quantity < 9) {
      setState(() {
        quantity++;
      });
    }
  }

  void decrement() {
    if (quantity > 0) {
      setState(() {
        quantity--;
      });
    }
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
                              opacity: item.inStock ? 1.0 : 0.5,
                              child: Image.network(
                                item.imageUrls[0],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image),
                              ),
                            ),
                          ),
                          if (!item.inStock)
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
                          color: item.inStock ? Colors.yellow.shade500 : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.black),
                        ),
                        child: Row(
                          children: [
                            Text(
                              item.offerPrice,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              item.mrp,
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
                            item.discount,
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
                    behavior: HitTestBehavior.translucent, // Important
                    onTap: () {}, // Prevent tap from propagating
                      child: SizedBox(
                        width: 80,
                        height: 32,
                        child: item.inStock
                            ? (quantity == 0
                            ? ElevatedButton(
                          onPressed: () {
                            setState(() {
                              quantity = 1;
                            });
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () {
                                  if (quantity == 1) {
                                    setState(() {
                                      quantity = 0;
                                    });
                                  } else {
                                    decrement();
                                  }
                                },
                                child: const Icon(Icons.remove, color: Colors.white, size: 16),
                              ),
                              Text(
                                '$quantity',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (quantity < 9) {
                                    increment();
                                  }
                                },
                                child: const Icon(Icons.add, color: Colors.white, size: 16),
                              ),
                            ],
                          ),
                        ))
                            : ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              notifyOn = !notifyOn;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.green,
                            side: const BorderSide(color: Colors.green),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            textStyle: const TextStyle(fontSize: 14),
                          ),
                          icon: Icon(
                            notifyOn ? Icons.notifications_off : Icons.notifications,
                            size: 16,
                          ),
                          label: Text(notifyOn ? 'Turn off' : 'Notify'),
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
                      SizedBox(width: 2),
                      Text('4.6 (450)', style: TextStyle(fontSize: 10)),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
