/*
 * @Author: LiZhiWei
 * @Date: 2025-12-15 15:04:27
 * @LastEditors: LiZhiWei
 * @LastEditTime: 2025-12-15 17:35:57
 * @Description: 
 */
import 'package:get/get.dart';
// import '../../../data/api/api_client.dart';
import '../../../common/utils/logger_util.dart';

class HomeController extends GetxController {
  // final ApiClient _apiClient = ApiClient();

  final count = 0.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    LoggerUtil.d("HomeController Init");
  }

  void increment() => count.value++;

  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 2));
      LoggerUtil.i("Data fetched successfully");
    } catch (e) {
      LoggerUtil.e(e);
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
