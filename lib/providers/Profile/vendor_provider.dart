import 'package:flutter/material.dart';
import 'package:vegiffyy_vendor/models/Profile/vendor_model.dart';
import 'package:vegiffyy_vendor/services/Profile/vendor_service.dart';

class VendorProvider extends ChangeNotifier {
  final _service = VendorService();

  VendorModel? vendor;
  bool loading = false;

  Future<void> load(String vendorId) async {
    loading = true;
    notifyListeners();
            print("lllllllllllllllllllllllllllllllllllll$vendorId");

    vendor = await _service.fetchProfile(vendorId);
    loading = false;
    notifyListeners();
  }
}
