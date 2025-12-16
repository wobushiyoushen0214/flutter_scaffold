import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class IflytekService extends GetxService {
  static const MethodChannel _channel = MethodChannel(
    'com.example.flutter_getx_dio_scaffold/iflytek',
  );

  // 用于广播识别结果
  final RxString recognizedText = ''.obs;
  final RxString sparkResponse = ''.obs; // 保持变量名兼容，实际是 Ollama 回复
  final RxString errorMsg = ''.obs;
  final RxBool isListening = false.obs;
  final RxBool isSparkThinking = false.obs; // 保持变量名兼容

  final Dio _dio = Dio();
  final String _ollamaUrl = "http://192.168.110.251:11434/api/generate";

  @override
  void onInit() {
    super.onInit();
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  Future<void> init(String appId, {String? apiKey, String? apiSecret}) async {
    try {
      // 初始化讯飞语音 SDK (SparkChain)
      await _channel.invokeMethod('init', {
        'appId': appId,
        'apiKey': apiKey,
        'apiSecret': apiSecret,
      });
    } on PlatformException catch (e) {
      errorMsg.value = "Init failed: ${e.message}";
    }
  }

  Future<void> chatWithSpark(String question) async {
    try {
      isSparkThinking.value = true;
      sparkResponse.value = '';

      final response = await _dio.post(
        _ollamaUrl,
        data: {"model": "qwen2.5:7b", "prompt": question, "stream": false},
      );

      if (response.statusCode == 200) {
        final text = response.data['response'] as String;
        sparkResponse.value = text;
        isSparkThinking.value = false;
      } else {
        throw Exception("Status code: ${response.statusCode}");
      }
    } catch (e) {
      isSparkThinking.value = false;
      errorMsg.value = "Ollama Chat failed: $e";
    }
  }

  Future<void> startListening() async {
    try {
      isListening.value = true;
      recognizedText.value = ''; // 清空上次结果
      await _channel.invokeMethod('startListening');
    } on PlatformException catch (e) {
      isListening.value = false;
      errorMsg.value = "Start listening failed: ${e.message}";
    }
  }

  Future<void> stopListening() async {
    try {
      await _channel.invokeMethod('stopListening');
      isListening.value = false;
    } on PlatformException catch (e) {
      errorMsg.value = "Stop listening failed: ${e.message}";
    }
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onResult':
        // 收到识别结果
        // 结果通常是 JSON 格式，或者是部分文本，这里假设原生层已经处理好拼接
        // 或者原生层分段发送，这里做拼接
        final String text = call.arguments as String;
        // 简单的追加逻辑，实际可能需要根据 isLast 标志位处理
        recognizedText.value += text;
        break;
      case 'onEndOfSpeech':
        isListening.value = false;
        break;
      case 'onError':
        isListening.value = false;
        errorMsg.value = call.arguments as String;
        break;
      case 'onSparkResult':
        // 星火大模型返回的片段
        final String text = call.arguments as String;
        sparkResponse.value += text;
        break;
      case 'onSparkError':
        isSparkThinking.value = false;
        errorMsg.value = "Spark Error: ${call.arguments}";
        break;
      case 'onSparkCompleted':
        isSparkThinking.value = false;
        break;
      default:
        print('Unknown method ${call.method}');
    }
  }
}
