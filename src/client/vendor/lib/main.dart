// // main.dart
//
// // import 'package:vendor/ui/cart_page.dart';
// import 'package:vendor/ui/categories_page.dart';
// import 'package:vendor/ui/home_page.dart';
// import 'package:vendor/ui/item_in_columns.dart';
// import 'package:vendor/ui/item_page.dart';
// import 'package:vendor/ui/login_page.dart';
// import 'package:vendor/ui/navigate.dart';
// import 'package:vendor/ui/profile.dart';
// import 'package:flutter/material.dart';
// import 'package:vendor/ui/splash_screen.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'dart:async';
//
// void main() async {
//   await dotenv.load(fileName: ".env");
//   print("API_URL: ${dotenv.env['API_URL']}");
//   runZonedGuarded(() {
//     runApp(const MyApp());
//   }, (error, stackTrace) {
//     debugPrint("Uncaught error: $error");
//   });
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       initialRoute: "/",
//       onGenerateRoute: (settings) {
//         // Handle named routes with arguments
//         switch (settings.name) {
//           case '/':
//             return MaterialPageRoute(builder: (_) => const SplashScreen());
//
//           case '/login':
//             return MaterialPageRoute(builder: (_) => const LoginPage());
//
//           // case '/home':
//           //   return MaterialPageRoute(builder: (_) => HomePage());
//
//           case '/item':
//             return MaterialPageRoute(builder: (_) => ItemPage());
//
//           case '/orders':
//             return MaterialPageRoute(builder: (_) => const OrderPage());
//
//           case '/fullCategory':
//             final category = settings.arguments as String;
//             return MaterialPageRoute(
//               builder: (_) => ItemInColumns(category: category),
//             );
//
//           case '/categories':
//             return MaterialPageRoute(builder: (_) => CategoriesPage());
//
//           case '/navbar':
//             return MaterialPageRoute(builder: (_) => NavigationBarPage());
//
//           case '/profile':
//             return MaterialPageRoute(builder: (_) => ProfilePage());
//
//           default:
//             return MaterialPageRoute(
//               builder: (_) => const Scaffold(
//                 body: Center(child: Text("Page not found")),
//               ),
//             );
//         }
//       },
//       theme: ThemeData(
//         fontFamily: 'Inter',
//       ),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
// main.dart

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';

import 'package:vendor/models/item.dart'; // for passing into routes
import 'package:vendor/ui/splash_screen.dart';
import 'package:vendor/ui/login_page.dart';
import 'package:vendor/ui/navigate.dart';
import 'package:vendor/ui/ordersfile.dart';
import 'package:vendor/ui/add_update_stock_page.dart';
import 'package:vendor/ui/profile.dart';
import 'package:vendor/ui/item_in_columns.dart';
import 'package:vendor/ui/vendor_item_detail_page.dart';
import 'package:vendor/ui/add_new_item.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  print("API_URL: \${dotenv.env['API_URL']}");
  runZonedGuarded(
        () => runApp(const MyApp()),
        (error, stackTrace) {
      debugPrint("Uncaught error: \$error");
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const SplashScreen());

          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginPage());

          case '/navbar':
            return MaterialPageRoute(builder: (_) => const NavigationBarPage());

          case '/orders':
          // You must supply a real orders list here
            return MaterialPageRoute(builder: (_) => OrdersPage());

          case '/stock':
            return MaterialPageRoute(builder: (_) => const AddUpdateStockPage());

          case '/fullCategory':
            final category = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => ItemInColumns(
                category: category,
                isVendorMode: true,
              ),
            );

          case '/item':
            final item = settings.arguments as Item?;
            return MaterialPageRoute(
              builder: (_) => VendorItemDetailPage(item: item),
            );

          case '/newItem':
            return MaterialPageRoute(builder: (_) => const AddNewItemPage());

          case '/profile':
            return MaterialPageRoute(builder: (_) => const ProfilePage());

          default:
            return MaterialPageRoute(
              builder: (_) => const Scaffold(
                body: Center(child: Text("Page not found")),
              ),
            );
        }
      },
      theme: ThemeData(
        fontFamily: 'Inter',
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
