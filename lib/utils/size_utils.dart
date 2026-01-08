import 'package:flutter/material.dart';

class SizeUtils{

  // MediaQueryData to get screen dimensions
  static late MediaQueryData _mediaQueryData; 
  static late double screenWidth;
  static late double screenHeight;  
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;

  // Design draft dimensions
  static const double designWidth = 375; // iPhone X
  static const double designHeight = 812;


  //intialize with context
 static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;

    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
  }


  static double scaleX(double value) => value * (screenWidth / designWidth);
  static double scaleY(double value) => value * (screenHeight / designHeight);




}