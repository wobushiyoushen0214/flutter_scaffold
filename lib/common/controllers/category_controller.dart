/*
 * @Author: LiZhiWei
 * @Date: 2025-12-15 17:23:33
 * @LastEditors: LiZhiWei
 * @LastEditTime: 2025-12-15 17:31:38
 * @Description: 
 */
import 'package:get/get.dart';
import 'package:flutter_getx_dio_scaffold/common/services/storage_service.dart';
import 'package:flutter_getx_dio_scaffold/data/models/category_model.dart';
import 'package:uuid/uuid.dart';

class CategoryController extends GetxController {
  final StorageService _storageService = StorageService.to;

  final RxList<CategoryModel> categories = <CategoryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  void loadCategories() {
    categories.value = _storageService.categoryBox.values.toList();
  }

  Future<void> addCategory(
    String name,
    String type,
    int iconCode,
    int colorValue,
  ) async {
    final newCategory = CategoryModel(
      id: const Uuid().v4(),
      name: name,
      type: type,
      iconCode: iconCode,
      colorValue: colorValue,
    );
    await _storageService.categoryBox.put(newCategory.id, newCategory);
    loadCategories();
  }

  Future<void> deleteCategory(String id) async {
    await _storageService.categoryBox.delete(id);
    loadCategories();
  }

  List<CategoryModel> get expenseCategories =>
      categories.where((c) => c.type == 'expense').toList();

  List<CategoryModel> get incomeCategories =>
      categories.where((c) => c.type == 'income').toList();
}
