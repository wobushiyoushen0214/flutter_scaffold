/*
 * @Author: LiZhiWei
 * @Date: 2025-12-17 10:35:40
 * @LastEditors: LiZhiWei
 * @LastEditTime: 2025-12-17 14:53:29
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'services/user_service.dart';

class Global {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Get.putAsync(() => UserService().init());
  }
}
