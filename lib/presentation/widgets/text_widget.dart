import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Text widgetText(String txtValue, String fontName, double txtFontSize,
    Color txtColor, TextAlign txtAlign, FontWeight fontWt, int status,{overflow = TextOverflow}) {

  return Text(
    txtValue,
    textAlign: txtAlign,
  //   style: TextStyle(
  //   color: txtColor,
  //   fontSize: txtFontSize,
  //   // fontFamily: fontName,
  //   fontWeight: fontWt,
  // ),
  //   overflow: overflow,
    style: GoogleFonts.oxygen(
    fontSize: txtFontSize,
    fontWeight: fontWt,
    color: txtColor,
    letterSpacing: status == 1 ? 0.48 : 0,
  ),
  );
}
