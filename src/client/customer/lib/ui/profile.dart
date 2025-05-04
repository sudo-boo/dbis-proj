import 'package:flutter/material.dart';
import 'package:customer/apis/profile_apis.dart';
import 'package:customer/data/repository/local_storage_manager.dart';
import '../models/user.dart'; // Assuming this contains the API call for profile

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Controllers for text fields
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  // User profile data
  UserProfile? userData;

  // Fetch user profile data
  void getUserData() async {
    try {
      UserProfile? profile = await getProfile();  // Call getProfile API to fetch data
      if (profile != null) {
        setState(() {
          userData = profile;
        });

        // Populate the text controllers with the fetched data
        usernameController.text = profile.name ?? '';
        phoneController.text = profile.phone ?? '';
        emailController.text = profile.email!;
        addressController.text = profile.address ?? '';
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();  // Fetch user data when the page initializes
  }

  @override
  void dispose() {
    usernameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }

  final EdgeInsets commonPadding = const EdgeInsets.symmetric(
      horizontal: 24, vertical: 12
  );

  // Widget for labeled text field
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
              hintText: 'Enter your $label',
              hintStyle: const TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  // Handle logout action
  void _handleLogout() {
    print('User logging out');
    eraseUserData();
    // Show a confirmation or navigate to login screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logged out')),
    );
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black87),
            onPressed: _handleLogout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Render the text fields for user data
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
                  ],
                ),
              ),
            ),
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

                    // Call the API to update the user profile
                    updateUserProfile(email, username, phone, address);
                    saveIsProfileNotCreated(false);

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
