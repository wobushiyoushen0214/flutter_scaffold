/*
 * @Author: LiZhiWei
 * @Date: 2025-12-15 15:02:27
 * @LastEditors: LiZhiWei
 * @LastEditTime: 2025-12-15 15:06:49
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'global.dart';
import 'routes/app_pages.dart';
import 'common/constants/app_strings.dart';
import 'common/constants/app_colors.dart';

void main() async {
  await Global.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // Design size in Figma/Sketch
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: AppStrings.appName,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: AppColors.backgroundLight,
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              secondary: AppColors.secondary,
              surface: AppColors.surfaceLight,
              onSurface: AppColors.textPrimaryLight,
            ),
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.backgroundLight,
              elevation: 0,
              iconTheme: IconThemeData(color: AppColors.textPrimaryLight),
              titleTextStyle: TextStyle(
                color: AppColors.textPrimaryLight,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: AppColors.backgroundDark,
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              secondary: AppColors.secondary,
              surface: AppColors.surfaceDark,
              onSurface: AppColors.textPrimaryDark,
            ),
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.backgroundDark,
              elevation: 0,
              iconTheme: IconThemeData(color: AppColors.textPrimaryDark),
              titleTextStyle: TextStyle(
                color: AppColors.textPrimaryDark,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          themeMode: ThemeMode
              .system, // Default to system, can be changed via Get.changeThemeMode
          initialRoute: AppPages.initial,
          getPages: AppPages.routes,
        );
      },
    );
  }
}
