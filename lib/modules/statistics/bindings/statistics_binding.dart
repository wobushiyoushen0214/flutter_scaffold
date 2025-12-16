/*
 * @Author: LiZhiWei
 * @Date: 2025-12-15 17:26:04
 * @LastEditors: LiZhiWei
 * @LastEditTime: 2025-12-15 17:26:06
 * @Description: 
 */
import 'package:get/get.dart';
import '../controllers/statistics_controller.dart';

class StatisticsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StatisticsController>(() => StatisticsController());
  }
}
