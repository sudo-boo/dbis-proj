import 'package:customer/data/repository/local_storage_manager.dart';
import 'package:flutter/material.dart';
import 'package:customer/commons/item_in_rows.dart';

import '../apis/get_products.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> categories = const [
    "Fruits & Vegetables",
    "Cooking Essentials",
    "Munchies",
    "Dairy, Bread & Batter",
    "Beverages",
    "Packaged Food",
    "Ice Cream & Desserts",
    "Chocolates & Candies",
    "Meats, Fish & Eggs",
    "Biscuits",
    "Personal Care",
    "Paan Corner",
    "Home & Cleaning",
    "Health & Hygiene",
    "Curated For You"
  ];

  @override
  void initState() {
    super.initState();
    _callTheAPIs();
  }

  void _callTheAPIs() async {
    print("call function start");

    // Await the token and userId retrieval
    String? token = await getUserToken();
    String? userId = await getUserId();

    if (token == null || userId == null) {
      print("Token or User ID is null");
      return;
    }

    print("Token: $token");
    print("User ID: $userId");

    await getCategories(token: token);
    print("Categories fetched");

    String categoryId = '1';
    String requestQuantity = '10';
    String batchNo = '1';

    await getProductsByCategory(
      token: token,
      categoryId: categoryId,
      requestQuantity: requestQuantity,
      batchNo: batchNo,
      userId: userId,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: categories
              .map((category) => ItemInRows(
            category: category,
            displayCategoryTitle: true,
          ))
              .toList(),
        ),
      ),
    );
  }
}
