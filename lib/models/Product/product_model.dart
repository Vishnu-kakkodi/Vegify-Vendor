class ProductModel {
  final String productId;
  final String restaurantName;
  final String locationName;
  final List<String> type;
  final Map<String, dynamic> recommendedItem;

  ProductModel({
    required this.productId,
    required this.restaurantName,
    required this.locationName,
    required this.type,
    required this.recommendedItem,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['productId'],
      restaurantName: json['restaurantName'] ?? '',
      locationName: json['locationName'] ?? '',
      type: List<String>.from(json['type'] ?? []),
      recommendedItem: json['recommendedItem'] ?? {},
    );
  }
}
