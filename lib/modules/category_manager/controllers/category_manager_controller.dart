/*
 * @Author: LiZhiWei
 * @Date: 2025-12-15 17:55:50
 * @LastEditors: LiZhiWei
 * @LastEditTime: 2025-12-15 17:55:52
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_getx_dio_scaffold/common/controllers/category_controller.dart';
import 'package:flutter_getx_dio_scaffold/data/models/category_model.dart';

class CategoryManagerController extends GetxController {
  final CategoryController _categoryController = Get.find();

  final RxString selectedType = 'expense'.obs; // 'income' or 'expense'
  final TextEditingController nameController = TextEditingController();

  // 预定义的图标列表供选择
  final List<IconData> availableIcons = [
    Icons.restaurant,
    Icons.directions_bus,
    Icons.shopping_bag,
    Icons.movie,
    Icons.home,
    Icons.account_balance_wallet,
    Icons.card_giftcard,
    Icons.work,
    Icons.local_hospital,
    Icons.school,
    Icons.flight,
    Icons.pets,
    Icons.sports_esports,
    Icons.fitness_center,
    Icons.local_cafe,
    Icons.local_bar,
    Icons.child_care,
    Icons.phone_iphone,
    Icons.wifi,
    Icons.directions_car,
    Icons.train,
    Icons.local_grocery_store,
    Icons.book,
    Icons.music_note,
  ];

  // 预定义的颜色列表供选择
  final List<Color> availableColors = [
    Colors.orange,
    Colors.blue,
    Colors.red,
    Colors.purple,
    Colors.green,
    Colors.teal,
    Colors.amber,
    Colors.indigo,
    Colors.pink,
    Colors.brown,
    Colors.cyan,
    Colors.deepPurple,
    Colors.lime,
    Colors.deepOrange,
  ];

  final Rx<IconData> selectedIcon = Icons.category.obs;
  final Rx<Color> selectedColor = Colors.blue.obs;

  List<CategoryModel> get currentCategories => selectedType.value == 'expense'
      ? _categoryController.expenseCategories
      : _categoryController.incomeCategories;

  void setType(String type) {
    selectedType.value = type;
  }

  void selectIcon(IconData icon) {
    selectedIcon.value = icon;
  }

  void selectColor(Color color) {
    selectedColor.value = color;
  }

  Future<void> addCategory() async {
    if (nameController.text.isEmpty) {
      Get.snackbar('错误', '请输入分类名称');
      return;
    }

    await _categoryController.addCategory(
      nameController.text,
      selectedType.value,
      selectedIcon.value.codePoint,
      selectedColor.value.toARGB32(),
    );

    nameController.clear();
    Get.back();
    Get.snackbar('成功', '分类添加成功');
  }

  Future<void> deleteCategory(String id) async {
    await _categoryController.deleteCategory(id);
    Get.snackbar('成功', '分类已删除');
  }
}
