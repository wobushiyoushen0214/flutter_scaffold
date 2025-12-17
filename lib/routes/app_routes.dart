part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const login = _Paths.login;
  static const mainTab = _Paths.mainTab;
  static const home = _Paths.home;
}

abstract class _Paths {
  _Paths._();
  static const login = '/login';
  static const mainTab = '/';
  static const home = '/home';
}
