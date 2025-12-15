part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const mainTab = _Paths.mainTab;
  static const home = _Paths.home;
}

abstract class _Paths {
  _Paths._();
  static const mainTab = '/';
  static const home = '/home';
}
