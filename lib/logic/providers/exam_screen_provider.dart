import 'package:flutter/material.dart';

class ExamScreenProvider extends ChangeNotifier {
  Future ? _toggleViewRes;

  Future? get toggleViewRes => _toggleViewRes;

   updateToggleViewRes(List section) {
    _toggleViewRes = Future.value(section);
    notifyListeners();
  }
  
}