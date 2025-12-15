import 'package:get/get.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/main_tab/bindings/main_tab_binding.dart';
import '../modules/main_tab/views/main_tab_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.mainTab;

  static final routes = [
    GetPage(
      name: _Paths.mainTab,
      page: () => const MainTabView(),
      binding: MainTabBinding(),
    ),
    GetPage(
      name: _Paths.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
  ];
}
