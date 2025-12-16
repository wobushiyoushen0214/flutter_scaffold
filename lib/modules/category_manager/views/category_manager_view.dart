import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../controllers/category_manager_controller.dart';
import 'package:flutter_getx_dio_scaffold/common/constants/app_colors.dart';

class CategoryManagerView extends GetView<CategoryManagerController> {
  const CategoryManagerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('分类管理'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddCategoryDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTypeSelector(),
          Expanded(
            child: Obx(() {
              final categories = controller.currentCategories;
              if (categories.isEmpty) {
                return const Center(child: Text('暂无分类'));
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: categories.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Card(
                        elevation: 0,
                        color: Get.theme.cardTheme.color,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Color(
                              category.colorValue,
                            ).withValues(alpha: 0.1),
                            child: Icon(
                              IconData(
                                category.iconCode,
                                fontFamily: 'MaterialIcons',
                              ),
                              color: Color(category.colorValue),
                            ),
                          ),
                          title: Text(category.name),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                            onPressed: () => _confirmDelete(category.id),
                          ),
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: (50 * index).ms)
                      .slideX(begin: 0.2, end: 0);
                },
              );
            }),
          ),
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
      final isSelected = controller.selectedType.value == value;
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

  void _confirmDelete(String id) {
    Get.defaultDialog(
      title: '确认删除',
      middleText: '删除该分类将无法恢复，是否继续？',
      textConfirm: '删除',
      textCancel: '取消',
      confirmTextColor: Colors.white,
      onConfirm: () {
        controller.deleteCategory(id);
        Get.back();
      },
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    // Reset selections
    controller.nameController.clear();
    controller.selectedIcon.value = Icons.category;
    controller.selectedColor.value = Colors.blue;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Get.theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '添加分类',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller.nameController,
                decoration: const InputDecoration(
                  labelText: '分类名称',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.edit),
                ),
              ),
              const SizedBox(height: 16),
              const Text('选择图标', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.availableIcons.length,
                  itemBuilder: (context, index) {
                    final icon = controller.availableIcons[index];
                    return Obx(() {
                      final isSelected = controller.selectedIcon.value == icon;
                      return GestureDetector(
                        onTap: () => controller.selectIcon(icon),
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary.withValues(alpha: 0.1)
                                : Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.grey.withValues(alpha: 0.3),
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            icon,
                            color: isSelected ? AppColors.primary : Colors.grey,
                          ),
                        ),
                      );
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),
              const Text('选择颜色', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.availableColors.length,
                  itemBuilder: (context, index) {
                    final color = controller.availableColors[index];
                    return Obx(() {
                      final isSelected =
                          controller.selectedColor.value == color;
                      return GestureDetector(
                        onTap: () => controller.selectColor(color),
                        child: Container(
                          width: 40,
                          height: 40,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: isSelected
                                ? Border.all(color: Colors.white, width: 3)
                                : null,
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: color.withValues(alpha: 0.5),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : null,
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 20,
                                )
                              : null,
                        ),
                      );
                    });
                  },
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.addCategory,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    '保存',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20), // Bottom padding
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}
