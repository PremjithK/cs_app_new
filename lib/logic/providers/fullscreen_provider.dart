import 'package:flutter/material.dart';

class FullScreenProvider extends ChangeNotifier {
  late bool _showMenus = true;
  late bool _isLoadingGoogleSlides = false;

  void toggleMenus(bool val) {
    _showMenus = val;
    notifyListeners();
  }

  void resetMenus() {
    _showMenus = true;
    notifyListeners();
  }
  void setLoadingGoogleSlides(bool val) {
    _isLoadingGoogleSlides = val;
    notifyListeners();
  }

  bool get showMenus => _showMenus;
  bool get isLoadingGoogleSlides => _isLoadingGoogleSlides;
}
