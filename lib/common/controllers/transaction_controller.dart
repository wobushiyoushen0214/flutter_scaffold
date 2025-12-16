/*
 * @Author: LiZhiWei
 * @Date: 2025-12-15 17:23:45
 * @LastEditors: LiZhiWei
 * @LastEditTime: 2025-12-15 17:23:46
 * @Description: 
 */
import 'package:get/get.dart';
import 'package:flutter_getx_dio_scaffold/common/services/storage_service.dart';
import 'package:flutter_getx_dio_scaffold/data/models/transaction_model.dart';
import 'package:uuid/uuid.dart';

class TransactionController extends GetxController {
  final StorageService _storageService = StorageService.to;

  final RxList<TransactionModel> transactions = <TransactionModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadTransactions();
  }

  void loadTransactions() {
    final list = _storageService.transactionBox.values.toList();
    // 按日期降序排序
    list.sort((a, b) => b.date.compareTo(a.date));
    transactions.value = list;
  }

  Future<void> addTransaction({
    required double amount,
    required String categoryId,
    required DateTime date,
    required String note,
    required String type,
  }) async {
    final newTransaction = TransactionModel(
      id: const Uuid().v4(),
      amount: amount,
      categoryId: categoryId,
      date: date,
      note: note,
      type: type,
    );
    await _storageService.transactionBox.put(newTransaction.id, newTransaction);
    loadTransactions();
  }

  Future<void> deleteTransaction(String id) async {
    await _storageService.transactionBox.delete(id);
    loadTransactions();
  }

  double get totalIncome {
    return transactions
        .where((t) => t.type == 'income')
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  double get totalExpense {
    return transactions
        .where((t) => t.type == 'expense')
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  // 获取指定月份的账单
  List<TransactionModel> getTransactionsByMonth(DateTime month) {
    return transactions.where((t) {
      return t.date.year == month.year && t.date.month == month.month;
    }).toList();
  }
}
