import 'package:cybersquare/globals.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Text widgetText(
  String txtValue,
  String fontName,
  double txtFontSize,
  Color txtColor,
  TextAlign txtAlign,
  FontWeight fontWt,
  int status, {
  TextOverflow overflow = TextOverflow.ellipsis,
}) {
  return Text(
    txtValue,
    textAlign: txtAlign,
    style: GoogleFonts.getFont(
      fontName.trim() != '' ? fontName : globalFontName,
      fontSize: txtFontSize,
      fontWeight: fontWt,
      color: txtColor,
      letterSpacing: status == 1 ? 0.48 : 0,
    ),
    overflow: overflow,
  );
}
