

import 'package:flutter/cupertino.dart';

class courseProvider extends ChangeNotifier {
  bool expandFirst = true;
  int menuIndex = 100; //100 is set for dashboard

  setexpandFirst(bool value){
    expandFirst = value;
    notifyListeners();
  }

  setmenuIndex(int value){
    menuIndex = value;
    notifyListeners();
  }
}