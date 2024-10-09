import 'package:flutter/material.dart';

class ProjectScreenProvider extends ChangeNotifier {
  late bool _isloading = true;

  bool get isloading => _isloading;
  
  void setLoading(bool val) {
    _isloading = val;
  notifyListeners();
  }
}