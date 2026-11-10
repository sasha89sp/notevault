import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecureStorageService {
  static const _kWebdavUser = 'webdav.user';
  static const _kWebdavPassword = 'webdav.password';
  static const _kCurrentUser = 'auth.currentUserId';
  static const _kUserPassword = 'auth.userPassword.';
  static const _kRememberPassword = 'auth.rememberPassword';
  static const _kBiometricEnabled = 'auth.biometricEnabled';
  static const _kAutoLock = 'auth.autoLock';
  static const _kLastUserId = 'auth.lastUserId';

  final FlutterSecureStorage _secure = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock_this_device),
  );

  Future<void> saveWebdavCredentials(String username, String appPassword) async {
    await _secure.write(key: _kWebdavUser, value: username);
    await _secure.write(key: _kWebdavPassword, value: appPassword);
  }

  Future<(String, String)?> getWebdavCredentials() async {
    final u = await _secure.read(key: _kWebdavUser);
    final p = await _secure.read(key: _kWebdavPassword);
    if (u == null || p == null) return null;
    return (u, p);
  }

  Future<void> clearWebdavCredentials() async {
    await _secure.delete(key: _kWebdavUser);
    await _secure.delete(key: _kWebdavPassword);
  }

  Future<void> saveUserPassword(String userId, String pin) async {
    await _secure.write(key: '$_kUserPassword$userId', value: pin);
  }

  Future<String?> getUserPassword(String userId) async {
    return _secure.read(key: '$_kUserPassword$userId');
  }

  Future<void> clearUserPassword(String userId) async {
    await _secure.delete(key: '$_kUserPassword$userId');
  }

  Future<void> setCurrentUser(String? userId) async {
    final prefs = await SharedPreferences.getInstance();
    if (userId == null) { await prefs.remove(_kCurrentUser); } 
    else { await prefs.setString(_kCurrentUser, userId); await prefs.setString(_kLastUserId, userId); }
  }

  Future<String?> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kCurrentUser);
  }

  Future<String?> getLastUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kLastUserId);
  }

  Future<void> setRememberPassword(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kRememberPassword, value);
  }

  Future<bool> getRememberPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kRememberPassword) ?? false;
  }

  Future<void> setBiometricEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kBiometricEnabled, value);
  }

  Future<bool> getBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kBiometricEnabled) ?? false;
  }

  Future<void> setAutoLockEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kAutoLock, value);
  }

  Future<bool> getAutoLockEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kAutoLock) ?? false;
  }

  Future<void> forgetDevice() async {
    await _secure.deleteAll();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
