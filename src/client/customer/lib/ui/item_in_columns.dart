import 'package:flutter/material.dart';
import 'package:customer/models/item.dart';
import 'package:customer/commons/item_container.dart';
import 'package:customer/apis/get_products.dart';
import 'package:customer/data/repository/local_storage_manager.dart';

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
        categoryName: widget.category,
        requestQuantity: _itemsPerPage.toString(),
        batchNo: (_page + 1).toString(),
        userId: userId,
      );

      setState(() {
        _items.addAll(items);
        _isLoading = false;
        _page++;
        if (items.length < _itemsPerPage) _hasMore = false;
      });
    } catch (e) {
      print("Error fetching items: $e");
      setState(() => _isLoading = false);
    }
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
        padding: const EdgeInsets.only(bottom: 12),
        child: GridView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.63,
            crossAxisSpacing: 10,
            mainAxisSpacing: 16,
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
