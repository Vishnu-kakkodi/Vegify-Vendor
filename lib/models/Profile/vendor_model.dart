class VendorModel {
  final String id;
  final String restaurantName;
  final String email;
  final String mobile;
  final String locationName;
  final String status;
  final double rating;
  final String referralCode;
  final double walletBalance;
  final String description;
  final String? imageUrl;
  final String? gstNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  final Map<String, DocumentModel?> documents;

  VendorModel({
    required this.id,
    required this.restaurantName,
    required this.email,
    required this.mobile,
    required this.locationName,
    required this.status,
    required this.rating,
    required this.referralCode,
    required this.walletBalance,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    this.imageUrl,
    this.gstNumber,
    required this.documents,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      id: json['_id'],
      restaurantName: json['restaurantName'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      locationName: json['locationName'] ?? '',
      status: json['status'] ?? 'inactive',
      rating: (json['rating'] ?? 0).toDouble(),
      referralCode: json['referralCode'] ?? '',
      walletBalance: (json['walletBalance'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      imageUrl: json['image']?['url'],
      gstNumber: json['gstNumber'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      documents: {
        'gst': DocumentModel.fromJson(json['gstCertificate']),
        'fssai': DocumentModel.fromJson(json['fssaiLicense']),
        'pan': DocumentModel.fromJson(json['panCard']),
        'aadhar': DocumentModel.fromJson(json['aadharCard']),
        'declaration': DocumentModel.fromJson(json['declarationForm']),
        'agreement': DocumentModel.fromJson(json['vendorAgreement']),
      },
    );
  }
}

class DocumentModel {
  final String url;
  final DateTime? uploadedAt;

  DocumentModel({required this.url, this.uploadedAt});

  static DocumentModel? fromJson(dynamic json) {
    if (json == null || json['url'] == null) return null;
    return DocumentModel(
      url: json['url'],
      uploadedAt:
          json['uploadedAt'] != null ? DateTime.parse(json['uploadedAt']) : null,
    );
  }
}
