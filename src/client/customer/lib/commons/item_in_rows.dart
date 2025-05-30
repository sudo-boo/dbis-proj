import 'package:customer/commons/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:customer/models/item.dart';
import 'package:customer/commons/item_container.dart';
import 'package:customer/ui/item_in_columns.dart';

import '../apis/get_products.dart';
import '../data/repository/local_storage_manager.dart';

class ItemInRows extends StatefulWidget {
  final String category;
  final String categoryName;
  final bool displayCategoryTitle;

  const ItemInRows({
    super.key,
    required this.category,
    required this.categoryName,
    required this.displayCategoryTitle,
  });

  @override
  State<ItemInRows> createState() => _ItemInRowsState();
}

class _ItemInRowsState extends State<ItemInRows> {
  List<Item> _items = [];
  int _minOfferPrice = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  // Loads items based on the category
  Future<void> _loadItems() async {
    try {
      final token = await getUserToken();
      final userId = await getUserId();

      if (token == null || userId == null) {
        print("Token or User ID is null");
        setState(() => _isLoading = false);
        return;
      }

      final items = await getProductsByCategory(
        token: token,
        categoryId: widget.category,
        categoryName: widget.categoryName,
        requestQuantity: '10',
        batchNo: '1',
        userId: userId,
      );

      final validPrices = items
          .map((item) => item.offerPrice)
          .where((price) => price.isNotEmpty)
          .map((price) => int.tryParse(price.replaceAll(RegExp(r'[^\d]'), '')))
          .where((price) => price != null)
          .cast<int>()
          .toList();

      setState(() {
        _items = items;
        _minOfferPrice = validPrices.isNotEmpty ? validPrices.reduce((a, b) => a < b ? a : b) : 0;
        _isLoading = false;
      });
    } catch (e) {
      print("Failed to load items: $e");
      setState(() => _isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        height: 250,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Category title and "See All" button
          if (widget.displayCategoryTitle) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.categoryName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  Text(
                    'See All',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ItemInColumns(category: widget.category),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Displaying the minimum offer price
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
              child: Text(
                'Starting at just ₹$_minOfferPrice/Kg',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ),
          ],

          SizedBox(
            height: screenHeight(context) * 0.3,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _items.length,
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: ItemCard(item: _items[index], x: 0.35),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
