/*
 * @Author: LiZhiWei
 * @Date: 2025-12-15 17:26:22
 * @LastEditors: LiZhiWei
 * @LastEditTime: 2025-12-15 17:57:05
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';
import '../../../routes/app_pages.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: ListView(
        children: [
          Obx(
            () => SwitchListTile(
              title: const Text('深色模式'),
              value: controller.isDarkMode.value,
              onChanged: controller.toggleTheme,
              secondary: const Icon(Icons.dark_mode),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('分类管理'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Get.toNamed(Routes.categoryManager);
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('关于'),
            subtitle: const Text('版本 1.0.0'),
          ),
        ],
      ),
    );
  }
}
