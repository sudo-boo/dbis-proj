// main.dart

import 'package:customer/ui/cart_page.dart';
import 'package:customer/ui/home_page.dart';
import 'package:customer/ui/item_page.dart';
import 'package:customer/ui/login_page.dart';
import 'package:flutter/material.dart';
import 'package:customer/ui/splash_screen.dart';
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
      routes: {
        "/": (context) => const SplashScreen(),
        "/login": (context) => const LoginPage(),
        "/home": (context) => HomePage(),
        "/item": (context) => ItemPage(),
        "/cart": (context) => const CartPage(),
        // "/profile": (context) => ProfilePage(),
        // "/transaction": (context) => const TransactionPage(),
        // "/new-ride": (context) => QRCodeScanPage(),
        // "/ride-history": (context) => const RideHistoryPage(),
        // "/logout": (context) => const LogOutPage(),
      },
      theme: ThemeData(
        fontFamily: 'Inter',
      ),
      initialRoute: "/",
      debugShowCheckedModeBanner: false,
    );
  }
}