/*
 * @Author: LiZhiWei
 * @Date: 2025-12-15 15:05:17
 * @LastEditors: LiZhiWei
 * @LastEditTime: 2025-12-15 17:56:34
 * @Description: 
 */
part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const mainTab = _Paths.mainTab;
  static const home = _Paths.home;
  static const addTransaction = _Paths.addTransaction;
  static const statistics = _Paths.statistics;
  static const settings = _Paths.settings;
  static const categoryManager = _Paths.categoryManager;
}

abstract class _Paths {
  _Paths._();
  static const mainTab = '/';
  static const home = '/home';
  static const addTransaction = '/add-transaction';
  static const statistics = '/statistics';
  static const settings = '/settings';
  static const categoryManager = '/category-manager';
}
