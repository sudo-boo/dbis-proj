class UserProfile {
  final String? name;
  final String? phone;
  final String? email;
  final double? latitude;
  final double? longitude;
  final String? address;

  // Constructor
  UserProfile({
    this.name,
    this.phone,
    required this.email,
    this.latitude,
    this.longitude,
    this.address,
  });

  // Factory method to create an instance of UserProfile from a JSON response
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      address: json['address'],
    );
  }

  // Method to convert the UserProfile object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }
}
