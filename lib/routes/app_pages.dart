/*
 * @Author: LiZhiWei
 * @Date: 2025-12-16 10:57:33
 * @LastEditors: LiZhiWei
 * @LastEditTime: 2025-12-16 11:02:02
 * @Description: 
 */
import 'package:get/get.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/main_tab/bindings/main_tab_binding.dart';
import '../modules/main_tab/views/main_tab_view.dart';
import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chat_view.dart';

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
    GetPage(
      name: _Paths.chat,
      page: () => const ChatView(),
      binding: ChatBinding(),
    ),
  ];
}
