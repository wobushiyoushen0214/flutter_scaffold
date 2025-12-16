import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/add_transaction_controller.dart';
import 'package:flutter_getx_dio_scaffold/common/constants/app_colors.dart';

class AddTransactionView extends GetView<AddTransactionController> {
  const AddTransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('记账'), centerTitle: true),
      body: Column(
        children: [
          _buildTypeSelector(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAmountInput(),
                  const SizedBox(height: 24),
                  const Text(
                    '分类',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildCategoryGrid(),
                  const SizedBox(height: 24),
                  _buildDateSelector(context),
                  const SizedBox(height: 16),
                  _buildNoteInput(),
                ],
              ),
            ),
          ),
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Get.theme.cardTheme.color,
      child: Row(
        children: [
          Expanded(child: _buildTypeButton('支出', 'expense')),
          const SizedBox(width: 16),
          Expanded(child: _buildTypeButton('收入', 'income')),
        ],
      ),
    );
  }

  Widget _buildTypeButton(String label, String value) {
    return Obx(() {
      final isSelected = controller.type.value == value;
      return ElevatedButton(
        onPressed: () => controller.setType(value),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? AppColors.primary : Colors.grey[200],
          foregroundColor: isSelected ? Colors.white : Colors.black,
          elevation: isSelected ? 2 : 0,
        ),
        child: Text(label),
      );
    });
  }

  Widget _buildAmountInput() {
    return TextField(
      controller: controller.amountController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      decoration: const InputDecoration(
        prefixText: '\$ ',
        border: InputBorder.none,
        hintText: '0.00',
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return Obx(() {
      final categories = controller.currentCategories;
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        itemCount: categories.length + 1, // +1 for "Add Custom"
        itemBuilder: (context, index) {
          if (index == categories.length) {
            return _buildAddCategoryButton();
          }
          final category = categories[index];
          return Obx(() {
            final isSelected =
                controller.selectedCategoryId.value == category.id;
            return GestureDetector(
              onTap: () => controller.setCategory(category.id),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: isSelected
                        ? Color(category.colorValue)
                        : Color(category.colorValue).withValues(alpha: 0.1),
                    child: Icon(
                      IconData(category.iconCode, fontFamily: 'MaterialIcons'),
                      color: isSelected
                          ? Colors.white
                          : Color(category.colorValue),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category.name,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected ? Get.theme.colorScheme.primary : null,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          });
        },
      );
    });
  }

  Widget _buildAddCategoryButton() {
    return GestureDetector(
      onTap: () {
        Get.snackbar('提示', '自定义分类功能即将推出');
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.grey[200],
            child: const Icon(Icons.add, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          const Text('添加', style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildDateSelector(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: controller.selectedDate.value,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
        );
        if (date != null) {
          controller.setDate(date);
        }
      },
      child: Row(
        children: [
          const Icon(Icons.calendar_today, size: 20),
          const SizedBox(width: 8),
          Obx(
            () => Text(
              DateFormat('yyyy-MM-dd').format(controller.selectedDate.value),
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteInput() {
    return TextField(
      controller: controller.noteController,
      decoration: const InputDecoration(
        icon: Icon(Icons.note),
        labelText: '备注',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: controller.saveTransaction,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          '保存',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
