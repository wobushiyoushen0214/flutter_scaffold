/*
 * @Author: LiZhiWei
 * @Date: 2025-12-15 16:01:51
 * @LastEditors: LiZhiWei
 * @LastEditTime: 2025-12-15 17:50:56
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_tab_controller.dart';
import '../../home/views/home_view.dart';
import '../../statistics/views/statistics_view.dart';
import '../../settings/views/settings_view.dart';
import '../../../routes/app_pages.dart';
import '../../../common/constants/app_colors.dart';

class MainTabView extends GetView<MainTabController> {
  const MainTabView({super.key});

  @override
  Widget build(BuildContext context) {
    // 确保这些Controller被初始化，即使它们是在各Tab的Binding中懒加载的
    // 由于我们是在MainTab中直接使用View，View会自动触发Binding（如果配置了GetPage）
    // 但在这里我们是直接嵌入Widget，所以需要手动处理或者依赖全局Binding
    // 更好的方式是使用 IndexedStack 保持状态

    final tabBodies = [
      const HomeView(),
      const StatisticsView(),
      const SettingsView(),
    ];

    return Obx(() {
      final index = controller.currentIndex.value;

      return Scaffold(
        body: IndexedStack(index: index, children: tabBodies),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: index,
          onTap: controller.onTabChanged,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
            BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: '统计'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: '设置'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Get.toNamed(Routes.addTransaction),
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.add, color: Colors.white),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      );
    });
  }
}
