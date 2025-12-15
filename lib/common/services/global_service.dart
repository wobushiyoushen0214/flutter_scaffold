import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/logger_util.dart';

class GlobalService extends GetxService {
  late SharedPreferences _prefs;

  Future<GlobalService> init() async {
    _prefs = await SharedPreferences.getInstance();
    LoggerUtil.i("GlobalService Initialized");
    return this;
  }

  SharedPreferences get prefs => _prefs;
}
