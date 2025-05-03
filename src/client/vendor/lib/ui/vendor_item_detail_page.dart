import 'dart:io';
import 'package:flutter/material.dart';
import 'package:vendor/models/item.dart';
import 'image_picker.dart';  // import your wrapper

class VendorItemDetailPage extends StatefulWidget {
  final Item? item;
  const VendorItemDetailPage({super.key, this.item});

  @override
  _VendorItemDetailPageState createState() => _VendorItemDetailPageState();
}

class _VendorItemDetailPageState extends State<VendorItemDetailPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController categoryController;
  late TextEditingController mrpController;
  late TextEditingController netQtyController;
  final TextEditingController stockQtyController = TextEditingController();

  List<MapEntry<TextEditingController, TextEditingController>> highlights = [];
  List<MapEntry<TextEditingController, TextEditingController>> infos = [];

  List<String> imagePaths = [];
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    nameController = TextEditingController(text: item?.name ?? '');
    categoryController = TextEditingController(text: item?.category ?? '');
    mrpController = TextEditingController(text: item?.mrp ?? '');
    netQtyController = TextEditingController(text: item?.netQty ?? '');

    if (item?.imageUrls != null) {
      imagePaths = List<String>.from(item!.imageUrls);
    }

    if (item?.productHighlights != null) {
      item!.productHighlights.forEach((k, v) {
        highlights.add(MapEntry(TextEditingController(text: k), TextEditingController(text: v)));
      });
    }
    if (highlights.isEmpty) {
      highlights.add(MapEntry(TextEditingController(), TextEditingController()));
    }

    if (item?.productInformation != null) {
      item!.productInformation.forEach((k, v) {
        infos.add(MapEntry(TextEditingController(text: k), TextEditingController(text: v)));
      });
    }
    if (infos.isEmpty) {
      infos.add(MapEntry(TextEditingController(), TextEditingController()));
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    categoryController.dispose();
    mrpController.dispose();
    netQtyController.dispose();
    stockQtyController.dispose();
    _pageController.dispose();
    for (var e in highlights) {
      e.key.dispose();
      e.value.dispose();
    }
    for (var e in infos) {
      e.key.dispose();
      e.value.dispose();
    }
    super.dispose();
  }

  Future<void> pickImages() async {
    final pickedFiles = await AppImagePicker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        imagePaths.addAll(pickedFiles.map((f) => f.path));
      });
    }
  }

  void _saveItem() {
    int addedQty = int.tryParse(stockQtyController.text) ?? 0;
    int newStockQty = (widget.item?.stockQty ?? 0) + addedQty;

    final updatedItem = Item(
      productId: widget.item?.productId ?? 0,
      name: nameController.text,
      category: categoryController.text,
      mrp: mrpController.text,
      netQty: netQtyController.text,
      imageUrls: imagePaths,
      stockQty: newStockQty,
      productHighlights: {
        for (var e in highlights)
          if (e.key.text.isNotEmpty && e.value.text.isNotEmpty)
            e.key.text: e.value.text,
      },
      productInformation: {
        for (var e in infos)
          if (e.key.text.isNotEmpty && e.value.text.isNotEmpty)
            e.key.text: e.value.text,
      },
    );

    stockQtyController.clear(); // Clear input field

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item saved successfully')),
    );

    Navigator.pop(context, updatedItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Add New Item' : 'Edit Item'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imagePaths.isNotEmpty) ...[
                SizedBox(
                  height: 300,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: imagePaths.length,
                    onPageChanged: (i) => setState(() => _currentImageIndex = i),
                    itemBuilder: (_, i) {
                      final path = imagePaths[i];
                      return path.startsWith('http')
                          ? Image.network(path, fit: BoxFit.cover)
                          : Image.file(File(path), fit: BoxFit.cover);
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    imagePaths.length,
                        (i) => Container(
                      margin: const EdgeInsets.all(4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentImageIndex == i ? Colors.blue : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
              Center(
                child: IconButton(
                  icon: const Icon(Icons.add_a_photo, size: 32),
                  onPressed: pickImages,
                ),
              ),

              const SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: mrpController,
                decoration: const InputDecoration(labelText: 'MRP'),
              ),
              TextFormField(
                controller: netQtyController,
                decoration: const InputDecoration(labelText: 'Net Quantity'),
              ),

              const SizedBox(height: 16),

              // Show Current Stock if editing an item
              if (widget.item != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Current Stock: ${widget.item!.stockQty}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),

              TextFormField(
                controller: stockQtyController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Add Stock Quantity',
                ),
              ),

              const SizedBox(height: 16),
              Text('Product Highlights', style: Theme.of(context).textTheme.titleMedium),
              ...highlights.map((entry) => Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: entry.key,
                      decoration: const InputDecoration(labelText: 'Key'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: entry.value,
                      decoration: const InputDecoration(labelText: 'Value'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () => setState(() => highlights.remove(entry)),
                  ),
                ],
              )),
              TextButton(
                onPressed: () => setState(() => highlights.add(MapEntry(TextEditingController(), TextEditingController()))),
                child: const Text('Add Highlight'),
              ),

              const SizedBox(height: 16),
              Text('Additional Info', style: Theme.of(context).textTheme.titleMedium),
              ...infos.map((entry) => Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: entry.key,
                      decoration: const InputDecoration(labelText: 'Key'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: entry.value,
                      decoration: const InputDecoration(labelText: 'Value'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () => setState(() => infos.remove(entry)),
                  ),
                ],
              )),
              TextButton(
                onPressed: () => setState(() => infos.add(MapEntry(TextEditingController(), TextEditingController()))),
                child: const Text('Add Info Field'),
              ),

              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _saveItem,
                  child: const Text('Save Item'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
