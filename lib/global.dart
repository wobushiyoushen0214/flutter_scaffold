import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'common/services/global_service.dart';

class Global {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Get.putAsync(() => GlobalService().init());
  }
}
