/*
 * @Author: LiZhiWei
 * @Date: 2025-12-15 16:01:49
 * @LastEditors: LiZhiWei
 * @LastEditTime: 2025-12-15 17:28:37
 * @Description: 
 */
import 'package:get/get.dart';
import '../controllers/main_tab_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../../common/controllers/category_controller.dart';
import '../../../common/controllers/transaction_controller.dart';
import '../../statistics/controllers/statistics_controller.dart';
import '../../settings/controllers/settings_controller.dart';

class MainTabBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainTabController>(() => MainTabController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<StatisticsController>(() => StatisticsController());
    Get.lazyPut<SettingsController>(() => SettingsController());
    Get.put<CategoryController>(CategoryController());
    Get.put<TransactionController>(TransactionController());
  }
}
