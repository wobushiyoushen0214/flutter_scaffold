import 'package:get/get.dart';
import '../controllers/main_tab_controller.dart';
import '../../home/controllers/home_controller.dart';

class MainTabBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainTabController>(() => MainTabController());
    Get.lazyPut<HomeController>(() => HomeController());
  }
}

