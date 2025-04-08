// main.dart

import 'package:customer/ui/home_page.dart';
import 'package:customer/ui/item_page.dart';
import 'package:flutter/material.dart';
import 'package:customer/ui/splash_screen.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/": (context) => const SplashScreen(),
        "/home": (context) => HomePage(),
        "/item": (context) => ItemPage(),
        // "/profile": (context) => ProfilePage(),
        // "/transaction": (context) => const TransactionPage(),
        // "/new-ride": (context) => QRCodeScanPage(),
        // "/wallet": (context) => const WalletPage(),
        // "/ride-history": (context) => const RideHistoryPage(),
        // "/info": (context) => const InfoPage(),
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