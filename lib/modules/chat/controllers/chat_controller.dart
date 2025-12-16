/*
 * @Author: LiZhiWei
 * @Date: 2025-12-16 11:01:10
 * @LastEditors: LiZhiWei
 * @LastEditTime: 2025-12-16 15:23:29
 * @Description: 
 */
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter_getx_dio_scaffold/common/services/iflytek_service.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;

  ChatMessage({required this.text, required this.isUser})
    : time = DateTime.now();
}

class ChatController extends GetxController {
  final IflytekService iflytekService = Get.put(IflytekService());
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final ScrollController scrollController = ScrollController();
  final String appId = "54548d09";
  final String apiKey =
      "8a2bed729629cf1da0a039af30d1e6a5"; // TODO: 请填入讯飞控制台获取的 APIKey
  final String apiSecret =
      "YjY3MzJlOWJiMzkyOTI2Y2Y3MWJlNGQz"; // TODO: 请填入讯飞控制台获取的 APISecret

  @override
  void onInit() {
    super.onInit();
    _initIflytek();

    // 监听识别结果，实时更新到当前正在输入的用户的消息中（可选）
    // 这里简单处理：当识别结束或有结果时，我们暂存到输入框或者直接发送
    ever(iflytekService.recognizedText, (text) {
      if (text.isNotEmpty && iflytekService.isListening.value) {
        // 实际场景中，可能需要一个临时状态来显示正在识别的文字
        // 这里简化：不实时上屏，等用户手动发送或自动发送
        // 或者我们可以做一个“正在输入”的效果
      }
    });

    // 监听是否停止录音，如果停止了，把结果作为一条消息发送
    ever(iflytekService.isListening, (listening) {
      if (!listening && iflytekService.recognizedText.value.isNotEmpty) {
        sendMessage(iflytekService.recognizedText.value);
        // 使用星火大模型
        iflytekService.chatWithSpark(iflytekService.recognizedText.value);
      }
    });

    // 监听星火大模型回复
    ever(iflytekService.sparkResponse, (text) {
      if (text.isNotEmpty) {
        // 实时更新最后一条消息（如果是AI消息）或者新增一条
        if (messages.isNotEmpty &&
            !messages.last.isUser &&
            iflytekService.isSparkThinking.value) {
          // 更新最后一条
          messages[messages.length - 1] = ChatMessage(
            text: text,
            isUser: false,
          );
          messages.refresh(); // 刷新 UI
        } else if (iflytekService.isSparkThinking.value &&
            (messages.isEmpty || messages.last.isUser)) {
          // 新增一条 AI 消息占位
          messages.add(ChatMessage(text: text, isUser: false));
        }
      }
    });
  }

  Future<void> _initIflytek() async {
    await requestPermissions();
    await iflytekService.init(appId, apiKey: apiKey, apiSecret: apiSecret);
    messages.add(
      ChatMessage(text: "你好！我是你的虚拟数字人助手。点击麦克风开始对话吧。", isUser: false),
    );
  }

  Future<void> requestPermissions() async {
    await [Permission.microphone, Permission.storage].request();
  }

  void startListening() {
    iflytekService.startListening();
  }

  void stopListening() {
    iflytekService.stopListening();
  }

  void sendMessage(String text) {
    messages.add(ChatMessage(text: text, isUser: true));
    update(); // 强制刷新 UI 如果需要
  }

  // void _mockAiResponse(String userText) async { ... }
}
