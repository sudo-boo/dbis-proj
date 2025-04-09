import 'dart:async';
import 'package:customer/ui/item_in_rows.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:customer/commons/cart_item_tile.dart';
import 'package:customer/models/item.dart';
import 'package:customer/data/repository/demo_data_loader.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Item> cartItems = []; // Store cart items
  bool isLoading = true; // Track loading state

  // Load the cart items when the page is initialized
  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  // Load demo data from DataLoader class
  Future<void> _loadCartItems() async {
    DataLoader dataLoader = DataLoader();
    List<Item> items = await dataLoader.loadDemoData();
    setState(() {
      cartItems = items; // Update the cart items with the loaded data
      isLoading = false; // Data is loaded, stop the loading indicator
    });
  }

  @override
  Widget build(BuildContext context) {
    int etaTime = 12; // Set estimated delivery time

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
      ),
      backgroundColor: CupertinoColors.extraLightBackgroundGray,
      body: isLoading // Show loading indicator while data is being loaded
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.timer_rounded,
                            color: Colors.lightGreen,
                            size: 40,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Delivery in $etaTime minutes",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Check if cart is empty and show a message if true
                      cartItems.isEmpty
                          ? Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          "Your cart is empty. Add some items to proceed!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      )
                          : Column(
                        children: [
                          // Render the cart items using CartItemTile
                          ...cartItems.map((item) => CartItemTile(item: item)),
                        ],
                      ),
                      Divider(
                        color: Colors.grey.shade400,
                        thickness: 1,
                        height: 20,
                        indent: 0,
                        endIndent: 0,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          "Add something else to the cart button",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),

                ),
              ),
            ),

            SizedBox(height: 12,),

            // Additional sections for price, payment options, etc.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "You might also like",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(
                            Icons.stars_rounded,
                            color: Colors.pinkAccent,
                            size: 40,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ItemInRows(category: "Cooking Essentials", displayCategoryTitle: false,)
                ]
              )

                ),
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
