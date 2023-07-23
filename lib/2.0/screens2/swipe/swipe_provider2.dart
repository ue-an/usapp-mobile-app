import 'package:flutter/cupertino.dart';

class SwipeProvider2 with ChangeNotifier {
  double _xOffset = 0;
  double _yOffset = 0;
  double _scaleFactor = 1;

  bool _isDrawerOpen = false;

  //getter
  double get xOffset => _xOffset;
  double get yOffset => _yOffset;
  double get scaleFactor => _scaleFactor;
  bool get isDrawerOpen => _isDrawerOpen;

  //setter
  set changeXoffset(double xOffset) {
    _xOffset = xOffset;
  }

  set changeYoffset(double yOffset) {
    _yOffset = yOffset;
  }

  set changeScaleFactor(double scaleFactor) {
    _scaleFactor = scaleFactor;
  }

  set changeIsDrawerOpen(bool isDrawerOpen) {
    _isDrawerOpen = isDrawerOpen;
  }

  //functions
  resetOffsets() {
    _xOffset = 0;
    _yOffset = 0;
    _scaleFactor = 1;
    _isDrawerOpen = false;
  }
}
