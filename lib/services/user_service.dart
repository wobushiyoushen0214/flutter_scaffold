/*
 * @Author: LiZhiWei
 * @Date: 2025-12-17 14:50:32
 * @LastEditors: LiZhiWei
 * @LastEditTime: 2025-12-17 14:52:09
 * @Description: 
 */
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/logger_util.dart';

class UserService extends GetxService {
  static const _keyToken = 'token';
  static const _keyUserId = 'user_id';
  static const _keyUserName = 'user_name';

  late SharedPreferences _prefs;

  final token = ''.obs;
  final userId = ''.obs;
  final userName = ''.obs;

  bool get isLoggedIn => token.value.isNotEmpty;

  Future<UserService> init() async {
    _prefs = await SharedPreferences.getInstance();

    token.value = _prefs.getString(_keyToken) ?? '';
    userId.value = _prefs.getString(_keyUserId) ?? '';
    userName.value = _prefs.getString(_keyUserName) ?? '';

    LoggerUtil.i('UserService Initialized, isLoggedIn=$isLoggedIn');
    return this;
  }

  Future<void> setUser({
    required String newToken,
    String? newUserId,
    String? newUserName,
  }) async {
    token.value = newToken;
    userId.value = newUserId ?? '';
    userName.value = newUserName ?? '';

    await _prefs.setString(_keyToken, token.value);
    await _prefs.setString(_keyUserId, userId.value);
    await _prefs.setString(_keyUserName, userName.value);

    LoggerUtil.i('UserService updated, isLoggedIn=$isLoggedIn');
  }

  Future<void> clearUser() async {
    token.value = '';
    userId.value = '';
    userName.value = '';

    await _prefs.remove(_keyToken);
    await _prefs.remove(_keyUserId);
    await _prefs.remove(_keyUserName);

    LoggerUtil.i('UserService cleared');
  }
}
