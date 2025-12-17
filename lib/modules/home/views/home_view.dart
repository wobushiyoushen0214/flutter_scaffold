/*
 * @Author: LiZhiWei
 * @Date: 2025-12-15 15:05:09
 * @LastEditors: LiZhiWei
 * @LastEditTime: 2025-12-17 11:52:05
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/home_controller.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_colors.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(AppStrings.homeTitle),
      //   centerTitle: true,
      //   backgroundColor: AppColors.primary,
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Count value:', style: TextStyle(fontSize: 20.sp)),
            SizedBox(height: 10.h),
            Obx(
              () => Text(
                '${controller.count.value}',
                style: TextStyle(
                  fontSize: 40.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Obx(
              () => controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: controller.fetchData,
                      child: const Text('Simulate API Call'),
                    ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: InputDecorator(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter a number',
                ),
                child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) =>
                      controller.a.value = int.tryParse(value) ?? 0,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: InputDecorator(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter a number',
                ),
                child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) =>
                      controller.b.value = int.tryParse(value) ?? 0,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: () =>
                  controller.add(controller.a.value, controller.b.value),
              child: const Text('Add a + b'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
