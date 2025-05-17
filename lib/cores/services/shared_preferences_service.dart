import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const _keyFirstOpen = 'is_first_open';
  static const _userNameKey = 'user_name';
  static SharedPreferences? _prefs;

// Add these to your existing SharedPreferencesService class
  static const _userIdKey = 'user_id';
  static const _phoneNumber = 'user_phone';
  static const _themeApp = 'theme_app';
  static Future<void> saveThemeAPp(bool themeApp) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeApp, themeApp);
  }

  static Future<bool?> getThemeApp() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeApp);
  }

  static Future<void> saveUserPhone(String userPhone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_phoneNumber, userPhone);
  }

  static Future<String?> getUserPhone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_phoneNumber);
  }

  static Future<void> clearUserPhone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_phoneNumber);
  }

  static Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  static Future<void> clearUserId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
  }

  /// Initialize SharedPreferences. Should be called at app startup.
  static Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
    } catch (e) {
      debugPrint('Failed to initialize SharedPreferences: $e');
    }
  }

  static Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, name);
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    log(prefs.getString(_userNameKey).toString());
    return prefs.getString(_userNameKey);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_userNameKey);
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userNameKey);
  }

  static Future<bool> isNotFirstOpen() async {
    try {
      if (_prefs == null) {
        await init();
      }

      bool hasOpenedBefore = _prefs?.getBool(_keyFirstOpen) ?? false;

      if (!hasOpenedBefore) {
        await _prefs?.setBool(_keyFirstOpen, true);
        return false;
      }

      return true;
    } catch (e) {
      debugPrint('Error in isNotFirstOpen: $e');
      return true;
    }
  }

  static Future<void> resetFirstTimeFlag() async {
    try {
      if (_prefs == null) {
        await init();
      }
      await _prefs?.remove(_keyFirstOpen);
    } catch (e) {
      debugPrint('Error resetting first time flag: $e');
    }
  }
}
