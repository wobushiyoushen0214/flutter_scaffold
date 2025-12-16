# 讯飞语音与大模型接入指南

本项目集成了科大讯飞 **MSC (语音听写/合成)** 和 **SparkChain (星火大模型)**。
由于 SDK 为私有库，**请务必下载对应的 SDK 文件并放入指定目录**。

## 1. 准备工作

1.  登录 [讯飞开放平台](https://www.xfyun.cn/)。
2.  进入控制台，找到你的应用 (AppID: `54548d09`)。
3.  开通以下服务：
    *   **语音听写** (ASR)
    *   **在线语音合成** (TTS)
    *   **星火认知大模型** (Spark LLM)
4.  下载 **MSC SDK** (Android/iOS) 和 **SparkChain SDK** (Android/iOS)。

## 2. Android 接入步骤

1.  **放置 Jar/AAR 包**：
    *   将 `Msc.jar` 放入 `android/app/libs/`。
    *   将 `SparkChain.aar` (如有) 放入 `android/app/libs/`。
2.  **放置 SO 库**：
    *   将 MSC SDK 的 `libs/arm64-v8a` 等文件夹放入 `android/app/src/main/jniLibs/`。
3.  **配置 build.gradle**：
    *   如果使用了 `SparkChain.aar`，确保 `dependencies` 中引用了它。
4.  **启用代码**：
    *   打开 `android/app/src/main/kotlin/.../IflytekPlugin.kt`。
    *   **取消注释** 所有的 import 语句 (包括 MSC 和 SparkChain)。
    *   **取消注释** `initSDK` 和 `startChat` 中的真实调用代码。
    *   **填入** 你的 `apiKey` 和 `apiSecret` 到 `lib/common/services/iflytek_service.dart` 中。

## 3. iOS 接入步骤

1.  **放置 Framework**：
    *   将 `iflyMSC.framework` 和 `SparkChain.framework` 放入 `ios/Runner/`。
2.  **Xcode 配置**：
    *   添加这两个 framework 到 "Frameworks, Libraries, and Embedded Content"，并设为 **Embed & Sign**。
3.  **启用代码**：
    *   打开 `ios/Runner/IflytekPlugin.swift`。
    *   **取消注释** `import SparkChain` 等相关代码。
    *   **取消注释** `initSDK` 和 `startChat` 中的真实调用代码。

## 4. 常见问题

*   **SparkChain 初始化失败**：请检查 `apiKey` 和 `apiSecret` 是否正确。
*   **模拟模式**：如果未放入 SDK，插件会自动降级为模拟模式，返回固定的测试回复。

## 5. Dart 层使用

`IflytekService` 提供了统一接口：
- `startListening()`: 语音听写
- `chatWithSpark(text)`: 调用星火大模型
- `speak(text)`: 语音合成

