/*
 * @Author: LiZhiWei
 * @Date: 2025-12-15 17:56:24
 * @LastEditors: LiZhiWei
 * @LastEditTime: 2025-12-15 17:56:25
 * @Description: 
 */
import 'package:get/get.dart';
import '../controllers/category_manager_controller.dart';

class CategoryManagerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryManagerController>(() => CategoryManagerController());
  }
}
