// splash_screen.dart

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Delay for 1.2 seconds, then navigate to home page
    Future.delayed(const Duration(milliseconds: 1200), () {
      // Check if the widget is still mounted before navigating
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF28282b),
      body: Center(
        child: Image.asset(
          'assets/images/splash.jpeg',
        //   to add height
        ),
      ),
    );
  }
}
