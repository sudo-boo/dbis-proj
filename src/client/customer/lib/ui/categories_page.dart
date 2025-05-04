import 'package:flutter/material.dart';
import 'package:customer/ui/item_in_columns.dart';

class CategoriesPage extends StatelessWidget {
  CategoriesPage({super.key});

  final Map<String, String> categoryImageUrls = {
    "Fruits & Vegetables": "https://cdn.zeptonow.com/production/tr:w-420,ar-486-333,pr-true,f-auto,q-80/cms/category/2b5f2be5-cada-4cd7-b0af-e46c0c065f71.png",
    "Cooking Essentials": "https://cdn.zeptonow.com/production/tr:w-210,ar-225-333,pr-true,f-auto,q-80/cms/category/c42610fc-a94c-40f6-9e74-d30c4a1f5895.png",
    "Munchies": "https://cdn.zeptonow.com/production/tr:w-210,ar-225-333,pr-true,f-auto,q-80/cms/category/90b2faee-1461-465a-a8c6-8c84716dd7dc.png",
    "Dairy, Bread & Batter": "https://cdn.zeptonow.com/production/tr:w-210,ar-225-333,pr-true,f-auto,q-80/cms/category/474e6e58-1894-4378-86f1-168cc7266d1a.png",
    "Beverages": "https://cdn.zeptonow.com/production/tr:w-210,ar-225-333,pr-true,f-auto,q-80/cms/category/ab241d87-da5b-4830-b38f-1a6cd30d0d41.png",
    "Packaged Food": "https://cdn.zeptonow.com/production/tr:w-210,ar-225-333,pr-true,f-auto,q-80/cms/category/47b3a34d-8f9f-42fe-97a0-4d8350748924.png",
    "Ice Cream & Desserts": "https://cdn.zeptonow.com/production/tr:w-210,ar-225-334,pr-true,f-auto,q-80/cms/category/db346f5e-644f-426a-85af-92d707e086ac.png",
    "Chocolates & Candies": "https://cdn.zeptonow.com/production/tr:w-210,ar-300-444,pr-true,f-auto,q-80/cms/category/ec7b14c6-2640-4165-b3ae-68c09a249ae0.png",
    "Meats, Fish & Eggs": "https://cdn.zeptonow.com/production/tr:w-210,ar-225-333,pr-true,f-auto,q-80/cms/category/1237afd6-40bf-4942-a266-25f23025e86c.png",
    "Biscuits": "https://cdn.zeptonow.com/production/tr:w-210,ar-226-334,pr-true,f-auto,q-80/cms/category/9b88fff5-73f5-46fd-999f-1622db4203d7.png",
    "Personal Care": "https://cdn.zeptonow.com/production/tr:w-210,ar-225-333,pr-true,f-auto,q-80/cms/category/b1909dfd-726c-412b-beb7-9553bc909363.png",
    "Paan Corner": "https://cdn.zeptonow.com/production/tr:w-210,ar-225-333,pr-true,f-auto,q-80/cms/category/6d26710a-1dd8-4d53-9884-33bbaebc4bf4.png",
    "Home & Cleaning": "https://cdn.zeptonow.com/production/tr:w-210,ar-226-334,pr-true,f-auto,q-80/cms/category/b322b3db-e75e-45e5-a11d-7ee37561c426.png",
    "Health & Hygiene": "https://cdn.zeptonow.com/production/tr:w-210,ar-304-464,pr-true,f-auto,q-80/cms/category/bc5f6b57-fa3a-4a71-b498-7b8cb83323f9.png",
    "Curated For You": "",
  };

  @override
  Widget build(BuildContext context) {
    final entries = categoryImageUrls.entries.toList();

    return Scaffold(
      appBar: AppBar(title: const Text("All Categories")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double fullWidth = constraints.maxWidth;
              const double spacing = 12;
              final double cellWidth = (fullWidth - spacing * 2) / 3;
              final double firstWidth = cellWidth * 2 + spacing;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: List.generate(entries.length, (index) {
                  final category = entries[index].key;
                  final imageUrl = entries[index].value;
                  final bool isFirst = index == 0;
                  final bool isLast = index == entries.length - 1;
                  final double itemWidth =
                  isLast ? fullWidth : isFirst ? firstWidth : cellWidth;
                  final double? itemHeight = isLast ? 100 : null;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ItemInColumns(category: category),
                        ),
                      );
                    },
                    child: Container(
                      width: itemWidth,
                      height: itemHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(8),
                      child: imageUrl.isNotEmpty
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.contain,
                        ),
                      )
                          : Center(
                        child: Text(
                          category,
                          style: TextStyle(
                            fontSize: isLast ? 24 : 14,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ),
      ),
    );
  }
}
