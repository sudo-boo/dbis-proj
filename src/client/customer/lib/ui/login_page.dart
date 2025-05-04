import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:customer/apis/verify_email.dart';
import 'package:customer/ui/verify_otp_page.dart';
import 'package:customer/commons/app_constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controller to handle the email input
  final TextEditingController _emailController = TextEditingController();

  // This will hold the location information
  String _locationMessage = "Getting location...";

  // The function to request location
  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Ask the user to enable location services by opening location settings
      setState(() {
        _locationMessage = "Location services are disabled. Please turn them on.";
      });

      // Show a dialog to inform the user to turn on location services
      await _showLocationDialog();

      // Return null since location services are not enabled
      return null;
    }

    // Request permission
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      setState(() {
        _locationMessage = "Location permission denied. Please grant permission.";
      });
      return null;
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _locationMessage = 'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
    });

    return position;
  }

  // Function to show a dialog asking the user to enable location services
  Future<void> _showLocationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // The user must tap a button to dismiss the dialog.
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Location Services Disabled'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Location services are required to continue. Please enable them in the settings.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Open Settings'),
              onPressed: () {
                // Open location settings for the user
                Geolocator.openLocationSettings();
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without action
              },
            ),
          ],
        );
      },
    );
  }

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
      return;
    }

    // Get current location
    Position? position = await _getCurrentLocation();

    // If the location is not available, show an error message
    if (position == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Unable to get location"))
      );
      return;
    }

    // Print the location details for debugging before proceeding
    print('Location details - Latitude: ${position.latitude}, Longitude: ${position.longitude}');

    // Handle OTP generation or sending here
    print('Email entered: $email');
    print('Sending OTP');

    // Call sendOtp function and wait for the result
    bool otpSendStatus = await getOtp(email);

    if (mounted) {
      if (otpSendStatus) {
        // If OTP is sent successfully, navigate to VerifyOtpPage
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("OTP has been sent"))
        );

        // Navigate to the VerifyOtpPage and pass the email and location
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyOtpPage(
              email: email,
              latitude: position.latitude,
              longitude: position.longitude,
            ),
          ),
        );
      } else {
        // If there is an error sending OTP, show an error message
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Error in sending OTP"))
        );
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
              SizedBox(height: 50),

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
