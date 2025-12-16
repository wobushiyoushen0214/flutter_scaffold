import 'package:get/get.dart';
import 'package:flutter_getx_dio_scaffold/common/controllers/transaction_controller.dart';
import 'package:flutter_getx_dio_scaffold/common/controllers/category_controller.dart';
import 'package:flutter_getx_dio_scaffold/data/models/transaction_model.dart';
import 'package:flutter_getx_dio_scaffold/data/models/category_model.dart';

enum StatisticsPeriod { day, month, year }

enum ChartType { pie, bar }

class StatisticsController extends GetxController {
  final TransactionController _transactionController = Get.find();
  final CategoryController _categoryController = Get.find();

  // 状态
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final RxString selectedType = 'expense'.obs; // 'income' or 'expense'
  final Rx<StatisticsPeriod> selectedPeriod = StatisticsPeriod.month.obs;
  final Rx<ChartType> selectedChartType = ChartType.pie.obs;

  // 获取当前筛选条件下的交易列表
  List<TransactionModel> get filteredTransactions {
    return _transactionController.transactions.where((t) {
      // 1. 类型筛选
      if (t.type != selectedType.value) return false;

      // 2. 时间筛选
      final date = t.date;
      final selected = selectedDate.value;

      switch (selectedPeriod.value) {
        case StatisticsPeriod.day:
          return date.year == selected.year &&
              date.month == selected.month &&
              date.day == selected.day;
        case StatisticsPeriod.month:
          return date.year == selected.year && date.month == selected.month;
        case StatisticsPeriod.year:
          return date.year == selected.year;
      }
    }).toList();
  }

  // 获取分类统计数据（用于饼图）
  Map<String, double> get categoryStats {
    final Map<String, double> stats = {};
    for (var t in filteredTransactions) {
      stats[t.categoryId] = (stats[t.categoryId] ?? 0) + t.amount;
    }
    return stats;
  }

  // 获取时间趋势数据（用于柱状图）
  // Map<Key, Amount>
  // Key: day (1-31) or month (1-12)
  Map<int, double> get trendStats {
    final Map<int, double> stats = {};
    final transactions = filteredTransactions;

    for (var t in transactions) {
      int key;
      if (selectedPeriod.value == StatisticsPeriod.year) {
        key = t.date.month; // 按月统计
      } else {
        key = t.date.day; // 按日统计 (月视图显示每日，日视图显示单日)
      }
      stats[key] = (stats[key] ?? 0) + t.amount;
    }
    return stats;
  }

  CategoryModel? getCategory(String id) {
    return _categoryController.categories.firstWhereOrNull((c) => c.id == id);
  }

  // 时间导航
  void previousPeriod() {
    final date = selectedDate.value;
    switch (selectedPeriod.value) {
      case StatisticsPeriod.day:
        selectedDate.value = date.subtract(const Duration(days: 1));
        break;
      case StatisticsPeriod.month:
        selectedDate.value = DateTime(date.year, date.month - 1);
        break;
      case StatisticsPeriod.year:
        selectedDate.value = DateTime(date.year - 1);
        break;
    }
  }

  void nextPeriod() {
    final date = selectedDate.value;
    switch (selectedPeriod.value) {
      case StatisticsPeriod.day:
        selectedDate.value = date.add(const Duration(days: 1));
        break;
      case StatisticsPeriod.month:
        selectedDate.value = DateTime(date.year, date.month + 1);
        break;
      case StatisticsPeriod.year:
        selectedDate.value = DateTime(date.year + 1);
        break;
    }
  }

  void toggleType() {
    selectedType.value = selectedType.value == 'expense' ? 'income' : 'expense';
  }

  void setPeriod(StatisticsPeriod period) {
    selectedPeriod.value = period;
  }

  void toggleChartType() {
    selectedChartType.value = selectedChartType.value == ChartType.pie
        ? ChartType.bar
        : ChartType.pie;
  }
}
