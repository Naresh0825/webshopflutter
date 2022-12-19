import 'package:flutter/material.dart';

import 'font_family.dart';
import 'font_manager.dart';

TextStyle _getTextStyle(double fontSize, String fontFamily, FontWeight fontWeight, Color color) {
  return TextStyle(fontSize: fontSize, fontFamily: fontFamily, color: color, fontWeight: fontWeight);
}

// regular style

TextStyle getRegularStyle({required double fontSize, required Color color}) {
  return _getTextStyle(fontSize, FontConstants.fontFamily, FontWeightManager.regular, color);
}
// light text style

TextStyle getLightStyle({required double fontSize, required Color color}) {
  return _getTextStyle(fontSize, FontConstants.fontFamily, FontWeightManager.light, color);
}
// bold text style

TextStyle getBoldStyle({required double fontSize, required Color color}) {
  return _getTextStyle(
    fontSize,
    FontConstants.fontFamily,
    FontWeightManager.bold,
    color,
  );
}

// semi bold text style

TextStyle getSemiBoldStyle({required double fontSize, required Color color}) {
  return _getTextStyle(
    fontSize,
    FontConstants.fontFamily,
    FontWeightManager.semiBold,
    color,
  );
}

// medium text style

TextStyle getMediumStyle({required double fontSize, required Color color}) {
  return _getTextStyle(fontSize, FontConstants.fontFamily, FontWeightManager.medium, color);
}
