import 'package:flutter/material.dart';
import 'vendor_section.dart';

class VendorNavigationProvider extends ChangeNotifier {
  VendorSection _current = VendorSection.dashboard;

  VendorSection get current => _current;

  void setSection(VendorSection section) {
    _current = section;
    notifyListeners();
  }
}
