import 'package:flutter/cupertino.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

class AdvDrawerController with ChangeNotifier {
  AdvancedDrawerController _advancedDrawerController =
      AdvancedDrawerController();

  //setter
  set setAdvDrawerController(AdvancedDrawerController advDrawerController) {
    _advancedDrawerController = advDrawerController;
    // notifyListeners();
  }

  //getter
  AdvancedDrawerController get advDrawerController => _advancedDrawerController;
}
