/*
 * @Author: LiZhiWei
 * @Date: 2025-12-15 15:03:48
 * @LastEditors: LiZhiWei
 * @LastEditTime: 2025-12-15 17:23:13
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'common/services/global_service.dart';
import 'common/services/storage_service.dart';

class Global {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Get.putAsync(() => GlobalService().init());
    await Get.putAsync(() => StorageService().init());
  }
}
