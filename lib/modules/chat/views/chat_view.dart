import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_getx_dio_scaffold/modules/chat/controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'AI 数字人对话',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              // 自动滚动到底部
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (controller.scrollController.hasClients) {
                  controller.scrollController.animateTo(
                    controller.scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                }
              });

              return ListView.builder(
                controller: controller.scrollController,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final msg = controller.messages[index];
                  return _buildMessageItem(msg);
                },
              );
            }),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildMessageItem(ChatMessage msg) {
    final isUser = msg.isUser;
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) _buildAvatar(isUser),
          SizedBox(width: 8.w),
          Flexible(
            child: Column(
              crossAxisAlignment: isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: isUser ? const Color(0xFF007AFF) : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.r),
                      topRight: Radius.circular(16.r),
                      bottomLeft: Radius.circular(isUser ? 16.r : 4.r),
                      bottomRight: Radius.circular(isUser ? 4.r : 16.r),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    msg.text,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: isUser ? Colors.white : const Color(0xFF333333),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          if (isUser) _buildAvatar(isUser),
        ],
      ),
    );
  }

  Widget _buildAvatar(bool isUser) {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: isUser ? Colors.blue[100] : Colors.deepPurple[100],
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Icon(
        isUser ? Icons.person : Icons.smart_toy,
        color: isUser ? const Color(0xFF007AFF) : Colors.deepPurple,
        size: 24.w,
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 30.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() {
            String statusText = "按住说话";
            if (controller.iflytekService.isListening.value) {
              statusText = "松开 发送";
            } else if (controller.iflytekService.isSparkThinking.value) {
              statusText = "正在思考...";
            }
            return Text(
              statusText,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            );
          }),
          SizedBox(height: 16.h),
          GestureDetector(
            onLongPressStart: (_) => controller.startListening(),
            onLongPressEnd: (_) => controller.stopListening(),
            child: Obx(
              () => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                height: 56.h,
                decoration: BoxDecoration(
                  color: controller.iflytekService.isListening.value
                      ? const Color(0xFFFF3B30) // 录音中变红
                      : const Color(0xFF007AFF),
                  borderRadius: BorderRadius.circular(28.h),
                  boxShadow: [
                    BoxShadow(
                      color:
                          (controller.iflytekService.isListening.value
                                  ? const Color(0xFFFF3B30)
                                  : const Color(0xFF007AFF))
                              .withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      controller.iflytekService.isListening.value
                          ? Icons.mic
                          : Icons.keyboard_voice,
                      color: Colors.white,
                      size: 24.w,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      controller.iflytekService.isListening.value
                          ? "正在听..."
                          : "按住说话",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Obx(() {
            if (controller.iflytekService.errorMsg.value.isNotEmpty) {
              return Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: Text(
                  controller.iflytekService.errorMsg.value,
                  style: TextStyle(color: Colors.red, fontSize: 12.sp),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
