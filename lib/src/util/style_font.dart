import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Created by Amit Rawat

class StyleFonts {
  static TextStyle fontstyle(double fontsize, FontWeight font, Color color) {
    return GoogleFonts.lato(
      textStyle: TextStyle(
          decoration: TextDecoration.none,
          fontSize: fontsize,
          fontWeight: font,
          color: color),
    );
  }
}
