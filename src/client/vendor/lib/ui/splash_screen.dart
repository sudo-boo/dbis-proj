// splash_screen.dart

import 'package:vendor/commons/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:vendor/data/repository/local_storage_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Delay for 1.2 seconds, then navigate to the appropriate page
    Future.delayed(const Duration(milliseconds: 1200), () async {
      // Fetch the user_email from SharedPreferences
      saveUserEmail("dummy@dummy.com");
      // eraseUserData();
      String? userEmail = await getUserEmail(); // Using getUserEmail function from local_storage_manager.dart


      // Check if the widget is still mounted before navigating
      if (mounted) {
        if (userEmail != null && userEmail.isNotEmpty) {
          // If user_email exists, navigate to /home
          Navigator.pushReplacementNamed(context, '/navbar');
        } else {
          // If user_email does not exist, navigate to /login
          Navigator.pushReplacementNamed(context, '/login');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF28282b),
      body: Center(
        child: Image.asset(
          "assets/images/splash.jpeg",
          height: screenHeight(context),
          fit: BoxFit.fitHeight,
        //   to add height
        ),
      ),
    );
  }
}
