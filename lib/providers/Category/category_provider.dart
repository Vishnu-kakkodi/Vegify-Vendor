import 'package:flutter/material.dart';
import 'package:vegiffyy_vendor/models/Category/category_model.dart';
import 'package:vegiffyy_vendor/services/Category/category_service.dart';


class CategoryProvider extends ChangeNotifier {
  final _service = CategoryService();

  bool loading = false;
  List<CategoryModel> categories = [];

  Future<void> load() async {
    loading = true;
    notifyListeners();
    categories = await _service.fetch();
    loading = false;
    notifyListeners();
  }

  Future<void> deleteCategory(String id) async {
    await _service.deleteCategory(id);
    categories.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  Future<void> deleteSubCategory(String catId, String subId) async {
    final cat = categories.firstWhere((c) => c.id == catId);
    cat.subcategories.removeWhere((s) => s.id == subId);
    notifyListeners();
    await _service.deleteSubCategory(catId, subId);
  }

  Future<void> updateCategory(
      String id, String name, String? imagePath) async {
    await _service.updateCategory(id, name, imagePath);
    await load();
  }

  Future<void> updateSubCategory(
      String catId, String subId, String name, String? imagePath) async {
    await _service.updateSubCategory(catId, subId, name, imagePath);
    await load();
  }
}
