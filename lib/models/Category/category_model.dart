class CategoryModel {
  final String id;
  String name;
  String imageUrl;
  DateTime createdAt;
  List<SubCategoryModel> subcategories;

  CategoryModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.createdAt,
    required this.subcategories,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'],
      name: json['categoryName'],
      imageUrl: json['imageUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      subcategories: (json['subcategories'] as List)
          .map((e) => SubCategoryModel.fromJson(e))
          .toList(),
    );
  }
}

class SubCategoryModel {
  final String id;
  String name;
  String? imageUrl;

  SubCategoryModel({
    required this.id,
    required this.name,
    this.imageUrl,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['_id'],
      name: json['subcategoryName'],
      imageUrl: json['subcategoryImageUrl'],
    );
  }
}
