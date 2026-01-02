import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vegiffyy_vendor/models/Category/category_model.dart';

class CategoryService {
  static const base = "http://31.97.206.144:5051/api/category";

  /// 🔹 FETCH CATEGORIES
  Future<List<CategoryModel>> fetch() async {
    final res = await http.get(Uri.parse(base));

    print("📡 FETCH CATEGORIES");
    print("STATUS: ${res.statusCode}");
    print("BODY: ${res.body}");

    if (res.statusCode != 200) {
      throw Exception("Failed to fetch categories");
    }

    final body = jsonDecode(res.body);
    return (body['data'] as List)
        .map((e) => CategoryModel.fromJson(e))
        .toList();
  }

  /// 🔹 DELETE CATEGORY
  Future<void> deleteCategory(String id) async {
    final res = await http.delete(Uri.parse("$base/$id"));

    print("🗑️ DELETE CATEGORY");
    print("CATEGORY ID: $id");
    print("STATUS: ${res.statusCode}");
    print("BODY: ${res.body}");

    if (res.statusCode != 200) {
      throw Exception("Failed to delete category");
    }
  }

  /// 🔹 DELETE SUBCATEGORY
  Future<void> deleteSubCategory(String catId, String subId) async {
    final res = await http.delete(
      Uri.parse("$base/$catId/subcategory/$subId"),
    );

    print("🗑️ DELETE SUBCATEGORY");
    print("CATEGORY ID: $catId");
    print("SUBCATEGORY ID: $subId");
    print("STATUS: ${res.statusCode}");
    print("BODY: ${res.body}");

    if (res.statusCode != 200) {
      throw Exception("Failed to delete subcategory");
    }
  }

  /// 🔹 UPDATE CATEGORY
  Future<void> updateCategory(
      String id, String name, String? imagePath) async {
    final req = http.MultipartRequest('PUT', Uri.parse("$base/$id"));
    req.fields['categoryName'] = name;

    if (imagePath != null) {
      req.files.add(
        await http.MultipartFile.fromPath('image', imagePath),
      );
    }

    final res = await req.send();
    final body = await res.stream.bytesToString();

    print("✏️ UPDATE CATEGORY");
    print("CATEGORY ID: $id");
    print("NAME: $name");
    print("IMAGE: ${imagePath ?? "NO CHANGE"}");
    print("STATUS: ${res.statusCode}");
    print("BODY: $body");

    if (res.statusCode != 200) {
      throw Exception("Failed to update category");
    }
  }

  /// 🔹 UPDATE SUBCATEGORY
  Future<void> updateSubCategory(
      String catId, String subId, String name, String? imagePath) async {
    final req = http.MultipartRequest(
      'PUT',
      Uri.parse("$base/$catId/subcategory/$subId"),
    );

    req.fields['subcategoryName'] = name;

    if (imagePath != null) {
      req.files.add(
        await http.MultipartFile.fromPath('image', imagePath),
      );
    }

    final res = await req.send();
    final body = await res.stream.bytesToString();

    print("✏️ UPDATE SUBCATEGORY");
    print("CATEGORY ID: $catId");
    print("SUBCATEGORY ID: $subId");
    print("NAME: $name");
    print("IMAGE: ${imagePath ?? "NO CHANGE"}");
    print("STATUS: ${res.statusCode}");
    print("BODY: $body");

    if (res.statusCode != 200) {
      throw Exception("Failed to update subcategory");
    }
  }
}
