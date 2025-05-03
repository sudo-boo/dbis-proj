import 'package:flutter/material.dart';
import 'package:customer/models/item.dart';
import 'package:customer/commons/item_container.dart';
import 'package:customer/data/repository/demo_data_loader.dart';

class ItemInColumns extends StatefulWidget {
  final String category;

  const ItemInColumns({super.key, required this.category});

  @override
  State<ItemInColumns> createState() => _ItemInColumnsState();
}

class _ItemInColumnsState extends State<ItemInColumns> {
  final ScrollController _scrollController = ScrollController();
  final List<Item> _items = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _page = 0;
  final int _itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _loadMoreItems();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && !_isLoading && _hasMore) {
        _loadMoreItems();
      }
    });
  }

  Future<void> _loadMoreItems() async {
    setState(() => _isLoading = true);

    final loader = DataLoader();
    final allItems = await loader.getItemsWithCategory(widget.category);

    final nextItems = allItems.skip(_page * _itemsPerPage).take(_itemsPerPage).toList();

    setState(() {
      _items.addAll(nextItems);
      _isLoading = false;
      _page++;
      if (nextItems.length < _itemsPerPage) _hasMore = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _items.isEmpty && _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.only(bottom: 12), // Avoid bottom overflow
        child: GridView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.63, // Adjusted to give more height room
            crossAxisSpacing: 10,
            mainAxisSpacing: 16, // More vertical spacing
          ),
          itemCount: _items.length + (_hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < _items.length) {
              return ItemCard(item: _items[index], x: 0.5);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
