class ProfileDetails {
  final String fullName;
  final String phone;
  final String city;
  final String state;
  final String country;
  final String pinCode;
  final String streetAddress;

  ProfileDetails({
    required this.fullName,
    required this.phone,
    required this.city,
    required this.state,
    required this.country,
    required this.pinCode,
    required this.streetAddress,
  });

  factory ProfileDetails.fromMap(Map<String, dynamic> map) {
    final shippingAddress = map['shipping_address'] ?? {};
    return ProfileDetails(
      fullName: map['full_name'] ?? '',
      phone: map['phn']?.toString() ?? '',
      city: shippingAddress['city'] ?? '',
      state: shippingAddress['state'] ?? '',
      country: shippingAddress['country'] ?? '',
      pinCode: shippingAddress['pin_code'] ?? '',
      streetAddress: shippingAddress['street_address'] ?? '',
    );
  }
}
