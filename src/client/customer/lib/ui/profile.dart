import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController usernameController = TextEditingController(text: 'Krish');
  final TextEditingController phoneController = TextEditingController(text: '9726974345');
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }

  final EdgeInsets commonPadding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12);

  Widget _buildLabeledTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: commonPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.purple.shade50,
              hintText: label == 'Email Address' ? 'Enter your email' : '',
              hintStyle: const TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Row(
                children: [
                  // Icon(Icons.arrow_back_ios, size: 20),
                  // SizedBox(width: 4),
                  // Text(
                  //   'Profile',
                  //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  // ),
                ],
              ),
            ),
            _buildLabeledTextField(
              label: 'Name',
              controller: usernameController,
            ),
            _buildLabeledTextField(
              label: 'Mobile Number',
              controller: phoneController,
              keyboardType: TextInputType.phone,
            ),
            _buildLabeledTextField(
              label: 'Email Address',
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            _buildLabeledTextField(
              label: 'Address',
              controller: addressController,
              maxLines: 3,
              keyboardType: TextInputType.multiline,
            ),
            const Spacer(),
            Padding(
              padding: commonPadding,
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade100,
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    final username = usernameController.text;
                    final phone = phoneController.text;
                    final email = emailController.text;
                    final address = addressController.text;

                    print('Saved: $username, $phone, $email, $address');

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile saved successfully')),
                    );
                  },
                  child: const Text('Submit'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
