import 'package:get/get.dart';
import '../../../data/api/api_client.dart';
import '../../../common/utils/logger_util.dart';

class HomeController extends GetxController {
  // ignore: unused_field
  final ApiClient _apiClient = ApiClient();
  
  final count = 0.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    LoggerUtil.d("HomeController Init");
    // fetchData(); // Example call
  }

  void increment() => count.value++;

  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      // final response = await _apiClient.get('/todos/1');
      // LoggerUtil.i(response.data);
      // Simulate network delay
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
