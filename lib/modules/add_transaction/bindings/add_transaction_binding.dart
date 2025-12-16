/*
 * @Author: LiZhiWei
 * @Date: 2025-12-15 17:27:11
 * @LastEditors: LiZhiWei
 * @LastEditTime: 2025-12-15 17:27:12
 * @Description: 
 */
import 'package:get/get.dart';
import '../controllers/add_transaction_controller.dart';

class AddTransactionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddTransactionController>(() => AddTransactionController());
  }
}
