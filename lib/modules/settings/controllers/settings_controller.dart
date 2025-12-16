/*
 * @Author: LiZhiWei
 * @Date: 2025-12-15 17:26:13
 * @LastEditors: LiZhiWei
 * @LastEditTime: 2025-12-15 17:26:14
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  final RxBool isDarkMode = (Get.isDarkMode).obs;

  void toggleTheme(bool isDark) {
    isDarkMode.value = isDark;
    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }
}
