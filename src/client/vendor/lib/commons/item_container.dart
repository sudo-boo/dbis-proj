// lib/ui/item_container.dart
import 'package:flutter/material.dart';
import 'package:vendor/models/item.dart';
import 'package:vendor/ui/vendor_item_detail_page.dart';

class VendorItemCard extends StatelessWidget {
  final Item item;
  const VendorItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final double imageSize = MediaQuery.of(context).size.width / 2.3;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VendorItemDetailPage(item: item),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                width: imageSize,
                height: imageSize,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.lightGreen.shade100, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    item.imageUrls.first,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (item.stockQty > 0)
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.pinkAccent,
                      // border: Border.all(color: Colors.lightGreen.shade100, width: 1),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      item.stockQty.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: imageSize,
            child: Text(
              item.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          SizedBox(
            width: imageSize,
            child: Text(
              item.netQty,
              style: const TextStyle(color: Colors.grey),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
