// main.dart

import 'package:customer/ui/cart_page.dart';
import 'package:customer/ui/categories_page.dart';
import 'package:customer/ui/home_page.dart';
import 'package:customer/ui/item_in_columns.dart';
import 'package:customer/ui/item_page.dart';
import 'package:customer/ui/login_page.dart';
import 'package:customer/ui/navigate.dart';
import 'package:customer/ui/order_confirmation.dart';
import 'package:customer/ui/profile.dart';
import 'package:customer/ui/orders.dart';
import 'package:customer/ui/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(); // Load the .env file
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      onGenerateRoute: (settings) {
        // Handle named routes with arguments
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const SplashScreen());

          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginPage());

          case '/home':
            return MaterialPageRoute(builder: (_) => HomePage());

          case '/item':
            return MaterialPageRoute(builder: (_) => ItemPage());

          case '/cart':
            return MaterialPageRoute(builder: (_) => const CartPage());

          case '/fullCategory':
            final category = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => ItemInColumns(category: category),
            );

          case '/categories':
            return MaterialPageRoute(builder: (_) => CategoriesPage());

          case '/navbar':
            return MaterialPageRoute(builder: (_) => NavigationBarPage());

          case '/profile':
            return MaterialPageRoute(builder: (_) => ProfilePage());

          case '/orders':
            return MaterialPageRoute(builder: (_) => const CustomerOrderHistoryPage());

          case OrderConfirmationPage.routeName:
            final args = settings.arguments as OrderConfirmationArguments;
            return MaterialPageRoute(
              builder: (_) => OrderConfirmationPage(
                order: args.order,
                items: args.items,
              ),
            );

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
