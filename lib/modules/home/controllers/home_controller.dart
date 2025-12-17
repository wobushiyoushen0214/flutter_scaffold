/*
 * @Author: LiZhiWei
 * @Date: 2025-12-15 15:04:27
 * @LastEditors: LiZhiWei
 * @LastEditTime: 2025-12-17 11:20:28
 * @Description: 
 */
import 'package:get/get.dart';
import '../../../utils/http/api_client.dart';
import '../../../utils/logger_util.dart';

class HomeController extends GetxController {
  final ApiClient _apiClient = ApiClient();

  final count = 0.obs;
  final isLoading = false.obs;

  final a = 0.obs;
  final b = 0.obs;

  @override
  void onInit() {
    super.onInit();
    LoggerUtil.d("HomeController Init");
  }

  void increment() => count.value++;

  void add(int a, int b) => count.value = a + b;

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
