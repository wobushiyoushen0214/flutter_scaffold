/*
 * @Author: LiZhiWei
 * @Date: 2025-12-16 10:57:33
 * @LastEditors: LiZhiWei
 * @LastEditTime: 2025-12-16 11:01:48
 * @Description: 
 */
part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const mainTab = _Paths.mainTab;
  static const home = _Paths.home;
  static const chat = _Paths.chat;
}

abstract class _Paths {
  _Paths._();
  static const mainTab = '/';
  static const home = '/home';
  static const chat = '/chat';
}
