import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_models.dart';

class VendorPreferences {
  static SharedPreferences? _prefs;

  static const String _keyVendor = 'vendor_data';
  static const String _keyLoggedIn = 'is_logged_in';

  /// Call once in main/splash
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<void> saveVendor(Vendor vendor) async {
    await init();
    final map = {
      'id': vendor.id,
      'restaurantName': vendor.restaurantName,
      'email': vendor.email,
      'mobile': vendor.mobile,
      'locationName': vendor.locationName,
      'image': vendor.image,
    };

    await _prefs!.setString(_keyVendor, jsonEncode(map));
    await _prefs!.setBool(_keyLoggedIn, true);
  }

  static bool isLoggedIn() {
    if (_prefs == null) return false;
    return _prefs!.getBool(_keyLoggedIn) ?? false;
  }

  static Vendor? getVendor() {
    if (_prefs == null) return null;
    final raw = _prefs!.getString(_keyVendor);
    if (raw == null) return null;

    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return Vendor.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  static Future<void> clear() async {
    await init();
    await _prefs!.remove(_keyVendor);
    await _prefs!.remove(_keyLoggedIn);
  }

  static String? getVendorId() {
  final vendor = getVendor();
  return vendor?.id;
}

}



