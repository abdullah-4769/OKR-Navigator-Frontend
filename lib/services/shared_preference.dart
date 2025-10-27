import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart'; // ✅ Needed for Icons

class SharedPrefs {
  static SharedPreferences? _prefs;

  /// ✅ Initialize SharedPreferences (call once in main.dart)
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ---------------------------------------------------------------------------
  // 🔹 General Keys
  // ---------------------------------------------------------------------------
  static const String keySelectedRoleIndex = 'selectedRoleIndex';
  static const String keyUserId = 'userId';
  static const String keyUserName = 'userName';

  // ---------------------------------------------------------------------------
  // 🔹 Role
  // ---------------------------------------------------------------------------
  static Future<void> saveSelectedRoleIndex(int index) async {
    await _prefs?.setInt(keySelectedRoleIndex, index);
  }

  static int getSelectedRoleIndex() {
    return _prefs?.getInt(keySelectedRoleIndex) ?? -1;
  }

  // ---------------------------------------------------------------------------
  // 🔹 User Info
  // ---------------------------------------------------------------------------
  static Future<void> saveUserId(String id) async {
    await _prefs?.setString(keyUserId, id);
  }

  static String? getUserId() {
    return _prefs?.getString(keyUserId);
  }

  static Future<void> saveUserName(String name) async {
    await _prefs?.setString(keyUserName, name);
  }

  static String? getUserName() {
    return _prefs?.getString(keyUserName);
  }

  // ---------------------------------------------------------------------------
  // 🔹 Industry
  // ---------------------------------------------------------------------------
  static const String keySelectedIndustryTitle = 'selectedIndustryTitle';
  static const String keySelectedIndustryDesc = 'selectedIndustryDesc';
  static const String keySelectedIndustryIcon = 'selectedIndustryIcon';

  static Future<void> saveSelectedIndustry(Map<String, dynamic> industry) async {
    await _prefs?.setString(
        keySelectedIndustryTitle, industry['titleKey'].toString());
    await _prefs?.setString(
        keySelectedIndustryDesc, industry['descriptionKey'].toString());
    await _prefs?.setString(
        keySelectedIndustryIcon, _iconToString(industry['icon']));
  }

  static Map<String, dynamic>? getSelectedIndustry() {
    final title = _prefs?.getString(keySelectedIndustryTitle);
    final desc = _prefs?.getString(keySelectedIndustryDesc);
    final iconName = _prefs?.getString(keySelectedIndustryIcon);

    if (title == null) return null;

    return {
      'titleKey': title,
      'descriptionKey': desc ?? '',
      'icon': _stringToIcon(iconName),
    };
  }

  static Future<void> clearSelectedIndustry() async {
    await _prefs?.remove(keySelectedIndustryTitle);
    await _prefs?.remove(keySelectedIndustryDesc);
    await _prefs?.remove(keySelectedIndustryIcon);
  }

  // ---------------------------------------------------------------------------
  // 🔹 Helper methods for icon storage
  // ---------------------------------------------------------------------------
  static String _iconToString(IconData? icon) {
    if (icon == Icons.computer) return 'computer';
    if (icon == Icons.account_balance) return 'finance';
    if (icon == Icons.local_hospital) return 'health';
    if (icon == Icons.flash_on) return 'energy';
    if (icon == Icons.local_shipping) return 'logistics';
    if (icon == Icons.account_balance_outlined) return 'public';
    if (icon == Icons.storefront) return 'retail';
    if (icon == Icons.phone_android) return 'telecom';
    if (icon == Icons.agriculture) return 'agriculture';
    return 'default';
  }

  static IconData _stringToIcon(String? iconName) {
    switch (iconName) {
      case 'computer':
        return Icons.computer;
      case 'finance':
        return Icons.account_balance;
      case 'health':
        return Icons.local_hospital;
      case 'energy':
        return Icons.flash_on;
      case 'logistics':
        return Icons.local_shipping;
      case 'public':
        return Icons.account_balance_outlined;
      case 'retail':
        return Icons.storefront;
      case 'telecom':
        return Icons.phone_android;
      case 'agriculture':
        return Icons.agriculture;
      default:
        return Icons.work; // fallback
    }
  }

  // ---------------------------------------------------------------------------
  // 🔹 Clear Everything
  // ---------------------------------------------------------------------------
  static Future<void> clearAll() async {
    await _prefs?.clear();
  }
}
