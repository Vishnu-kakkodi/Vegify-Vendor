import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../models/auth_models.dart';

class AuthService {
  final http.Client _client;

  AuthService({http.Client? client}) : _client = client ?? http.Client();

  Future<VendorLoginResponse> loginVendor({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse(ApiConstants.vendorLogin);
    final response = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);
      return VendorLoginResponse.fromJson(data);
    } else {
      throw Exception('Login failed (code: ${response.statusCode})');
    }
  }

  Future<VerifyOtpResponse> verifyOtp({
    required String vendorId,
    required String otp,
  }) async {
    final uri = Uri.parse(ApiConstants.verifyVendorOtp);
    final response = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'vendorId': vendorId, 'otp': otp}),
    );
print("sdkhfdsfjskdjfdsl;jfdsl;fds;f;k${response.body}");
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);
      return VerifyOtpResponse.fromJson(data);
    } else {
      throw Exception('OTP verification failed (code: ${response.statusCode})');
    }
  }
}
