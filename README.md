# Flutter GetX Dio Scaffold 使用手册

本项目是一个基于 Flutter + GetX + Dio + ScreenUtil 的高效开发脚手架，旨在提供清晰的架构和开箱即用的功能，帮助开发者快速构建高质量的 Flutter 应用。

## 1. 技术栈

- **Flutter**: UI 框架 (SDK ^3.8.1)
- **GetX**: 状态管理、依赖注入、路由管理 (^4.7.3)
- **Dio**: 强大的 HTTP 网络请求库 (^5.9.0)
- **flutter_screenutil**: 屏幕适配方案 (^5.9.3)
- **logger**: 美观的日志打印 (^2.6.2)
- **shared_preferences**: 本地轻量级存储 (^2.5.3)

## 2. 目录结构

```text
lib/
├── common/             # 通用模块
│   ├── constants/      # 常量定义 (如颜色 AppColors、字符串 AppStrings)
│   ├── services/       # 全局服务 (如 GlobalService 用于 SharedPreferences)
│   └── utils/          # 工具类 (如 LoggerUtil)
├── data/               # 数据层
│   └── api/            # API 相关
│       ├── api_client.dart    # Dio 封装 (拦截器、错误处理)
│       └── api_constants.dart # API 常量 (BaseURL, Timeout)
├── modules/            # 业务模块 (按功能划分，采用 GetX Pattern)
│   └── home/           # 示例模块
│       ├── bindings/   # 依赖注入 (Binding)
│       ├── controllers/# 业务逻辑 (Controller)
│       └── views/      # UI 界面 (View)
├── routes/             # 路由管理
│   ├── app_pages.dart  # 路由注册表
│   └── app_routes.dart # 路由名称定义
├── global.dart         # 全局初始化配置
└── main.dart           # 应用程序入口
```

## 3. 核心功能使用指南

### 3.1 创建新模块 (GetX Pattern)

在 `lib/modules/` 下创建新模块文件夹，例如 `profile`，建议包含以下三个子目录：

1.  **View (`views/profile_view.dart`)**:
    ```dart
    import 'package:flutter/material.dart';
    import 'package:get/get.dart';
    import '../controllers/profile_controller.dart';

    class ProfileView extends GetView<ProfileController> {
      const ProfileView({super.key});

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(title: const Text('Profile')),
          body: Center(child: Text("User Profile")),
        );
      }
    }
    ```

2.  **Controller (`controllers/profile_controller.dart`)**:
    ```dart
    import 'package:get/get.dart';

    class ProfileController extends GetxController {
      final username = 'User'.obs;

      @override
      void onInit() {
        super.onInit();
        // 初始化逻辑
      }
    }
    ```

3.  **Binding (`bindings/profile_binding.dart`)**:
    ```dart
    import 'package:get/get.dart';
    import '../controllers/profile_controller.dart';

    class ProfileBinding extends Bindings {
      @override
      void dependencies() {
        Get.lazyPut<ProfileController>(() => ProfileController());
      }
    }
    ```

### 3.2 路由管理

1.  **定义路径**: 在 `lib/routes/app_routes.dart` 中添加：
    ```dart
    abstract class Routes {
      static const profile = _Paths.profile;
    }

    abstract class _Paths {
      static const profile = '/profile';
    }
    ```

2.  **注册页面**: 在 `lib/routes/app_pages.dart` 中添加 `GetPage`：
    ```dart
    GetPage(
      name: _Paths.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    ```

3.  **页面跳转**:
    ```dart
    Get.toNamed(Routes.profile);
    ```

### 3.3 网络请求 (Dio)

项目封装了 `ApiClient` 单例，内置了日志拦截器和基础错误处理。

**使用示例**:
```dart
// 在 Controller 中调用
Future<void> getUserData() async {
  try {
    final response = await ApiClient().get('/users/1');
    // 处理 response.data
  } catch (e) {
    // 错误处理
  }
}
```

**配置**:
可在 `lib/data/api/api_constants.dart` 中修改 `baseUrl`、`connectionTimeout` 等配置。

### 3.4 屏幕适配

项目使用 `flutter_screenutil`，在 `main.dart` 中已初始化 (设计稿尺寸默认为 375x812)。

**使用方法**:
- **宽度**: `.w` (例如 `100.w`)
- **高度**: `.h` (例如 `100.h`)
- **字体**: `.sp` (例如 `16.sp`)
- **屏幕宽**: `1.sw`
- **屏幕高**: `1.sh`

```dart
Container(
  width: 200.w,
  height: 50.h,
  child: Text('Hello', style: TextStyle(fontSize: 18.sp)),
)
```

### 3.5 全局服务 & 本地存储

`GlobalService` (lib/common/services/global_service.dart) 在应用启动时通过 `Global.init()` 初始化，并持有 `SharedPreferences` 实例。

**使用方法**:
```dart
// 获取 Service
final globalService = Get.find<GlobalService>();

// 存储数据
await globalService.prefs.setString('token', 'your_token');

// 读取数据
String? token = globalService.prefs.getString('token');
```

### 3.6 日志工具

使用 `LoggerUtil` 替代 `print`，输出带有格式和颜色的日志。

```dart
LoggerUtil.d("Debug message"); // 调试信息
LoggerUtil.i("Info message");  // 一般信息
LoggerUtil.w("Warning message"); // 警告
LoggerUtil.e("Error message");   // 错误
```

## 4. 开发流程建议

1.  **需求分析**: 确定页面和功能。
2.  **路由定义**: 在 `routes` 目录下定义好页面路径。
3.  **模块创建**: 在 `modules` 下创建对应的 View, Controller, Binding。
4.  **UI 开发**: 使用 `ScreenUtil` 进行响应式布局开发。
5.  **逻辑实现**: 在 Controller 中编写业务逻辑，调用 `ApiClient` 与后端交互。
6.  **状态绑定**: 使用 `Obx` 或 `GetBuilder` 将 Controller 的数据绑定到 View。

## 5. 运行项目

```bash
# 1. 获取依赖
flutter pub get

# 2. 运行项目
flutter run
```
