import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';

import 'package:delivery/models/item.dart'; // for passing into routes
import 'package:delivery/ui/splash_screen.dart';
import 'package:delivery/ui/login_page.dart';
import 'package:delivery/ui/navigate.dart';
import 'package:delivery/ui/ordersfile.dart';
import 'package:delivery/ui/profile.dart';

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
