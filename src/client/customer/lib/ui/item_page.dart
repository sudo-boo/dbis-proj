import 'package:customer/data/repository/demo_data_loader.dart';
import 'package:customer/commons/item_container.dart';
import 'package:flutter/material.dart';

import '../models/item.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({super.key});

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  late Future<List<Item>> itemsFuture;

  @override
  void initState() {
    super.initState();
    itemsFuture = loadItems();
  }

  Future<List<Item>> loadItems() async {
    final loader = DataLoader();
    final item1 = await loader.getSingleItem(208);
    final item2 = await loader.getSingleItem(209);
    final item3 = await loader.getSingleItem(210);

    // Filter out nulls in case any fetch fails
    return [item1, item2, item3].whereType<Item>().toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Items")),
      body: FutureBuilder<List<Item>>(
        future: itemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No items found'));
          } else {
            return SingleChildScrollView(
              child: Column(
                children: snapshot.data!
                    .map((item) => ItemCard(item: item, x: 0.5))
                    .toList(),
              ),
            );
          }
        },
      ),
    );
  }
}
