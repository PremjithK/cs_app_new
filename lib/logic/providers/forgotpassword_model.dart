

import 'package:flutter/material.dart';

class ForgotpswdProvider extends ChangeNotifier {
  bool otpEmailvalidated = false;
  bool otpSent = false;
  List<int> _selectedmobileIndexes = [];
  List<int> _selectedemailIndexes = [];


  List<int> get selectedmobileIndexes => _selectedmobileIndexes;
  List<int> get selectedemailIndexes => _selectedemailIndexes;

  setotpEmailvalidated(bool value){
    otpEmailvalidated = value;
    notifyListeners();
  }

  setotpSent(bool value){
    otpSent = value;
    notifyListeners();
  }

  void resetState() {
    otpEmailvalidated = false;
    otpSent = false;
    notifyListeners();
  }

  void togglemobileIndex(int index) {
    if (_selectedmobileIndexes.contains(index)) {
      _selectedmobileIndexes.remove(index);
    } else {
      _selectedmobileIndexes.add(index);
    }
    notifyListeners();
  }

  void toggleemailIndex(int index) {
    if (_selectedemailIndexes.contains(index)) {
      _selectedemailIndexes.remove(index);
    } else {
      _selectedemailIndexes.add(index);
    }
    notifyListeners();
  }
}