import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:vendor/models/item.dart';

class DataLoader {
  // A function to load demo data from a JSON string (or a local file)
  Future<List<Item>> loadDemoData() async {
    // Hardcoded JSON data as a string (for testing purposes)
    String jsonData = '''[
      {
        "product_id": 208,
        "category": "Cooking Essentials",
        "image_urls": [
          "https://cdn.zeptonow.com/production/ik-seo/tr:w-1280,ar-1500-1500,pr-true,f-auto,q-80/inventory/product/4e319b22-4fdf-40fe-b374-604bd29d8187-3065/Saffola-Soya-Chunks-Mealmaker-200-g-Combo.jpg",
          "https://cdn.zeptonow.com/production/ik-seo/tr:w-1210,ar-1210-700,pr-true,f-auto,q-80/inventory/IMAGE/c55e1c9f-8d21-4153-bf29-46892d57c616-Screenshot_2022-08-26_at_15.35.02/Saffola-Soya-Chunks-Mealmaker-200-g-Combo.png"
        ],
        "product_highlights": {
          "Brand": "Saffola",
          "Weight": "200 g x 2"
        },
        "product_information": {
          "Disclaimer": "All images are for representational purposes only. It is advised that you read the batch and manufacturing details, directions for use, allergen information, health and nutritional claims (wherever applicable), and other details mentioned on the label before consuming the product. For combo items, individual prices can be viewed on the page.",
          "Customer Care Details": "In case of any issue, contact us E-mail address: support@zeptonow.com",
          "Seller Name": "Geddit Convenience Private Limited",
          "Seller Address": "Geddit Convenience Private Limited, Unit 803, Lodha Supremus, Saki Vihar Road, Opp MTNL, Office, Powai, Mumbai, Maharashtra, India,400072 For Support ReachOut : support+geddit@zeptonow.com",
          "Seller License No.": "11521998000248"
        },
        "offer_price": "\u20b9114",
        "discount": "5% Off",
        "name": "Saffola Soya Chunks Mealmaker 200 g Combo",
        "net_qty": "200 g X 2",
        "mrp": "\u20b9120",
        "stock_qty": 10
      },
      {
        "product_id": 209,
        "category": "Cooking Essentials",
        "image_urls": [
          "https://cdn.zeptonow.com/production/ik-seo/tr:w-1280,ar-1500-1500,pr-true,f-auto,q-80/cms/product_variant/164c050c-469a-4b3d-bd43-3070593340c06665/24-Mantra-Bura-Brown-Sugar-Demerara-500-g-Combo.jpg",
          "https://cdn.zeptonow.com/production/ik-seo/tr:w-1210,ar-1210-700,pr-true,f-auto,q-80/inventory/IMAGE/c55e1c9f-8d21-4153-bf29-46892d57c616-Screenshot_2022-08-26_at_15.35.02/24-Mantra-Bura-Brown-Sugar-Demerara-500-g-Combo.png"
        ],
        "product_highlights": {
          "Brand": "24 Mantra",
          "Weight": "500 g x 2"
        },
        "product_information": {
          "Disclaimer": "All images are for representational purposes only. It is advised that you read the batch and manufacturing details, directions for use, allergen information, health and nutritional claims (wherever applicable), and other details mentioned on the label before consuming the product. For combo items, individual prices can be viewed on the page.",
          "Customer Care Details": "In case of any issue, contact us E-mail address: support@zeptonow.com",
          "Seller Name": "Drogheria Sellers Private Limited",
          "Seller Address": "Brigade IRV, 9th & 10th Floors, Nallurhalli, White Field, Bangalore, Banglore, Karnataka, India, 560066 For Support ReachOut : support+drogheria@zeptonow.com",
          "Seller License No.": "11522998001570"
        },
        "offer_price": "\u20b9148",
        "discount": "12% Off",
        "name": "24 Mantra Bura (Brown )Sugar Demerara 500 g Combo",
        "net_qty": "500 g X 2",
        "mrp": "\u20b9170"
      },
      {
        "product_id": 210,
        "category": "Cooking Essentials",
        "image_urls": [
          "https://cdn.zeptonow.com/production/ik-seo/tr:w-1000,ar-1000-1000,pr-true,f-auto,q-80/cms/product_variant/1f58c686-4c74-4883-813c-0fd5c541918d/Popular-Essentials-Green-Cardamom-Elaichi.jpeg",
          "https://cdn.zeptonow.com/production/ik-seo/tr:w-1090,ar-1090-1598,pr-true,f-auto,q-80/inventory/product/43beb905-4354-450d-8b91-dbec13c92045-1-Uoqol8xPSLGvs-UmLHX97Psgpj5NjIS/Popular-Essentials-Green-Cardamom-Elaichi.jpeg",
          "https://cdn.zeptonow.com/production/ik-seo/tr:w-700,ar-700-700,pr-true,f-auto,q-80/inventory/product/43beb905-4354-450d-8b91-dbec13c92045-1hK8-2-IT_-NSZ2cFqvPW4LXHV7ERp_Is/Popular-Essentials-Green-Cardamom-Elaichi.jpeg",
          "https://cdn.zeptonow.com/production/ik-seo/tr:w-1210,ar-1210-700,pr-true,f-auto,q-80/inventory/IMAGE/c55e1c9f-8d21-4153-bf29-46892d57c616-Screenshot_2022-08-26_at_15.35.02/Popular-Essentials-Green-Cardamom-Elaichi.png"
        ],
        "product_highlights": {
          "Is Perishable": "No",
          "Organic": "No",
          "Added Preservatives": "No Preservative Added",
          "Brand": "POPULAR ESSENTIALS",
          "Dietary Preference": "Veg",
          "Health Benefits": "Antioxidant properties, aids digestion, good source of minerals and vitamins",
          "Ingredients": "Cardamom",
          "Item Form": "Whole",
          "Key Features": "Premium grade Green Cardamom, adds delightful taste to dishes, distinct aroma and exotic flavor, known for antioxidant properties",
          "Material Type Free": "Preservative-free",
          "Nutrition Information": "Energy (kcal) 362.1, Protein (g) 10.5, Carbohydrates (g) 69.6, Iron (mg) 5.2, Calcium (mg) 392.4, Total Dietary Fibre (g) 28.0, Added Sugar (g) 0.0, Total Fat (g) 6.7, Saturated Fatty Acids (g) 1.6, Trans Fatty Acids (g) 0.0, Monounsaturated Fatty Acids - MUFA (g) 1.87, Polyunsaturated Fatty Acids - PUFA (g) 1.07, Cholesterol (mg) 0.0, Sodium (mg) 189.9",
          "Packaging Type": "Pouch",
          "Product Type": "Cardamom",
          "Storage Instruction": "After opening the pack, transfer the contents to an airtight container. Store in a cool and dry place. Keep away from direct sunlight",
          "Unit": "1 pack",
          "Weight": "50 g",
          "Allergen Information": "May contain: Dairy, Dry Fruits, Nuts, and Soy"
        },
        "product_information": {
          "Disclaimer": "All images are for representational purposes only. It is advised that you read the batch and manufacturing details, directions for use, allergen information, health and nutritional claims (wherever applicable), and other details mentioned on the label before consuming the product. For combo items, individual prices can be viewed on the page.",
          "Customer Care Details": "In case of any issue, contact us E-mail address: support@zeptonow.com",
          "Seller Name": "Commodum Groceries Private Limited",
          "Seller Address": "COMMODUM GROCERIES PRIVATE LIMITED, Regd. Office: 44, Saket Building, Mullick Bazaar, Park Street, Kolkata, West Bengal, India, 700016. For Support ReachOut : support+commodum@zeptonow.com",
          "Seller License No.": "12822999000310",
          "Manufacturer Name": "Popular Essentials Inc",
          "Manufacturer Address": "Popular Essentials Inc, No.60/1, 2nd Stage, Industrial Suburb, Yeshwanthpur, Bangalore-560022.",
          "Country Of Origin": "India",
          "Shelf Life": "6 months"
        },
        "offer_price": "\u20b9340",
        "discount": null,
        "name": "Popular Essentials Green Cardamom | Elaichi",
        "net_qty": "50 g",
        "mrp": null
      }
    ]''';

    // Parse the JSON data
    List<dynamic> dataList = jsonDecode(jsonData);

    // Convert each map to an Item object and return as a list
    return dataList.map<Item>((json) => Item.fromJson(json)).toList();
  }

  // Function to get a single item based on product_id
  Future<Item?> getSingleItem(int productId) async {
    List<Item> allItems = await loadDemoData();
    return allItems.firstWhere((item) => item.productId == productId);
  }

  Future<List<Item>> getItemsWithCategory(String category) async {
    List<Item> allItems = await loadDemoData();
    return allItems.where((item) => item.category == category).toList();
  }
}