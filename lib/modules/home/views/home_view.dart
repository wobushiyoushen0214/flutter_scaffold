import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_getx_dio_scaffold/common/controllers/transaction_controller.dart';
import 'package:flutter_getx_dio_scaffold/common/controllers/category_controller.dart';
import 'package:flutter_getx_dio_scaffold/common/constants/app_colors.dart';
import 'package:flutter_getx_dio_scaffold/data/models/category_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionController = Get.find<TransactionController>();
    final categoryController = Get.find<CategoryController>();

    return Scaffold(
      appBar: AppBar(title: const Text('我的钱包'), elevation: 0),
      body: Column(
        children: [
          _buildOverviewCard(transactionController)
              .animate()
              .fadeIn(duration: 600.ms)
              .slideY(begin: -0.2, end: 0, curve: Curves.easeOutBack),
          Expanded(
            child: Obx(() {
              if (transactionController.transactions.isEmpty) {
                return const Center(
                  child: Text('暂无账单'),
                ).animate().fadeIn(duration: 500.ms);
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: transactionController.transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactionController.transactions[index];
                  final category = categoryController.categories
                      .firstWhereOrNull((c) => c.id == transaction.categoryId);

                  return _buildTransactionItem(
                        transaction,
                        category,
                        transactionController,
                      )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: (50 * index).ms)
                      .slideX(begin: 0.2, end: 0);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCard(TransactionController controller) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text('总资产', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          Obx(
            () =>
                Text(
                      '\$ ${(controller.totalIncome - controller.totalExpense).toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                    .animate(
                      key: ValueKey(
                        controller.totalIncome - controller.totalExpense,
                      ),
                    )
                    .scale(duration: 300.ms, curve: Curves.easeOutBack),
          ),
          const SizedBox(height: 20),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryItem(
                  icon: Icons.arrow_downward,
                  label: '收入',
                  value: controller.totalIncome,
                  color: Colors.greenAccent,
                ),
                _buildSummaryItem(
                  icon: Icons.arrow_upward,
                  label: '支出',
                  value: controller.totalExpense,
                  color: Colors.redAccent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required String label,
    required double value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            Text(
              '\$ ${value.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTransactionItem(
    dynamic transaction,
    CategoryModel? category,
    TransactionController controller,
  ) {
    final isIncome = transaction.type == 'income';
    return Dismissible(
      key: Key(transaction.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        controller.deleteTransaction(transaction.id);
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 0,
        color: Get.theme.cardTheme.color,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: category != null
                ? Color(category.colorValue).withValues(alpha: 0.1)
                : Colors.grey.withValues(alpha: 0.1),
            child: Icon(
              category != null
                  ? IconData(category.iconCode, fontFamily: 'MaterialIcons')
                  : Icons.category,
              color: category != null
                  ? Color(category.colorValue)
                  : Colors.grey,
            ),
          ),
          title: Text(
            category?.name ?? 'Unknown',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            transaction.note.isNotEmpty
                ? transaction.note
                : DateFormat('MMM d, y').format(transaction.date),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(
            '${isIncome ? '+' : '-'} \$ ${transaction.amount.toStringAsFixed(2)}',
            style: TextStyle(
              color: isIncome ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
