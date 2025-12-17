import 'package:get/get.dart';
import '../../../services/user_service.dart';
import '../../../utils/http/api_client.dart';
import '../../../utils/logger_util.dart';

class LoginController extends GetxController {
  final username = ''.obs;
  final password = ''.obs;
  final isLoading = false.obs;
  final isPasswordHidden = true.obs;

  final ApiClient _apiClient = ApiClient();

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> login() async {
    if (username.value.isEmpty || password.value.isEmpty) {
      Get.snackbar('提示', '用户名和密码不能为空');
      return;
    }

    try {
      isLoading.value = true;

      final response = await _apiClient.post(
        '/login',
        data: {'username': username.value, 'password': password.value},
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        final token = data['token']?.toString() ?? '';
        final userId = data['userId']?.toString();
        final userName = data['userName']?.toString() ?? username.value;

        if (token.isEmpty) {
          Get.snackbar('登录失败', '未返回 token');
          return;
        }

        final userService = Get.find<UserService>();
        await userService.setUser(
          newToken: token,
          newUserId: userId,
          newUserName: userName,
        );

        LoggerUtil.i('Login success, navigate to mainTab');
        Get.offAllNamed('/'); // Routes.mainTab
      } else {
        Get.snackbar('登录失败', '响应数据格式不正确');
      }
    } catch (e) {
      LoggerUtil.e(e);
      Get.snackbar('登录失败', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
