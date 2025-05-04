import 'dart:async';
import 'package:customer/commons/item_in_rows.dart';
import 'package:customer/models/order.dart';
import 'package:customer/ui/order_confirmation.dart';
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
      body: isLoading
    ? const Center(child: CircularProgressIndicator())
    : cartItems.isEmpty
        ? const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Your cart is empty. Add some items to proceed!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          )
        : SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    decoration: BoxDecoration( 
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.timer_rounded, color: Colors.lightGreen, size: 40),
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
                          ...cartItems.map((item) => CartItemTile(item: item)),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {
                            // build your Order object here, e.g.:
                            final order = Order(
                              orderId: 1234,
                              vendorId: 42,
                              deliveryGuyId: 7,
                              vendorAddress: "123, Vendor Street",
                              customerAddress: "456, Customer Lane",
                              products: {}, // up to you
                              done: false,
                              expecteddeliveryTime: "In 12 mins",
                              timeOfDelivery: "",
                              orderAssigned: true,
                              orderDelivered: false,
                            );
                            Navigator.pushNamed(
                              context,
                              OrderConfirmationPage.routeName,
                              arguments: OrderConfirmationArguments(
                                order: order,
                                items: cartItems,
                              ),
                            );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.green,
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(color: Colors.green, width: 2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text("Proceed to Checkout", style: TextStyle(fontSize: 18)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "You might also like",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                              ),
                              SizedBox(width: 10),
                              Icon(Icons.stars_rounded, color: Colors.pinkAccent, size: 40),
                            ],
                          ),
                          SizedBox(height: 12),
                          // ItemInRows(category: "Cooking Essentials", displayCategoryTitle: false),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
