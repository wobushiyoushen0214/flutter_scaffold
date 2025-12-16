/*
 * @Author: LiZhiWei
 * @Date: 2025-12-15 15:05:24
 * @LastEditors: LiZhiWei
 * @LastEditTime: 2025-12-15 17:56:44
 * @Description: 
 */
import 'package:get/get.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/main_tab/bindings/main_tab_binding.dart';
import '../modules/main_tab/views/main_tab_view.dart';
import '../modules/add_transaction/bindings/add_transaction_binding.dart';
import '../modules/add_transaction/views/add_transaction_view.dart';
import '../modules/statistics/bindings/statistics_binding.dart';
import '../modules/statistics/views/statistics_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/category_manager/bindings/category_manager_binding.dart';
import '../modules/category_manager/views/category_manager_view.dart';

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
      name: _Paths.addTransaction,
      page: () => const AddTransactionView(),
      binding: AddTransactionBinding(),
    ),
    GetPage(
      name: _Paths.statistics,
      page: () => const StatisticsView(),
      binding: StatisticsBinding(),
    ),
    GetPage(
      name: _Paths.settings,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.categoryManager,
      page: () => const CategoryManagerView(),
      binding: CategoryManagerBinding(),
    ),
  ];
}
