/*
 * @Author: LiZhiWei
 * @Date: 2025-12-15 17:26:30
 * @LastEditors: LiZhiWei
 * @LastEditTime: 2025-12-15 17:26:31
 * @Description: 
 */
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(() => SettingsController());
  }
}
