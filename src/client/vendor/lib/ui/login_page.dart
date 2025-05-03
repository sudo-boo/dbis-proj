import 'package:vendor/apis/verify_email.dart';
import 'package:vendor/ui/verify_otp_page.dart';
import 'package:flutter/material.dart';
import 'package:vendor/commons/app_constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controller to handle the email input
  final TextEditingController _emailController = TextEditingController();

  // The function that calls sendOtp API
  Future<void> _handleGetOtp() async {
    String email = _emailController.text.trim();

    if (email.isEmpty) {
      // If the email is empty, show a snack bar with an error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please enter your email"))
        );
      }
    } else {
      // Handle OTP generation or sending here
      print('Email entered: $email');
      print('Sending OTP');

      // Call sendOtp function and wait for the result
      bool otpSendStatus = await sendOtp(email);

      if (mounted) {
        if (otpSendStatus) {
          // If OTP is sent successfully, navigate to VerifyOtpPage
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("OTP has been sent"))
          );

          // Navigate to the VerifyOtpPage
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VerifyOtpPage(email: email)),
          );
        } else {
          // If there is an error sending OTP, show an error message
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Error in sending OTP"))
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getPrimaryColor(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Enter Your Email to Login",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
              SizedBox(height: 50,),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'example@mail.com',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Get OTP Button (TextButton style)
              TextButton(
                onPressed: _handleGetOtp, // Call the _handleGetOtp function
                style: TextButton.styleFrom(
                  foregroundColor: Colors.yellow.shade300,
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 48.0),
                  backgroundColor: Colors.yellow.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Get OTP',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
