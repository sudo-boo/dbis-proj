import 'package:cached_network_image/cached_network_image.dart';
import 'package:customer/ui/cart_page.dart';
import 'package:customer/commons/item_in_rows.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:customer/models/item.dart';

import '../apis/cart.dart';

class ItemDetailPage extends StatefulWidget {
  final Item item;
  const ItemDetailPage({super.key, required this.item});

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  late PageController _pageController;
  bool showAllHighlights = false;
  bool showAllInfo = false;
  final ScrollController _scrollController = ScrollController();
  bool _showNavbar = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _scrollController.addListener(() {
      if (_scrollController.offset > 0 && !_showNavbar) {
        setState(() => _showNavbar = true);
      } else if (_scrollController.offset <= 0 && _showNavbar) {
        setState(() => _showNavbar = false);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  @override
  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Scaffold(
      body: Stack(
        children: [
          // Main scrollable content
          SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.only(bottom: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40), // Top safe space
                // 🔼 Image carousel
                SizedBox(
                  height: 300,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: item.imageUrls.length,
                    itemBuilder: (context, index) {
                      // return Image.network(item.imageUrls[index], fit: BoxFit.cover);
                      return CachedNetworkImage(
                        imageUrl: item.imageUrls[index].trim(),
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) => SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator()
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: item.imageUrls.length,
                    effect: const WormEffect(dotHeight: 8, dotWidth: 8, activeDotColor: Colors.black),
                  ),
                ),

                const SizedBox(height: 16),
                _buildItemInfoCard(item),
                const SizedBox(height: 16),
                _buildExpandableSection(
                  title: "Highlights",
                  data: item.productHighlights,
                  isExpanded: showAllHighlights,
                  onToggle: () => setState(() => showAllHighlights = !showAllHighlights),
                ),
                const SizedBox(height: 16),
                _buildExpandableSection(
                  title: "Information",
                  data: item.productInformation,
                  isExpanded: showAllInfo,
                  onToggle: () => setState(() => showAllInfo = !showAllInfo),
                ),
                const SizedBox(height: 16),
                // ItemInRows(category: item.category, displayCategoryTitle: true),
                const SizedBox(height: 100),
              ],
            ),
          ),

          // 🔘 Floating transparent back button
          Positioned(
            top: 40,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
              child: FloatingActionButton.small(
                backgroundColor: Colors.transparent,
                elevation: 0,
                onPressed: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
          ),

          // 🔼 AppBar shown only on scroll
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            top: _showNavbar ? 0 : -80,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _showNavbar ? 1.0 : 0.0,
              child: Container(
                height: 100,
                padding: const EdgeInsets.only(top: 40, left: 16),
                color: Colors.white,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis, // <-- Prevent overflow
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // Bottom CTA
      bottomSheet: Container(
        height: 60,
        width: double.infinity,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: !(item.inStock != 0)
            ? ElevatedButton(
          onPressed: () {
            setState(() {
              item.toNotify = !item.toNotify;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pinkAccent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(
            item.toNotify ? "Turn off notification" : "Notify me when available",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
            : item.cartQuantity == 0
            ? ElevatedButton(
          onPressed: () async {
            // Add item to cart when cartQuantity is 0
            await addToCart(productId: item.productId.toString(), quantity: 1);

            // Update the cart quantity after adding the item
            setState(() {
              item.cartQuantity = 1;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pinkAccent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text(
            "Add to cart",
            style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 🛒 Cart Button
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 34),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CartPage()),
                  );
                },
                icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
                label: const Text("Cart", style: TextStyle(color: Colors.black)),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  foregroundColor: Colors.black,
                ),
              ),
            ),
            const SizedBox(width: 5),

            // ➖ item.cartQuantity Adjuster
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                color: Colors.pinkAccent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, size: 20, color: Colors.white),
                    onPressed: () async {
                      if (item.cartQuantity > 0) {
                        setState(() {
                          item.cartQuantity--;
                        });
                        await updateCart(
                          productId: item.productId.toString(),
                          quantity: item.cartQuantity,
                        );
                      }
                    },
                  ),
                  Text(
                    "${item.cartQuantity}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, size: 20, color: Colors.white),
                    onPressed: () async {
                      if (item.cartQuantity == 0) {
                        // Add item to cart first
                        await addToCart(productId: item.productId.toString(), quantity: 1); // Add 1 item initially
                        setState(() {
                          item.cartQuantity = 1;
                        });
                      } else if (item.cartQuantity < item.inStock) {
                        // Otherwise, just update cart quantity
                        setState(() {
                          item.cartQuantity++;
                        });
                        await updateCart(
                          productId: item.productId.toString(),
                          quantity: item.cartQuantity,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemInfoCard(Item item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(item.netQty, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.green, size: 16),
              const SizedBox(width: 4),
              const Text('4.5 (16.4k)', style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children:[
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 3), // Outer border
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Offer Price Container
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                      ),
                      child: Text(
                        "₹ ${item.offerPrice}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    // Vertical Divider (Thick black border)
                    if (item.mrp.isNotEmpty) Container(
                      width: 2,
                      height: 30,
                      color: Colors.black,
                    ),
                    // MRP Container
                    if (item.mrp.isNotEmpty) Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.yellow.shade700,
                      ),
                      child: Text(
                        "₹ ${item.mrp}",
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.bolt, color: Colors.green),
              const SizedBox(width: 6),
              Text('Estimated Delivery Time: 11 mins', style: TextStyle(color: Colors.green.shade700)),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Save ₹50 with Zepto ", style: TextStyle(color: Colors.white)),
                Text("SUPER SAVER", style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

 Widget _buildExpandableSection({
    required String title,
    required Map<String, dynamic> data,
    required bool isExpanded,
    required VoidCallback onToggle,
  }) {
    final entries = data.entries.toList();
    final visibleEntries = isExpanded ? entries : entries.take(2).toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...visibleEntries.map((entry) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    entry.key,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 3,
                  child: Text(
                    "${entry.value}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          )),
          if (entries.length > 2)
            Center(
              child: TextButton.icon(
                onPressed: onToggle,
                icon: Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: Colors.black,
                ),
                label: Text(
                  isExpanded ? "View less" : "View more",
                  style: const TextStyle(color: Colors.pinkAccent),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
