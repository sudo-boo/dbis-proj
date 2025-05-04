import 'package:flutter/material.dart';
import 'package:customer/data/repository/local_storage_manager.dart';
import 'package:customer/commons/item_in_rows.dart';

import '../apis/get_products.dart';
import '../models/category.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Category> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _populateCategories();
  }

  Future<void> _populateCategories() async {
    try {
      print("call function start");

      String? token = await getUserToken();
      String? userId = await getUserId();

      if (token == null || userId == null) {
        print("Token or User ID is null");
        return;
      }

      print("Token: $token");
      print("User ID: $userId");

      final fetchedCategories = await getCategories(token: token);
      setState(() {
        categories = fetchedCategories;
        isLoading = false;
      });
      print("Categories fetched: ${categories.length}");
      for (var category in categories) {
        print('Category ID: ${category.categoryId}, Name: ${category.name}');
      }

      // Example: Fetch products for the first category
      if (categories.isNotEmpty) {
        String categoryId = categories[1].categoryId.toString();
        String categoryName = categories[1].name.toString();
        String requestQuantity = '10';
        String batchNo = '1';

        await getProductsByCategory(
          token: token,
          categoryId: categoryId,
          categoryName: categoryName,
          requestQuantity: requestQuantity,
          batchNo: batchNo,
          userId: userId,
        );
      }
    } catch (e) {
      print("Error while calling APIs: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: categories
              .map((category) => ItemInRows(
            category: category.categoryId.toString(),
            categoryName: category.name,
            displayCategoryTitle: true,
          ))
              .toList(),
        ),
      ),
    );
  }
}
