/*
 * @Author: LiZhiWei
 * @Date: 2025-12-15 17:26:42
 * @LastEditors: LiZhiWei
 * @LastEditTime: 2025-12-15 17:26:44
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_getx_dio_scaffold/common/controllers/transaction_controller.dart';
import 'package:flutter_getx_dio_scaffold/common/controllers/category_controller.dart';
import 'package:flutter_getx_dio_scaffold/data/models/category_model.dart';

class AddTransactionController extends GetxController {
  final TransactionController _transactionController = Get.find();
  final CategoryController _categoryController = Get.find();

  final RxString type = 'expense'.obs; // 'income' or 'expense'
  final RxDouble amount = 0.0.obs;
  final RxString selectedCategoryId = ''.obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  List<CategoryModel> get currentCategories => type.value == 'expense'
      ? _categoryController.expenseCategories
      : _categoryController.incomeCategories;

  @override
  void onClose() {
    amountController.dispose();
    noteController.dispose();
    super.onClose();
  }

  void setType(String newType) {
    type.value = newType;
    selectedCategoryId.value = ''; // Reset category selection
  }

  void setCategory(String id) {
    selectedCategoryId.value = id;
  }

  void setDate(DateTime date) {
    selectedDate.value = date;
  }

  Future<void> saveTransaction() async {
    final amountText = amountController.text;
    if (amountText.isEmpty) {
      Get.snackbar('Error', 'Please enter amount');
      return;
    }

    if (selectedCategoryId.value.isEmpty) {
      Get.snackbar('Error', 'Please select a category');
      return;
    }

    try {
      final amountValue = double.parse(amountText);
      await _transactionController.addTransaction(
        amount: amountValue,
        categoryId: selectedCategoryId.value,
        date: selectedDate.value,
        note: noteController.text,
        type: type.value,
      );
      Get.back();
      Get.snackbar('Success', 'Transaction added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Invalid amount');
    }
  }
}
