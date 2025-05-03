// // home_page.dart
//
// import 'package:flutter/material.dart';
// import 'package:customer/data/repository/demo_data_loader.dart';
// import 'package:customer/models/item.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//
//   // Function to print demo data
//   void _printDemoData() async {
//     try {
//       // // Load demo data
//       // List<Item> demoData = await dataLoader.loadDemoData();
//       //
//       // // Print the demo data to the console
//       // for (var item in demoData) {
//       //   print('Product Name: ${item.name}');
//       //   print('Price: ₹${item.mrp}');
//       //   print('Discount: ${item.discount}%');
//       //   print('Images: ${item.imageUrls?.join(', ')}');
//       //   print('-----------------------------');
//       // }
//       DataLoader dataLoader = DataLoader();
//
//       // Get item with product_id 208
//       Item? item = await dataLoader.getSingleItem(208);
//
//       if (item != null) {
//         print("Item found: ${item.name}");
//       } else {
//         print("Item not found");
//       }
//     } catch (e) {
//       // Handle errors, e.g., data loading issues
//       print('Error loading demo data: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Home Page'),
//       ),
//       body: Center(
//         child: Container(
//           color: Colors.pinkAccent,
//           child: TextButton(
//             onPressed: _printDemoData,
//             child: const Icon(Icons.adb_rounded),
//           ),
//         ),
//       ),
//     );
//   }
// }


// home_page.dart

import 'package:flutter/material.dart';
import 'package:customer/commons/item_in_rows.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: categories
              .map((category) => ItemInRows(category: category, displayCategoryTitle: true,))
              .toList(),
        ),
      ),
    );
  }
}
