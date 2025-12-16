/*
 * @Author: LiZhiWei
 * @Date: 2025-12-16 11:01:18
 * @LastEditors: LiZhiWei
 * @LastEditTime: 2025-12-16 11:01:19
 * @Description: 
 */
import 'package:get/get.dart';
import 'package:flutter_getx_dio_scaffold/modules/chat/controllers/chat_controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatController>(() => ChatController());
  }
}
