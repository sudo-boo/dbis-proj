import 'package:flutter/material.dart';
import 'package:vendor/commons/app_constants.dart';

class VerifyOtpPage extends StatefulWidget {
  final String email;
  const VerifyOtpPage({
    super.key,
    required this.email,
  });

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  // Controllers for each OTP digit
  final List<TextEditingController> _otpControllers = List.generate(6, (_) => TextEditingController());
  // FocusNodes for each OTP field to manage focus
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    // Dispose of the FocusNodes to avoid memory leaks
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  // Function to move focus to the next field
  void _onOtpFieldChanged(int index) {
    // Move focus to the next field if the current one is filled
    if (_otpControllers[index].text.isNotEmpty && index < 5) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    }
    // Move focus to the previous field if the user deletes the digit
    if (_otpControllers[index].text.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getPrimaryColor(),  // Set background color as per your design
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // OTP Input Field (6 blanks for OTP)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SizedBox(
                      width: 40,
                      child: TextField(
                        controller: _otpControllers[index],
                        focusNode: _focusNodes[index],
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          counterText: "",  // Hide the character count
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: "0",
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        onChanged: (value) {
                          // Move to the next field when a digit is entered
                          _onOtpFieldChanged(index);
                        },
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 30),

              // Continue Button (TextButton style)
              TextButton(
                onPressed: () {
                  // Collect OTP input and handle verification
                  String otp = _otpControllers.map((controller) => controller.text).join();
                  if (otp.length == 6) {
                    // If OTP is entered, continue with verification
                    print('OTP entered: $otp');

                    // for now just skip this
                    if(otp == "111111"){
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("OTP Verified")));
                      Navigator.pushReplacementNamed(context, '/home');

                    }
                  } else {
                    // If OTP is incomplete, show error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please enter a valid OTP")));
                  }
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.yellow.shade300,
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 48.0),
                  backgroundColor: Colors.yellow.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Continue',
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
