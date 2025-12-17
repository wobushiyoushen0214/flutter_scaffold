/*
 * @Author: LiZhiWei
 * @Date: 2025-12-15 16:01:51
 * @LastEditors: LiZhiWei
 * @LastEditTime: 2025-12-15 16:06:01
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_tab_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/views/home_view.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_colors.dart';

class MainTabView extends GetView<MainTabController> {
  const MainTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final tabTitles = [AppStrings.homeTitle, 'Discover', 'Profile'];

    final tabBodies = [
      const HomeView(),
      const Center(child: Text('Discover Page')),
      const Center(child: Text('Profile Page')),
    ];

    return Obx(() {
      final index = controller.currentIndex.value;

      return Scaffold(
        // appBar: AppBar(
        //   title: Text(tabTitles[index]),
        //   centerTitle: true,
        //   backgroundColor: AppColors.primary,
        // ),
        body: tabBodies[index],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: index,
          onTap: controller.onTabChanged,
          selectedItemColor: AppColors.primary,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Discover',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
        floatingActionButton: index == 0
            ? FloatingActionButton(
                onPressed: homeController.increment,
                child: const Icon(Icons.add),
              )
            : null,
      );
    });
  }
}
