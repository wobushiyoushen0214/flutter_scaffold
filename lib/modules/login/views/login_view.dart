import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/login_controller.dart';
import '../../../constants/app_colors.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;

    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(color: AppColors.grey.withValues(alpha: 0.25)),
    );

    return Scaffold(
      body: TapRegion(
        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primary.withValues(alpha: 0.10),
                AppColors.background,
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                20.w,
                56.h,
                20.w,
                viewInsets.bottom + 24.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 64.w,
                      height: 64.w,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                      child: Icon(
                        Icons.lock_rounded,
                        color: AppColors.primary,
                        size: 34.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    '欢迎回来',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '登录后将自动保存 token，并在 401 时自动退出',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.sp,
                      height: 1.4,
                      color: AppColors.black.withValues(alpha: 0.55),
                    ),
                  ),
                  SizedBox(height: 28.h),
                  Card(
                    elevation: 0,
                    color: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      side: BorderSide(
                        color: AppColors.grey.withValues(alpha: 0.16),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.h,
                      ),
                      child: Column(
                        children: [
                          TextField(
                            decoration: InputDecoration(
                              labelText: '用户名',
                              prefixIcon: const Icon(
                                Icons.person_outline_rounded,
                              ),
                              border: inputBorder,
                              enabledBorder: inputBorder,
                              focusedBorder: inputBorder.copyWith(
                                borderSide: BorderSide(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.55,
                                  ),
                                ),
                              ),
                              filled: true,
                              fillColor: AppColors.background.withValues(
                                alpha: 0.65,
                              ),
                            ),
                            textInputAction: TextInputAction.next,
                            onChanged: (value) =>
                                controller.username.value = value.trim(),
                          ),
                          SizedBox(height: 12.h),
                          Obx(
                            () => TextField(
                              decoration: InputDecoration(
                                labelText: '密码',
                                prefixIcon: const Icon(
                                  Icons.lock_outline_rounded,
                                ),
                                suffixIcon: IconButton(
                                  onPressed:
                                      controller.togglePasswordVisibility,
                                  icon: Icon(
                                    controller.isPasswordHidden.value
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                  ),
                                ),
                                border: inputBorder,
                                enabledBorder: inputBorder,
                                focusedBorder: inputBorder.copyWith(
                                  borderSide: BorderSide(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.55,
                                    ),
                                  ),
                                ),
                                filled: true,
                                fillColor: AppColors.background.withValues(
                                  alpha: 0.65,
                                ),
                              ),
                              obscureText: controller.isPasswordHidden.value,
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) => controller.login(),
                              onChanged: (value) =>
                                  controller.password.value = value,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Obx(
                            () => SizedBox(
                              width: double.infinity,
                              height: 48.h,
                              child: ElevatedButton(
                                onPressed: controller.isLoading.value
                                    ? null
                                    : controller.login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: AppColors.white,
                                  disabledBackgroundColor: AppColors.primary
                                      .withValues(alpha: 0.45),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                                child: controller.isLoading.value
                                    ? SizedBox(
                                        height: 18.sp,
                                        width: 18.sp,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        '登录',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
