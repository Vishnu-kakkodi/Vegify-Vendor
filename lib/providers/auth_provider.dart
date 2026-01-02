import 'package:flutter/material.dart';

import '../models/auth_models.dart';
import '../services/auth_service.dart';
import '../helper/vendor_storage_helper.dart';

enum AuthStep { login, otp }
enum AuthStatus { idle, loading, success, error }

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  AuthProvider({AuthService? authService})
      : _authService = authService ?? AuthService();

  // ----------------- CONTROLLERS -----------------
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final otpController = TextEditingController();

  // ----------------- STATE -----------------
  AuthStep currentStep = AuthStep.login;
  AuthStatus status = AuthStatus.idle;
  String? errorMessage;

  String? vendorId;
  String? demoOtp;
  Vendor? vendor;
  bool isLoggedIn = false;

  // ----------------- LOGIN -----------------
  Future<void> login() async {
    status = AuthStatus.loading;
    errorMessage = null;
    notifyListeners();

    try {
      final res = await _authService.loginVendor(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (!res.success) {
        status = AuthStatus.error;
        errorMessage = res.message;
        notifyListeners();
        return;
      }

      vendorId = res.vendorId;
      demoOtp = res.otp;
      currentStep = AuthStep.otp;
      status = AuthStatus.success;
      notifyListeners();
    } catch (e) {
      status = AuthStatus.error;
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  // ----------------- OTP VERIFY -----------------
  Future<bool> verifyOtp() async {
    if (vendorId == null) return false;

    status = AuthStatus.loading;
    errorMessage = null;
    notifyListeners();

    try {
      final res = await _authService.verifyOtp(
        vendorId: vendorId!,
        otp: otpController.text.trim(),
      );

      if (!res.success || res.vendor == null) {
        status = AuthStatus.error;
        errorMessage = res.message;
        notifyListeners();
        return false;
      }

      vendor = res.vendor;
print("sskfjdsjfjlsjflffffjfflsdf;sjsdfj$vendor");
      // Save vendor info to SharedPreferences
      await VendorPreferences.saveVendor(vendor!);
      isLoggedIn = true;

      status = AuthStatus.success;
      notifyListeners();
      return true;
    } catch (e) {
      status = AuthStatus.error;
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ----------------- CHECK LOGIN ON START -----------------
  Future<void> checkLoginStatus() async {
    await VendorPreferences.init();

    if (VendorPreferences.isLoggedIn()) {
      vendor = VendorPreferences.getVendor();
      isLoggedIn = vendor != null;
    } else {
      vendor = null;
      isLoggedIn = false;
    }

    notifyListeners();
  }

  // ----------------- LOGOUT -----------------
  Future<void> logout() async {
    await VendorPreferences.clear();

    isLoggedIn = false;
    vendor = null;
    vendorId = null;
    demoOtp = null;

    emailController.clear();
    passwordController.clear();
    otpController.clear();

    currentStep = AuthStep.login;
    status = AuthStatus.idle;
    errorMessage = null;

    notifyListeners();
  }

  

  // ----------------- UI HELPERS -----------------
  void goBackToLogin() {
    currentStep = AuthStep.login;
    otpController.clear();
    status = AuthStatus.idle;
    errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    otpController.dispose();
    super.dispose();
  }
}
