/*
 * @Author: LiZhiWei
 * @Date: 2025-12-15 17:22:57
 * @LastEditors: LiZhiWei
 * @LastEditTime: 2025-12-15 17:35:11
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_getx_dio_scaffold/data/models/category_model.dart';
import 'package:flutter_getx_dio_scaffold/data/models/transaction_model.dart';
import 'package:uuid/uuid.dart';

class StorageService extends GetxService {
  static StorageService get to => Get.find();

  late Box<CategoryModel> categoryBox;
  late Box<TransactionModel> transactionBox;

  Future<StorageService> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(CategoryModelAdapter());
    Hive.registerAdapter(TransactionModelAdapter());

    categoryBox = await Hive.openBox<CategoryModel>('categories');
    transactionBox = await Hive.openBox<TransactionModel>('transactions');

    await _seedDefaultCategories();

    return this;
  }

  Future<void> _seedDefaultCategories() async {
    if (categoryBox.isNotEmpty) return;

    final defaultCategories = [
      // 支出
      CategoryModel(
        id: const Uuid().v4(),
        name: '餐饮',
        type: 'expense',
        iconCode: Icons.restaurant.codePoint,
        colorValue: Colors.orange.toARGB32(),
      ),
      CategoryModel(
        id: const Uuid().v4(),
        name: '交通',
        type: 'expense',
        iconCode: Icons.directions_bus.codePoint,
        colorValue: Colors.blue.toARGB32(),
      ),
      CategoryModel(
        id: const Uuid().v4(),
        name: '购物',
        type: 'expense',
        iconCode: Icons.shopping_bag.codePoint,
        colorValue: Colors.red.toARGB32(),
      ),
      CategoryModel(
        id: const Uuid().v4(),
        name: '娱乐',
        type: 'expense',
        iconCode: Icons.movie.codePoint,
        colorValue: Colors.purple.toARGB32(),
      ),
      CategoryModel(
        id: const Uuid().v4(),
        name: '居住',
        type: 'expense',
        iconCode: Icons.home.codePoint,
        colorValue: Colors.green.toARGB32(),
      ),
      // 收入
      CategoryModel(
        id: const Uuid().v4(),
        name: '工资',
        type: 'income',
        iconCode: Icons.account_balance_wallet.codePoint,
        colorValue: Colors.teal.toARGB32(),
      ),
      CategoryModel(
        id: const Uuid().v4(),
        name: '奖金',
        type: 'income',
        iconCode: Icons.card_giftcard.codePoint,
        colorValue: Colors.amber.toARGB32(),
      ),
      CategoryModel(
        id: const Uuid().v4(),
        name: '兼职',
        type: 'income',
        iconCode: Icons.work.codePoint,
        colorValue: Colors.indigo.toARGB32(),
      ),
    ];

    for (var category in defaultCategories) {
      await categoryBox.put(category.id, category);
    }
  }
}
