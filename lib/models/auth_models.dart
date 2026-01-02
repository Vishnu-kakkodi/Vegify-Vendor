// You can split these into multiple files if you like.

class VendorLoginResponse {
  final bool success;
  final String message;
  final String vendorId;
  final String otp; // demo otp from api

  VendorLoginResponse({
    required this.success,
    required this.message,
    required this.vendorId,
    required this.otp,
  });

  factory VendorLoginResponse.fromJson(Map<String, dynamic> json) {
    return VendorLoginResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      vendorId: json['vendorId'] ?? '',
      otp: json['otp']?.toString() ?? '',
    );
  }
}

class Vendor {
  final String id;
  final String restaurantName;
  final String email;
  final String mobile;
  final String locationName;
  final String image;

  Vendor({
    required this.id,
    required this.restaurantName,
    required this.email,
    required this.mobile,
    required this.locationName,
    required this.image,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      id: json['id'] ?? '',
      restaurantName: json['restaurantName'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      locationName: json['locationName'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

class VerifyOtpResponse {
  final bool success;
  final String message;
  final Vendor? vendor;

  VerifyOtpResponse({
    required this.success,
    required this.message,
    required this.vendor,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      vendor: json['vendor'] != null ? Vendor.fromJson(json['vendor']) : null,
    );
  }
}
